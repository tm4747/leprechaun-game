extends Node
## Autoload: CriticalWarnings
## Centralized warning controller (PRD section 50). Listens to the three
## meters and republishes a single set of critical/restored events on
## EventBus so HUD flashing and warning audio never fight each other by
## running three independent ad-hoc timers.

const BEEP_INTERVAL := 1.2

var _health_was_critical := false
var _vitality_was_critical := false
var _gut_was_critical := false

var audio_player: AudioStreamPlayer
var _beep_timer: Timer

func _ready() -> void:
	GameState.health.health_changed.connect(_on_health_changed)
	GameState.vitality.vitality_changed.connect(_on_vitality_changed)
	GameState.gut.gut_changed.connect(_on_gut_changed)

	audio_player = AudioStreamPlayer.new()
	audio_player.volume_db = -4.0
	add_child(audio_player)
	_beep_timer = Timer.new()
	_beep_timer.wait_time = BEEP_INTERVAL
	_beep_timer.timeout.connect(_on_beep_timeout)
	add_child(_beep_timer)

func _on_health_changed(_current: float, _max_health: float) -> void:
	var critical := GameState.health.is_critical()
	var was_critical := _health_was_critical
	# Update the flag *before* emitting: any_critical() must already read
	# true by the time a listener reacts to the signal it triggers.
	_health_was_critical = critical
	if critical and not was_critical:
		EventBus.health_critical.emit()
	elif not critical and was_critical:
		EventBus.health_restored.emit()
	_refresh_beep()

func _on_vitality_changed(_current: float, _max_vitality: float) -> void:
	var critical := GameState.vitality.is_critical()
	var was_critical := _vitality_was_critical
	_vitality_was_critical = critical
	if critical and not was_critical:
		EventBus.vitality_critical.emit()
	elif not critical and was_critical:
		EventBus.vitality_restored.emit()
	_refresh_beep()

func _on_gut_changed(_value: float, state: int) -> void:
	var critical := state == GutComponent.State.TERROR
	var was_critical := _gut_was_critical
	_gut_was_critical = critical
	if critical and not was_critical:
		EventBus.gut_critical.emit(state)
	elif not critical and was_critical:
		EventBus.gut_restored.emit()
	_refresh_beep()

func any_critical() -> bool:
	return _health_was_critical or _vitality_was_critical or _gut_was_critical

## A single warning beep for all three meters (PRD section 50) so they
## never fight each other over audio.
func _refresh_beep() -> void:
	if any_critical():
		if _beep_timer.is_stopped():
			_play_beep()
			_beep_timer.start()
	else:
		_beep_timer.stop()

func _on_beep_timeout() -> void:
	if any_critical():
		_play_beep()
	else:
		_beep_timer.stop()

func _play_beep() -> void:
	audio_player.stream = ToneGenerator.generate_beep(880.0, 0.12)
	audio_player.play()
