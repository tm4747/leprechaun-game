extends Node2D
## Falling into the underworld (PRD section 34). Fleshed out fully in
## Phase 10 -- this stub exists so Phase 9's well fall has a real scene to
## transition into.

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.current_world = "underworld"
	GameState.intro_progress = "underworld_transition"
