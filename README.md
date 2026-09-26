# Leprechaun

A story-driven 2D action-adventure vertical slice, built in Godot 4.7.2
(GDScript, not .NET). This implements the full intro game + first
underworld screen described in `docs/Leprechaun_Intro_First_Underworld_PRD.md`.

## Status

All 13 build phases from the PRD (section 65/80) are complete and
playable start to finish: title screen -> Friday morning -> school ->
home/TV -> parents/angel -> Saturday/well -> underworld transition ->
first underworld screen.

189 automated headless tests pass across `tests/Phase0Test.tscn` through
`tests/Phase12Test.tscn` (there is no Phase0 test file -- bootstrap is
covered by the Phase 1 suite). See **Running the tests** below.

## Requirements

- Godot Engine **4.7.2** (GDScript/standard build, not the .NET/Mono
  build -- the project uses no C#).

## Opening the project

Open `project.godot` in Godot 4.7.2, or run it directly:

```sh
godot --path . scenes/boot/Boot.tscn
```

## Running the automated tests

Each phase has a headless test scene under `tests/`. Run one with:

```sh
godot --headless --path . res://tests/Phase3Test.tscn
```

It prints `PASS`/`FAIL` lines per assertion and exits with a non-zero
code if anything failed. There's no test runner script wiring them all
together yet -- run them individually, or loop over `tests/Phase*Test.tscn`
in a shell script if you want one command for all of them.

## Known limitations -- read before judging the visuals

**This slice has no real art or audio assets.** Every sprite, prop, and
background is placeholder geometry (`ColorRect`/`Polygon2D` shapes), and
every sound (the warning beep, wind, TV hum, title drone, etc.) is
procedurally generated at runtime by `scripts/audio/tone_generator.gd`
rather than composed/recorded. This was a constraint of the environment
this slice was built in, not a design choice -- the PRD calls for 16-bit
Final-Fantasy-style pixel art in the human world and higher-fidelity
painterly nature art in the underworld, and neither exists yet.

Everything else -- the state architecture, save system, dialogue/event
system, HUD, player controller, and all scripted content -- is complete
and functional. Dropping in real sprites, tilesets, and audio should be
mostly a matter of populating the empty `art/` and `audio/` folders and
wiring them into the existing nodes (`AnimatedSprite2D.sprite_frames` on
`Player`, `AudioStreamPlayer.stream` throughout) -- the animation state
machine already looks for named animations like `walk_down`/`idle_left`
and falls back gracefully when they don't exist.

## Project layout

Follows the structure in PRD section 8.1: `scenes/`, `scripts/`, `data/`,
`art/`, `audio/`, `shaders/`, `fonts/`, `tests/`. See
`docs/Leprechaun_Intro_First_Underworld_PRD.md` for the full spec this
was built against, including the reference art in `docs/prd_assets/`.

## Debug tools

In a debug build, press **F3** in-game to toggle a debug overlay showing
scene/position/meters/save state, with number-key shortcuts (1-9) for
restoring health/vitality, forcing Gut Meter states, toggling collision
visualization, and jumping directly to key scenes (angel, underworld,
well). See `scripts/core/debug_overlay.gd`. This is compiled out of
release builds via `OS.is_debug_build()`.
