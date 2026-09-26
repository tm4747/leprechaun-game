extends Node2D
## First playable underworld screen (PRD sections 35-45, 55-60). A single
## bounded board -- four paths are visible but not yet crossable, and
## nothing here explains where the boy is or what to do next (sections 42,
## 44). world_id/screen_id per section 59's logical-screen architecture.

const WORLD_ID := "underworld"
const SCREEN_ID := "forest_001"
const BOARD_SIZE := Vector2(1920, 1080)

## A small, fixed number of internal observations (PRD section 43) --
## never a constant narration system. Each fires once, in order, the
## first time its delay has elapsed since arriving.
const THOUGHTS: Array[Dictionary] = [
	{"delay": 3.0, "text": "What is this place...?"},
	{"delay": 14.0, "text": "How did I get here?"},
	{"delay": 26.0, "text": "It's like our world... but where is the sun?"},
	{"delay": 40.0, "text": "I don't know what that is up there."},
]

@onready var player: Player = $Player

var _elapsed := 0.0
var _next_thought_index := 0

func _ready() -> void:
	DebugOverlay.register_scene("underworld", scene_file_path)
	GameState.current_scene_path = scene_file_path
	GameState.current_world = WORLD_ID
	GameState.intro_progress = "underworld_first_screen"
	GameState.mark_screen_visited(SCREEN_ID)

	player.set_movement_mode(Player.MovementMode.TOP_DOWN)
	player.set_camera_limits(0, 0, int(BOARD_SIZE.x), int(BOARD_SIZE.y))
	player.global_position = BOARD_SIZE / 2.0

	# Section 63: the UI transitions as a set rather than popping instantly.
	# CanvasLayer itself has no modulate -- fade the HUD's inner Root Control.
	GameHUD.root.modulate.a = 0.0
	GameHUD.set_world_style(WORLD_ID)
	var hud_fade := create_tween()
	hud_fade.tween_property(GameHUD.root, "modulate:a", 1.0, 1.0)

	GameState.set_control_enabled(true)
	set_process(true)

func _process(delta: float) -> void:
	_elapsed += delta
	if _next_thought_index < THOUGHTS.size() and _elapsed >= THOUGHTS[_next_thought_index]["delay"]:
		var thought: Dictionary = THOUGHTS[_next_thought_index]
		_next_thought_index += 1
		Dialogue.say("", thought["text"], "THOUGHT", 2.6)
