extends CanvasLayer
## Autoload: DebugOverlay
## Dev-only debug overlay (PRD section 69). Must never appear in release
## builds -- gated on OS.is_debug_build() at every entry point, not just
## on visibility, so exported release builds carry no debug UI or hooks.

var _overlay_visible := false
var _label: Label
var _debug_scenes: Dictionary = {} # id (String) -> scene path (String)

func _ready() -> void:
	layer = 4097
	if not OS.is_debug_build():
		set_process(false)
		set_process_unhandled_input(false)
		return
	_label = Label.new()
	_label.add_theme_color_override("font_color", Color.WHITE)
	_label.add_theme_color_override("font_outline_color", Color.BLACK)
	_label.add_theme_constant_override("outline_size", 3)
	_label.position = Vector2(12, 12)
	_label.visible = false
	add_child(_label)

## Later phases call this once their scene exists, e.g.
## DebugOverlay.register_scene("angel", "res://scenes/intro/IntroBedroomAngel.tscn")
func register_scene(id: String, path: String) -> void:
	if OS.is_debug_build():
		_debug_scenes[id] = path

func jump_to(id: String) -> void:
	if not OS.is_debug_build():
		return
	if _debug_scenes.has(id):
		SceneManager.goto_scene(_debug_scenes[id])
	else:
		push_warning("[DebugOverlay] No debug scene registered for id: %s" % id)

func _unhandled_input(event: InputEvent) -> void:
	if not OS.is_debug_build():
		return
	if event.is_action_pressed("debug_toggle"):
		_overlay_visible = not _overlay_visible
		_label.visible = _overlay_visible
		get_viewport().set_input_as_handled()
		return
	if not _overlay_visible or not (event is InputEventKey) or not event.pressed:
		return
	match event.keycode:
		KEY_1:
			GameState.health.restore_full()
		KEY_2:
			GameState.vitality.restore_full()
		KEY_3:
			GameState.gut.set_gut(0.0)
		KEY_4:
			GameState.gut.set_gut(-1.0)
		KEY_5:
			GameState.gut.set_gut(1.0)
		KEY_6:
			get_tree().debug_collisions_hint = not get_tree().debug_collisions_hint
		KEY_7:
			jump_to("angel")
		KEY_8:
			jump_to("underworld")

func _process(_delta: float) -> void:
	if not OS.is_debug_build() or not _overlay_visible:
		return
	_label.text = _build_debug_text()

func _build_debug_text() -> String:
	var player := get_tree().get_first_node_in_group("player")
	var gut_state_name: String = GutComponent.State.keys()[GameState.gut.get_gut_state()]
	return "\n".join([
		"Scene: %s" % GameState.current_scene_path,
		"Player position: %s" % (str(player.global_position) if player else "n/a"),
		"Health: %.0f / %.0f" % [GameState.health.current_health, GameState.health.max_health],
		"Vitality: %.0f / %.0f" % [GameState.vitality.current_vitality, GameState.vitality.max_vitality],
		"Gut: %.2f (%s)" % [GameState.gut.value, gut_state_name],
		"Cycle: %.2f (%s)" % [GameState.cycle_value, GameState.cycle_state],
		"Current screen: %s" % GameState.current_screen,
		"Save state: %s" % ("has save" if GameState.has_save else "no save"),
		"Movement mode: %d" % GameState.movement_mode,
		"",
		"[F3 toggle] 1 hp 2 vit 3 gut-calm 4 gut-terror 5 gut-joy 6 collision 7 angel 8 underworld",
	])
