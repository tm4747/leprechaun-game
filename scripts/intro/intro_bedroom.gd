extends Node2D
## Friday morning: bedroom (PRD section 13.1). Boy starts asleep in bed,
## already dressed; no explicit movement tutorial -- the player discovers
## movement by pressing a direction, which just walks the boy off the bed
## and out toward the hallway.

const NEXT_SCENE := "res://scenes/intro/IntroHouseInterior.tscn"

@onready var player: Player = $Player

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "friday_bedroom"
	GameState.mark_screen_visited("intro_bedroom")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 900, 600)
