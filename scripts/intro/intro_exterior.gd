extends Node2D
## Yard / path / well area + bus route (PRD sections 13.5, 14.1). The well
## is visible but purely scenery on this Friday visit -- it only becomes
## interactive in the Saturday well sequence (Phase 9).

const SCHOOL_SCENE := "res://scenes/intro/IntroSchool.tscn"

@onready var player: Player = $Player
@onready var bus_stop_trigger: AutoEventTrigger = $BusStopTrigger
@onready var bus: ColorRect = $Bus
@onready var bus_arrival_marker: Marker2D = $BusArrivalMarker
@onready var bus_stand_marker: Marker2D = $BusStandMarker

func _ready() -> void:
	DebugOverlay.register_scene("exterior", scene_file_path)
	GameState.current_scene_path = scene_file_path
	GameState.intro_progress = "friday_exterior"
	GameState.mark_screen_visited("intro_exterior")
	player.set_movement_mode(Player.MovementMode.SIDE_SCROLL)
	player.set_camera_limits(0, 0, 1800, 600)

	if GameState.pending_spawn_id != "" and has_node(GameState.pending_spawn_id):
		player.global_position = get_node(GameState.pending_spawn_id).global_position
	GameState.pending_spawn_id = ""

	bus.visible = false
	bus_stop_trigger.triggered.connect(_on_bus_stop_triggered)

func _on_bus_stop_triggered() -> void:
	Events.disable_control()
	await Events.move_character(player, bus_stand_marker.global_position, 140.0)

	bus.visible = true
	bus.position = bus_arrival_marker.position + Vector2(420, 0)
	var tween := create_tween()
	tween.tween_property(bus, "position", bus_arrival_marker.position, 1.0)
	await tween.finished
	await Events.wait(0.4)

	await Events.move_character(player, bus_arrival_marker.global_position + Vector2(20, 0), 100.0)
	Events.transition_scene(SCHOOL_SCENE)
