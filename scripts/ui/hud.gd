class_name HUD
extends CanvasLayer
## Assembles the meters into one HUD and switches all of them between the
## clean human-world look and the weathered underworld look together
## (PRD section 63: the transition fades as a set, not piecemeal).

@onready var root: Control = $Root
@onready var health_bar: BarMeter = $Root/MetersBox/HealthBar
@onready var vitality_bar: BarMeter = $Root/MetersBox/VitalityBar
@onready var gut_meter: GutMeter = $Root/MetersBox/GutMeter
@onready var cycle_indicator: CycleIndicator = $Root/CycleIndicator
@onready var mini_map: MiniMap = $Root/MiniMap

func _ready() -> void:
	layer = 10
	set_world_style(GameState.current_world)

func set_world_style(world: String) -> void:
	var underworld := world == "underworld"
	health_bar.set_style(BarMeter.Style.WEATHERED if underworld else BarMeter.Style.CLEAN)
	vitality_bar.set_style(health_bar.style)
	gut_meter.set_style(GutMeter.Style.GRANULAR_UNDERWORLD if underworld else GutMeter.Style.OPAQUE_INTRO)
	cycle_indicator.set_style(CycleIndicator.Style.HOURGLASS if underworld else CycleIndicator.Style.SUN_MOON)

func refresh_minimap() -> void:
	mini_map.refresh()
