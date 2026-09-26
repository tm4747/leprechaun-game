class_name VitalityComponent
extends RefCounted
## Reusable vitality component (PRD section 48).
## Conceptually separate from health. Future systems will drain vitality
## over time/activity -- not implemented yet, per PRD Rule 3 (don't overbuild).

signal vitality_changed(current: float, max_vitality: float)
signal vitality_critical

const CRITICAL_RATIO := 0.2

var max_vitality: float = 100.0
var current_vitality: float = 100.0

func consume(amount: float) -> void:
	if amount <= 0.0:
		return
	current_vitality = maxf(current_vitality - amount, 0.0)
	vitality_changed.emit(current_vitality, max_vitality)
	if is_critical():
		vitality_critical.emit()

func restore(amount: float) -> void:
	if amount <= 0.0:
		return
	current_vitality = minf(current_vitality + amount, max_vitality)
	vitality_changed.emit(current_vitality, max_vitality)

func restore_full() -> void:
	current_vitality = max_vitality
	vitality_changed.emit(current_vitality, max_vitality)

func get_ratio() -> float:
	return 0.0 if max_vitality <= 0.0 else current_vitality / max_vitality

func is_critical() -> bool:
	return get_ratio() <= CRITICAL_RATIO
