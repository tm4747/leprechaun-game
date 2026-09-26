extends Node2D
## Saturday morning: dog, stick, well (PRD sections 31-34). Fleshed out
## fully in Phase 9 -- this stub exists so Phase 8's angel scene has a
## real scene to transition into.

@onready var player: Player = $Player

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "saturday_morning"
	GameState.mark_screen_visited("intro_saturday")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
