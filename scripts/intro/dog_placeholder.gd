class_name DogPlaceholder
extends Node2D
## Placeholder for the golden retriever (PRD section 76: eventually a major
## companion system, but this slice only needs "follows the boy warmly" and
## the scripted well-sequence beats -- Rule 3, don't build the whole future
## companion system now).

@export var follow_target_path: NodePath
@export var follow_distance: float = 40.0
@export var follow_speed: float = 160.0

@onready var body: ColorRect = $Body

var _target: Node2D
var _manual_control := false

func _ready() -> void:
	if follow_target_path != NodePath():
		_target = get_node(follow_target_path)

func set_follow_target(target: Node2D) -> void:
	_target = target

func _process(delta: float) -> void:
	if _manual_control or _target == null:
		return
	var to_target := _target.global_position - global_position
	if to_target.length() > follow_distance:
		global_position += to_target.normalized() * follow_speed * delta

func set_manual_control(enabled: bool) -> void:
	_manual_control = enabled

## Used for scripted beats (fetching, the well jump) where the dog needs to
## move along an exact path rather than just loosely following the player.
func move_to(target_position: Vector2, duration: float = 0.6) -> void:
	set_manual_control(true)
	var tween := create_tween()
	tween.tween_property(self, "global_position", target_position, duration)
	await tween.finished
