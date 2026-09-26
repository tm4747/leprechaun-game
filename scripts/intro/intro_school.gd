extends Node2D
## The whole school day in one consolidated scene, per PRD section 8.2's
## file list. Bus arrival -> classroom (a pure fade; "no player control...
## purpose is pacing and contrast", section 15, so it doesn't need real
## classroom geometry) -> recess with the red-eye incident (section 17,
## the first supernatural hint) -> front gate / Billy (section 18).

const HOME_SCENE := "res://scenes/intro/IntroHome.tscn"

@onready var player: Player = $Player
@onready var school_door_trigger: AutoEventTrigger = $SchoolDoorTrigger
@onready var incident_trigger: AutoEventTrigger = $IncidentTrigger
@onready var billy_trigger: AutoEventTrigger = $BillyTrigger

@onready var recess_spawn: Marker2D = $RecessSpawn
@onready var kid_a: NPCPlaceholder = $KidA
@onready var kid_b: NPCPlaceholder = $KidB
@onready var teacher: NPCPlaceholder = $Teacher
@onready var teacher_stand_marker: Marker2D = $TeacherStandMarker

@onready var billy_car: Node2D = $BillyCar
@onready var billy: NPCPlaceholder = $BillyCar/Billy

func _ready() -> void:
	DebugOverlay.register_scene("school", scene_file_path)
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "school_arrival"
	GameState.mark_screen_visited("intro_school")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 2000, 600)

	if GameState.pending_spawn_id != "" and has_node(GameState.pending_spawn_id):
		player.global_position = get_node(GameState.pending_spawn_id).global_position
	GameState.pending_spawn_id = ""

	school_door_trigger.triggered.connect(_on_school_door_triggered)
	incident_trigger.triggered.connect(_on_incident_triggered)
	billy_trigger.triggered.connect(_on_billy_triggered)

## Section 14.2/15: entering school skips straight through the school day.
## No tutorial, no classroom minigame -- just a believable fade.
func _on_school_door_triggered() -> void:
	Events.disable_control()
	await Events.fade_to_black(0.5)
	await Events.wait(1.2) # the school day passing, off-screen
	player.global_position = recess_spawn.global_position
	await Events.fade_from_black(0.5)
	GameState.intro_progress = "school_recess"
	Events.enable_control()

## Section 17: the first subtle supernatural hint. No freeze, no zoom, no
## sting, no label, no leprechaun, no one commenting on it (Rule 6/10).
func _on_incident_triggered() -> void:
	Events.disable_control()
	await Events.dialogue(kid_a.npc_name, "Whaa whaa whaa!", "GARBLED", 1.4)
	await Events.dialogue(kid_b.npc_name, "Whaa whaa whaa whaa!", "GARBLED", 1.4)

	var shove := create_tween()
	shove.tween_property(kid_a, "position:x", kid_a.position.x - 10, 0.15)
	shove.parallel().tween_property(kid_b, "position:x", kid_b.position.x + 10, 0.15)
	await shove.finished

	# The critical animation: both flicker red at once, look at the
	# protagonist, then immediately return to normal. That's the entire
	# beat -- nothing narrates it.
	kid_a.flash_eyes_red(0.15)
	await kid_b.flash_eyes_red(0.15)
	GameState.gut.modify_gut(-0.15)

	await Events.dialogue(kid_a.npc_name, "Whaa whaa!", "GARBLED", 1.1)

	var teacher_step := create_tween()
	teacher_step.tween_property(teacher, "global_position", teacher_stand_marker.global_position, 0.8)
	await teacher_step.finished
	await Events.wait(0.6)

	GameState.intro_progress = "school_incident_seen"
	Events.enable_control()

## Section 18: Billy. Gut swings hard toward joy on seeing him, then hard
## toward fear/sadness after he mocks the boy and drives off. No revenge,
## no confrontation, no melodrama -- the boy just absorbs it.
func _on_billy_triggered() -> void:
	Events.disable_control()
	GameState.gut.set_gut(0.6)
	await Events.wait(0.4)
	await Events.dialogue(GameState.player_name, "Hey Billy, can I get a ride home?", "CLEAR", 2.0)
	await Events.dialogue(billy.npc_name, "Whaa whaa whaa whaa whaa!", "GARBLED", 1.6)
	GameState.gut.set_gut(-0.5)

	var drive_off := create_tween()
	drive_off.tween_property(billy_car, "position:x", billy_car.position.x - 500, 0.8) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await drive_off.finished

	await Events.move_character(player, player.global_position + Vector2(-120, 0), 90.0)
	GameState.intro_progress = "school_billy_seen"
	Events.transition_scene(HOME_SCENE)
