extends Node
## Headless test runner for Phase 4 acceptance criteria (PRD section 65/66).
## Run with: godot --headless --path . res://tests/Phase4Test.tscn
##
## NOTE on structure: SceneManager.goto_scene() ultimately calls
## get_tree().change_scene_to_file(), which replaces this very test node's
## tree once its fade-out tween completes (~0.4s later). So exactly one
## transition-triggering scenario runs, last, and everything after it stays
## synchronous (no awaits) until an immediate quit() -- long before that
## tween could fire and pull the rug out from under the still-running test.

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 4 title screen tests ==")
	SaveManager.delete_save()

	await _test_title_reveal_and_no_save_state()
	await _test_continue_enabled_with_save()
	await _test_confirmation_and_transition_flow()

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _spawn_menu() -> MainMenu:
	var menu: MainMenu = preload("res://scenes/menu/MainMenu.tscn").instantiate()
	add_child(menu)
	await get_tree().process_frame
	return menu

func _test_title_reveal_and_no_save_state() -> void:
	SaveManager.delete_save()
	var menu := await _spawn_menu()
	_check(menu.continue_button.disabled, "Continue disabled with no save")

	while not menu.reveal_finished:
		await get_tree().process_frame
	await get_tree().process_frame
	_check(menu.menu_box.visible, "title animation completes and menu becomes visible")

	menu.queue_free()
	await get_tree().process_frame

func _test_continue_enabled_with_save() -> void:
	GameState.reset_for_new_quest()
	GameState.current_scene_path = MainMenu.FIRST_INTRO_SCENE
	SaveManager.save_game()
	var menu := await _spawn_menu()
	_check(not menu.continue_button.disabled, "Continue enabled once a save exists")
	menu.queue_free()
	await get_tree().process_frame

## Deliberately synchronous from the first _on_start_pressed() call to the
## final quit() -- see the note above the class.
func _test_confirmation_and_transition_flow() -> void:
	GameState.reset_for_new_quest()
	GameState.current_scene_path = MainMenu.FIRST_INTRO_SCENE
	SaveManager.save_game()
	var menu: MainMenu = preload("res://scenes/menu/MainMenu.tscn").instantiate()
	add_child(menu)
	await get_tree().process_frame # let menu's own _ready() run once, naturally

	menu._on_start_pressed()
	_check(menu.confirm_dialog.visible, "Start with an existing save shows the confirmation dialog")

	menu._on_confirm_no()
	_check(not menu.confirm_dialog.visible, "Choosing No dismisses the dialog")
	_check(SaveManager.has_save(), "Choosing No preserves the existing save")

	menu._on_start_pressed()
	_check(menu.confirm_dialog.visible, "Start shows the dialog again on a second attempt")

	# Choosing Yes exercises the exact same _begin_new_quest() path that a
	# fresh (no-save) Start also uses, so this covers both branches of
	# _on_start_pressed()'s save-exists check.
	menu._on_confirm_yes()
	_check(not SaveManager.has_save(), "Choosing Yes destroys the existing save")
	_check(SceneManager.is_transitioning(), "Choosing Yes begins the transition into the intro scene")

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)
