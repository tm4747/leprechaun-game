class_name DialogueLayer
extends CanvasLayer
## Lightweight dialogue system (PRD section 53). Supports CLEAR, GARBLED and
## THOUGHT lines -- garbled dialogue reads as unintelligible emotional noise
## via a wave text effect rather than a translated subtitle (section 17).

@onready var panel: PanelContainer = $Panel
@onready var speaker_label: Label = $Panel/VBox/SpeakerLabel
@onready var text_label: RichTextLabel = $Panel/VBox/TextLabel

func _ready() -> void:
	layer = 20
	panel.visible = false
	text_label.bbcode_enabled = true

## Awaits until the line is dismissed: after hold_time seconds if given,
## otherwise on the next "confirm" press so the player controls pacing.
func say(speaker: String, text: String, kind: String = "CLEAR", hold_time: float = -1.0) -> void:
	_show(speaker, text, kind)
	EventBus.dialogue_line_started.emit(speaker, text, kind)
	if hold_time >= 0.0:
		await get_tree().create_timer(hold_time).timeout
	else:
		await _wait_for_confirm()
	_hide()
	EventBus.dialogue_line_finished.emit()

func _show(speaker: String, text: String, kind: String) -> void:
	speaker_label.visible = speaker != ""
	speaker_label.text = speaker
	match kind:
		"GARBLED":
			text_label.text = "[wave amp=28 freq=4]%s[/wave]" % text
			text_label.modulate = Color(0.85, 0.55, 0.55)
		"THOUGHT":
			text_label.text = "[i]%s[/i]" % text
			text_label.modulate = Color(0.75, 0.8, 0.95)
		_:
			text_label.text = text
			text_label.modulate = Color(1, 1, 1)
	panel.visible = true

func _hide() -> void:
	panel.visible = false

func _wait_for_confirm() -> void:
	await get_tree().process_frame # don't consume the press that opened this line
	while true:
		if Input.is_action_just_pressed("confirm"):
			return
		await get_tree().process_frame
