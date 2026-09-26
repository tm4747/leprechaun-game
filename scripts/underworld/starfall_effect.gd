class_name StarfallEffect
extends Control
## Simple procedural "falling through darkness" visual for the underworld
## transition (PRD section 34) -- drifting light streaks, no particle
## system or art asset required.

@export var star_count := 60
@export var speed := 320.0

var _stars: Array[Vector2] = []
var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()
	set_process(false)
	call_deferred("_spawn_stars")

func _spawn_stars() -> void:
	for i in star_count:
		_stars.append(Vector2(_rng.randf_range(0, size.x), _rng.randf_range(0, size.y)))

func _process(delta: float) -> void:
	for i in _stars.size():
		_stars[i].y += speed * delta
		if _stars[i].y > size.y:
			_stars[i].y = 0.0
			_stars[i].x = _rng.randf_range(0, size.x)
	queue_redraw()

func _draw() -> void:
	for star in _stars:
		draw_circle(star, 1.5, Color(0.8, 0.85, 1.0, 0.8))
