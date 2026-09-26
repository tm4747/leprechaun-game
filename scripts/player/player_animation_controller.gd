class_name PlayerAnimationController
extends RefCounted
## Animation state selection (PRD section 46). Accepts an arbitrary movement
## vector and picks the matching named animation, falling back to the
## dominant cardinal direction when a diagonal animation doesn't exist yet.
## Must not depend on how many sprite directions are actually authored.

enum Direction { DOWN, UP, LEFT, RIGHT, DOWN_LEFT, DOWN_RIGHT, UP_LEFT, UP_RIGHT }

const CARDINALS: Array[Direction] = [Direction.DOWN, Direction.UP, Direction.LEFT, Direction.RIGHT]

var sprite: AnimatedSprite2D
var current_animation := ""

var _cardinal_facing := Direction.DOWN

func _init(p_sprite: AnimatedSprite2D) -> void:
	sprite = p_sprite

## movement_vector: raw input/velocity direction (not required to be
## normalized). moving: whether the character is actually translating.
func update(movement_vector: Vector2, moving: bool) -> void:
	var direction := _vector_to_direction(movement_vector)
	if _is_cardinal(direction):
		_cardinal_facing = direction
	_play(_resolve_animation_name(direction, movement_vector, moving))

func get_cardinal_facing() -> Direction:
	return _cardinal_facing

func _is_cardinal(direction: Direction) -> bool:
	return CARDINALS.has(direction)

func _vector_to_direction(v: Vector2) -> Direction:
	if v.length() < 0.001:
		return _cardinal_facing
	var deg := rad_to_deg(v.angle())
	if deg < 0.0:
		deg += 360.0
	var sector := int(round(deg / 45.0)) % 8
	match sector:
		0: return Direction.RIGHT
		1: return Direction.DOWN_RIGHT
		2: return Direction.DOWN
		3: return Direction.DOWN_LEFT
		4: return Direction.LEFT
		5: return Direction.UP_LEFT
		6: return Direction.UP
		_: return Direction.UP_RIGHT

func _resolve_animation_name(direction: Direction, raw_vector: Vector2, moving: bool) -> String:
	var prefix := "walk_" if moving else "idle_"
	var full_name := prefix + _direction_name(direction)
	if _has_animation(full_name):
		return full_name
	var cardinal := _dominant_cardinal(direction, raw_vector)
	return prefix + _direction_name(cardinal)

func _dominant_cardinal(direction: Direction, raw_vector: Vector2) -> Direction:
	if _is_cardinal(direction):
		return direction
	if absf(raw_vector.x) >= absf(raw_vector.y):
		return Direction.RIGHT if raw_vector.x > 0.0 else Direction.LEFT
	return Direction.DOWN if raw_vector.y > 0.0 else Direction.UP

func _direction_name(direction: Direction) -> String:
	match direction:
		Direction.DOWN: return "down"
		Direction.UP: return "up"
		Direction.LEFT: return "left"
		Direction.RIGHT: return "right"
		Direction.DOWN_LEFT: return "down_left"
		Direction.DOWN_RIGHT: return "down_right"
		Direction.UP_LEFT: return "up_left"
		Direction.UP_RIGHT: return "up_right"
	return "down"

func _has_animation(anim_name: String) -> bool:
	return sprite != null and sprite.sprite_frames != null and sprite.sprite_frames.has_animation(anim_name)

func _play(anim_name: String) -> void:
	if anim_name == current_animation:
		return
	current_animation = anim_name
	if _has_animation(anim_name):
		sprite.play(anim_name)
	# else: no art authored for this animation yet (placeholder-art phase).
	# We still track it as "current" so callers/tests can assert intent.
