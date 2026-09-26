class_name GutComponent
extends RefCounted
## The Gut Meter (PRD section 49). Normalized internal value:
##   -1.0 = Terror ... 0.0 = Calm ... +1.0 = Joy / Excitement
## The UI must not depend on this storage representation -- always read
## through get_gut_state() / value, never assume a 0-100 scale elsewhere.

signal gut_changed(value: float, state: State)
signal gut_critical(state: State)

enum State { TERROR, FEAR, UNEASY, CALM, COMFORT, JOY, EXCITEMENT }

var value: float = 0.0

func set_gut(v: float) -> void:
	value = clampf(v, -1.0, 1.0)
	_emit()

func modify_gut(delta: float) -> void:
	set_gut(value + delta)

func get_gut_state() -> State:
	if value <= -0.75:
		return State.TERROR
	elif value <= -0.4:
		return State.FEAR
	elif value <= -0.1:
		return State.UNEASY
	elif value < 0.1:
		return State.CALM
	elif value < 0.4:
		return State.COMFORT
	elif value < 0.75:
		return State.JOY
	else:
		return State.EXCITEMENT

func _emit() -> void:
	var state := get_gut_state()
	gut_changed.emit(value, state)
	if state == State.TERROR:
		gut_critical.emit(state)
