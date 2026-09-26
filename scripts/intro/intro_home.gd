extends Node2D
## Evening: return home, dinner, living room, TV (PRD sections 19-22).
## Parents' argument and the angel scene (Phase 8) extend this same scene
## per PRD 8.2's IntroHome.tscn; this phase covers dinner through TV
## shutdown.

const CARTOON_COLOR := Color(0.5, 0.7, 0.85)
const STATIC_COLOR := Color(0.6, 0.6, 0.6)
const COMMERCIAL_COLOR := Color(0.85, 0.75, 0.55)

@onready var player: Player = $Player
@onready var mother: NPCPlaceholder = $Mother
@onready var father: NPCPlaceholder = $Father
@onready var salesman: NPCPlaceholder = $Salesman

@onready var dinner_trigger: AutoEventTrigger = $DinnerTrigger
@onready var dinner_seat: Marker2D = $DinnerSeat
@onready var remote_trigger: AutoEventTrigger = $RemoteTrigger
@onready var couch_marker: Marker2D = $CouchMarker
@onready var tv_screen: ColorRect = $TV/Screen
@onready var tv_audio: AudioStreamPlayer = $TVAudio
@onready var channel_chirp: AudioStreamPlayer = $ChannelChirp
@onready var bedroom_exit: ExitTrigger = $BedroomExit

var channel_index := 0

func _ready() -> void:
	DebugOverlay.register_scene("home", scene_file_path)
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "evening_return_home"
	GameState.mark_screen_visited("intro_home")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 1350, 600)

	tv_screen.visible = false
	salesman.visible = false
	father.visible = false

	dinner_trigger.triggered.connect(_on_dinner_triggered)
	remote_trigger.triggered.connect(_on_remote_triggered)

## Section 19: quiet, wordless dinner after a hard day. No narration box --
## the player just watches him eat, same beat structure as breakfast.
func _on_dinner_triggered() -> void:
	Events.disable_control()
	await Events.dialogue(mother.npc_name, "There's some dinner on the table for you.", "CLEAR", 2.2)
	await Events.move_character(player, dinner_seat.global_position, 140.0)
	await Events.wait(1.0)
	Events.enable_control()

## Sections 20-22: remote pickup -> real, testable channel switching ->
## the commercial (and its subtle supernatural hint) always arrives after
## a few seconds regardless of what channel the player lands on -- a
## believable "commercial break interrupts whatever's on" beat -- -> TV off.
func _on_remote_triggered() -> void:
	Events.disable_control()
	await Events.move_character(player, couch_marker.global_position, 140.0)

	tv_screen.visible = true
	channel_index = 0
	_render_channel()
	GameState.intro_progress = "evening_tv_on"

	# CRT hum/static bed for as long as the TV is on (PRD section 54.4).
	tv_audio.stream = ToneGenerator.generate_noise(2.0, 44100, 0.06)
	tv_audio.volume_db = -12.0
	tv_audio.play()

	await _allow_channel_surfing(3.0)
	await _play_commercial_and_supernatural_hint()
	await _shutdown_tv()

func _allow_channel_surfing(duration: float) -> void:
	var elapsed := 0.0
	while elapsed < duration:
		if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down"):
			channel_index = 1 - channel_index
			_render_channel()
			channel_chirp.stream = ToneGenerator.generate_beep(1400.0, 0.05, 44100, 0.25)
			channel_chirp.play()
		await get_tree().process_frame
		elapsed += get_process_delta_time()

func _render_channel() -> void:
	tv_screen.color = CARTOON_COLOR if channel_index == 0 else STATIC_COLOR

func _play_commercial_and_supernatural_hint() -> void:
	tv_screen.color = COMMERCIAL_COLOR
	salesman.visible = true
	await Events.dialogue(salesman.npc_name, "Tired? Haggard? Try NEW Youth Mist!", "CLEAR", 2.2)
	await Events.dialogue(salesman.npc_name, "Just look what it did for me... and my dog... and my gerbil!", "CLEAR", 2.6)
	await Events.dialogue("", "$19.99 -- BUY ONE, GET THREE FREE.", "CLEAR", 2.0)

	# The subtle supernatural hint (section 21). Deliberately brief and
	# ambiguous -- never a clean, identifiable face, never named as
	# anything. The player may not be sure they saw it at all. Audio gets
	# "slightly unnatural processing" here per section 54.4, not a sting.
	var normal_pitch := tv_audio.pitch_scale
	tv_audio.pitch_scale = 0.55
	await salesman.flash_eyes_red(0.12)
	tv_screen.modulate = Color(0.55, 0.15, 0.15)
	await Events.wait(0.2)
	tv_screen.modulate = Color(1, 1, 1)
	tv_audio.pitch_scale = normal_pitch

	GameState.gut.set_gut(-0.7)
	GameState.vitality.consume(60.0)
	salesman.visible = false

func _shutdown_tv() -> void:
	await Events.wait(0.8)
	tv_screen.visible = false
	tv_audio.stop()
	GameState.intro_progress = "evening_tv_off"
	Events.enable_control()
	await _father_arrives_and_argument()

## Section 23: the boy is free to move throughout -- nothing requires him
## to resolve the argument, and the dialogue plays out ambiently rather
## than as a control-locking cutscene (PRD Rule 7: preserve player agency).
func _father_arrives_and_argument() -> void:
	father.visible = true
	await Events.dialogue(father.npc_name, "Hey, kiddo.", "CLEAR", 1.8)
	await Events.wait(0.6)
	await Events.dialogue(mother.npc_name, "Whaa whaa whaa...", "GARBLED", 1.6)
	await Events.dialogue(father.npc_name, "Whaa whaa whaa whaa!", "GARBLED", 1.6)
	await Events.dialogue(mother.npc_name, "Whaa whaa!", "GARBLED", 1.4)

	GameState.health.damage(35.0)
	GameState.vitality.consume(15.0)
	GameState.gut.modify_gut(-0.15)
	GameState.intro_progress = "evening_parents_argument"
