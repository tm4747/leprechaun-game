extends CanvasLayer
## Autoload: SceneManager
## Handles scene transitions with a fade-to-black so no scene change is a
## hard cut unless a cinematic explicitly wants one (PRD section 34, 63).

const DEFAULT_FADE_DURATION := 0.4

var _fade_rect: ColorRect
var _is_transitioning := false

func _ready() -> void:
	layer = 4096
	_fade_rect = ColorRect.new()
	_fade_rect.color = Color.BLACK
	_fade_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_fade_rect.modulate.a = 0.0
	add_child(_fade_rect)

func is_transitioning() -> bool:
	return _is_transitioning

## Fades to black, swaps the scene, then fades back in. Disables player
## control for the duration so nothing sneaks input in during the cut.
func goto_scene(path: String, fade_duration: float = DEFAULT_FADE_DURATION) -> void:
	if _is_transitioning:
		return
	if not ResourceLoader.exists(path):
		push_error("[SceneManager] Scene does not exist: %s" % path)
		return
	_is_transitioning = true
	EventBus.scene_transition_started.emit(path)
	GameState.set_control_enabled(false)

	await fade_to_black(fade_duration)
	get_tree().change_scene_to_file(path)
	GameState.current_scene_path = path
	await get_tree().process_frame
	await fade_from_black(fade_duration)

	GameState.set_control_enabled(true)
	EventBus.scene_transition_finished.emit(path)
	_is_transitioning = false

func fade_to_black(duration: float = DEFAULT_FADE_DURATION) -> void:
	var tween := create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_from_black(duration: float = DEFAULT_FADE_DURATION) -> void:
	var tween := create_tween()
	tween.tween_property(_fade_rect, "modulate:a", 0.0, duration)
	await tween.finished
