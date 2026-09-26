extends Node2D
## Night bedroom + first angel encounter (PRD sections 24-30). The boy
## starts in bed already unable to sleep; getting up is just normal
## movement (no special "wake up" trigger, matching the Friday bedroom).
## Walking onto the rug in front of the window ends control and begins
## the angel sequence with no button prompt (section 25.2).

const SATURDAY_SCENE := "res://scenes/intro/WellSequence.tscn"

@onready var player: Player = $Player
@onready var rug_trigger: AutoEventTrigger = $RugTrigger
@onready var angel: Node2D = $Angel
@onready var distortion_overlay: ColorRect = $DistortionOverlay

func _ready() -> void:
	DebugOverlay.register_scene("angel", scene_file_path)
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "night_bedroom"
	GameState.mark_screen_visited("intro_bedroom_angel")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 790, 600)

	if GameState.pending_spawn_id != "" and has_node(GameState.pending_spawn_id):
		player.global_position = get_node(GameState.pending_spawn_id).global_position
	GameState.pending_spawn_id = ""

	angel.visible = false
	angel.modulate.a = 0.0
	distortion_overlay.color.a = 0.0

	EventBus.health_critical.connect(_refresh_distortion)
	EventBus.health_restored.connect(_refresh_distortion)
	EventBus.vitality_critical.connect(_refresh_distortion)
	EventBus.vitality_restored.connect(_refresh_distortion)
	EventBus.gut_critical.connect(func(_state): _refresh_distortion())
	EventBus.gut_restored.connect(_refresh_distortion)
	_refresh_distortion()

	rug_trigger.triggered.connect(_on_rug_triggered)

## The room visibly reflects however bad things already are (PRD section
## 24: "the room becomes increasingly distorted"). Values carry over from
## the TV scene and parents' argument -- nothing here artificially forces
## them, it just renders whatever GameState already holds.
##
## Note: HallwayGlimpse (beyond the doorway on the right) is a fixed tint,
## deliberately never touched here -- the protection calms this room but
## must not pretend the danger everywhere else in the house is gone
## (PRD section 29).
func _refresh_distortion() -> void:
	var target_alpha := 0.4 if CriticalWarnings.any_critical() else 0.0
	var tween := create_tween()
	tween.tween_property(distortion_overlay, "color:a", target_alpha, 0.6)

func _on_rug_triggered() -> void:
	Events.disable_control()

	await Events.dialogue("", "God... why are things like this?", "THOUGHT", 2.4)
	await Events.dialogue("", "Why do people treat each other like this?", "THOUGHT", 2.4)
	await Events.dialogue("", "Why does everyone seem to be upset?", "THOUGHT", 2.6)

	angel.visible = true
	angel.position.y -= 220.0
	var descend := create_tween()
	descend.tween_property(angel, "modulate:a", 1.0, 1.0)
	descend.parallel().tween_property(angel, "position:y", angel.position.y + 220.0, 1.4) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	await descend.finished
	await Events.wait(0.5)

	await Events.dialogue("The angel", "I know this has been difficult.", "CLEAR", 2.6)
	await Events.dialogue("The angel", "But have faith. Have hope.", "CLEAR", 2.4)
	await Events.dialogue("The angel", "It won't be very long now...", "CLEAR", 2.8)

	# The effect itself communicates the mechanic -- no notification text
	# (PRD section 28: never "HEALTH RESTORED" / "ANGEL PROTECTION ACQUIRED").
	Events.heal_full()
	Events.restore_vitality_full()
	GameState.gut.set_gut(0.5)

	# Protection pushes the chaos back without pretending it never
	# existed -- the overlay clears here, in the protected room, but nothing
	# claims the danger elsewhere in the house is gone (section 29).
	await Events.wait(0.3)
	GameState.intro_progress = "angel_scene_complete"
	SaveManager.save_game()
	await Events.wait(1.2)
	Events.transition_scene(SATURDAY_SCENE)
