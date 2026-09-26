class_name CycleIndicator
extends Control
## Human-world sun/moon dial that later transitions into the underworld's
## ominous hourglass (PRD section 40). Both read GameState.cycle_value /
## cycle_state; only the drawing style changes.

enum Style { SUN_MOON, HOURGLASS }

@export var style: Style = Style.SUN_MOON
@export var indicator_size: Vector2 = Vector2(56, 56)

var _sand_time := 0.0

func _ready() -> void:
	custom_minimum_size = indicator_size
	size = indicator_size
	set_process(true)

func _process(delta: float) -> void:
	_sand_time += delta
	queue_redraw()

func set_style(new_style: Style) -> void:
	style = new_style
	queue_redraw()

func _draw() -> void:
	if style == Style.SUN_MOON:
		_draw_sun_moon()
	else:
		_draw_hourglass()

func _draw_sun_moon() -> void:
	var center := size / 2.0
	var radius := minf(size.x, size.y) / 2.0 - 4.0
	draw_circle(center, radius + 3.0, Color(0.15, 0.15, 0.2, 0.6))
	var angle := GameState.cycle_value * TAU
	var is_day := GameState.cycle_state == "day"
	var body_color := Color(0.95, 0.85, 0.4) if is_day else Color(0.75, 0.78, 0.9)
	var body_pos := center + Vector2(cos(angle - PI / 2.0), sin(angle - PI / 2.0)) * (radius * 0.55)
	draw_circle(body_pos, radius * 0.4, body_color)
	draw_arc(center, radius, 0, TAU, 32, Color(0.5, 0.5, 0.55, 0.8), 1.5)

func _draw_hourglass() -> void:
	var w := size.x
	var h := size.y
	var frame_color := Color(0.55, 0.45, 0.25)
	var top_tri := PackedVector2Array([Vector2(4, 4), Vector2(w - 4, 4), Vector2(w / 2.0, h / 2.0), Vector2(4, 4)])
	var bottom_tri := PackedVector2Array([Vector2(4, h - 4), Vector2(w - 4, h - 4), Vector2(w / 2.0, h / 2.0), Vector2(4, h - 4)])
	draw_polyline(top_tri, frame_color, 2.0)
	draw_polyline(bottom_tri, frame_color, 2.0)

	var fill_ratio := GameState.cycle_value
	var dark_on_top := GameState.cycle_state != "day"
	var sand_color := Color(0.5, 0.15, 0.15) if dark_on_top else Color(0.75, 0.65, 0.3)

	var pile_h := (h / 2.0 - 6.0) * fill_ratio
	if pile_h > 1.0:
		var pile := PackedVector2Array([
			Vector2(w / 2.0 - pile_h, h - 6.0),
			Vector2(w / 2.0 + pile_h, h - 6.0),
			Vector2(w / 2.0, h - 6.0 - pile_h),
		])
		draw_colored_polygon(pile, sand_color)

	var stream_phase := fmod(_sand_time * 4.0, 1.0)
	draw_line(Vector2(w / 2.0, h / 2.0 - 2.0), Vector2(w / 2.0, h / 2.0 + 2.0 + stream_phase * 4.0), sand_color, 2.0)
