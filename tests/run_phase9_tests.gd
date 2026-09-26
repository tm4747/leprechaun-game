extends Node
## Headless test runner for Phase 9 acceptance criteria (PRD section 65/66):
## the sequence reads emotionally without text exposition, and the player
## cannot accidentally skip the critical well sequence.
## Run with: godot --headless --path . res://tests/Phase9Test.tscn

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 9 Saturday / well tests ==")
	GameState.reset_for_new_quest()

	var scene = preload("res://scenes/intro/WellSequence.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame

	_test_stick_pickup(scene)
	await _test_fetch_requires_stick(scene)
	await _test_full_well_sequence(scene) # ends with a real transition -- keep last

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_stick_pickup(scene: Node) -> void:
	_check(scene.stick.visible, "the stick is on the ground before it's picked up")
	scene._on_stick_triggered()
	# Calling the handler directly (rather than walking through the real
	# Area2D) bypasses AutoEventTrigger's own one-shot bookkeeping. Mark it
	# used so a later scripted walk back through this same spot (the well
	# sequence crosses it again) can't re-fire it for real, which would be
	# a test artifact, not a real gameplay path.
	scene.stick_trigger._used = true
	_check(GameState.has_flag("has_stick"), "walking over the stick picks it up")
	_check(not scene.stick.visible, "the stick prop disappears once picked up")

func _test_fetch_requires_stick(scene: Node) -> void:
	GameState.set_flag("has_stick", false)
	await scene._on_fetch_triggered()
	_check(GameState.control_enabled, "fetch does nothing without the stick (control was never taken)")
	GameState.set_flag("has_stick", true)

## Deliberately synchronous from Events.transition_scene() onward -- see the
## earlier phase tests' note on why a real transition has to be last.
func _test_full_well_sequence(scene: Node) -> void:
	# Same reasoning as the stick trigger above: mark it used before calling
	# the handler directly so the sequence's own player movement through
	# this same spot can't re-fire it a second time for real.
	scene.fetch_trigger._used = true

	var dialogue_lines := {"n": 0}
	var listener := func(_speaker, _text, _kind): dialogue_lines["n"] += 1
	EventBus.dialogue_line_started.connect(listener)

	await scene._on_fetch_triggered()

	EventBus.dialogue_line_started.disconnect(listener)

	_check(dialogue_lines["n"] == 1, "the whole sequence uses exactly one line of dialogue (the shout), not exposition")
	_check(not GameState.control_enabled, "control never returns once the well sequence begins -- it can't be skipped")
	_check(GameState.intro_progress == "well_fall", "the fall advances the intro checkpoint")
	_check(GameState.gut.value <= -0.99, "the fall leaves the Gut Meter at full terror")
	_check(scene.player.modulate.a < 0.05, "the boy visibly fades out as he falls")
	_check(SaveManager.has_save(), "the fall is saved as a checkpoint before the world changes")
	_check(SceneManager.is_transitioning(), "the sequence ends by transitioning into the underworld")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)
