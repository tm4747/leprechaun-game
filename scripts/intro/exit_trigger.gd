class_name ExitTrigger
extends Area2D
## Generic "walk here to leave the scene" trigger, reusable across every
## intro room (PRD 13.5 house exterior, bus stop, front gate, etc.) so each
## scene doesn't reimplement scene-transition boilerplate.

@export var target_scene: String = ""
@export var target_spawn_id: String = ""

var _used := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collision_layer = 0
	collision_mask = 1 # player layer

func _on_body_entered(body: Node) -> void:
	if _used:
		return
	if not (body is Player):
		return
	if not GameState.control_enabled or SceneManager.is_transitioning():
		return
	_used = true
	GameState.pending_spawn_id = target_spawn_id
	SceneManager.goto_scene(target_scene)
