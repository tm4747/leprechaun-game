extends Node2D
## Evening: return home, dinner, living room, TV, parents (PRD sections
## 19-24). Fleshed out fully in Phase 7 -- this stub exists so Phase 6's
## bus-home beat has a real scene to transition into.

@onready var player: Player = $Player

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "evening_return_home"
	GameState.mark_screen_visited("intro_home")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
