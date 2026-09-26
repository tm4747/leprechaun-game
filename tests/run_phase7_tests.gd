extends Node
## Headless test runner for Phase 7 acceptance criteria (PRD section 65/66):
## the player can control the remote, the supernatural TV event is subtle,
## and no explicit leprechaun identification occurs.
## Run with: godot --headless --path . res://tests/Phase7Test.tscn

var _pass := 0
var _fail := 0

func _ready() -> void:
	print("== Phase 7 home / TV tests ==")
	GameState.reset_for_new_quest()

	var home = preload("res://scenes/intro/IntroHome.tscn").instantiate()
	add_child(home)
	await get_tree().process_frame

	await _test_dinner(home)
	await _test_channel_switching(home)
	await _test_commercial_and_shutdown(home)

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_dinner(home: Node) -> void:
	var captured := {"speaker": ""}
	var listener := func(speaker, _text, _kind): captured["speaker"] = speaker
	EventBus.dialogue_line_started.connect(listener)

	await home._on_dinner_triggered()

	EventBus.dialogue_line_started.disconnect(listener)
	_check(captured["speaker"] == "Mother", "coming home triggers Mother's quiet dinner line")
	_check(GameState.control_enabled, "control returns to the player after dinner")

func _test_channel_switching(home: Node) -> void:
	home.channel_index = 0
	home._render_channel()
	_check(home.tv_screen.color == home.CARTOON_COLOR, "the TV starts on the cartoon channel")

	Input.action_press("move_down")
	await home._allow_channel_surfing(0.2)
	Input.action_release("move_down")
	await get_tree().process_frame

	_check(home.channel_index == 1, "the player can change the channel with a direction press")
	_check(home.tv_screen.color == home.STATIC_COLOR, "the second channel renders differently from the cartoon")

func _test_commercial_and_shutdown(home: Node) -> void:
	GameState.gut.set_gut(0.0)
	GameState.vitality.restore_full()

	await home._play_commercial_and_supernatural_hint()

	_check(is_equal_approx(GameState.gut.value, -0.7), "the supernatural hint pushes the Gut Meter toward terror")
	_check(GameState.vitality.current_vitality < GameState.vitality.max_vitality * 0.5,
		"the supernatural hint drains vitality toward the red zone")
	_check(not home.salesman.visible, "the on-screen figure is gone once the hint passes -- nothing lingers to explain it")
	_check(home.tv_screen.modulate == Color(1, 1, 1), "the screen distortion is momentary, not a permanent visual change")

	await home._shutdown_tv()
	_check(not home.tv_screen.visible, "turning off the TV hides its glow")
	_check(GameState.control_enabled, "control returns to the player once the TV is off")
	# _shutdown_tv() chains straight into Phase 8's father-arrives/argument
	# beat (same IntroHome scene, same PRD 8.2 file), so by the time this
	# await returns the checkpoint has already advanced past "evening_tv_off"
	# -- Phase 8's own suite covers that beat in detail.
	_check(GameState.intro_progress == "evening_parents_argument", "the TV sequence leads into the rest of the evening")
