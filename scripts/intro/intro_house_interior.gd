extends Node2D
## Hallway + kitchen, consolidated into one scene per PRD section 8.2
## ("can be consolidated where technically cleaner"). Covers sections
## 13.2 (hallway), 13.3 (kitchen/breakfast) and 13.4 (backpack).

const NEXT_SCENE := "res://scenes/intro/IntroExterior.tscn"

@onready var player: Player = $Player
@onready var breakfast_trigger: AutoEventTrigger = $BreakfastTrigger
@onready var backpack_trigger: AutoEventTrigger = $BackpackTrigger
@onready var table_seat: Marker2D = $TableSeat
@onready var mother: NPCPlaceholder = $Mother

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "friday_kitchen"
	GameState.mark_screen_visited("intro_house_interior")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 1600, 600)

	if GameState.pending_spawn_id != "" and has_node(GameState.pending_spawn_id):
		player.global_position = get_node(GameState.pending_spawn_id).global_position
	GameState.pending_spawn_id = ""

	breakfast_trigger.triggered.connect(_on_breakfast_triggered)
	backpack_trigger.triggered.connect(_on_backpack_triggered)

func _on_breakfast_triggered() -> void:
	Events.disable_control()
	# Incidental line during an otherwise-automatic beat -- auto-advances
	# rather than waiting on confirm, so a missed prompt can't soft-lock it.
	await Events.dialogue(mother.npc_name, "Good morning, sweetheart. I made you some French toast.", "CLEAR", 2.4)
	await Events.move_character(player, table_seat.global_position, 140.0)
	await Events.wait(1.2)
	Events.enable_control()

func _on_backpack_triggered() -> void:
	GameState.set_flag("has_backpack", true)
