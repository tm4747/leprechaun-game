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
@onready var eyes: ColorRect = $Eyes

var _normal_eye_color: Color

func _ready() -> void:
	body.color = body_color
	head.color = head_color
	_normal_eye_color = eyes.color

## A fraction-of-a-second red flicker (PRD section 17) -- never a freeze,
## zoom, sound cue, or label. Just the animation, exactly as specified.
func flash_eyes_red(duration: float = 0.15) -> void:
	eyes.color = Color(0.9, 0.1, 0.1)
	await get_tree().create_timer(duration).timeout
	eyes.color = _normal_eye_color
