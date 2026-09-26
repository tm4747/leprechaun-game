extends Node
## Headless test runner for Phase 10 acceptance criteria (PRD section 65):
## the player emerges in the correct underworld scene.
## Run with: godot --headless --path . res://tests/Phase10Test.tscn
##
## This scene's whole job is to play out on its own and then transition --
## there's no player-triggered beat to isolate, so the test just lets it
## run and checks the outcome. That final transition is real, so (per the
## established pattern in earlier phase tests) this has to be the only
## thing this test does.

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 10 underworld transition tests ==")
	GameState.reset_for_new_quest()
	GameState.current_world = "human"

	var scene = preload("res://scenes/underworld/UnderworldTransition.tscn").instantiate()
	add_child(scene)
	await get_tree().process_frame

	_check(GameState.current_world == "underworld", "entering the transition immediately flips the world state")
	_check(not GameState.control_enabled, "control stays disabled through the whole transition")

	# Let the full fall -> darkness -> waking sequence play out for real,
	# but watch for the transition signal rather than guessing a fixed
	# duration: SceneManager.goto_scene() swaps out the whole tree shortly
	# after firing it, which would destroy this very test node if we were
	# still awaiting a timer when that happens.
	await EventBus.scene_transition_started
	_check(SceneManager.is_transitioning(), "the transition ends by moving into the first underworld screen")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)
