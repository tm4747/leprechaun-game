class_name DogPlaceholder
extends Node2D
## The golden retriever (PRD section 76: eventually a major companion
## system, but this slice only needs "follows the boy warmly" plus the
## scripted well-sequence beats -- Rule 3, don't build the whole future
## companion system now).

@export var follow_target_path: NodePath
@export var follow_distance: float = 40.0
@export var follow_speed: float = 160.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var _target: Node2D
var _manual_control := false
var _pose_override := ""

func _ready() -> void:
	if follow_target_path != NodePath():
		_target = get_node(follow_target_path)
	_play_if_available("idle")

func set_follow_target(target: Node2D) -> void:
	_target = target

func _process(delta: float) -> void:
	if _manual_control or _target == null:
		return
	var to_target := _target.global_position - global_position
	if to_target.length() > follow_distance:
		var step := to_target.normalized() * follow_speed * delta
		global_position += step
		_face_direction(step.x)
		if _pose_override == "":
			_play_if_available("walk")
	elif _pose_override == "":
		_play_if_available("idle")

func set_manual_control(enabled: bool) -> void:
	_manual_control = enabled

## Used for scripted beats (fetching, the well jump) where the dog needs to
## move along an exact path rather than just loosely following the player.
func move_to(target_position: Vector2, duration: float = 0.6) -> void:
	set_manual_control(true)
	_face_direction(target_position.x - global_position.x)
	if _pose_override == "":
		_play_if_available("walk")
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_position, duration)
	await tween.finished
	if _pose_override == "":
		_play_if_available("idle")

## Scripted beats (sitting after a fetch, carrying the stick, the well
## jump) call this to override the automatic idle/walk animation until
## cleared with an empty string.
func play_pose(pose_name: String) -> void:
	_pose_override = pose_name
	if pose_name != "":
		_play_if_available(pose_name)

func _face_direction(dx: float) -> void:
	if absf(dx) > 0.5:
		sprite.flip_h = dx > 0.0

func _play_if_available(anim_name: String) -> void:
	if sprite.sprite_frames and sprite.sprite_frames.has_animation(anim_name):
		if sprite.animation != anim_name or not sprite.is_playing():
			sprite.play(anim_name)
