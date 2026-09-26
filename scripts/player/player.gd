class_name Player
extends CharacterBody2D
## Shared player controller for both the side-scrolling human-world intro
## and the top-down underworld (PRD section 45). One implementation, one
## presentation/movement-mode abstraction -- never two unrelated controllers.

enum MovementMode { SIDE_SCROLL, TOP_DOWN }

@export var movement_mode: MovementMode = MovementMode.TOP_DOWN
@export var move_speed: float = 220.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var placeholder_visual: Node2D = $PlaceholderVisual
@onready var camera: Camera2D = $Camera2D
@onready var _anim_controller := PlayerAnimationController.new(sprite)

## True while the player controller should read Input actions. Scripted
## cinematics drive the player directly (move_to, etc.) and set this false
## via GameState.set_control_enabled(false) so nothing fights their control.
var accepts_input: bool = true

func _ready() -> void:
	add_to_group("player")
	GameState.movement_mode = movement_mode
	accepts_input = GameState.control_enabled
	EventBus.control_enabled.connect(_on_control_enabled)
	EventBus.control_disabled.connect(_on_control_disabled)
	_update_visual_mode()

func _on_control_enabled() -> void:
	accepts_input = true

func _on_control_disabled() -> void:
	accepts_input = false
	velocity = Vector2.ZERO

## Rooms/screens call this once in their own _ready() so the shared camera
## on the player never shows past their background art (PRD section 37).
func set_camera_limits(left: int, top: int, right: int, bottom: int) -> void:
	camera.limit_left = left
	camera.limit_top = top
	camera.limit_right = right
	camera.limit_bottom = bottom
	camera.reset_smoothing()

func set_movement_mode(mode: MovementMode) -> void:
	movement_mode = mode
	GameState.movement_mode = mode
	velocity = Vector2.ZERO
	_update_visual_mode()

## Real art only exists for one movement mode at a time so far (side-scroll
## has it, top-down doesn't yet) -- fall back to the placeholder silhouette
## for whichever mode has no matching directional animations, rather than
## hiding it outright the moment any sprite_frames resource is attached.
func _update_visual_mode() -> void:
	var has_art := false
	if sprite.sprite_frames:
		if movement_mode == MovementMode.SIDE_SCROLL:
			has_art = sprite.sprite_frames.has_animation("walk_left") or sprite.sprite_frames.has_animation("walk_right")
		else:
			has_art = sprite.sprite_frames.has_animation("walk_down") or sprite.sprite_frames.has_animation("walk_up")
	sprite.visible = has_art
	if placeholder_visual:
		placeholder_visual.visible = not has_art

func _physics_process(_delta: float) -> void:
	if not accepts_input:
		return

	var input_vector := _read_input_vector()
	velocity = input_vector * move_speed
	move_and_slide()
	_anim_controller.update(input_vector, input_vector.length() > 0.01)

func _read_input_vector() -> Vector2:
	var raw := Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	if movement_mode == MovementMode.SIDE_SCROLL:
		raw.y = 0.0
	if raw.length() > 1.0:
		raw = raw.normalized()
	return raw

## Used by the scripted event system (PRD section 52) to move the player
## without touching input state, e.g. walking to the breakfast table.
## Safety-capped so a stuck path (e.g. blocked by collision) can never
## soft-lock a cutscene -- it just stops short and logs a warning.
func move_to(target_position: Vector2, speed: float = move_speed) -> void:
	var was_accepting := accepts_input
	accepts_input = false
	var direction := (target_position - global_position)
	var max_ticks := int((direction.length() / maxf(speed, 1.0) + 2.0) * Engine.physics_ticks_per_second)
	var ticks := 0
	while direction.length() > 2.0 and ticks < max_ticks:
		var step := direction.normalized() * speed * get_physics_process_delta_time()
		if step.length() > direction.length():
			step = direction
		velocity = step / get_physics_process_delta_time()
		move_and_slide()
		_anim_controller.update(direction, true)
		await get_tree().physics_frame
		direction = target_position - global_position
		ticks += 1
	if ticks >= max_ticks:
		push_warning("[Player] move_to() timed out before reaching %s" % target_position)
	velocity = Vector2.ZERO
	_anim_controller.update(Vector2.ZERO, false)
	accepts_input = was_accepting
