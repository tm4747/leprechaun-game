class_name MiniMap
extends Control
## Mini-map framework (PRD section 41, 60). Consumes GameState's logical
## screen graph (current_screen / visited_screens) rather than being a
## one-off image, so future screens slot in without replacing this system.

@export var map_size: Vector2 = Vector2(80, 60)

func _ready() -> void:
	custom_minimum_size = map_size
	size = map_size

func refresh() -> void:
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	draw_rect(rect, Color(0.05, 0.08, 0.05, 0.85))
	draw_rect(rect, Color(0.5, 0.55, 0.4, 0.9), false, 2.0)
	# For this vertical slice there is exactly one screen, so it always
	# fills the frame; a multi-screen map would position this sub-rect
	# according to the visited_screens graph instead.
	var inner := rect.grow(-rect.size.x * 0.32)
	draw_rect(inner, Color(0.35, 0.75, 0.35, 0.9))
	draw_rect(inner, Color(1, 1, 1, 0.6), false, 1.5)
