class_name GutMeter
extends Control
## The Gut Meter's two visual stages (PRD 12.3, 39). During the intro it
## must read as opaque/mysterious; in the underworld it becomes a granular
## Fallout-4-power-armor-style dial: a stationary needle over a flowing gauge.

enum Style { OPAQUE_INTRO, GRANULAR_UNDERWORLD }

@export var style: Style = Style.OPAQUE_INTRO
@export var meter_size: Vector2 = Vector2(220, 22)

var needle_ratio := 0.5 # 0 = terror, 0.5 = calm, 1 = joy/excitement
var _flow_time := 0.0

func _ready() -> void:
	custom_minimum_size = meter_size
	size = meter_size
	GameState.gut.gut_changed.connect(_on_gut_changed)
	_on_gut_changed(GameState.gut.value, GameState.gut.get_gut_state())
	set_process(true)

func _on_gut_changed(value: float, _state: int) -> void:
	needle_ratio = (value + 1.0) / 2.0
	queue_redraw()

func _process(delta: float) -> void:
	if style == Style.GRANULAR_UNDERWORLD:
		_flow_time += delta
		queue_redraw()

func set_style(new_style: Style) -> void:
	style = new_style
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if style == Style.OPAQUE_INTRO:
		_draw_opaque(rect)
	else:
		_draw_granular(rect)

func _draw_opaque(rect: Rect2) -> void:
	var terror_color := Color(0.45, 0.1, 0.15, 0.55)
	var calm_color := Color(0.25, 0.25, 0.3, 0.55)
	var joy_color := Color(0.35, 0.4, 0.15, 0.55)
	draw_rect(rect, Color(0.05, 0.05, 0.06, 0.7))
	var half := rect.size.x / 2.0
	draw_rect(Rect2(rect.position, Vector2(half, rect.size.y)), terror_color.lerp(calm_color, 0.5))
	draw_rect(Rect2(rect.position + Vector2(half, 0), Vector2(half, rect.size.y)), calm_color.lerp(joy_color, 0.5))
	draw_rect(rect, Color(0.4, 0.4, 0.4, 0.6), false, 2.0)
	var marker_x := rect.size.x * needle_ratio
	draw_line(Vector2(marker_x, 0), Vector2(marker_x, rect.size.y), Color(1, 1, 1, 0.35), 2.0)

func _draw_granular(rect: Rect2) -> void:
	draw_rect(rect, Color(0.08, 0.08, 0.06, 0.9))
	var terror_color := Color(0.6, 0.15, 0.1)
	var calm_color := Color(0.3, 0.5, 0.25)
	var joy_color := Color(0.8, 0.65, 0.15)
	var segments := 24
	for i in segments:
		var t0 := float(i) / segments
		var t1 := float(i + 1) / segments
		var col: Color = terror_color.lerp(calm_color, t0 * 2.0) if t0 < 0.5 else calm_color.lerp(joy_color, (t0 - 0.5) * 2.0)
		col.a = sin(_flow_time * 3.0 + i) * 0.15 + 0.85
		draw_rect(Rect2(rect.position + Vector2(rect.size.x * t0, 0), Vector2(rect.size.x * (t1 - t0) + 1, rect.size.y)), col)
	draw_rect(rect, Color(0.5, 0.45, 0.3, 0.9), false, 2.0)
	var marker_x := rect.size.x * needle_ratio
	draw_polygon(PackedVector2Array([
		Vector2(marker_x - 5, -6), Vector2(marker_x + 5, -6), Vector2(marker_x, 4)
	]), PackedColorArray([Color.WHITE, Color.WHITE, Color.WHITE]))
