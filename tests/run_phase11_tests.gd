extends Node
## Headless test runner for Phase 11 acceptance criteria (PRD section 65):
## the player can freely explore the complete first board without leaving
## it. Run with: godot --headless --path . res://tests/Phase11Test.tscn

var _pass := 0
var _fail := 0
var scene: Node
var player: Player

func _ready() -> void:
	print("== Phase 11 first underworld board tests ==")
	GameState.reset_for_new_quest()
	GameState.current_world = "human"

	scene = preload("res://scenes/underworld/UnderworldFirstScreen.tscn").instantiate()
	add_child(scene)
	player = scene.get_node("Player")
	await get_tree().process_frame

	# Listen for thought bubbles from the very start: the movement tests
	# below take upwards of 25 real seconds (holding directions for
	# several seconds each to prove the boundary holds), which is easily
	# enough time for the first couple of thoughts to fire on their own
	# schedule. Connecting a listener only afterward would miss them.
	var thought_seen := {"seen": false}
	var listener := func(_speaker, _text, kind):
		if kind == "THOUGHT":
			thought_seen["seen"] = true
	EventBus.dialogue_line_started.connect(listener)

	_test_setup()
	await _test_diagonal_movement()
	await _test_cannot_leave_board()

	EventBus.dialogue_line_started.disconnect(listener)
	_check(thought_seen["seen"], "the boy has brief internal thoughts while exploring, not narration")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_setup() -> void:
	_check(player.movement_mode == Player.MovementMode.TOP_DOWN, "the underworld player uses top-down movement")
	_check(player.global_position.distance_to(Vector2(960, 540)) < 5.0, "the boy wakes near the center of the board")
	_check(GameState.current_world == "underworld", "arriving sets the world to underworld")
	_check(GameState.current_screen == "forest_001", "the first screen registers its logical screen id")
	_check(GameState.visited_screens.has("forest_001"), "the screen graph records this screen as visited")
	_check(GameHUD.health_bar.style == BarMeter.Style.WEATHERED, "the HUD switches to the weathered underworld style")
	_check(GameHUD.gut_meter.style == GutMeter.Style.GRANULAR_UNDERWORLD, "the Gut Meter switches to the granular underworld style")
	_check(GameHUD.cycle_indicator.style == CycleIndicator.Style.HOURGLASS, "the cycle indicator becomes the hourglass")
	_check(GameState.control_enabled, "the player can move immediately -- no forced quest marker or tutorial gate")

func _hold(action: String, seconds: float) -> void:
	Input.action_press(action)
	var ticks := int(seconds * Engine.physics_ticks_per_second)
	for i in ticks:
		await get_tree().physics_frame
	Input.action_release(action)
	await get_tree().physics_frame

func _test_diagonal_movement() -> void:
	player.global_position = Vector2(960, 540)
	Input.action_press("move_right")
	Input.action_press("move_down")
	for i in 20:
		await get_tree().physics_frame
	Input.action_release("move_right")
	Input.action_release("move_down")
	await get_tree().physics_frame

	_check(player.global_position.x > 960.0 and player.global_position.y > 540.0,
		"the player can move diagonally (8-direction architecture)")

func _test_cannot_leave_board() -> void:
	player.global_position = Vector2(960, 540)
	await _hold("move_up", 6.0)
	_check(player.global_position.y >= 0.0, "the player cannot leave through the north path")

	player.global_position = Vector2(960, 540)
	await _hold("move_down", 6.0)
	_check(player.global_position.y <= 1080.0, "the player cannot leave through the south path")

	player.global_position = Vector2(960, 540)
	await _hold("move_left", 8.0)
	_check(player.global_position.x >= 0.0, "the player cannot leave through the west path")

	player.global_position = Vector2(960, 540)
	await _hold("move_right", 8.0)
	_check(player.global_position.x <= 1920.0, "the player cannot leave through the east path")

