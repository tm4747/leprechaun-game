# LEPRECHAUN

## Game Design & Implementation PRD --- Intro Game + First Underworld Screen

**Project:** Leprechaun\
**Document:** Product Requirements Document / Game Design &
Implementation Specification\
**Scope:** Title screen, playable human-world intro, angel scene, well
transition, first underworld screen\
**Engine:** Godot 4.x\
**Target:** PC / Steam; controller-first\
**Document status:** Implementation-ready vertical-slice specification\
**Version:** 1.0\
**Primary objective:** Produce a structurally sound, playable beginning
of the game that can be extended into the full RPG without replacing the
core architecture.

------------------------------------------------------------------------

# 1. Executive Summary

*Leprechaun* is a single-player 2D action-adventure RPG built around
exploration, emotional intuition, subtle supernatural mystery, survival,
and the gradual discovery that the strange world beneath the human world
is connected to the protagonist's everyday life.

This PRD covers only the beginning of the game:

1.  Title / load screen.
2.  Friday morning at the boy's home.
3.  Bus ride / school.
4.  Recess and the first subtle supernatural clue.
5.  Brother encounter after school.
6.  Return home.
7.  Dinner.
8.  Television sequence and the second subtle supernatural clue.
9.  Parents' conflict.
10. Bedroom / prayer.
11. First angel encounter.
12. Saturday morning.
13. Dog / stick / well sequence.
14. Fall into the well.
15. Transition into the underworld.
16. First playable underworld screen.

The deliverable is **not an MVP of the entire game**. It is a polished,
playable opening vertical slice designed to become the foundation of the
full game.

The implementation must therefore prioritize:

-   Stable scene/state architecture.
-   Reusable player controller.
-   Reusable HUD systems.
-   Save/load foundation.
-   Input abstraction.
-   Transition architecture.
-   Dialogue/event scripting.
-   Data-driven configuration.
-   Clear separation between intro presentation and later gameplay.
-   A clean transition from 16-bit human-world art to higher-definition
    underworld art.
-   Systems that can expand without being rewritten.

The opening should feel like a finished game, not a prototype.

------------------------------------------------------------------------

# 2. Core Design Philosophy

## 2.1 Show, don't explain

This is a primary design rule.

The player should frequently understand **what happened** without
immediately understanding **what it means**.

The game should trust the player to notice patterns.

Examples:

-   Children briefly show red eyes.
-   Both children glance toward the protagonist simultaneously.
-   Their eyes immediately return to normal.
-   Nobody comments on it.
-   A strange face may briefly appear over the television salesman.
-   The player may not even be sure they saw it.
-   The angel never receives an explanatory UI label.
-   The protective light is experienced rather than described.
-   The Gut Meter exists before its meaning is explained.
-   The day/night system is experienced before its full mechanics are
    taught.
-   The angel's statement "it won't be very long now" is intentionally
    ambiguous.
-   The supernatural is initially embedded inside ordinary events.

### Required rule

Do **not** add tutorial popups, objective labels, lore cards,
achievement-style notifications, or explicit narration to explain these
mysteries unless specifically required later.

The player should be allowed to wonder.

------------------------------------------------------------------------

## 2.2 Emotional authenticity

The protagonist is a 13-year-old boy.

He is:

-   Kind.
-   Sensitive.
-   Intuitive.
-   Honest.
-   Empathic.
-   Quiet.
-   Capable of fear.
-   Capable of sadness.
-   Capable of loneliness.
-   Not perfect.
-   Not initially powerful.
-   Not a chosen-one caricature.

His sensitivity initially feels like a burden.

He notices emotional hostility more strongly than other people do. He
doesn't understand why people treat one another cruelly.

Over the course of the game, the same sensitivity becomes a strength.

The opening must establish this without exposition.

------------------------------------------------------------------------

## 2.3 The supernatural should be ambiguous

The opening contains supernatural events, but the game should not
immediately identify them.

The school red-eye incident is a good example:

1.  Two children argue.
2.  Their speech is difficult to understand.
3.  They become angry.
4.  Their eyes flicker red for a fraction of a second.
5.  Both look toward the protagonist simultaneously.
6.  The protagonist shakes his head in confusion.
7.  Their eyes are normal.
8.  They continue fighting.
9.  An adult breaks it up.
10. The story moves on.

There is no:

> "Something supernatural happened!"

There is no camera freeze.

There is no tutorial.

There is no explanatory sound effect.

The player may initially dismiss the event.

------------------------------------------------------------------------

## 2.4 Consequences matter

The eventual game will contain meaningful consequences and some one-way
decisions.

For this opening slice:

-   The well fall is irreversible.
-   The transition into the underworld is irreversible within the
    narrative.
-   The player should not be able to save-scum the story transition.
-   The save system must nevertheless be built so the game does not
    require one uninterrupted playthrough.

Do not implement the complete future consequence/capture system yet.

Build the architecture so it can later support persistent story state.

------------------------------------------------------------------------

# 3. Story Context

## 3.1 Protagonist

The player controls a 13-year-old human boy.

The player chooses his name.

He lives in a rural setting with:

-   Mother.
-   Father.
-   Older brother Billy.
-   Younger brother.
-   Golden retriever.
-   Family home.
-   Yard.
-   Well.
-   School and bus route.

The protagonist loves his family despite conflict.

He particularly loves his older brother even though Billy can be cruel
toward him.

------------------------------------------------------------------------

## 3.2 The opening premise

The opening begins on a normal Friday.

The player initially believes they are playing a small story about an
ordinary boy.

The world gradually feels emotionally wrong:

-   People are angry.
-   Arguments feel unusually intense.
-   Speech sometimes becomes indistinct.
-   Cruelty appears casually.
-   The protagonist senses something others do not.
-   Strange visual events occur briefly.
-   His emotional state deteriorates.
-   An angel appears when he prays.
-   The angel protects him.
-   The next morning, the ordinary world continues.
-   The boy plays fetch with his dog.
-   The dog jumps toward a stick that falls into the well.
-   The boy attempts to save the dog.
-   He falls.
-   The world changes.

------------------------------------------------------------------------

# 4. Scope of This PRD

## 4.1 In scope

### Title / menu

-   Black opening.
-   Individual letter reveal: L E P R E C H A U N.
-   Amorphous portal/membrane effect.
-   Final title.
-   Start.
-   Continue.
-   Single active quest slot.
-   Existing-save warning.
-   Transition into opening bedroom.

### Human-world intro

-   Side-scrolling 2D presentation.
-   16-bit / classic Final Fantasy-inspired pixel art.
-   Bedroom.
-   Hallway.
-   Kitchen.
-   Breakfast.
-   Backpack.
-   Front door.
-   Yard / path / well area.
-   Walk to bus.
-   Bus.
-   School arrival.
-   Classroom.
-   Recess.
-   School incident.
-   Brother encounter.
-   Bus home.
-   Dinner.
-   Living room.
-   CRT television.
-   Television commercial.
-   Subtle supernatural TV event.
-   Parents' argument.
-   Bedroom.
-   Prayer.
-   Angel encounter.
-   Healing.
-   Temporary protection.
-   Saturday morning.
-   Dog.
-   Stick.
-   Well.
-   Fall.

### Underworld

-   Transition.
-   New visual presentation.
-   3/4 top-down player.
-   Four-direction and diagonal movement architecture.
-   First-screen environment.
-   Grass.
-   Ocarina-of-Time-like fantasy trees as visual inspiration, not copied
    assets.
-   Four paths leading to future screens.
-   Player cannot leave the screen in this slice.
-   High-definition environmental art direction.
-   Detailed weathered HUD.
-   Hourglass cycle UI.
-   Granular Gut Meter.
-   Grainy/weathered health.
-   Grainy/weathered vitality.
-   Mini-map showing current rectangular screen.

------------------------------------------------------------------------

## 4.2 Explicitly out of scope

Do not implement yet:

-   Combat.
-   Enemies.
-   Weapons.
-   Inventory.
-   Shops.
-   Quests.
-   NPC dialogue system beyond what's required by the intro.
-   Dog gameplay commands.
-   Full dog companion system.
-   Dungeons.
-   Bosses.
-   Boats.
-   Desert.
-   Realm Beyond.
-   Full map system.
-   Full sleep/save system.
-   Full capture system.
-   Full angel system.
-   Full leprechaun system.
-   Full weather/mood system.
-   Procedural generation.
-   Multiplayer.
-   Mobile support.

Architecture should allow these systems later, but implementation should
not expand into them during this phase.

------------------------------------------------------------------------

# 5. Target Experience

The player should finish this slice feeling:

-   Curious.
-   Emotionally connected to the boy.
-   Slightly unsettled.
-   Unsure what is happening.
-   Protective of the boy.
-   Emotionally affected by the dog/fall.
-   Curious about the new world.
-   Ready to explore.

The player should **not** feel:

-   Like they were given a lore lecture.
-   Like they were completing a tutorial checklist.
-   Like the supernatural was explained.
-   Like they were playing a horror game.
-   Like the intro was an extended cutscene.
-   Like the game was already throwing RPG systems at them.

------------------------------------------------------------------------

# 6. Art Direction

## 6.1 Human-world intro

The human-world intro uses **16-bit pixel-art presentation**.

Reference target:

-   Classic Final Fantasy-era pixel-art sensibility.
-   Rich but limited palettes.
-   Readable silhouettes.
-   Strong environmental composition.
-   Expressive but economical animation.
-   Deliberate sprite readability.
-   No modern photorealism.
-   No excessive particle effects.
-   No pixel-art imitation that looks procedurally blurred.

The intro should feel warm, familiar, slightly nostalgic, and grounded.

The supernatural events can violate this visual language subtly.

------------------------------------------------------------------------

## 6.2 Underworld

The underworld transitions to a higher-definition presentation.

It should feel like the visual language has expanded.

The first underworld screen should have:

-   Dense grass.
-   Detailed trees.
-   Rocks.
-   Small flowers.
-   Dirt paths.
-   Soft atmospheric depth.
-   Rich environmental texture.
-   Natural but strange composition.
-   Ocarina of Time-like fantasy forest sensibility.
-   No direct copying of Nintendo assets, characters, maps, or textures.

The underworld should feel beautiful before it feels threatening.

------------------------------------------------------------------------

## 6.3 Transition philosophy

The art transition itself is part of the story.

Human world:

> Simple / familiar / controlled / 16-bit.

Underworld:

> Richer / stranger / more dimensional / more detailed.

Do not make the underworld merely "darker pixel art."

It is a new visual layer.

------------------------------------------------------------------------

# 7. Visual References

## 7.1 Title screen reference

The following crop is the title/menu reference generated during design.

![Title Screen
Reference](leprechaun_prd_assets/title_screen_reference.png)

Use this as a **composition and mood reference**, not as a final
production asset.

Required final behavior:

-   Black background.
-   Letters reveal one at a time.
-   Amorphous membrane/portal.
-   Ancient green lettering.
-   Low ominous music.
-   Start / Continue.
-   Continue disabled when no save exists.

------------------------------------------------------------------------

## 7.2 First underworld reference

![First Underworld Screen
Reference](leprechaun_prd_assets/underworld_first_screen_reference.png)

Use this as a composition/mood reference.

The production version must be substantially cleaner and more internally
consistent than the concept image.

Required visual elements:

-   Top-down / 3/4 player.
-   Dense green grass.
-   Fantasy trees.
-   Paths in four directions.
-   HUD.
-   Hourglass.
-   Mini-map.
-   Weathered health/vitality/gut presentation.

------------------------------------------------------------------------

## 7.3 16-bit art-direction reference

![16-bit Art Direction
Reference](leprechaun_prd_assets/16bit_art_direction_reference.png)

This is a broad visual reference only. Production assets should be
created as consistent 16-bit pixel art rather than using the concept
sheet directly.

------------------------------------------------------------------------

# 8. Technical Architecture

## 8.1 Godot project

Use Godot 4.x.

Recommended top-level structure:

``` text
res://
  project.godot

  scenes/
    boot/
    menu/
    intro/
    underworld/
    player/
    ui/
    transitions/

  scripts/
    core/
    player/
    intro/
    underworld/
    ui/
    save/
    dialogue/
    audio/

  data/
    characters/
    scenes/
    dialogue/
    configuration/

  art/
    intro/
      characters/
      environments/
      ui/
      effects/
    underworld/
      characters/
      environments/
      ui/
      effects/

  audio/
    music/
    ambience/
    sfx/
    dialogue/

  shaders/
  fonts/
  tests/
```

------------------------------------------------------------------------

## 8.2 Scene architecture

Recommended major scenes:

``` text
Boot.tscn
MainMenu.tscn
IntroWorld.tscn
IntroBedroom.tscn
IntroHouse.tscn
IntroSchool.tscn
IntroHome.tscn
IntroBedroomAngel.tscn
WellSequence.tscn
UnderworldTransition.tscn
UnderworldFirstScreen.tscn
```

These can be consolidated where technically cleaner, but the logical
scene boundaries must remain explicit.

------------------------------------------------------------------------

## 8.3 State machine

Implement a centralized game state model.

Example:

``` text
GameState
  current_scene
  player_name
  dog_name
  has_save
  intro_progress
  health
  vitality
  gut_value
  gut_state
  cycle_value
  cycle_state
  current_world
  current_screen
```

Do not scatter critical state across scene-local variables.

------------------------------------------------------------------------

# 9. Input Architecture

Use Godot's InputMap.

At minimum:

``` text
move_up
move_down
move_left
move_right
interact
confirm
cancel
pause
```

Movement must be abstracted from the player controller.

The architecture should support:

### Current target

-   Up.
-   Down.
-   Left.
-   Right.
-   Optional diagonals.

The implementation should support analog input without requiring the
final design to commit to unrestricted analog movement.

------------------------------------------------------------------------

# 10. Title Screen

## 10.1 Opening sequence

The game begins on black.

Letters appear individually:

``` text
L
E
P
R
E
C
H
A
U
N
```

The timing should feel deliberate.

Do not make it resemble a conventional logo animation.

An amorphous, organic, wiggling membrane gradually opens behind/around
the title.

The final title appears:

**LEPRECHAUN**

in an ancient Gaelic-inspired fantasy type treatment.

------------------------------------------------------------------------

## 10.2 Audio

Low, ominous, restrained music.

Avoid:

-   Jump scares.
-   Horror stingers.
-   Loud impacts.
-   Excessive choir.

The goal is dread and mystery, not horror.

------------------------------------------------------------------------

## 10.3 Menu

Only:

``` text
START
CONTINUE
```

No:

-   Options.
-   Extras.
-   New Game Plus.
-   Credits.
-   Multiplayer.

Those may be added later.

------------------------------------------------------------------------

## 10.4 Continue

If no save exists:

``` text
CONTINUE
```

is visibly disabled.

If a save exists:

Continue loads the active quest.

There is only one active quest slot for this design.

------------------------------------------------------------------------

## 10.5 Starting a new quest with an existing save

Selecting Start when a quest exists displays:

> This will destroy your current quest.\
> Are you sure?

Buttons:

``` text
YES
NO
```

Do not call it "save file," "game slot," or "campaign" in the
player-facing UI.

------------------------------------------------------------------------

# 11. Human-World Intro Camera / Presentation

The human-world intro is side-scrolling 2D.

The player sees:

-   Boy from side.
-   Environments from side.
-   Classic 16-bit pixel-art composition.

Use scripted camera framing for:

-   Important dialogue.
-   School incident.
-   Brother encounter.
-   TV commercial.
-   Angel.
-   Well sequence.

The player should regain control frequently.

Avoid turning the entire 15--20 minute opening into one continuous
cutscene.

------------------------------------------------------------------------

# 12. Human-World HUD

## 12.1 Health

Initially:

-   Simple green bar.
-   Light-ish green filled region.
-   Very dark green depleted region.
-   Approximately 2px medium grey-green border.
-   Solid colors.
-   Minimal texture.

No ornate frame.

------------------------------------------------------------------------

## 12.2 Vitality

Initially:

-   Simple bar.
-   Small number of colors.
-   Clean.
-   Minimal texture.
-   Same general visual weight as health.

Vitality is conceptually separate from health.

------------------------------------------------------------------------

## 12.3 Gut Meter

The Gut Meter is visible from the beginning.

Conceptual state:

``` text
TERROR <------------- CALM -------------> JOY / EXCITEMENT
```

However, during the intro:

-   It should be visually opaque.
-   Labels may be blurred, indistinct, or absent.
-   It should not immediately look like a conventional RPG meter.
-   Its exact meaning should remain mysterious.

The player should notice it reacts.

They should not be told what it represents.

------------------------------------------------------------------------

## 12.4 Intro redline state

Before the angel encounter:

-   Health redlines.
-   Vitality redlines.
-   Gut Meter redlines toward terror.
-   Bars flash subtly.
-   Warning beep.
-   All three communicate that something is badly wrong.

This is inspired by old-school game feedback such as Metroid.

Do not use a giant warning message.

------------------------------------------------------------------------

# 13. Friday Morning Sequence

## 13.1 Bedroom

Opening image:

Boy asleep in bed.

He is already dressed.

Player control begins.

No explicit movement tutorial.

The player discovers movement by pressing the controller.

The boy gets out of bed.

Exit is to the right.

------------------------------------------------------------------------

## 13.2 Hallway

The hall contains:

-   Family photo.
-   Bedroom doors.
-   Living room entrance.
-   Kitchen.

Only selected objects are interactive.

Do not make every prop inspectable.

------------------------------------------------------------------------

## 13.3 Kitchen

Mother says something similar to:

> "Good morning, sweetheart. I made you some French toast."

Sincere/warm speech is clear.

The boy walks to the food.

He automatically sits.

Control temporarily pauses.

He eats a couple bites.

Control returns.

------------------------------------------------------------------------

## 13.4 Backpack

The backpack is hanging near the front door.

Player walks to it.

The boy picks it up.

No inventory tutorial.

No inventory UI is required for this slice.

------------------------------------------------------------------------

## 13.5 Leaving

Player exits the front door.

House exterior layout:

``` text
                 FIELDS / WELL
                       ↑
                       |
              [HOUSE / FRONT]
                       |
ROAD / BUS  ←----------+
```

From the bottom of the front steps:

-   Right = field/well.
-   Left = around house toward driveway/road.

The bus route is to the left.

------------------------------------------------------------------------

# 14. Bus / School

## 14.1 Bus

Boy walks to bus stop.

Bus arrives.

Boy boards.

Transition to school.

No elaborate bus simulation is required.

------------------------------------------------------------------------

## 14.2 School arrival

Boy exits bus.

He walks left along sidewalk.

He enters school.

The scene mirrors the house-to-bus movement:

-   Player understands spatial movement.
-   No tutorial text.

------------------------------------------------------------------------

# 15. Classroom

The boy is seated in class.

No player control.

The class should feel ordinary.

Teacher dialogue may be present but does not need extensive
implementation.

The purpose is pacing and contrast.

------------------------------------------------------------------------

# 16. Recess

Player control resumes.

The playground is presented in 16-bit style.

The tone may have a slightly exaggerated, South Park-like simplicity in
character design:

-   Simple bodies.
-   Expressive faces.
-   Strong silhouettes.
-   Slightly absurd proportions.

Do not literally reproduce South Park art.

------------------------------------------------------------------------

# 17. School Incident --- First Supernatural Hint

Two children begin arguing.

Their speech is not clearly understandable.

Represent hostile speech as distorted/intelligible emotional noise such
as:

> "Whaa whaa whaa..."

This is not a joke.

The player understands emotion more than literal words.

The argument escalates.

They push each other.

Camera moves closer.

### Critical animation

For a fraction of a second:

-   Both children's eyes flicker red.
-   Both look directly toward the protagonist.
-   They do this at the same time.

The boy reacts with a small confused head shake.

The eyes are immediately normal.

The children continue fighting.

An adult breaks up the fight.

### Forbidden

Do not:

-   Freeze the screen.
-   Zoom dramatically on red eyes.
-   Play a supernatural sound.
-   Label the event.
-   Show a leprechaun.
-   Have another character comment.
-   Explain it.

The player may question whether they saw anything.

------------------------------------------------------------------------

# 18. End of School / Billy

The bell rings.

Boy leaves classroom.

He walks through corridor.

He exits front gate.

He sees his older brother Billy in a car with friends.

One friend is in front.

A guy and girl are in the back.

The protagonist's Gut Meter should move sharply toward joy/excitement
when he sees Billy.

The boy says:

> "Hey Billy, can I get a ride home?"

Billy responds with angry, mocking unintelligible speech.

Friends laugh.

The Gut Meter swings away from joy toward fear/sadness.

Billy drives away quickly.

The boy walks to the bus.

No revenge.

No confrontation.

No melodramatic speech.

The boy simply absorbs the experience.

------------------------------------------------------------------------

# 19. Return Home

The boy gets off the bus.

Walks home.

Mother says something similar to:

> "There's some dinner on the table for you."

He eats.

He is quiet.

The player should feel that he has had a difficult day without requiring
an explicit narration box.

------------------------------------------------------------------------

# 20. Living Room / Television

The living room contains:

-   Couch.
-   Lamp.
-   Standing plant.
-   Old CRT television.
-   Rabbit-ear antennas.
-   Remote.

The television should resemble an old 1980s-era set.

------------------------------------------------------------------------

## 20.1 Remote interaction

The player picks up the remote.

The boy sits on couch.

TV turns on.

The player can change channels.

------------------------------------------------------------------------

## 20.2 Channel 1

A cartoon with absurd, senseless violence.

Do not use copyrighted characters.

Purpose:

-   Establish a culture saturated with casual violence.
-   Reinforce the boy's discomfort.

------------------------------------------------------------------------

## 20.3 Commercial

A slick salesman sells facial spray.

The product makes tired/haggard people appear young/healthy.

He demonstrates it on:

-   Himself.
-   A sad dog.
-   A gerbil.

Commercial ends with:

> \$19.99\
> BUY ONE GET 3 FREE

A phone number may appear.

------------------------------------------------------------------------

# 21. Television Supernatural Hint

This is deliberately subtle.

The boy watches.

Camera moves closer.

The television salesman speaks.

The player's interpretation should initially remain:

> Strange commercial.

Then:

-   His speech continues.
-   The image subtly distorts.
-   For a brief moment, something resembling a dark/bearded mouth
    appears over or within the salesman's mouth.
-   A hint of another face may be visible.
-   Red may appear in the eyes for an instant.
-   The strange visual may be so subtle that the player is not sure what
    they saw.
-   The salesman continues moving normally.
-   The membrane/TV distortion develops.
-   The boy becomes frightened.

Do not show a clean, identifiable leprechaun face.

Do not identify the creature.

Do not say "leprechaun."

The player should potentially only recognize this event much later.

------------------------------------------------------------------------

# 22. TV Shutdown

The boy turns the TV off.

The TV glow disappears.

The Gut Meter is heavily toward terror.

Vitality is approaching the red zone.

The atmosphere becomes quiet.

The father arrives home.

------------------------------------------------------------------------

# 23. Parents

Father says something warm such as:

> "Hey, kiddo."

His sincere speech is understandable.

Parents talk.

Their conflict becomes increasingly hostile.

Much of their dialogue becomes emotionally intelligible rather than
literally intelligible.

The boy is free to move.

The player is not required to resolve anything.

The meaningful destination is eventually his bedroom.

------------------------------------------------------------------------

# 24. Bedroom / Night

The boy goes to his room.

He gets into bed.

Parents continue fighting.

The boy cannot sleep.

The room becomes increasingly distorted.

The Gut Meter moves toward terror.

The world begins swirling/red.

A knock is heard.

Glass breaks.

The danger escalates.

The health, vitality, and Gut Meter approach critical redline states.

------------------------------------------------------------------------

# 25. Angel Scene

## 25.1 Player discovery

The boy cannot sleep.

Player presses a directional input.

The boy gets out of bed.

The room layout:

``` text
+-----------------------------------+
|                                   |
|  BED             WINDOW           |
|  [====]          [      ]         |
|                  [ MOON ]         |
|                                   |
|             RUG                   |
|          [=========]              |
|                                   |
+-----------------------------------+
```

The window is centered.

The bed is on the left.

The rug is directly in front of the window.

The window view should contain:

-   High-fidelity realistic night sky.
-   Moon.
-   Clouds.
-   Natural atmospheric lighting.

The window should contrast against the 16-bit room without becoming a
photorealistic compositing mistake.

------------------------------------------------------------------------

## 25.2 Trigger

When the boy walks onto the rug:

-   Player control ends.
-   Sequence automatically begins.

No button prompt.

------------------------------------------------------------------------

## 25.3 Prayer

The boy kneels.

His thoughts are revealed.

Rough target dialogue:

> "God... why are things like this?"
>
> "Why do people treat each other like this?"
>
> "Why does everyone seem to be upset?"

This is one of the first times the player directly understands his
internal emotional state.

------------------------------------------------------------------------

# 26. Angel Appearance

The angel does not appear as a conventional winged human.

A luminous egg-shaped form descends from the top of the screen.

Approximately human-sized.

It settles to the boy's right.

Within the luminous form:

-   Approximately 50% transparent humanoid female form.
-   Fair.
-   Long hair.
-   Elf-like features.
-   Ancient/elf-like clothing.
-   Light/white colors.
-   Ethereal.
-   Semi-material.
-   Beautiful but not sexualized.

The player should initially see the luminous form before clearly
understanding the humanoid figure within it.

------------------------------------------------------------------------

# 27. Angel Dialogue

The angel speaks.

Target wording:

> "I know this has been difficult."
>
> "But have faith. Have hope."
>
> "It won't be very long now..."

The final phrase is intentionally incomplete in meaning.

Do not explain what "it" refers to.

This line is a narrative seed for the eventual ending.

------------------------------------------------------------------------

# 28. Angel Healing

The angel restores:

-   Health → full.
-   Vitality → full.
-   Gut Meter → calm/joy.

The player sees the values change.

Do not show a notification.

Do not show:

> ANGEL PROTECTION ACQUIRED

Do not show:

> HEALTH RESTORED

The effect itself communicates the mechanic.

------------------------------------------------------------------------

# 29. Angel Protection

The angel's light fills the bedroom.

The swirling red chaos is pushed backward.

The room becomes calm.

The protection does not destroy the darkness.

The darkness remains visible outside the protected space.

For example:

``` text
[ CALM / PROTECTED ]
      BEDROOM
         |
         | doorway
         v
[ RED / CHAOTIC ]
   HALLWAY / HOUSE
```

The player should be able to visually understand:

> Something is protecting this space.

But the game never tells them what the protection is called.

------------------------------------------------------------------------

## 29.1 Duration

Protection lasts approximately one night cycle.

It is lasting but not permanent.

The opening does not display the duration.

The player simply experiences the protected night.

------------------------------------------------------------------------

# 30. Angel Scene Exit

The boy is safe.

He is calm.

He can sleep.

The angel's presence remains briefly.

The scene fades.

Do not add lore exposition.

Do not explain angels.

Do not explain dimensions.

Do not explain the larger mythology.

This is the protagonist's first encounter with the angelic realm.

------------------------------------------------------------------------

# 31. Saturday Morning

The next sequence begins the following morning.

Boy wakes.

Goes to kitchen.

Mother is cooking.

He eats breakfast.

The dog is nearby.

When the boy walks by, the dog follows.

This should feel normal and loving.

The player should remember the dog strongly.

------------------------------------------------------------------------

# 32. Dog / Stick Sequence

Outside, a stick lies on the ground.

The player can pick it up.

The dog is excited.

### Fetch sequence

First throw:

-   Boy throws stick.
-   Dog fetches.
-   Dog returns.
-   Dog sits.
-   Front paws lift slightly.

Second throw:

-   Boy throws farther.
-   Dog fetches.
-   Dog drops stick at boy's feet.

Third throw:

-   Boy throws high.
-   Stick travels toward the well.

The stick goes into the well.

------------------------------------------------------------------------

# 33. Well Sequence

The boy's fear spikes.

World begins swirling/red.

The dog moves toward the well.

Boy yells:

> "NO!"

The dog jumps.

The dog lands belly-first on the far side.

A small impact/oof.

Dog scrambles to safety.

Boy reaches the well.

He leans over.

He tries to reach/push the dog toward safety.

The well is too wide.

He loses balance.

He falls headfirst.

Slow motion.

The boy disappears into the well.

The dog turns.

The dog looks down.

The dog whines.

Cut to black.

------------------------------------------------------------------------

# 34. Transition to Underworld

The transition should not immediately reveal the new environment.

Use:

-   Falling.
-   Wind.
-   Darkness.
-   Muffled sound.
-   Increasing distance from the dog.
-   Silence.

The transition should feel physically disorienting.

Then:

-   Darkness.
-   Grass/ground.
-   Ambient environmental sound.
-   Boy wakes.

------------------------------------------------------------------------

# 35. First Underworld Screen

## 35.1 Purpose

The first underworld screen is the first true playable RPG environment.

The player's immediate experience is:

> "Where am I?"

Not:

> "Here is your quest."

The boy should initially orient himself.

------------------------------------------------------------------------

## 35.2 Environment

The screen is a rectangular playable board/screen.

Ground:

-   Green grass.
-   Dirt paths.
-   Dense foliage.
-   Rocks.
-   Flowers.
-   Trees.
-   Environmental details.

There are visible paths toward:

-   Up.
-   Down.
-   Left.
-   Right.

However, **for this iteration the player cannot actually leave the
screen**.

Invisible or natural boundaries should prevent leaving.

Do not make the player feel trapped by obvious walls.

Use:

-   Dense vegetation.
-   Impassable roots.
-   Slopes.
-   Screen boundary.
-   Temporary invisible collision if necessary.

The final game will later connect these exits to other screens.

------------------------------------------------------------------------

# 36. Underworld Character Rendering

The protagonist is re-rendered in 3/4 top-down perspective.

He should retain recognizable identity:

-   Same age.
-   Same hair.
-   Same clothing.
-   Same backpack if appropriate.
-   Same general proportions.

He should not look like a completely different character.

------------------------------------------------------------------------

## 36.1 Movement

Architecture must support:

-   Up.
-   Down.
-   Left.
-   Right.
-   Up-left.
-   Up-right.
-   Down-left.
-   Down-right.

Final movement may use unrestricted analog movement.

Do not lock the architecture into only four directions.

------------------------------------------------------------------------

## 36.2 Animation

Initial production target may use:

-   Up.
-   Down.
-   Left.
-   Right.

Diagonal movement can reuse/choose the closest cardinal animation.

If production time permits, create:

-   Up-left.
-   Up-right.
-   Down-left.
-   Down-right.

The controller architecture must not depend on the number of sprite
directions.

------------------------------------------------------------------------

# 37. Underworld Camera

Camera follows the player.

The first board should fit within one screen.

No scrolling is required for the first-board implementation if the
environment is designed as a single screen.

The camera architecture should nevertheless support future larger maps.

------------------------------------------------------------------------

# 38. Underworld HUD

The underworld HUD is deliberately more granular and weathered.

The player's interface has transitioned from a clean human-world
appearance to something ancient.

------------------------------------------------------------------------

## 38.1 Health bar

Human world:

-   Flat.
-   Simple.
-   Light green.
-   Dark green depleted section.
-   2px border.

Underworld:

-   Grainy.
-   Weathered.
-   Ancient.
-   Cracked-rock texture.
-   Green stone-like fill.
-   Irregular visual surface.
-   Slightly visceral.

The bar should still communicate health immediately.

Do not sacrifice readability for texture.

------------------------------------------------------------------------

## 38.2 Vitality

Same transformation.

Human-world vitality:

-   Simple.
-   Flat.
-   Clean.

Underworld vitality:

-   Grainy.
-   Weathered.
-   Ancient.
-   Visceral.
-   Stone/organic texture.

------------------------------------------------------------------------

# 39. Underworld Gut Meter

The Gut Meter becomes more understandable visually.

It should resemble the conceptual behavior of the Fallout 4 power armor
energy meter:

-   Stationary indicator/needle.
-   Flowing or rolling gauge beneath/around it.
-   More granular visual information.
-   Strong directional state.

Conceptual scale:

``` text
TERROR <---------------- CALM ----------------> JOY / EXCITEMENT
```

The underworld version may now make the relationship clearer.

However, avoid adding a giant tutorial.

The player learns its meaning through behavior.

------------------------------------------------------------------------

# 40. Underworld Hourglass

The human-world sun/moon cycle transitions into an ominous hourglass.

The hourglass represents the environmental cycle.

It should:

-   Be visually ancient.
-   Be recognizable as an hourglass.
-   Show sand flowing.
-   Have a light side and dark side.
-   Become more ominous when the dark side is on top.

The eventual full game uses the cycle to determine:

-   World mood.
-   Enemy strength.
-   Leprechaun activity.
-   Safety.
-   Exploration conditions.

Only the visual system is required in this slice.

------------------------------------------------------------------------

## 40.1 First-screen behavior

The hourglass should animate continuously.

Do not require the player to understand it immediately.

The player should be able to notice:

-   Sand moving.
-   State changing.
-   Visual mood shifting.

------------------------------------------------------------------------

# 41. Mini-map

The mini-map is present immediately.

It represents the current rectangular screen.

For the first board:

``` text
+----------------+
|                |
|      [X]       |
|                |
+----------------+
```

The current screen rectangle is highlighted.

No unexplored neighboring screens need to be populated yet.

The mini-map should establish the eventual mapping language.

------------------------------------------------------------------------

# 42. First-Screen Player Experience

On entering the underworld:

1.  Boy wakes.
2.  Player regains control.
3.  HUD is visible.
4.  Player can walk in all directions.
5.  Player can see paths in all four cardinal directions.
6.  Player cannot leave the screen yet.
7.  Mini-map shows the current rectangular screen.
8.  Hourglass is visible.
9.  Health/vitality/gut are visible.
10. Environment feels significantly richer than the intro.
11. No enemies.
12. No combat.
13. No objective popup.
14. No tutorial window.

The player is simply allowed to explore.

------------------------------------------------------------------------

# 43. First Underworld Thought Bubbles

Optional short internal observations can occur after a few seconds or
after the player moves.

Suggested ideas:

> "What is this place...?"

Later:

> "How did I get here?"

Later:

> "It's like our world... but where is the sun?"

Later:

> "I don't know what that is up there."

These should not become a constant narration system.

Use only a small number.

------------------------------------------------------------------------

# 44. No Forced Quest Marker

There should be no:

> FIND YOUR WAY HOME

marker.

There should be no:

> OBJECTIVE: FIND SHELTER

notification.

The player's first experience is orientation.

A future design can establish shelter through environmental necessity.

------------------------------------------------------------------------

# 45. Player Controller Requirements

## 45.1 Shared controller architecture

Use a player controller capable of supporting both:

### Intro

Side-scrolling movement.

### Underworld

Top-down movement.

Do not create two unrelated player implementations.

Use a presentation/movement mode abstraction.

Example:

``` gdscript
enum MovementMode:
    SIDE_SCROLL
    TOP_DOWN
```

The exact implementation can differ internally, but shared state should
include:

-   Input.
-   Facing.
-   Animation state.
-   Movement speed.
-   Control enabled/disabled.
-   Position.
-   Health.
-   Vitality.
-   Gut.

------------------------------------------------------------------------

# 46. Character Animation State

Recommended:

``` text
idle_up
idle_down
idle_left
idle_right

walk_up
walk_down
walk_left
walk_right
```

Optional:

``` text
walk_up_left
walk_up_right
walk_down_left
walk_down_right
```

The animation controller must accept an arbitrary movement vector.

It should select:

-   Cardinal animation when diagonal assets do not exist.
-   Diagonal animation when available.

------------------------------------------------------------------------

# 47. Health System

Create a reusable health component.

Required properties:

``` text
max_health
current_health
```

Required signals:

``` text
health_changed
health_depleted
```

Required functions:

``` text
damage(amount)
heal(amount)
restore_full()
```

The intro primarily uses `restore_full()` through the angel.

Combat does not need to be implemented yet.

------------------------------------------------------------------------

# 48. Vitality System

Create a reusable vitality component.

Required:

``` text
max_vitality
current_vitality
```

Signals:

``` text
vitality_changed
vitality_critical
```

Functions:

``` text
consume(amount)
restore(amount)
restore_full()
```

Future systems will drain vitality over time and through activity.

Do not implement the entire future vitality economy yet.

------------------------------------------------------------------------

# 49. Gut System

Use normalized internal value:

``` text
-1.0 = Terror
 0.0 = Calm
+1.0 = Joy / Excitement
```

Or an equivalent 0--100 representation.

The UI should not depend on the storage representation.

Required:

``` text
set_gut(value)
modify_gut(delta)
get_gut_state()
```

Suggested state enum:

``` text
TERROR
FEAR
UNEASY
CALM
COMFORT
JOY
EXCITEMENT
```

Do not overexpose these labels in the intro.

------------------------------------------------------------------------

# 50. Critical Meter Behavior

When a meter approaches critical state:

-   Flashing.
-   Beeping.
-   Visual urgency.

Use a centralized warning controller rather than separate ad-hoc timers.

Example:

``` text
CriticalWarningController
    health_critical
    vitality_critical
    gut_critical
```

This prevents three separate systems from fighting over audio/UI
effects.

------------------------------------------------------------------------

# 51. Save System Foundation

Only one active quest slot.

Implement a basic save structure even though the complete save design is
not finalized.

Minimum saved state:

``` text
version
player_name
dog_name
current_scene
intro_progress
health
vitality
gut
world
current_screen
```

Do not save temporary cinematic animation state.

Save only at safe logical checkpoints.

For this slice, safe checkpoints can be:

-   Title/new-game initialization.
-   After major completed intro scene.
-   After angel scene.
-   Before/after transition as appropriate.

The exact player-facing save UI can remain minimal.

------------------------------------------------------------------------

# 52. Scene/Event System

The intro requires a reusable scripted event system.

Events should be composable.

Example conceptual event types:

``` text
MoveCharacter
Dialogue
SetControlEnabled
CameraMove
Fade
Wait
PlayAnimation
SetGut
SetHealth
SetVitality
PlaySFX
PlayMusic
StopMusic
SpawnEffect
TransitionScene
```

A sequence could be:

``` text
DisableControl
BoyKneels
Dialogue
AngelDescends
AngelAppears
HealHealth
RestoreVitality
SetGutCalm
ExpandLight
Wait
EnableSleep
```

Do not hard-code every cinematic directly into `_process()`.

------------------------------------------------------------------------

# 53. Dialogue System

A lightweight dialogue/event system is required.

The intro uses two types:

### Spoken dialogue

Used for:

-   Mother.
-   Father.
-   Boy.
-   Angel.
-   Other ordinary characters.

### Emotional/garbled dialogue

Used for:

-   Hostile parents.
-   Billy.
-   Fighting children.
-   Potential supernatural influence.

The system should support a line being marked as:

``` text
CLEAR
GARBLED
THOUGHT
```

Garbled dialogue may display/animate as sound-like text without
requiring a full subtitle.

------------------------------------------------------------------------

# 54. Audio Requirements

## 54.1 Title

Low ominous music.

------------------------------------------------------------------------

## 54.2 Human-world daytime

Warm, restrained ambient sound.

Examples:

-   Birds.
-   House ambience.
-   Bus.
-   Classroom.
-   Playground.
-   Distant traffic.

------------------------------------------------------------------------

## 54.3 School supernatural moment

No obvious supernatural sting.

The red-eye moment should be carried primarily by animation.

------------------------------------------------------------------------

## 54.4 Television

CRT:

-   Electrical hum.
-   Channel switching.
-   Static.
-   Speaker distortion.

Commercial:

-   Slick commercial music.
-   Slightly unnatural processing near the supernatural hint.

------------------------------------------------------------------------

## 54.5 Parents

Muffled household ambience.

Glass break.

Knock.

Emotional tension.

------------------------------------------------------------------------

## 54.6 Angel

Audio should become:

-   Soft.
-   Ethereal.
-   Peaceful.
-   Spacious.

The contrast should be immediate.

------------------------------------------------------------------------

## 54.7 Well

Dog:

-   Excited.
-   Fetch sounds.
-   Barking/whining.
-   Panic.

Well:

-   Echo.
-   Falling sound.
-   Increasing depth.

------------------------------------------------------------------------

## 54.8 Underworld

Ambient:

-   Wind.
-   Leaves.
-   Water at a distance.
-   Insects.
-   Strange natural sounds.

No combat music.

No enemies are present yet.

------------------------------------------------------------------------

# 55. Underworld Environmental Design

The first screen should communicate:

> This is beautiful, but this is not home.

Use:

-   Deep greens.
-   Moss.
-   Ancient trees.
-   Dense grass.
-   Small flowers.
-   Rocks.
-   Dirt paths.
-   Natural asymmetry.

Avoid:

-   Generic fantasy village.
-   Castles.
-   Obvious leprechaun props.
-   Exposition signs.
-   NPCs explaining the world.

The environment itself should be the first question.

------------------------------------------------------------------------

# 56. Collision Design

The first board must have clean collision.

The player can walk:

-   Up.
-   Down.
-   Left.
-   Right.
-   Diagonally.

Collision should exist against:

-   Trees.
-   Large rocks.
-   Dense impassable vegetation.
-   Board boundary.

Small flowers and grass should generally be non-blocking.

------------------------------------------------------------------------

# 57. First Board Layout

A simple conceptual layout:

``` text
+------------------------------------------------+
|                NORTH PATH                      |
|                       ↑                        |
|       TREE          TREE        TREE           |
|                                                |
|   ROCK       grass / open area      ROCK       |
|                                                |
| WEST ←            PLAYER             → EAST    |
| PATH             START               PATH      |
|                                                |
|      TREE                     FLOWERS          |
|                                                |
|               SOUTH PATH                       |
|                       ↓                        |
+------------------------------------------------+
```

The final environment should be substantially more organic than this
diagram.

------------------------------------------------------------------------

# 58. Board Boundary

Although four exits are visible, they are unavailable during this
iteration.

Recommended behavior:

-   Player can walk close to each exit.
-   Natural collision prevents transition.
-   No "locked" popup.
-   No invisible dialogue.
-   No explicit statement that the paths are unavailable.

This preserves immersion.

------------------------------------------------------------------------

# 59. Camera / World Coordinate Architecture

The first board must be represented as a logical screen.

Example:

``` text
world_id = "underworld"
screen_id = "forest_001"
screen_size = Vector2(...)
```

Future screens:

``` text
forest_000
forest_001
forest_002
forest_003
```

The first screen must not be hard-coded as the only world.

------------------------------------------------------------------------

# 60. Mini-map Architecture

The mini-map should consume logical screen data rather than being a
one-off image.

Current state:

``` text
visited_screens = ["forest_001"]
current_screen = "forest_001"
```

The current rectangle is highlighted.

Future screens can be added later without replacing the system.

------------------------------------------------------------------------

# 61. UI Scaling

The game must support:

-   16:9 desktop.
-   Common Steam Deck-like 16:10 layout.
-   Different resolutions.

HUD should be anchored using Godot Control nodes.

Do not place HUD elements in world coordinates.

Recommended structure:

``` text
CanvasLayer
  HUD
    Health
    Vitality
    Gut
    Cycle
    MiniMap
```

------------------------------------------------------------------------

# 62. UI Visual Transformation

## Human world

``` text
clean
simple
flat
few colors
minimal borders
```

## Underworld

``` text
weathered
grainy
ancient
cracked
organic
visceral
more granular
```

The transformation is intentional.

It communicates that the rules of this world are different.

------------------------------------------------------------------------

# 63. Intro-to-Underworld UI Transition

Do not abruptly replace the UI.

During the transition:

1.  Human-world UI fades.
2.  World goes dark.
3.  Underworld begins.
4.  New environment appears.
5.  Underworld UI fades in.
6.  The player notices the changed appearance.

The player should not receive a textual explanation.

------------------------------------------------------------------------

# 64. Performance Requirements

The first board should maintain a stable target frame rate on:

-   Typical modern Mac development machine.
-   Steam Deck-class hardware.
-   Mid-range Windows PC.

Avoid unnecessarily expensive:

-   Real-time lighting everywhere.
-   Large numbers of transparent particles.
-   Excessive shader passes.
-   Unbounded physics bodies.

Art can be high-definition while rendering remains efficient.

------------------------------------------------------------------------

# 65. Development Phases

The AI builder must implement the game in sequential phases.

Each phase must leave the project in a runnable state.

------------------------------------------------------------------------

## Phase 0 --- Project Bootstrap

### Deliver

-   Godot project.
-   Main entry point.
-   InputMap.
-   Folder structure.
-   Basic resolution/scaling.
-   Debug configuration.
-   Version-control-friendly structure.

### Acceptance

-   Project opens without errors.
-   Empty boot scene runs.
-   Controller and keyboard inputs register.
-   Window scales correctly.

------------------------------------------------------------------------

## Phase 1 --- Core State Architecture

### Deliver

-   GameState.
-   Health component.
-   Vitality component.
-   Gut component.
-   Scene transition manager.
-   Basic save manager.
-   Input abstraction.

### Acceptance

A test scene can:

-   Modify health.
-   Modify vitality.
-   Modify gut.
-   Transition scenes.
-   Save/load state.

No game content required yet.

------------------------------------------------------------------------

## Phase 2 --- Player Foundation

### Deliver

-   Side-scrolling controller.
-   Top-down controller.
-   Animation state machine.
-   Facing direction.
-   Control enable/disable.

### Acceptance

A test scene can switch movement modes and maintain player state.

------------------------------------------------------------------------

## Phase 3 --- HUD Foundation

### Deliver

-   Health.
-   Vitality.
-   Gut.
-   Critical warnings.
-   Mini-map framework.
-   Cycle framework.

### Acceptance

All meters react correctly to test values.

Critical values visibly flash and produce the correct warning audio.

------------------------------------------------------------------------

## Phase 4 --- Title Screen

### Deliver

-   Letter-by-letter title reveal.
-   Membrane animation.
-   Title.
-   Start.
-   Continue.
-   Disabled Continue.
-   Existing-save confirmation.
-   Transition into intro.

### Acceptance

A new player can start.

A returning player can continue.

Starting over requires confirmation when a quest exists.

------------------------------------------------------------------------

## Phase 5 --- Intro: Friday Morning

### Deliver

-   Bedroom.
-   Hall.
-   Kitchen.
-   Breakfast.
-   Backpack.
-   Exterior.
-   Bus route.
-   Bus transition.

### Acceptance

Player can complete the morning without soft-locking.

------------------------------------------------------------------------

## Phase 6 --- School

### Deliver

-   Bus arrival.
-   School.
-   Classroom.
-   Recess.
-   Two-child incident.
-   Red-eye animation.
-   Billy encounter.
-   Bus home.

### Acceptance

The supernatural hints occur without explicit explanation.

The Gut Meter responds appropriately.

------------------------------------------------------------------------

## Phase 7 --- Home / TV

### Deliver

-   Dinner.
-   Living room.
-   CRT.
-   Remote.
-   Channel switching.
-   Cartoon channel.
-   Commercial.
-   Subtle supernatural TV event.

### Acceptance

The player can control the remote.

The supernatural TV event is subtle.

No explicit leprechaun identification occurs.

------------------------------------------------------------------------

## Phase 8 --- Parents / Angel

### Deliver

-   Father arrival.
-   Argument.
-   Bedroom.
-   Redline state.
-   Player gets out of bed.
-   Rug trigger.
-   Prayer.
-   Angel descent.
-   Angel visual.
-   Angel dialogue.
-   Healing.
-   Gut restoration.
-   Protective light.
-   Sleep.

### Acceptance

All three meters clearly change from critical to restored.

No explicit protection notification appears.

The protected room visually contrasts with the chaotic hallway.

------------------------------------------------------------------------

## Phase 9 --- Saturday / Well

### Deliver

-   Saturday morning.
-   Dog following.
-   Stick.
-   Three fetch sequence.
-   Well.
-   Dog jump.
-   Boy fall.
-   Dog reaction.
-   Fade to black.

### Acceptance

The sequence is emotionally readable without requiring text exposition.

The player cannot accidentally skip the critical well sequence.

------------------------------------------------------------------------

## Phase 10 --- Underworld Transition

### Deliver

-   Falling transition.
-   Darkness.
-   Environmental sound.
-   Boy wakes.
-   World presentation changes.

### Acceptance

The player emerges in the correct underworld scene.

------------------------------------------------------------------------

## Phase 11 --- First Underworld Board

### Deliver

-   High-definition environment.
-   3/4 player.
-   Top-down movement.
-   Diagonal movement architecture.
-   Four visible paths.
-   Collision.
-   No exit transitions.
-   Underworld HUD.
-   Weathered health.
-   Weathered vitality.
-   Granular Gut Meter.
-   Hourglass.
-   Mini-map.

### Acceptance

Player can freely explore the complete first board without leaving it.

------------------------------------------------------------------------

## Phase 12 --- Polish Pass

### Deliver

-   Animation timing.
-   Audio mix.
-   Transition polish.
-   UI polish.
-   Camera smoothing.
-   Collision cleanup.
-   Visual consistency.
-   Input responsiveness.
-   Save/load reliability.
-   Bug fixes.

### Acceptance

A tester can start from a fresh install and play from title screen
through first underworld exploration without developer intervention.

------------------------------------------------------------------------

# 66. Automated / AI Builder Test Matrix

The AI building system should implement automated tests where practical.

## Title

-   [ ] Fresh boot shows title.
-   [ ] Continue disabled with no save.
-   [ ] Start works.
-   [ ] Save existence enables Continue.
-   [ ] Start with save asks for confirmation.
-   [ ] Cancel preserves save.
-   [ ] Confirm replaces active quest.

## Player

-   [ ] Up movement.
-   [ ] Down movement.
-   [ ] Left movement.
-   [ ] Right movement.
-   [ ] Diagonal movement.
-   [ ] Movement disabled during cinematic.
-   [ ] Movement restored afterward.

## Health

-   [ ] Damage lowers health.
-   [ ] Heal increases health.
-   [ ] Full restore works.
-   [ ] Critical warning activates.

## Vitality

-   [ ] Drain works.
-   [ ] Restore works.
-   [ ] Critical warning activates.

## Gut

-   [ ] Terror state works.
-   [ ] Calm state works.
-   [ ] Joy state works.
-   [ ] UI moves smoothly.
-   [ ] Critical terror warning works.

## Angel

-   [ ] Trigger occurs when player reaches rug.
-   [ ] Player control disables.
-   [ ] Prayer occurs.
-   [ ] Angel appears.
-   [ ] Health restores.
-   [ ] Vitality restores.
-   [ ] Gut restores.
-   [ ] Protection visual appears.
-   [ ] Player can sleep afterward.

## Well

-   [ ] Stick sequence triggers.
-   [ ] Dog follows.
-   [ ] Dog fetches.
-   [ ] Well sequence plays.
-   [ ] Player cannot interrupt critical fall.
-   [ ] Underworld transition completes.

## Underworld

-   [ ] Player spawns correctly.
-   [ ] All movement directions work.
-   [ ] Collision works.
-   [ ] Four exits are visible.
-   [ ] Exits cannot yet be crossed.
-   [ ] Mini-map highlights current screen.
-   [ ] Hourglass animates.
-   [ ] Weathered HUD renders.

------------------------------------------------------------------------

# 67. Manual QA Checklist

A human tester should verify:

### Emotional pacing

-   Friday morning feels normal.
-   School incident feels strange but not obvious.
-   Billy encounter feels painful without being melodramatic.
-   TV scene feels increasingly wrong.
-   Parents' conflict feels emotionally believable.
-   Angel encounter feels peaceful and mysterious.
-   Dog sequence feels warm before becoming frightening.
-   Underworld arrival feels like entering another reality.

### Mystery

-   A new player cannot immediately explain the red eyes.
-   A new player cannot immediately identify the TV entity as a
    leprechaun.
-   A new player understands that the angel helped.
-   A new player does not need to understand what an angel is.
-   A new player does not receive explicit lore explanations.

### Controls

-   Movement feels immediate.
-   Scripted control takeovers are predictable.
-   Control always returns when intended.
-   No soft locks.

------------------------------------------------------------------------

# 68. Accessibility / Readability

Even though the design relies on subtlety, critical gameplay information
must remain readable.

Do not make:

-   Health bars unreadable.
-   Gut state impossible to interpret.
-   Character sprites indistinct.
-   Critical collision invisible.

Mystery should come from **meaning**, not poor presentation.

------------------------------------------------------------------------

# 69. Debug Tools

The AI builder should create a development-only debug overlay.

It should be toggleable.

Display:

``` text
Scene:
Player position:
Health:
Vitality:
Gut:
Cycle:
Current screen:
Save state:
Movement mode:
```

Also provide debug commands for:

-   Skip to scene.
-   Restore health.
-   Restore vitality.
-   Set gut.
-   Trigger angel.
-   Trigger well.
-   Load underworld.
-   Toggle collision visualization.

Debug UI must never appear in release builds.

------------------------------------------------------------------------

# 70. Data-Driven Configuration

Where reasonable, expose values in resources/configuration rather than
hard-code them.

Examples:

``` text
PlayerConfig
HealthConfig
VitalityConfig
GutConfig
CycleConfig
SceneConfig
DialogueData
```

This allows future tuning without rewriting logic.

------------------------------------------------------------------------

# 71. Future Compatibility Requirements

The architecture must leave room for:

-   Dog companion.
-   Enemy AI.
-   Combat.
-   Weapons.
-   Items.
-   Dungeons.
-   NPCs.
-   Quests.
-   World screens.
-   Sleep.
-   Safe shelters.
-   Angel sanctums.
-   Leprechaun pursuit.
-   World mood.
-   Hourglass states.
-   Persistent consequences.
-   One-way doors.
-   Full mapping.
-   Steam Deck support.

Do not implement these systems now.

Build interfaces that do not prevent them.

------------------------------------------------------------------------

# 72. Important Future Gameplay Context

The full game is expected to be a compact, polished RPG rather than a
giant open-world RPG.

Target eventual scale:

-   Approximately 5--7 hours main story.
-   Approximately 8--12 hours with optional content.
-   Approximately 10--15 hours completionist.
-   Three dungeons.
-   Three to four major bosses.
-   Four major overworld regions.
-   Eight to twelve enemy types.
-   Fifteen to twenty-five meaningful NPCs.
-   Approximately ten to fifteen major abilities/items.

This PRD does not implement that scope.

It only establishes the foundation.

------------------------------------------------------------------------

# 73. Future World Structure

The eventual world is semi-linear / Metroidvania-like.

Major regions:

1.  Black Forest of LLhuien.
2.  Oceanside / tributaries.
3.  The Long Desert.
4.  Realm Beyond.

The first underworld screen should therefore be architected as one node
in a larger screen graph.

------------------------------------------------------------------------

# 74. Future Mapping Context

Eventually:

-   Player remembers a limited number of recent screens.
-   Older screens fade from memory.
-   Later, the boy finds a notepad and pencil.
-   The player manually builds a persistent map from screen fragments.
-   Underground transitions create separate map fragments.

The current mini-map must therefore be designed as a future-compatible
screen graph, even though only one screen exists now.

------------------------------------------------------------------------

# 75. Future Sleep Context

Eventually:

-   Vitality naturally decreases.
-   Sleep becomes important.
-   Safe sleeping places matter.
-   Some locations are dangerous.
-   Light/dark cycle affects exploration.
-   Hourglass replaces the human-world astronomical cycle.

The angel's protected bedroom is the first thematic preview of this
system.

------------------------------------------------------------------------

# 76. Future Dog Context

The dog eventually becomes a major gameplay companion.

The dog:

-   Can detect secrets.
-   Can sense danger.
-   Can attack/distract.
-   Can fetch objects.
-   Can stabilize the Gut Meter.
-   Can be useful and potentially vulnerable.

The opening must establish the emotional importance of the dog.

Do not introduce the dog as a tutorial mechanic.

------------------------------------------------------------------------

# 77. Narrative Seeds Established by This Slice

The following mysteries must remain unresolved:

### Red eyes

Why did the children briefly have red eyes?

### Simultaneous glance

Why did both children look at the boy?

### TV face

What did the boy actually see?

### Membrane

What is the strange organic portal-like phenomenon?

### Parents

Why is conflict so pervasive?

### Angel

What is she?

Where did she come from?

Why did she answer him?

### "It won't be very long now"

What does "it" mean?

### Well

Why did the dog survive while the boy fell?

### Underworld

Where is he?

Why does it resemble the natural world?

Why is there no sun?

These should become future narrative material.

------------------------------------------------------------------------

# 78. Narrative Information Hierarchy

The game should progressively move through:

``` text
EVENT
  ↓
PATTERN
  ↓
SUSPICION
  ↓
DISCOVERY
  ↓
UNDERSTANDING
  ↓
MEANING
```

The opening should mostly occupy:

``` text
EVENT
PATTERN
```

Do not jump immediately to:

``` text
EXPLANATION
```

------------------------------------------------------------------------

# 79. Definition of Done

The project is complete for this PRD when:

1.  A fresh player can launch the game.
2.  Title animation plays.
3.  Start begins a new quest.
4.  Continue behaves correctly.
5.  Player reaches bedroom.
6.  Friday sequence is playable.
7.  School sequence is playable.
8.  Red-eye event occurs subtly.
9.  Billy sequence works.
10. Home/TV sequence works.
11. TV supernatural event is subtle.
12. Parents' argument works.
13. Player gets out of bed.
14. Rug triggers angel sequence.
15. Prayer plays.
16. Angel appears correctly.
17. Angel speaks.
18. Health restores.
19. Vitality restores.
20. Gut returns toward calm/joy.
21. Protective light fills room.
22. Darkness remains outside protection.
23. Saturday sequence begins.
24. Dog follows.
25. Fetch sequence works.
26. Stick falls into well.
27. Dog survives.
28. Boy falls.
29. Screen transitions to underworld.
30. Underworld player renders in 3/4 view.
31. Player moves in all required directions.
32. First board is explorable.
33. Four paths are visible.
34. Player cannot leave the board yet.
35. Underworld HUD appears.
36. Health is weathered/grainy.
37. Vitality is weathered/grainy.
38. Gut Meter is more granular.
39. Hourglass replaces sun/moon representation.
40. Mini-map highlights current screen.
41. No combat exists.
42. No enemy exists.
43. No unnecessary tutorial appears.
44. No major supernatural mystery is explicitly explained.
45. Save/load does not corrupt progress.
46. Debug tools can verify state.
47. No critical console/runtime errors occur during the complete
    sequence.

------------------------------------------------------------------------

# 80. Recommended Build Order Summary

The AI implementation system should follow this exact dependency order:

``` text
0  Project Bootstrap
        ↓
1  Core State
        ↓
2  Player Controller
        ↓
3  HUD
        ↓
4  Title / Menu
        ↓
5  Friday Morning
        ↓
6  School
        ↓
7  Home / TV
        ↓
8  Parents / Angel
        ↓
9  Saturday / Well
        ↓
10 Underworld Transition
        ↓
11 First Underworld Board
        ↓
12 Polish / QA
```

Do not skip directly from Title Screen to the complete intro.

Each phase should produce a playable build.

------------------------------------------------------------------------

# 81. AI Builder Instructions

The AI system implementing this PRD should follow these rules:

### Rule 1 --- Preserve working states

Never destroy a working phase while implementing the next.

### Rule 2 --- Prefer reusable systems

If a feature will obviously be reused later, implement it as a reusable
component.

### Rule 3 --- Do not overbuild

Do not implement future combat, enemies, inventory, quests, or map
systems simply because the architecture anticipates them.

### Rule 4 --- Keep content data-driven

Dialogue, scene events, tuning values, and UI configuration should be
editable without rewriting core systems.

### Rule 5 --- Test every phase

Do not accumulate untested code across multiple phases.

### Rule 6 --- Protect narrative subtlety

Never add explanatory UI simply because a mechanic is technically
implemented.

### Rule 7 --- Preserve player agency

The player should control the protagonist whenever the scene does not
specifically require scripted presentation.

### Rule 8 --- Script only important moments

Use cinematic control only for:

-   Important dialogue.
-   Supernatural clues.
-   Angel.
-   Well.
-   Transitions.

### Rule 9 --- No generic placeholder UI in final slice

Temporary debug graphics are acceptable during implementation but must
be replaced before the phase is marked complete.

### Rule 10 --- No invented lore

If this PRD does not define an explanation, the implementation should
not invent one.

Mystery is intentional.

------------------------------------------------------------------------

# 82. Final Design Principle

The most important implementation requirement is not a particular
sprite, shader, meter, or scene.

It is the game's relationship with the player.

The game should behave as though the player is intelligent.

It should let the player notice.

It should let the player wonder.

It should let the player be wrong.

It should allow earlier events to acquire new meaning later.

The opening should therefore feel like an ordinary boy's life gradually
becoming inexplicably wrong---not like a tutorial introducing a fantasy
RPG.

The player should reach the underworld carrying questions rather than
answers.

That is the intended beginning of *Leprechaun*.
