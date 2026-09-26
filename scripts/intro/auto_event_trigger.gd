class_name AutoEventTrigger
extends Area2D
## Generic "walk here and something happens once" trigger -- the breakfast
## table, the backpack, the bedroom rug, etc. This node only knows about
## overlap + one-shot bookkeeping; the owning scene's script connects to
## `triggered` and supplies the actual scripted content (PRD Rule 2/6).

signal triggered

@export var one_shot: bool = true

var _used := false

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	collision_layer = 0
	collision_mask = 1

func _on_body_entered(body: Node) -> void:
	if _used and one_shot:
		return
	if not (body is Player):
		return
	_used = true
	triggered.emit()
