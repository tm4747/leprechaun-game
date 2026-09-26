extends Node2D
## Saturday morning through the fall into the well (PRD sections 31-34).
## Once the third throw sails toward the well, control locks for the rest
## of the sequence -- the fall is irreversible and the player must not be
## able to accidentally (or deliberately) skip it (PRD 2.4, Phase 9
## acceptance).

const UNDERWORLD_TRANSITION_SCENE := "res://scenes/underworld/UnderworldTransition.tscn"

@onready var player: Player = $Player
@onready var dog: DogPlaceholder = $Dog
@onready var mother: NPCPlaceholder = $Mother
@onready var stick: ColorRect = $Stick
@onready var stick_trigger: AutoEventTrigger = $StickTrigger
@onready var fetch_trigger: AutoEventTrigger = $FetchTrigger
@onready var well_marker: Marker2D = $WellMarker
@onready var dog_home_marker: Marker2D = $DogHomeMarker
@onready var fetch_marker_1: Marker2D = $FetchMarker1
@onready var fetch_marker_2: Marker2D = $FetchMarker2

func _ready() -> void:
	DebugOverlay.register_scene("well", scene_file_path)
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "saturday_morning"
	GameState.mark_screen_visited("well_sequence")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 1500, 600)

	dog.set_follow_target(player)
	stick_trigger.triggered.connect(_on_stick_triggered)
	fetch_trigger.triggered.connect(_on_fetch_triggered)

func _on_stick_triggered() -> void:
	GameState.set_flag("has_stick", true)
	stick.visible = false

## Three throws (PRD section 32): short and playful, then farther, then
## high toward the well -- which is where everything turns.
func _on_fetch_triggered() -> void:
	if not GameState.has_flag("has_stick"):
		return
	Events.disable_control()
	dog.set_manual_control(true)

	await Events.wait(0.4)
	await dog.move_to(fetch_marker_1.global_position, 0.5)
	await Events.wait(0.3)
	dog.play_pose("carry")
	await dog.move_to(dog_home_marker.global_position, 0.6)
	dog.play_pose("sit")
	var hop := create_tween()
	hop.tween_property(dog, "position:y", dog.position.y - 8.0, 0.12)
	hop.tween_property(dog, "position:y", dog.position.y, 0.12)
	await hop.finished
	dog.play_pose("")

	await Events.wait(0.5)
	await dog.move_to(fetch_marker_2.global_position, 0.7)
	await Events.wait(0.3)
	dog.play_pose("carry")
	await dog.move_to(player.global_position + Vector2(-20, 0), 0.8)
	dog.play_pose("")

	await Events.wait(0.6)
	await _play_well_sequence()

## Section 33: the fall. No dialogue beyond the one shout -- entirely
## carried by movement, so it reads emotionally without any text box.
func _play_well_sequence() -> void:
	# The third throw itself: the stick visibly arcs toward the well and
	# goes in (PRD section 32's closing beat), before the dog reacts to it.
	stick.global_position = player.global_position + Vector2(10, -10)
	stick.visible = true
	stick.modulate.a = 1.0
	var stick_arc := create_tween()
	stick_arc.tween_property(stick, "global_position", well_marker.global_position, 0.5) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	stick_arc.parallel().tween_property(stick, "modulate:a", 0.0, 0.5).set_delay(0.3)
	await stick_arc.finished
	stick.visible = false

	GameState.gut.modify_gut(-0.4)
	await dog.move_to(well_marker.global_position + Vector2(-30, 0), 0.9)

	await Events.dialogue(GameState.player_name, "NO!", "CLEAR", 0.8)

	dog.play_pose("jump")
	var jump := create_tween()
	jump.tween_property(dog, "global_position", well_marker.global_position + Vector2(30, -20), 0.35) \
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	jump.tween_property(dog, "global_position", well_marker.global_position + Vector2(30, 0), 0.15) \
		.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await jump.finished
	dog.play_pose("")
	await Events.wait(0.3)
	await dog.move_to(well_marker.global_position + Vector2(60, 0), 0.5)

	await Events.move_character(player, well_marker.global_position + Vector2(-10, 0), 160.0)
	await Events.wait(0.5)

	GameState.gut.set_gut(-1.0)
	GameState.intro_progress = "well_fall"

	var fall := create_tween()
	fall.tween_property(player, "global_position", well_marker.global_position + Vector2(10, 30), 1.6) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	fall.parallel().tween_property(player, "modulate:a", 0.0, 1.6)
	await fall.finished

	await Events.wait(0.4)
	SaveManager.save_game()
	Events.transition_scene(UNDERWORLD_TRANSITION_SCENE)
