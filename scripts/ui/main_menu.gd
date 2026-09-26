class_name MainMenu
extends Control
## Title screen (PRD section 10). Black opening -> letters reveal one at a
## time -> membrane opens -> Start/Continue. Continue is disabled without a
## save; starting over with an existing save requires explicit confirmation
## (section 10.5) so a player can never destroy a quest by accident.

const FIRST_INTRO_SCENE := "res://scenes/intro/IntroBedroom.tscn"
const LETTER_DELAY := 0.28
const LETTER_FADE_DURATION := 0.35
const POST_REVEAL_HOLD := 0.6

@onready var letters_box: HBoxContainer = $CenterContainer/VBoxContainer/LettersBox
@onready var menu_box: VBoxContainer = $CenterContainer/VBoxContainer/MenuBox
@onready var start_button: Button = $CenterContainer/VBoxContainer/MenuBox/StartButton
@onready var continue_button: Button = $CenterContainer/VBoxContainer/MenuBox/ContinueButton
@onready var confirm_dialog: Control = $ConfirmDialog
@onready var confirm_yes: Button = $ConfirmDialog/Panel/VBox/Buttons/YesButton
@onready var confirm_no: Button = $ConfirmDialog/Panel/VBox/Buttons/NoButton
@onready var music_player: AudioStreamPlayer = $MusicPlayer

var _letters: Array[Label] = []
var reveal_finished := false

func _ready() -> void:
	DebugOverlay.register_scene("menu", scene_file_path)
	confirm_dialog.visible = false
	menu_box.modulate.a = 0.0
	menu_box.visible = false

	for child in letters_box.get_children():
		if child is Label:
			_letters.append(child)
			child.modulate.a = 0.0

	continue_button.disabled = not GameState.has_save
	start_button.pressed.connect(_on_start_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	confirm_yes.pressed.connect(_on_confirm_yes)
	confirm_no.pressed.connect(_on_confirm_no)

	_play_music()
	await _reveal_title()
	_show_menu()

func _reveal_title() -> void:
	for letter in _letters:
		var tween := create_tween()
		tween.tween_property(letter, "modulate:a", 1.0, LETTER_FADE_DURATION) \
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(LETTER_DELAY).timeout
	await get_tree().create_timer(POST_REVEAL_HOLD).timeout
	reveal_finished = true

func _show_menu() -> void:
	menu_box.visible = true
	var tween := create_tween()
	tween.tween_property(menu_box, "modulate:a", 1.0, 0.6)
	continue_button.disabled = not GameState.has_save

func _play_music() -> void:
	music_player.stream = ToneGenerator.generate_drone()
	music_player.volume_db = -14.0
	music_player.play()

func _on_start_pressed() -> void:
	if GameState.has_save:
		confirm_dialog.visible = true
	else:
		_begin_new_quest()

func _on_continue_pressed() -> void:
	if not GameState.has_save:
		return
	SaveManager.continue_game()

func _on_confirm_yes() -> void:
	confirm_dialog.visible = false
	SaveManager.delete_save()
	_begin_new_quest()

func _on_confirm_no() -> void:
	confirm_dialog.visible = false

func _begin_new_quest() -> void:
	GameState.reset_for_new_quest()
	SceneManager.goto_scene(FIRST_INTRO_SCENE)
