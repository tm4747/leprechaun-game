extends Node
## Headless test runner for Phase 2 acceptance criteria (PRD section 65/66).
## Run with: godot --headless --path . res://tests/Phase2Test.tscn

var _pass := 0
var _fail := 0
var player: Player

func _ready() -> void:
	print("== Phase 2 player controller tests ==")
	player = preload("res://scenes/player/Player.tscn").instantiate()
	add_child(player)
	await get_tree().process_frame
	await get_tree().physics_frame

	await _test_top_down_movement()
	await _test_side_scroll_locks_vertical()
	await _test_control_disable()
	await _test_move_to()

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _hold(action: String, frames: int) -> void:
	Input.action_press(action)
	for i in frames:
		await get_tree().physics_frame
	Input.action_release(action)
	await get_tree().physics_frame

func _test_top_down_movement() -> void:
	player.set_movement_mode(Player.MovementMode.TOP_DOWN)
	player.global_position = Vector2.ZERO

	var start_x := player.global_position.x
	Input.action_press("move_right")
	for i in 10:
		await get_tree().physics_frame
	_check(player.global_position.x > start_x, "top-down: move_right increases x")
	_check(player._anim_controller.current_animation == "walk_right", "animation follows move_right")
	Input.action_release("move_right")
	await get_tree().physics_frame

	var start_y := player.global_position.y
	await _hold("move_up", 10)
	_check(player.global_position.y < start_y, "top-down: move_up decreases y")

	await get_tree().physics_frame
	_check(player._anim_controller.current_animation.begins_with("idle_"), "animation returns to idle when no input")

func _test_side_scroll_locks_vertical() -> void:
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.global_position = Vector2.ZERO
	var start_y := player.global_position.y
	await _hold("move_up", 10)
	_check(player.global_position.y == start_y, "side-scroll: vertical input does not move the player")

	var start_x := player.global_position.x
	await _hold("move_right", 10)
	_check(player.global_position.x > start_x, "side-scroll: horizontal input still moves the player")
	_check(GameState.movement_mode == Player.MovementMode.SIDE_SCROLL, "GameState.movement_mode mirrors player mode")

func _test_control_disable() -> void:
	player.set_movement_mode(Player.MovementMode.TOP_DOWN)
	player.global_position = Vector2.ZERO
	GameState.set_control_enabled(false)
	await get_tree().physics_frame
	var start_pos := player.global_position
	await _hold("move_right", 10)
	_check(player.global_position == start_pos, "movement disabled while control is disabled")
	GameState.set_control_enabled(true)
	await get_tree().physics_frame
	await _hold("move_right", 10)
	_check(player.global_position.x > start_pos.x, "movement resumes once control is re-enabled")

func _test_move_to() -> void:
	player.global_position = Vector2.ZERO
	var target := Vector2(64, 0)
	await player.move_to(target, 300.0)
	_check(player.global_position.distance_to(target) < 3.0, "move_to (scripted movement) reaches its target")
