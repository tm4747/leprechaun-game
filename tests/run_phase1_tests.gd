extends Node
## Headless test runner for Phase 1 acceptance criteria (PRD section 65).
## Run with: godot --headless --path . res://tests/Phase1Test.tscn
## Exits with code 1 if any assertion fails, so it can gate CI/manual checks.

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 1 core state tests ==")

	_test_health()
	_test_vitality()
	_test_gut()
	_test_save_load()

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_health() -> void:
	var h := GameState.health
	h.max_health = 100.0
	h.restore_full()
	h.damage(30.0)
	_check(h.current_health == 70.0, "health.damage lowers health")
	h.heal(10.0)
	_check(h.current_health == 80.0, "health.heal increases health")
	h.restore_full()
	_check(h.current_health == 100.0, "health.restore_full works")
	h.damage(85.0)
	_check(h.is_critical(), "health critical warning activates below 20%")
	h.restore_full()

func _test_vitality() -> void:
	var v := GameState.vitality
	v.max_vitality = 100.0
	v.restore_full()
	v.consume(40.0)
	_check(v.current_vitality == 60.0, "vitality.consume drains vitality")
	v.restore(20.0)
	_check(v.current_vitality == 80.0, "vitality.restore works")
	v.consume(70.0)
	_check(v.is_critical(), "vitality critical warning activates")
	v.restore_full()

func _test_gut() -> void:
	var g := GameState.gut
	g.set_gut(-0.9)
	_check(g.get_gut_state() == GutComponent.State.TERROR, "gut terror state works")
	g.set_gut(0.0)
	_check(g.get_gut_state() == GutComponent.State.CALM, "gut calm state works")
	g.set_gut(0.9)
	_check(g.get_gut_state() == GutComponent.State.EXCITEMENT, "gut joy/excitement state works")
	g.set_gut(0.0)

func _test_save_load() -> void:
	GameState.player_name = "TestBoy"
	GameState.dog_name = "TestDog"
	GameState.intro_progress = "friday_kitchen"
	GameState.health.current_health = 55.0
	GameState.vitality.current_vitality = 33.0
	GameState.gut.set_gut(0.5)
	GameState.current_world = "underworld"
	GameState.current_screen = "forest_001"

	SaveManager.save_game()
	_check(SaveManager.has_save(), "save_game creates a save file")

	# Corrupt in-memory state, then reload from disk to prove persistence.
	GameState.player_name = "Wrong"
	GameState.health.current_health = 1.0
	GameState.gut.set_gut(-1.0)

	var loaded := SaveManager.load_game()
	_check(loaded, "load_game reports success")
	_check(GameState.player_name == "TestBoy", "load_game restores player_name")
	_check(GameState.intro_progress == "friday_kitchen", "load_game restores intro_progress")
	_check(GameState.health.current_health == 55.0, "load_game restores health")
	_check(GameState.vitality.current_vitality == 33.0, "load_game restores vitality")
	_check(is_equal_approx(GameState.gut.value, 0.5), "load_game restores gut")
	_check(GameState.current_world == "underworld", "load_game restores world")
	_check(GameState.current_screen == "forest_001", "load_game restores current_screen")

	SaveManager.delete_save()
	_check(not SaveManager.has_save(), "delete_save removes the save file")
