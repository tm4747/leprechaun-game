extends Node2D
## First playable underworld screen (PRD sections 35-43). Fleshed out fully
## in Phase 11 -- this stub exists so Phase 10's transition has a real
## scene to land in.

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.current_world = "underworld"
	GameState.intro_progress = "underworld_first_screen"
	GameState.mark_screen_visited("forest_001")
	GameState.set_control_enabled(true)
