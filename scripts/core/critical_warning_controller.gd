extends Node
## Autoload: CriticalWarnings
## Centralized warning controller (PRD section 50). Listens to the three
## meters and republishes a single set of critical/restored events on
## EventBus so HUD flashing and warning audio never fight each other by
## running three independent ad-hoc timers.

var _health_was_critical := false
var _vitality_was_critical := false
var _gut_was_critical := false

func _ready() -> void:
	GameState.health.health_changed.connect(_on_health_changed)
	GameState.vitality.vitality_changed.connect(_on_vitality_changed)
	GameState.gut.gut_changed.connect(_on_gut_changed)

func _on_health_changed(_current: float, _max_health: float) -> void:
	var critical := GameState.health.is_critical()
	if critical and not _health_was_critical:
		EventBus.health_critical.emit()
	elif not critical and _health_was_critical:
		EventBus.health_restored.emit()
	_health_was_critical = critical

func _on_vitality_changed(_current: float, _max_vitality: float) -> void:
	var critical := GameState.vitality.is_critical()
	if critical and not _vitality_was_critical:
		EventBus.vitality_critical.emit()
	elif not critical and _vitality_was_critical:
		EventBus.vitality_restored.emit()
	_vitality_was_critical = critical

func _on_gut_changed(_value: float, state: int) -> void:
	var critical := state == GutComponent.State.TERROR
	if critical and not _gut_was_critical:
		EventBus.gut_critical.emit(state)
	elif not critical and _gut_was_critical:
		EventBus.gut_restored.emit()
	_gut_was_critical = critical

func any_critical() -> bool:
	return _health_was_critical or _vitality_was_critical or _gut_was_critical
