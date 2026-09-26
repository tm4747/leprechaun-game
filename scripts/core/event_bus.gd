extends Node
## Autoload: EventBus
## Central signal hub for cross-cutting, decoupled events. Reserved for
## events that many unrelated systems care about (critical warnings,
## scripted-event control takeover, scene transitions, dialogue). Per-value
## reactions (a single HUD bar reacting to health) should connect directly
## to GameState.health/vitality/gut instead of round-tripping through here.

signal health_critical
signal health_restored
signal vitality_critical
signal vitality_restored
signal gut_critical(state: int)
signal gut_restored

signal control_enabled
signal control_disabled

signal scene_transition_started(path: String)
signal scene_transition_finished(path: String)

signal dialogue_line_started(speaker: String, text: String, kind: String)
signal dialogue_line_finished

signal cycle_state_changed(state: String)
