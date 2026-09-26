extends Node2D
## Falling into the underworld (PRD section 34). Purely presentational --
## no player input here. Falling/wind/darkness that fades toward silence,
## then ambient environmental sound and a hint of ground/grass fading in
## as the boy wakes, right before Phase 11's first underworld screen takes
## over. Control stays disabled throughout; the well sequence already
## turned it off and the first underworld screen turns it back on once the
## player can actually explore.

const FIRST_SCREEN_SCENE := "res://scenes/underworld/UnderworldFirstScreen.tscn"

@onready var starfall: Control = $Starfall
@onready var wind_player: AudioStreamPlayer = $WindPlayer
@onready var whine_player: AudioStreamPlayer = $WhinePlayer
@onready var wake_glow: ColorRect = $WakeGlow

func _ready() -> void:
	GameState.current_scene_path = scene_file_path
	GameState.current_world = "underworld"
	GameState.intro_progress = "underworld_transition"
	GameState.set_control_enabled(false)

	wake_glow.color.a = 0.0
	_play_fall_sequence()

func _play_fall_sequence() -> void:
	# Increasing distance from the dog: a fading whine, heard once, then gone.
	whine_player.stream = ToneGenerator.generate_beep(600.0, 0.5, 44100, 0.3)
	whine_player.pitch_scale = 0.7
	whine_player.play()

	wind_player.stream = ToneGenerator.generate_noise(2.0, 44100, 0.4)
	wind_player.play()
	starfall.set_process(true)

	var wind_fade := create_tween()
	wind_fade.tween_property(wind_player, "volume_db", -40.0, 3.0)
	await wind_fade.finished
	wind_player.stop()
	starfall.set_process(false)
	starfall.visible = false

	# A beat of total darkness and silence -- the impact, and the moment
	# the world has fully changed underneath him.
	await Events.wait(1.0)

	# Ambient environmental sound and a hint of grass/ground fading in as
	# he wakes (section 34's closing beat).
	var ambience := AudioStreamPlayer.new()
	add_child(ambience)
	ambience.stream = ToneGenerator.generate_noise(3.0, 44100, 0.15)
	ambience.volume_db = -18.0
	ambience.play()

	var wake := create_tween()
	wake.tween_property(wake_glow, "color:a", 0.5, 1.5)
	await wake.finished

	await Events.wait(0.5)
	Events.transition_scene(FIRST_SCREEN_SCENE)
