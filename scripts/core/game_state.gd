extends Node
## Autoload: GameState
## Centralized game state model (PRD section 8.3).
## Do not scatter critical state across scene-local variables -- everything
## that must survive a scene change or be saved lives here.

var health: HealthComponent
var vitality: VitalityComponent
var gut: GutComponent

var player_name: String = "Danny"
var dog_name: String = "Buddy"
var has_save: bool = false

## Free-form checkpoint id (e.g. "friday_bedroom", "angel_scene_complete").
## Kept as a String rather than an enum so intro content stays data-driven
## (PRD Rule 4) and new checkpoints don't require touching this script.
var intro_progress: String = "not_started"

var current_scene_path: String = ""
var current_world: String = "human" # "human" | "underworld"
var current_screen: String = ""

## Name of a Marker2D in the destination scene to spawn the player at,
## set by an ExitTrigger just before transitioning. Cleared once consumed.
var pending_spawn_id: String = ""

## Simple narrative flags the intro needs (has_backpack, etc.) without
## inventing a full inventory/quest-flag system (PRD Rule 3).
var story_flags: Dictionary = {}

func set_flag(flag_name: String, value: bool = true) -> void:
	story_flags[flag_name] = value

func has_flag(flag_name: String) -> bool:
	return story_flags.get(flag_name, false)

## Logical screen graph backing the mini-map (PRD section 60). A future
## multi-screen underworld appends to this instead of replacing the system.
var visited_screens: Array[String] = []

## 0..1 human-world sun/moon position, later reinterpreted as the
## underworld hourglass fill (PRD section 40).
var cycle_value: float = 0.35
var cycle_state: String = "day"

## Mirrors Player.MovementMode without creating a hard dependency from
## GameState -> Player; the player controller writes this on mode switch.
var movement_mode: int = 0

var control_enabled: bool = true

func _ready() -> void:
	health = HealthComponent.new()
	vitality = VitalityComponent.new()
	gut = GutComponent.new()
	has_save = FileAccess.file_exists("user://leprechaun_save.json")

func reset_for_new_quest() -> void:
	intro_progress = "not_started"
	current_world = "human"
	current_screen = ""
	cycle_value = 0.35
	cycle_state = "day"
	control_enabled = true
	health.restore_full()
	vitality.restore_full()
	gut.set_gut(0.0)

func mark_screen_visited(screen_id: String) -> void:
	current_screen = screen_id
	if not visited_screens.has(screen_id):
		visited_screens.append(screen_id)

func set_control_enabled(enabled: bool) -> void:
	if control_enabled == enabled:
		return
	control_enabled = enabled
	if enabled:
		EventBus.control_enabled.emit()
	else:
		EventBus.control_disabled.emit()
