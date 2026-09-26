extends Node
## Headless test runner for Phase 5 acceptance criteria (PRD section 65/66):
## "Player can complete the morning without soft-locking."
## Run with: godot --headless --path . res://tests/Phase5Test.tscn
##
## Rooms are exercised as plain children (not the tree's current_scene) so
## we can await their internal coroutines directly. Only the very last
## check triggers a real SceneManager transition -- see the Phase 4 test's
## note on why that has to be last.

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 5 Friday morning tests ==")
	GameState.reset_for_new_quest()

	await _test_bedroom_movement()
	await _test_breakfast_and_backpack()
	await _test_bus_sequence_begins_transition()

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_bedroom_movement() -> void:
	var bedroom = preload("res://scenes/intro/IntroBedroom.tscn").instantiate()
	add_child(bedroom)
	await get_tree().process_frame

	var player: Player = bedroom.get_node("Player")
	var start_x := player.global_position.x
	Input.action_press("move_right")
	for i in 20:
		await get_tree().physics_frame
	Input.action_release("move_right")
	_check(player.global_position.x > start_x, "player can walk in the bedroom (no movement tutorial needed)")
	_check(GameState.intro_progress == "friday_bedroom", "entering the bedroom sets intro_progress checkpoint")

	bedroom.queue_free()
	await get_tree().process_frame

func _test_breakfast_and_backpack() -> void:
	var house = preload("res://scenes/intro/IntroHouseInterior.tscn").instantiate()
	add_child(house)
	await get_tree().process_frame

	# GDScript lambdas capture value-type locals by value, not by reference,
	# so a plain String local wouldn't observe the mutation -- use a
	# Dictionary (a reference type) to actually capture the signal payload.
	var captured := {"speaker": ""}
	var listener := func(speaker, _text, _kind): captured["speaker"] = speaker
	EventBus.dialogue_line_started.connect(listener)

	await house._on_breakfast_triggered()
	_check(captured["speaker"] == "Mother", "walking into the kitchen triggers Mother's breakfast line")
	_check(GameState.control_enabled, "control returns to the player after the breakfast beat")
	EventBus.dialogue_line_started.disconnect(listener)

	GameState.set_flag("has_backpack", false)
	house._on_backpack_triggered()
	_check(GameState.has_flag("has_backpack"), "walking through the backpack trigger picks it up (no inventory UI)")

	house.queue_free()
	await get_tree().process_frame

## Deliberately synchronous from the final Events.transition_scene() call to
## quit() -- see the Phase 4 test note on why real transitions run last.
func _test_bus_sequence_begins_transition() -> void:
	var exterior = preload("res://scenes/intro/IntroExterior.tscn").instantiate()
	add_child(exterior)
	await get_tree().process_frame

	await exterior._on_bus_stop_triggered()
	_check(SceneManager.is_transitioning(), "boarding the bus begins the transition toward school")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)
