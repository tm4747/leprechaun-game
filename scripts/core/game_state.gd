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

func set_control_enabled(enabled: bool) -> void:
	if control_enabled == enabled:
		return
	control_enabled = enabled
	if enabled:
		EventBus.control_enabled.emit()
	else:
		EventBus.control_disabled.emit()
