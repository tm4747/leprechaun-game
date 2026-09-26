class_name MembraneEffect
extends Control
## Amorphous, organic, wiggling membrane/portal effect behind the title
## (PRD 10.1). Two layered irregular polygons whose vertices drift on
## independent sine phases so the silhouette never looks like a static
## logo shape or a simple circle.

@export var point_count := 16
@export var base_radius := 220.0
@export var wobble_amount := 26.0
@export var outer_color := Color(0.05, 0.35, 0.12, 0.55)
@export var inner_color := Color(0.02, 0.02, 0.03, 0.6)

var _time := 0.0

func _ready() -> void:
	set_process(true)
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _process(delta: float) -> void:
	_time += delta
	queue_redraw()

func _draw() -> void:
	var center := size / 2.0
	draw_colored_polygon(_ring(center, base_radius, wobble_amount, 3.0, 0.6, 5.0, -0.9), outer_color)
	draw_colored_polygon(_ring(center, base_radius * 0.65, wobble_amount * 0.6, 4.0, -0.8, 2.0, 1.2), inner_color)

func _ring(center: Vector2, radius: float, wobble: float, freq_a: float, speed_a: float, freq_b: float, speed_b: float) -> PackedVector2Array:
	var points := PackedVector2Array()
	for i in point_count:
		var angle := TAU * i / point_count
		var noise := sin(angle * freq_a + _time * speed_a) * 0.5 + sin(angle * freq_b + _time * speed_b) * 0.5
		var r := radius + noise * wobble
		points.append(center + Vector2(cos(angle), sin(angle)) * r)
	return points
