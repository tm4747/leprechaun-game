extends Node
## Autoload: SaveManager
## Single active quest slot (PRD section 51). Saves only at safe logical
## checkpoints -- callers decide when, this just persists GameState.

const SAVE_PATH := "user://leprechaun_save.json"
const SAVE_VERSION := 1

func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)

func save_game() -> void:
	var data := {
		"version": SAVE_VERSION,
		"player_name": GameState.player_name,
		"dog_name": GameState.dog_name,
		"current_scene": GameState.current_scene_path,
		"intro_progress": GameState.intro_progress,
		"health": GameState.health.current_health,
		"max_health": GameState.health.max_health,
		"vitality": GameState.vitality.current_vitality,
		"max_vitality": GameState.vitality.max_vitality,
		"gut": GameState.gut.value,
		"world": GameState.current_world,
		"current_screen": GameState.current_screen,
	}
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("[SaveManager] Failed to open save file for writing: %s" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(data, "\t"))
	file.close()
	GameState.has_save = true

func load_game() -> bool:
	if not has_save():
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		push_error("[SaveManager] Failed to open save file for reading: %s" % SAVE_PATH)
		return false
	var text := file.get_as_text()
	file.close()

	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("[SaveManager] Save file is corrupt: %s" % SAVE_PATH)
		return false

	var data: Dictionary = parsed
	GameState.player_name = data.get("player_name", "Danny")
	GameState.dog_name = data.get("dog_name", "Buddy")
	GameState.current_scene_path = data.get("current_scene", "")
	GameState.intro_progress = data.get("intro_progress", "not_started")
	GameState.health.max_health = data.get("max_health", 100.0)
	GameState.health.current_health = data.get("health", 100.0)
	GameState.vitality.max_vitality = data.get("max_vitality", 100.0)
	GameState.vitality.current_vitality = data.get("vitality", 100.0)
	GameState.gut.set_gut(data.get("gut", 0.0))
	GameState.current_world = data.get("world", "human")
	GameState.current_screen = data.get("current_screen", "")
	GameState.has_save = true
	return true

## Destroys the active quest (PRD section 10.5 "Start" over an existing save).
func delete_save() -> void:
	if has_save():
		DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_PATH))
	GameState.has_save = false

func continue_game() -> void:
	if load_game() and GameState.current_scene_path != "":
		SceneManager.goto_scene(GameState.current_scene_path)
