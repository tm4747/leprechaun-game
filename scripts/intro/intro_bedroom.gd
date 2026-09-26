extends Node2D
## Friday morning: bedroom (PRD section 13.1). Boy starts asleep in bed,
## already dressed; player discovers movement with no tutorial prompt.
## Fleshed out fully in Phase 5 -- this stub exists so Phase 4's
## Start/Continue flow has a real scene to transition into.

@onready var player: Player = $Player

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.mark_screen_visited("intro_bedroom")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
