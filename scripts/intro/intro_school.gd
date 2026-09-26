extends Node2D
## School arrival (PRD section 14.2). Fleshed out fully in Phase 6 -- this
## stub exists so Phase 5's bus sequence has a real scene to transition
## into without soft-locking.

@onready var player: Player = $Player

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "school_arrival"
	GameState.mark_screen_visited("intro_school")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
