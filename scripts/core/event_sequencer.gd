extends Node
## Autoload: Events
## Composable primitives for scripted cutscenes (PRD section 52). Scene
## "director" scripts await these in sequence instead of hand-rolling
## cinematic state machines inside _process() (PRD Rule 8 / section 52).

func disable_control() -> void:
	GameState.set_control_enabled(false)

func enable_control() -> void:
	GameState.set_control_enabled(true)

func dialogue(speaker: String, text: String, kind: String = "CLEAR", hold_time: float = -1.0) -> void:
	await Dialogue.say(speaker, text, kind, hold_time)

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

## character must implement move_to(target_position, speed) -- Player does.
func move_character(character: Node, target_position: Vector2, speed: float = 160.0) -> void:
	if character.has_method("move_to"):
		await character.move_to(target_position, speed)

func set_gut(value: float) -> void:
	GameState.gut.set_gut(value)

func modify_gut(delta: float) -> void:
	GameState.gut.modify_gut(delta)

func set_health(value: float) -> void:
	GameState.health.current_health = clampf(value, 0.0, GameState.health.max_health)
	GameState.health.health_changed.emit(GameState.health.current_health, GameState.health.max_health)

func heal_full() -> void:
	GameState.health.restore_full()

func set_vitality(value: float) -> void:
	GameState.vitality.current_vitality = clampf(value, 0.0, GameState.vitality.max_vitality)
	GameState.vitality.vitality_changed.emit(GameState.vitality.current_vitality, GameState.vitality.max_vitality)

func restore_vitality_full() -> void:
	GameState.vitality.restore_full()

func fade_to_black(duration: float = 0.5) -> void:
	await SceneManager.fade_to_black(duration)

func fade_from_black(duration: float = 0.5) -> void:
	await SceneManager.fade_from_black(duration)

func transition_scene(path: String) -> void:
	SceneManager.goto_scene(path)

func play_sfx(player: AudioStreamPlayer, stream: AudioStream) -> void:
	player.stream = stream
	player.play()
	await player.finished
