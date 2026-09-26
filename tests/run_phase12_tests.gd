extends Node
## Headless test runner for Phase 12 polish/QA (PRD section 65 Phase 12,
## section 79 Definition of Done): save/load reliability across every
## checkpoint in the game, and no broken scene references anywhere in the
## build order. Run with: godot --headless --path . res://tests/Phase12Test.tscn

const CHECKPOINTS: Array[Dictionary] = [
	{"scene": "res://scenes/intro/IntroBedroom.tscn", "progress": "friday_bedroom"},
	{"scene": "res://scenes/intro/IntroHouseInterior.tscn", "progress": "friday_kitchen"},
	{"scene": "res://scenes/intro/IntroExterior.tscn", "progress": "friday_exterior"},
	{"scene": "res://scenes/intro/IntroSchool.tscn", "progress": "school_arrival"},
	{"scene": "res://scenes/intro/IntroHome.tscn", "progress": "evening_return_home"},
	{"scene": "res://scenes/intro/IntroBedroomAngel.tscn", "progress": "night_bedroom"},
	{"scene": "res://scenes/intro/WellSequence.tscn", "progress": "saturday_morning"},
	{"scene": "res://scenes/underworld/UnderworldTransition.tscn", "progress": "underworld_transition"},
	{"scene": "res://scenes/underworld/UnderworldFirstScreen.tscn", "progress": "underworld_first_screen"},
]

const ALL_PROJECT_SCENES: Array[String] = [
	"res://scenes/boot/Boot.tscn",
	"res://scenes/menu/MainMenu.tscn",
	"res://scenes/intro/IntroBedroom.tscn",
	"res://scenes/intro/IntroHouseInterior.tscn",
	"res://scenes/intro/IntroExterior.tscn",
	"res://scenes/intro/IntroSchool.tscn",
	"res://scenes/intro/IntroHome.tscn",
	"res://scenes/intro/IntroBedroomAngel.tscn",
	"res://scenes/intro/WellSequence.tscn",
	"res://scenes/underworld/UnderworldTransition.tscn",
	"res://scenes/underworld/UnderworldFirstScreen.tscn",
]

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 12 polish / QA tests ==")

	_test_all_scenes_resolve()
	_test_save_load_across_every_checkpoint()
	_test_corrupt_save_handled_gracefully()

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_all_scenes_resolve() -> void:
	for path in ALL_PROJECT_SCENES:
		_check(ResourceLoader.exists(path), "scene resolves: %s" % path)

func _test_save_load_across_every_checkpoint() -> void:
	for checkpoint in CHECKPOINTS:
		GameState.reset_for_new_quest()
		GameState.current_scene_path = checkpoint["scene"]
		GameState.intro_progress = checkpoint["progress"]
		GameState.health.current_health = 42.0
		GameState.vitality.current_vitality = 77.0
		GameState.gut.set_gut(-0.35)
		GameState.current_world = "underworld" if checkpoint["scene"].contains("underworld") else "human"

		SaveManager.save_game()

		# Scramble in-memory state so a stale in-memory value can't
		# masquerade as a successful load.
		GameState.current_scene_path = "res://scenes/menu/MainMenu.tscn"
		GameState.intro_progress = "not_started"
		GameState.health.current_health = 1.0

		var loaded := SaveManager.load_game()
		_check(loaded, "load succeeds for checkpoint %s" % checkpoint["progress"])
		_check(GameState.current_scene_path == checkpoint["scene"],
			"checkpoint %s restores the correct scene path" % checkpoint["progress"])
		_check(GameState.intro_progress == checkpoint["progress"],
			"checkpoint %s restores the correct progress id" % checkpoint["progress"])
		_check(GameState.health.current_health == 42.0,
			"checkpoint %s restores health" % checkpoint["progress"])
		_check(ResourceLoader.exists(GameState.current_scene_path),
			"checkpoint %s's saved scene is a valid Continue target" % checkpoint["progress"])

	SaveManager.delete_save()

func _test_corrupt_save_handled_gracefully() -> void:
	var path := "user://leprechaun_save.json"
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_string("{ this is not valid json ]")
	file.close()

	var loaded := SaveManager.load_game()
	_check(not loaded, "a corrupt save file fails to load instead of crashing")

	SaveManager.delete_save()
	_check(not SaveManager.has_save(), "a corrupt save can still be cleared via delete_save")
