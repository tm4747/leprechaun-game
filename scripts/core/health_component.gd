class_name HealthComponent
extends RefCounted
## Reusable health component (PRD section 47).
## Owned by GameState so health persists across scene changes rather than
## living on a scene-local player node.

signal health_changed(current: float, max_health: float)
signal health_depleted

const CRITICAL_RATIO := 0.2

var max_health: float = 100.0
var current_health: float = 100.0

func damage(amount: float) -> void:
	if amount <= 0.0:
		return
	current_health = maxf(current_health - amount, 0.0)
	health_changed.emit(current_health, max_health)
	if current_health <= 0.0:
		health_depleted.emit()

func heal(amount: float) -> void:
	if amount <= 0.0:
		return
	current_health = minf(current_health + amount, max_health)
	health_changed.emit(current_health, max_health)

func restore_full() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func get_ratio() -> float:
	return 0.0 if max_health <= 0.0 else current_health / max_health

func is_critical() -> bool:
	return get_ratio() <= CRITICAL_RATIO
