extends Node
## Headless test runner for Phase 6 acceptance criteria (PRD section 65/66):
## the supernatural hints occur without explicit explanation and the Gut
## Meter responds appropriately.
## Run with: godot --headless --path . res://tests/Phase6Test.tscn

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 6 school sequence tests ==")
	GameState.reset_for_new_quest()

	var school = preload("res://scenes/intro/IntroSchool.tscn").instantiate()
	add_child(school)
	await get_tree().process_frame

	await _test_school_door(school)
	await _test_incident(school)
	_test_billy(school) # deliberately synchronous to the final quit()

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_school_door(school: Node) -> void:
	await school._on_school_door_triggered()
	_check(GameState.intro_progress == "school_recess", "entering school advances to recess without a classroom minigame")
	_check(GameState.control_enabled, "control returns to the player once class is over")

func _test_incident(school: Node) -> void:
	var seen_kinds := {"garbled_count": 0}
	var listener := func(_speaker, _text, kind):
		if kind == "GARBLED":
			seen_kinds["garbled_count"] += 1
	EventBus.dialogue_line_started.connect(listener)

	GameState.gut.set_gut(0.0)
	await school._on_incident_triggered()

	EventBus.dialogue_line_started.disconnect(listener)

	_check(seen_kinds["garbled_count"] >= 2, "the argument plays as garbled/unintelligible dialogue, not translated subtitles")
	_check(GameState.gut.value < 0.0, "the Gut Meter dips during the red-eye moment")
	_check(school.kid_a.eyes.color != Color(0.9, 0.1, 0.1), "eyes return to normal immediately after the flash (no lingering supernatural marker)")
	_check(GameState.intro_progress == "school_incident_seen", "the incident advances the intro checkpoint")
	_check(GameState.control_enabled, "control returns to the player after the incident")

## Deliberately synchronous from Events.transition_scene() onward -- see the
## Phase 4/5 tests' note on why a real transition has to be the last thing
## a test does.
func _test_billy(school: Node) -> void:
	var gut_peak := {"max": -1.0}
	var listener := func(value, _state):
		gut_peak["max"] = maxf(gut_peak["max"], value)
	GameState.gut.gut_changed.connect(listener)

	await school._on_billy_triggered()

	GameState.gut.gut_changed.disconnect(listener)

	_check(gut_peak["max"] >= 0.55, "seeing Billy swings the Gut Meter sharply toward joy")
	_check(GameState.gut.value < 0.0, "Billy's mockery swings the Gut Meter back toward fear/sadness")
	_check(SceneManager.is_transitioning(), "the school day ends by transitioning home")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)
