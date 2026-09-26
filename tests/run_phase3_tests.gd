extends Node
## Headless test runner for Phase 3 acceptance criteria (PRD section 65/66).
## Run with: godot --headless --path . res://tests/Phase3Test.tscn

var _pass := 0
var _fail := 0
var hud: HUD

func _ready() -> void:
	print("== Phase 3 HUD tests ==")
	GameState.health.restore_full()
	GameState.vitality.restore_full()
	GameState.gut.set_gut(0.0)

	hud = preload("res://scenes/ui/HUD.tscn").instantiate()
	add_child(hud)
	await get_tree().process_frame

	_test_bars_react_to_values()
	_test_gut_meter_reacts()
	_test_style_switch()
	await _test_critical_warning_flow()

	print("== %d passed, %d failed ==" % [_pass, _fail])
	get_tree().quit(1 if _fail > 0 else 0)

func _check(condition: bool, label: String) -> void:
	if condition:
		_pass += 1
		print("  PASS: %s" % label)
	else:
		_fail += 1
		print("  FAIL: %s" % label)

func _test_bars_react_to_values() -> void:
	GameState.health.max_health = 100.0
	GameState.health.current_health = 100.0
	GameState.health.damage(25.0)
	_check(is_equal_approx(hud.health_bar.ratio, 0.75), "health bar ratio follows GameState.health")

	GameState.vitality.max_vitality = 100.0
	GameState.vitality.current_vitality = 100.0
	GameState.vitality.consume(60.0)
	_check(is_equal_approx(hud.vitality_bar.ratio, 0.4), "vitality bar ratio follows GameState.vitality")

	GameState.health.restore_full()
	GameState.vitality.restore_full()

func _test_gut_meter_reacts() -> void:
	GameState.gut.set_gut(-1.0)
	_check(is_equal_approx(hud.gut_meter.needle_ratio, 0.0), "gut meter needle at 0.0 for full terror")
	GameState.gut.set_gut(1.0)
	_check(is_equal_approx(hud.gut_meter.needle_ratio, 1.0), "gut meter needle at 1.0 for full joy")
	GameState.gut.set_gut(0.0)
	_check(is_equal_approx(hud.gut_meter.needle_ratio, 0.5), "gut meter needle at 0.5 for calm")

func _test_style_switch() -> void:
	hud.set_world_style("human")
	_check(hud.health_bar.style == BarMeter.Style.CLEAN, "human world uses clean bar style")
	_check(hud.gut_meter.style == GutMeter.Style.OPAQUE_INTRO, "human world uses opaque gut style")
	_check(hud.cycle_indicator.style == CycleIndicator.Style.SUN_MOON, "human world uses sun/moon cycle style")

	hud.set_world_style("underworld")
	_check(hud.health_bar.style == BarMeter.Style.WEATHERED, "underworld uses weathered bar style")
	_check(hud.gut_meter.style == GutMeter.Style.GRANULAR_UNDERWORLD, "underworld uses granular gut style")
	_check(hud.cycle_indicator.style == CycleIndicator.Style.HOURGLASS, "underworld uses hourglass cycle style")

func _test_critical_warning_flow() -> void:
	GameState.health.restore_full()
	GameState.health.damage(90.0) # drops well below the 20% critical threshold

	await get_tree().process_frame
	_check(hud.health_bar.critical, "health bar enters critical state")
	_check(CriticalWarnings.audio_player.playing, "critical warning beep plays")

	await get_tree().create_timer(0.3).timeout
	var alpha_low := hud.health_bar.modulate.a
	await get_tree().create_timer(0.3).timeout
	var alpha_high := hud.health_bar.modulate.a
	_check(not is_equal_approx(alpha_low, alpha_high), "health bar visibly flashes while critical")

	GameState.health.restore_full()
	await get_tree().process_frame
	_check(not hud.health_bar.critical, "health bar leaves critical state once restored")
	_check(is_equal_approx(hud.health_bar.modulate.a, 1.0), "health bar returns to full opacity once restored")
