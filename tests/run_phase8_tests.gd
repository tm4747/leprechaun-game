extends Node
## Headless test runner for Phase 8 acceptance criteria (PRD section 65/66):
## all three meters clearly change from critical to restored, no explicit
## protection notification appears, and the protected room visually
## contrasts with the chaotic state that came before it.
## Run with: godot --headless --path . res://tests/Phase8Test.tscn

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 8 parents / angel tests ==")
	GameState.reset_for_new_quest()

	await _test_parents_argument()
	await _test_distortion_reacts_to_critical_state()
	await _test_angel_sequence() # ends with a real transition -- keep last

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_parents_argument() -> void:
	var home = preload("res://scenes/intro/IntroHome.tscn").instantiate()
	add_child(home)
	await get_tree().process_frame

	var speakers_seen := {"set": {}}
	var listener := func(speaker, _text, _kind): speakers_seen["set"][speaker] = true
	EventBus.dialogue_line_started.connect(listener)

	var health_before := GameState.health.current_health
	var vitality_before := GameState.vitality.current_vitality
	var gut_before := GameState.gut.value

	await home._father_arrives_and_argument()

	EventBus.dialogue_line_started.disconnect(listener)

	_check(home.father.visible, "father becomes visible when he arrives home")
	_check(speakers_seen["set"].has("Father") and speakers_seen["set"].has("Mother"),
		"both parents speak during the argument")
	_check(GameState.health.current_health < health_before, "the argument lowers health toward the redline")
	_check(GameState.vitality.current_vitality < vitality_before, "the argument lowers vitality toward the redline")
	_check(GameState.gut.value < gut_before, "the argument pushes the Gut Meter further toward terror")
	_check(GameState.control_enabled, "the player is free to move during the argument, not locked into a cutscene")

	home.queue_free()
	await get_tree().process_frame

func _test_distortion_reacts_to_critical_state() -> void:
	GameState.reset_for_new_quest()
	var bedroom = preload("res://scenes/intro/IntroBedroomAngel.tscn").instantiate()
	add_child(bedroom)
	await get_tree().process_frame

	_check(is_equal_approx(bedroom.distortion_overlay.color.a, 0.0), "the room starts undistorted when the meters are healthy")

	GameState.health.damage(90.0) # forces a critical state
	await get_tree().create_timer(0.7).timeout
	_check(bedroom.distortion_overlay.color.a > 0.1, "the room visibly distorts once a meter goes critical")

	GameState.health.restore_full()
	await get_tree().create_timer(0.7).timeout
	_check(bedroom.distortion_overlay.color.a < 0.05, "the distortion clears once the meter recovers")

	bedroom.queue_free()
	await get_tree().process_frame

## Deliberately synchronous from Events.transition_scene() onward -- see the
## earlier phase tests' note on why a real transition has to be last.
func _test_angel_sequence() -> void:
	GameState.reset_for_new_quest()
	SaveManager.delete_save()
	GameState.health.damage(85.0)
	GameState.vitality.consume(85.0)
	GameState.gut.set_gut(-0.9)

	var bedroom = preload("res://scenes/intro/IntroBedroomAngel.tscn").instantiate()
	add_child(bedroom)
	await get_tree().process_frame
	_check(CriticalWarnings.any_critical(), "the boy is genuinely in a critical state before the angel arrives")

	var thought_count := {"n": 0}
	var listener := func(_speaker, _text, kind):
		if kind == "THOUGHT":
			thought_count["n"] += 1
	EventBus.dialogue_line_started.connect(listener)

	await bedroom._on_rug_triggered()

	EventBus.dialogue_line_started.disconnect(listener)

	_check(thought_count["n"] >= 3, "the prayer plays as the boy's internal thoughts, not spoken dialogue")
	_check(bedroom.angel.visible and bedroom.angel.modulate.a > 0.9, "the angel is fully visible after descending")
	_check(GameState.health.current_health == GameState.health.max_health, "the angel fully restores health")
	_check(GameState.vitality.current_vitality == GameState.vitality.max_vitality, "the angel fully restores vitality")
	_check(GameState.gut.value > 0.0, "the angel moves the Gut Meter back toward calm/joy")
	_check(not CriticalWarnings.any_critical(), "no meter is still critical after the angel's healing")
	_check(SaveManager.has_save(), "the angel scene is a safe checkpoint that saves the game")
	_check(GameState.intro_progress == "angel_scene_complete", "the angel scene advances the intro checkpoint")
	_check(SceneManager.is_transitioning(), "the scene transitions onward to Saturday morning once the boy can sleep")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)
