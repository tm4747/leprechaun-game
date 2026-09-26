class_name NPCPlaceholder
extends Node2D
## Static placeholder for human-world NPCs (Mother, Father, Billy, kids at
## school) until real 16-bit sprites exist. Same simple body+head silhouette
## as the player's placeholder, just recolored per character.

@export var npc_name: String = "NPC"
@export var body_color: Color = Color(0.5, 0.4, 0.3)
@export var head_color: Color = Color(0.85, 0.71, 0.55)

@onready var body: ColorRect = $Body
@onready var head: ColorRect = $Head

func _ready() -> void:
	body.color = body_color
	head.color = head_color
