class_name BarMeter
extends Control
## Reusable health/vitality bar (PRD 12.1, 12.2, 38.1, 38.2). One script
## renders both the flat human-world style and the grainy/weathered
## underworld style -- only the exported style + color differ, per the
## "UI Visual Transformation" requirement in section 62.

enum Stat { HEALTH, VITALITY }
enum Style { CLEAN, WEATHERED }

@export var stat: Stat = Stat.HEALTH
@export var style: Style = Style.CLEAN
@export var fill_color: Color = Color(0.35, 0.75, 0.35)
@export var bar_size: Vector2 = Vector2(220, 22)

var ratio := 1.0
var critical := false

var _flash_on := false
var _flash_timer: Timer

func _ready() -> void:
	custom_minimum_size = bar_size
	size = bar_size
	_flash_timer = Timer.new()
	_flash_timer.wait_time = 0.25
	_flash_timer.timeout.connect(_on_flash_timeout)
	add_child(_flash_timer)
	_connect_stat()

func _connect_stat() -> void:
	if stat == Stat.HEALTH:
		GameState.health.health_changed.connect(_on_value_changed)
		EventBus.health_critical.connect(_start_flash)
		EventBus.health_restored.connect(_stop_flash)
		_on_value_changed(GameState.health.current_health, GameState.health.max_health)
	else:
		GameState.vitality.vitality_changed.connect(_on_value_changed)
		EventBus.vitality_critical.connect(_start_flash)
		EventBus.vitality_restored.connect(_stop_flash)
		_on_value_changed(GameState.vitality.current_vitality, GameState.vitality.max_vitality)

func _on_value_changed(current: float, max_value: float) -> void:
	ratio = 0.0 if max_value <= 0.0 else clampf(current / max_value, 0.0, 1.0)
	queue_redraw()

func _start_flash() -> void:
	critical = true
	_flash_timer.start()

func _stop_flash() -> void:
	critical = false
	_flash_timer.stop()
	modulate.a = 1.0

func _on_flash_timeout() -> void:
	_flash_on = not _flash_on
	modulate.a = 0.35 if _flash_on else 1.0

func set_style(new_style: Style) -> void:
	style = new_style
	queue_redraw()

func _draw() -> void:
	var rect := Rect2(Vector2.ZERO, size)
	if style == Style.CLEAN:
		_draw_clean(rect)
	else:
		_draw_weathered(rect)

func _draw_clean(rect: Rect2) -> void:
	draw_rect(rect, fill_color.darkened(0.65))
	draw_rect(Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y)), fill_color)
	draw_rect(rect, Color(0.35, 0.4, 0.35), false, 2.0)

func _draw_weathered(rect: Rect2) -> void:
	draw_rect(rect, fill_color.darkened(0.7).lerp(Color(0.2, 0.18, 0.12), 0.4))
	var filled_rect := Rect2(rect.position, Vector2(rect.size.x * ratio, rect.size.y))
	draw_rect(filled_rect, fill_color.lerp(Color(0.3, 0.25, 0.15), 0.25))
	var crack_color := Color(0, 0, 0, 0.25)
	var x := 6.0
	while x < filled_rect.size.x:
		var jitter := sin(x * 12.9898) * 3.0
		draw_line(Vector2(x, 2.0), Vector2(x + jitter, rect.size.y - 2.0), crack_color, 1.0)
		x += 9.0
	draw_rect(rect, Color(0.45, 0.38, 0.25), false, 3.0)
