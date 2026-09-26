# LEPRECHAUN — Full World Bible & Design Source Document

**Project:** Leprechaun
**Document:** Master design reference, distilled directly from the original planning transcript
**Companion document:** `Leprechaun_Intro_First_Underworld_PRD.md` (the implementation-ready spec for the title screen, the Friday/Saturday intro, and the first underworld screen — that document is scoped narrowly on purpose; this one is not)
**Purpose:** The original design conversation for this game covered far more than the opening slice: the full leprechaun mythology, the four regions, combat, the dog companion system, the sleep/day-night cycle, the wanted/chase mechanic, the map-memory system, and business/scope targets. Rather than let those details live only in the source transcript, this document restates them completely, in the design's own words wherever possible, so nothing gets lost the way it apparently did when the transcript was first condensed into a PRD.
**Status of content below:** Most of this is locked creative direction from the planning conversation. Where the original conversation left a question genuinely unanswered or contradicted itself, that is called out explicitly under **Open Questions** at the end, rather than silently resolved or invented.

---

# 1. Business & Platform Context

This shaped every subsequent design decision, so it belongs at the top.

- **Engine:** Godot 4 (chosen over GameMaker, Unity, Phaser, RPG Maker, LibGDX/MonoGame). Godot won specifically because: excellent dedicated 2D renderer, TileMap workflow well suited to a Zelda-like world, GDScript is approachable for an experienced programmer while C# remains available, scene/node architecture is a strong match for building a *reusable RPG framework* rather than a one-off game, and Steamworks integration exists via GodotSteam for Godot 4.4+.
- **Platform:** Steam (PC). Steam Deck compatibility is a goal, not yet a hard requirement.
- **Commercial goal:** Turn a profit on this first title. Price target: **$12.99**.
- **Scope philosophy:** Optimize for a small, extremely polished game over a large, mediocre one. Market reference used during planning: paid Steam games in the $10–14.99 band had a median reviewed playtime around 7.2 hours (2026 analysis of ~7,000 paid Steam titles) — used as a sanity check, not a hard rule.
- **Target scope for the full game (not the intro slice):**
  - Main story: 5–7 hours
  - Main + substantial side content: 7–10 hours
  - 100%/completionist: 10–15 hours
  - 3 dungeons
  - 3–4 major bosses
  - 4 major overworld regions
  - 8–12 enemy types (each meaningfully distinct — not 40 palette-swapped enemies)
  - 15–25 NPCs with meaningful dialogue (not 100 generic villagers)
  - 10–15 major abilities/items
  - Single-player, controller-first, no multiplayer, no procedural generation, no crafting tree, no massive loot economy
- **Structural model:** Action-adventure RPG, not a traditional stats-heavy RPG. Player should understand the game in about 30 seconds. Exploration is Dark-Souls-like (a few branching paths, not open from the start like Elden Ring) rather than truly open world — closer to Metroidvania gating via items/puzzles between sub-sectors of each region.
- **Development philosophy for the studio:** the first game should double as a reusable RPG framework (movement, combat, dialogue, save, inventory, UI, audio, Steam integration) so that a second game doesn't start from zero.
- **Recommended pre-production step (from planning, not yet executed):** build a small vertical slice — final-ish art, one enemy, one weapon, one NPC, one short quest, one dungeon room, one boss, full menus/save/audio — before committing to the full production plan. The current intro + first-underworld-screen slice is effectively serving this role.

---

# 2. Core Pillars

1. **Show, don't tell.** Truths are revealed through events, visual cues, behavior, and consequence — never through tutorials or exposition dumps.
2. **Maintain mystery.** The supernatural is hinted at, never explained early. Some things are only ever explained retroactively, or not at all until very late.
3. **Emotional authenticity.** The protagonist is not perfect. He feels sadness, fear, loneliness, and occasional anger — and endures anyway.
4. **Consequences matter.** Certain actions are one-way doors. Not every failure can be reloaded away.
5. **Player agency.** Encourage exploration, observation, and strategy. Avoid hand-holding, quest markers, and objective popups.
6. **Subtlety.** Red eyes, distorted faces, and other supernatural "tells" should be quick and ambiguous. The player's own gut feeling — literalized as the Gut Meter — is the real guide.

---

# 3. The Protagonist

- **Age:** 13. **Name:** chosen by the player (profanity/slur filter required — the game must not permit an obscene or hateful name for either the boy or the dog).
- **Personality before the well:** A sweetheart. Quiet, introverted, sensitive, intuitive, empathic, honest, uncorrupted. He doesn't understand why other kids are mean to him, or why people treat each other cruelly at all — this confusion (not cynicism) is his defining trait pre-adventure.
- **Not a chosen one in the traditional sense.** He isn't special because of birthright or prophecy. He is targeted/affected specifically *because* he is sensitive and intuitive — he perceives and feels things other people numb themselves to. That sensitivity is the whole reason "why him."
- **Arc:** He does not become a different person. He learns to live with fear, sadness, and loneliness without letting them corrupt him, and learns to trust the same intuition that once felt like a burden. On the Gut Meter, his arc is not "reach permanent joy" — it's "learn to stand at TERROR without surrendering to it."
- **He is not perfect.** He gets sad, afraid, lonely. He wants people to be as kind to him as his dog is. He wants people to simply get along. These are explicit, stated flaws/wants — not resolved by becoming a warrior.
- **Family:**
  - **Mother** — warm; her sincere lines ("Good morning, sweetheart, I made you some French toast," "There's some dinner on the table for you") always come through as clear, intelligible speech to the boy, regardless of what garbled/hostile speech surrounds them.
  - **Father** — works, comes home stressed; his warm asides ("Hey, kiddo") are also always clear. He and Mother argue increasingly through the Friday sequence; their hostile dialogue is deliberately unintelligible ("Whaa whaa whaa...").
  - **Billy, the older brother** — the boy's only sibling. Mean to the protagonist (mocks him, refuses him a ride, drives off with friends laughing), but the protagonist loves him anyway. This relationship is intended to mirror, thematically, how the boy will eventually deal with the leprechauns: cruelty met without hatred.
  - A "little brother" mentioned once in the transcript, only in the described ending hug, has been **dropped by decision** — there is no younger brother. The ending reunion is mother, father, Billy, and the dog.
- **Dog:** A golden retriever, extremely friendly and loving. **Named by the player** (same profanity filter applies). Central to both the opening and the mid/late game — see Section 8.

---

# 4. The Well Accident (locked narrative detail)

The boy is playing fetch with his dog near the well in the family's yard. Three throws:
1. Short, playful throw — dog fetches, returns, sits with paws up.
2. Farther throw — dog fetches, drops stick at his feet.
3. A great overhead arc, straight into the well.

The dog runs for the well. The boy screams and chases, trying to stop him. The dog actually clears the far rim and lands belly-first on the other side with an "oof," scrambling to safety — the boy, reaching over the well to try to grab/push the dog to safety, overbalances on the near rim and **falls in himself**, head-first (he does not see the dog make it to safety — that's a piece of information the *player* has that the boy does not, for a long stretch of the game). The dog turns, looks down the well, and whines. This is a genuine accident; nobody caused it, and the boy remembers every second of it (no memory loss).

---

# 5. The Leprechaun World — Mythology

## 5.1 Cosmology & history
- The underworld has always been the leprechauns' realm — physically inside the earth, and *dimensionally* separated from the human world (not merely "underground" in a literal-geography sense; the leprechauns cannot access the human world physically, only by luring people through enclosed dark places).
- Leprechauns were **once good**, many ages ago. Over many generations, corrupting forces led them to find pleasure in darker uses of magic.
- The corrupted leprechauns eventually performed a ritual in the **Realm Beyond** that anchored the dark force into their world **and destroyed their own sun** — the source of their joy, light, and truth. This act is both the origin of the underworld's permanent dusk and the philosophical fall of leprechaun society.
- **The sun's fate (destroyed vs. imprisoned vs. hidden) was never pinned down in the original conversation** — it was raised as an open story question ("does the sun still exist somewhere?") and never answered. This is a major potential endgame hook and should be treated as unresolved, not retconned into something specific without a deliberate decision.
- The underworld has no sun. It exists in a permanent dusk — things glow faintly as if lit without a source. The "weather" of the world is emotional/temporal rather than meteorological — see World Moods, Section 7.

## 5.2 Leprechaun society
- Leprechaun society is dominated by darkness and skill in dark magical arts. The powerful ones are fierce, commanding, and malevolent — the working comparison given was **Smaug from The Hobbit**: not "evil little green guys," but ancient, terrifying beings that happen to look folkloric until you meet a truly powerful one.
- It is a dominance hierarchy: the strong subjugate the weak, who become servants and toadies.
- Culture: feasts, beer, leprechaun music, dancing, carrying on late into the night — followed by group magical rituals attempting to open a portal to spy into the human world.
- They lure humans into their world, then torment them with "twisted games" and imprison them.
- **Good leprechauns** live among the bad ones but keep a low profile. They are regarded (by the bad leprechauns) as weak — low magical power, mostly limited to some healing ability, no dark arts. They survive by staying quiet rather than by fighting (violence itself may feed the darkness — this reasoning was proposed as a design question but never explicitly confirmed by the user).
- **Source of power (bad leprechauns):** they grow powerful by causing fear, spreading gloom, and getting into the heads of other creatures to dominate them. Their signature ability is **projecting a "shade"** — a spying/possessing projection of themselves that can inhabit or observe through animals and creatures, or search for people.
- **Limits of their power:**
  - They cannot dominate the joyful, the pure of heart, or those who hold onto hope/love/imagined warmth despite the lack of a literal sun.
  - They cannot open portals into the human world in sunlight — **only** in darkness: night, caves, wells. Enclosed, dark spaces are the only doorway.
- **Leprechaun speech:** a "broguelike," strange, nonsensical gibberish to the player/protagonist — mirroring the "Whaa whaa whaa" device used for hostile human speech in the intro. When leprechauns speak, **thought bubbles can show pictures/impressions** that hint at intent, rather than translating the words. The boy's intuition tells him *what a leprechaun is*, even when he can't understand *what it's saying*.
- **Unresolved:** the transcript posed but never answered detailed questions about leprechaun physical appearance (traditional Irish-folklore look vs. something darker; whether good and bad leprechauns are visually distinguishable at all), size (tiny vs. child-sized vs. human-sized vs. variable-by-power), and exactly what visibly marks a *powerful* leprechaun as terrifying (does it grow larger? distort its surroundings? multiply itself? speak barely above a whisper?). These are flagged again in **Open Questions**.

## 5.3 The Great Hall — a major future story beat
This was described as a specific, pivotal scene the boy will witness later in the underworld (not part of the currently-implemented intro/first-screen slice, but essential lore for future development):

The boy comes upon a great hall of the leprechauns. He watches (unseen) as they dance, drink, and sing, carrying on late into the night. At some point they bring out **slaves on a chain** and force one to drink their brew, after which the slave collapses unconscious. At the end of the revelry, the leprechauns **join hands and chant together**, and through this ritual **project their will into the human world** — the boy sees, within their shared vision, **his own parents** fighting. This is the moment the story pivots from "I need to escape this world" to "this world is causing the corruption in mine": the leprechauns' magic and malevolence are *directly* responsible for the deterioration the boy witnessed in "A Day in the Life" (the parents' fighting, the TV's degeneration, etc.). It is a retroactive reveal — the opening's ambient wrongness was evidence, not just atmosphere.

## 5.4 Regions
Four major overworld regions (matching the "4 major regions" scope target):
1. **The Black Forest of Llhuien** (spelled "LLhuien" once in the transcript — treat as the working spelling until corrected)
2. **The Oceanside and tributaries** — requires a boat to traverse
3. **The Long Desert** — lethal to cross without the right equipment, knowledge, and experience gained elsewhere first
4. **The Realm Beyond** — the final, alien, volcanic, otherworldly region; the secret nerve center of the leprechauns is hidden here, and it is where the original sun-destroying ritual took place

## 5.5 Creatures
- Half-human/half-horse beings (centaur-like), dragons, and other mythical creatures, alongside ordinary animals such as rabbits.
- Even "ordinary" animals in this world usually carry something strange — an unexpected ability, behavior, or intelligence.
- Creatures range from speaking allies, to hostile enemies, to servants bound to the leprechauns.
- **Power of good** is mainly tapped through certain trees, springs, and other "places of power" — natural rather than architectural sources of benevolent magic.

## 5.6 Visual identity
Nature is the throughline of the world's visual language: abundant waterfalls, flowing water, quickly-growing flowers and plants, trees that occasionally move. Music should reflect this nature-heavy, "alive" quality. The underworld should read as beautiful before it reads as threatening.

## 5.7 Title
The game's title is simply **"Leprechaun."**

---

# 6. Angels

- Angels are **multi-dimensional beings** from another realm entirely (distinct from both the human world and the leprechaun underworld). They can be *called* into the human world, and — a discovery for later in the game — the boy eventually learns he can call them into the underworld too.
- They oppose the leprechauns thematically: hope, truth, courage, love, creation, healing, and guidance versus fear, gloom, domination, corruption, despair, and manipulation.
- **Not freely available.** Calling an angel requires specific circumstances — the fear/gloom atmosphere of the leprechaun realm itself works against casual prayer. The exact gating (required attributes, health thresholds, specific items, or specific locations) was explicitly left as a design question to flesh out later ("what does the character need... in order to call the angel?").
- **Sanctums:** likely locations — underground or surface springs — function similarly to Zelda's fairy fountains, but should do more than restore health: they should also deliver information, messages, encouragement, and aid, not act as a pure healing station.
- **First encounter (intro, already implemented in detail):** a luminous, human-sized, egg-shaped light descends into the boy's bedroom and settles to his right; within it, a ~50%-transparent elf-like woman in pale/ancient clothing partially materializes. She heals him fully (health, vitality, gut all restored to calm/joy) and says: *"I know this has been difficult. But have faith. Have hope. It won't be very long now..."* — the referent of "it" is deliberately never specified. Her protection fills the room with light, pushes back the swirling red distortion (visible continuing in the rest of the house), and lasts roughly one night-cycle — lasting, not permanent.

---

# 7. World Time, Mood, and Safety Systems

## 7.1 Day/night representation
- **Human world:** an ancient astronomical/navigational instrument — realistic, multi-colored, evocative of *The Dark Crystal*'s planetary armillary crossed with a compass — represents the sun/moon cycle. Not a cartoon icon.
- **Underworld:** the equivalent instrument is an **hourglass**. Sand pours first one direction, then the other. When the dark side is on top, leprechauns are at their strongest, the world grows emotionally darker, monsters get stronger, and leprechauns actively prowl.

## 7.2 Vitality & sleep
- **Vitality** (the design settled on this term over "stamina") naturally decreases — during the human-world intro it wanes across the day and bottoms out near bedtime (last ~5%, the red zone).
- The player **cannot force sleep** — it only becomes available once vitality drops into the red zone (~10%), at which point the character can lie down.
- **Safe vs. unsafe places to sleep** is a central survival mechanic in the underworld: part of exploring any new area is figuring out where it's safe to rest. Sleeping in the wrong place has consequences (unspecified in detail, but implied to be dangerous — possibly triggering the "wake up somewhere else" mechanic below).
- **Sleeping can relocate the character.** If the boy falls asleep in certain places (explicitly called out: in/near water), he may wake up elsewhere in the world. This is a deliberate mechanic, not a bug — falling asleep is a small gamble unless a location is a known-safe spot.
- **Cycle-syncing is a strategic choice, not a hard rule.** Moving during the light cycle and sleeping through the dark cycle is the safer, "best practice" approach; the player *can* go against this (or invert it entirely) but at significantly higher difficulty. Leprechauns and their shades are far more active at night.

## 7.3 World Mood vs. Gut Meter — two separate systems
These were explicitly designed as **independent** systems that can diverge, which is itself a source of mystery:
- **World Mood** (external, affects the whole world): a spectrum something like *Serene → Somber → Gloom → Dread → Crimson/Terror*. Changes lighting, environment, creature behavior, available paths, music, and the frequency of supernatural phenomena.
- **Gut Meter** (internal, the boy's own state): see Section 9.
- Example of the intended payoff: the World Mood might be Gloom (everything *looks* dangerous) while the boy's Gut Meter unexpectedly swings toward Joy — the player has to notice the mismatch and investigate, because it usually means something specific and beneficial (a hidden spring, a good creature nearby, etc.) rather than being random.

## 7.4 The wanted/chase mechanic ("on the drawing board" but detailed)
- If a leprechaun's shade spots the player, it flees back to report to the leprechaun it belongs to, which then gathers others and organizes an active search — explicitly compared to **GTA's wanted-star system**.
- The Gut Meter's fear axis effectively *is* the wanted-level indicator in this scenario.
- Music changes during an active search.
- The player's job during a search is to evade — break line of sight, hide, cross water, take an alternate route, wait it out. Leprechauns search for a while, then give up.
- **Stakes while being hunted:**
  - The **dog can be captured** if caught during a search. This is intended to be a real, semi-permanent consequence (not simply reload-and-retry) — the dog would not be recoverable until the ending, where the player gets him back regardless of the game's other outcomes.
  - **The boy himself can be captured**, with an explicitly tiered, escalating consequence structure that was proposed (not fully finalized): 1st capture → some kind of confinement the player can find a way out of; 2nd capture → a different, harder escape; 3rd capture → **a bad ending** where the boy lives out his days as a leprechaun prisoner. This means the game does not always have to resolve toward the "happy" ending — the design explicitly wants some real bite and player nervousness, without being edgy for its own sake.
- **Design tension acknowledged in the transcript itself:** the wanted/capture mechanic is only meaningful if the player can't simply reload a save to erase the consequence, but the design also explicitly does *not* want to require one uninterrupted playthrough, and does *not* want Dark-Souls-style repeated grinding through the same stretch to reach a boss. This tension was never resolved — see **Save System**, Section 11.

---

# 8. The Dog — Full Companion System

- Breed: golden retriever. Extremely friendly and loving by nature.
- **Narrative timing:** the dog survives the well fall (landing safely on the far rim) but does **not** appear again immediately. The player should spend real time — potentially several hours, "maybe halfway through the game" — wondering what happened to him, with the boy occasionally voicing that worry in a thought bubble. He is intended to reappear near the original drop-in point of the underworld, triggering a mostly wordless, emotionally significant reunion (a bark, the boy's Gut Meter spiking toward Joy, the boy kneeling as the dog runs to him).
- **Gameplay role — must be genuinely useful, never a dead-weight escort companion:**
  - **Sniff:** finds hidden objects, secret passages, detects whether something recently passed through an area.
  - **Danger sense:** growls before ambushes, tenses around supernatural creatures, reacts to invisible threats.
  - **Attack:** distracts or bites certain enemies, interrupts attacks, can knock down smaller creatures.
  - **Fetch:** retrieves items or activates mechanisms out of the boy's reach.
  - **Emotional stabilization:** proximity to the dog helps calm the Gut Meter — but the dog should not be a blanket "fear immunity" device; some situations should frighten even him.
  - He can also be a liability at times, requiring the player to actively command him rather than simply ignore him.
- **Command scheme — deliberately minimal, gesture-based rather than a menu:**
  - Quick double-press **toward** the dog's direction → **Stay**
  - Quick double-press **away from** the dog's direction → **Come**
  - Triple-press in any direction, then release with no movement → **Investigate** (opens selection of a visible object on screen for the dog to retrieve/check)
  - Player toggles/holds a "sneak" input → the dog automatically sneaks in sync with the player (no separate command)
  - Player attacks → the dog automatically attacks in sync with the player (no separate command)
- **Capture risk:** see Section 7.4 — the dog can be taken by leprechauns during an active search, with the loss standing until the game's ending (regardless of how the story otherwise resolves).

---

# 9. The Gut Meter — Full Specification

This is one of the game's signature systems and should be treated as core, not decorative UI.

## 9.1 Concept
A single linear gauge:
```
TERROR <---------------- CALM ----------------> JOY / EXCITEMENT
```
Visualized as a **stationary needle** with a **rolling/circular gauge beneath or around it** that moves like an old analog power meter — the explicit reference given was **the Fallout 4 power-armor energy display**. In the underworld it should look progressively more like this granular reference; in the human-world intro it is intentionally opaque, with blurred/undefined/washed-out labeling, so the player doesn't initially know what it even is.

## 9.2 Two functions
1. **Danger awareness.** The meter reflects the boy's subconscious read on danger in a scene. The game never labels this outright — the player has to learn to interpret it and decide whether to fight, evade, hide, or flee.
2. **Intuition / discovery.** The meter can also swing toward Joy/Excitement when the boy senses something good, safe, or significant nearby (e.g., a hidden path to a healing spring). Critically, **this signal may not repeat** — if the player doesn't act on a flicker of Joy when it happens, they may not get a second chance at that specific discovery. This is meant to train real player attentiveness, not function as a cheap "secret detector" that fires reliably every time.

## 9.3 Fear's mechanical effect on the character
As fear rises, the character's responsiveness should degrade — but this needs careful, playtested calibration, not an extreme implementation on the first try:
- **Low fear:** normal control.
- **Moderate fear:** subtle cues only — breathing, animation changes, slightly slower recovery, occasional hesitation.
- **High fear:** reduced precision — less responsive movement, harder-to-execute attacks, occasional hesitation before acting.
- **Terror:** potential freezing, stumbling, refusing an attack, brief involuntary movement, or brief loss of control.
- **Explicit caution from the design conversation itself:** taking control away from the player is thematically strong but mechanically risky — a better first implementation reduces available options/precision rather than randomly overriding input, and the more extreme "involuntary action" version should be prototyped and tested rather than assumed.

## 9.4 Thematic tie-in
Leprechaun power is explicitly fear-based (Section 5.2), so the boy's growing ability to *function* under fear (not to stop feeling it, but to act anyway) is not just a gameplay stat — it's the literal mechanism by which he resists the antagonists. The intended emotional progression:
> "I'm terrified." → "I'm still afraid, but I know what to do." → "This is terrifying, but I can face it." → "I'm afraid, and I won't surrender."

## 9.5 Relationship to progression
Because the Gut Meter reflects perceived danger rather than an explicit numeric threat level, player growth is meant to be felt organically: an enemy that once spiked the meter to Terror might later only reach Fear, then Calm, once the player has better means to handle it — a softer, more diegetic version of traditional level-gating.

---

# 10. Combat, Items, and Exploration (evolving design — flagged for scope control)

The user explicitly flagged during this part of the conversation that some of these ideas may be scope creep for a first game and would likely be "reeled back in."

## 10.1 Early game
Starts with unarmed punches/kicks — thrown the way an untrained kid would fight, not a trained combatant. Progresses to found weapons: a stick, a rock.

## 10.2 Items are meaningful, not abundant
Explicitly **not** a Skyrim-style loot-everywhere game. Items are rare, and each one has a real use. Some items carry quasi-magical properties tied to the world's "forces of nature" theme:
- A stick may sometimes reveal a safe place to sleep.
- A stick can reveal a false wall / secret passageway when pointed at one (vibrates in the direction of something hidden).
- Discovery of world information happens through clues, books, scrolls, conversation, and witnessing natural/strange events (a tree dissolving, a mood shift turning everything red and swirling, etc.) rather than through UI logs.

## 10.3 Combat mechanics (revised toward a Dark Souls/Elden Ring-inspired but scaled-down feel)
- Movement-based positioning: hop forward, hop back, hop at an angle, each combinable with an attack.
- Block and duck.
- Traps: originally floated as a primary strategy (luring an enemy into a trapped area, stunning/finishing it), but the user later **revised this down** — traps should appear "here and there," and in a few specific spots progression may *require* a trap to bypass an otherwise-impossible fight, but they are not meant to be the main combat loop.
- **Life bar growth:** the boy's health grows by defeating enemies, but the world has a **finite number of enemies** — once a given enemy is defeated, it's gone permanently (not respawning trash mobs). This directly affects how "grinding" would even be possible in this game — it largely wouldn't be.
- **Sneaking / sound:** a sound-based detection mechanic. Moving slowly = quiet/sneaking; walking/running = louder "thumps" that can alert enemies. Sneaking past danger, rather than fighting it, is often the correct strategic choice — reinforced narratively by the theme that courage sometimes means knowing when *not* to fight (Section 7.4).

## 10.4 Exploration structure
Metroidvania-style gating rather than a fully open world: a few branching paths or general explorable areas per region, gated behind items/puzzles to reach the next sub-sector — closer to Dark Souls' structure than Elden Ring's immediate openness.

## 10.5 Dungeons
- Especially dark; light sources are required to navigate them.
- **Different colored lights reveal different things** — an "electromagnetic spectrum" concept where certain objects, paths, or dangers are only visible under a specific light color. Finding the right light(s) is part of solving a dungeon.
- Visually and structurally inspired by the original Zelda's grid-of-rooms dungeon design (including multi-level dungeons with upper/lower rooms) — the whole game's world structure may even follow this "series of rooms" model rather than continuous scrolling terrain.
- A dungeon map should reveal rooms as they're visited, and the player should be able to drop manual markers on the map.

## 10.6 Puzzles
- Hidden passages gating required items.
- Multiple valid paths through some puzzles.
- Directional/sequence puzzles in the vein of the original Zelda's "lost woods" trick — but must fit the world's tone, not feel like a generic minigame.
- Story/quest gates: some passages only open after a specific quest/interaction is completed (e.g., a tree that's simply gone on a return visit, revealing a new route).
- **Explicit anti-goal:** avoid the original Zelda's "bomb every wall" style of blind trial-and-error. Secrets should be discoverable through subtle, consistent cues — the character's hair visibly bristling, and above all the **Gut Meter** — rather than being findable only by exhaustively interacting with every tile.

## 10.7 Bosses
- **Single life bar** (not segmented into multiple phases with separate bars, which was called out as demoralizing to fight).
- Bosses go through visible **transformations/stages** as they approach death, escalating in power — with an element of **randomization** in which stage-variant appears, some considerably more dangerous than others.
- General enemies can also "morph" into angrier, more malevolent forms under certain conditions.
- Example creature concept given (not necessarily a specific boss, just an illustrative monster idea): a large, spider/crab-like creature with a scorpion-style stinger.

## 10.8 Optional activities
Fishing and hunting (as life-replenishment activities grounded in the world's nature theme), and swimming into underwater holes/hidden areas as an exploration mechanic.

## 10.9 World size philosophy
The world should feel expansive the way the original Zelda's overworld did, despite actually being a fairly compact grid. The explicit anti-goal is aimless wandering through empty space — most "rooms"/screens should contain something discoverable or something that changes based on player action or world mood, so re-traversal doesn't feel wasted.

---

# 11. Save System — Explicitly Unresolved ("on the drawing board")

This was never settled in the planning conversation and should not be treated as decided. What *was* discussed:
- Certain major events are intended as **one-way doors**: no reloading/resetting past them once triggered (the well fall itself is the first example, already implemented as irreversible in the current intro slice).
- The design explicitly wants the game to feel a little dangerous/nervous-making — "some bite" — and is open to endings that are **not** the happy return-home ending (see the tiered capture-consequence idea in Section 7.4).
- The design explicitly does **not** want:
  - a single required uninterrupted playthrough with no saving at all, nor
  - Dark-Souls-style repeated runs through the same stretch to re-attempt a boss, nor
  - a save system so permissive that a player can simply reload the instant before a costly capture/consequence, which would gut the tension the wanted/capture system is trying to create.
- A tentative idea floated (not committed to): **sleep as a save point.** This pairs naturally with the vitality/sleep system (Section 7.2) but was explicitly marked as uncertain.
- **Conclusion:** this remains a genuinely open design problem. Any future implementation work on the save system beyond the current intro slice's "single active quest, no scumming past one-way doors" foundation should treat this as a live design question, not settled scope.

---

# 12. Mapping — Memory, Notebook, and Fragments

- The player initially navigates by **memory only**: the last several visited screens remain visible/lit on the mini-map; older ones progressively darken and eventually drop off the map entirely.
- Later, the boy finds a **notebook and pencil**, at which point the player can begin permanently mapping every screen visited.
- Screens do **not** automatically snap together into a correct layout — they appear as loose fragments that the player must manually assemble into a coherent map, based on their own memory of how areas connected.
- **Consecutive screens** traveled in sequence form one fragment; if the boy goes underground and comes back up elsewhere, that starts an **entirely new fragment** requiring separate assembly and eventual connection back to the main map.
- Tentative, unconfirmed late-game idea: the player might eventually find pieces of a "greater" pre-existing map that reveal hidden areas not otherwise discoverable — explicitly flagged as "a concept to revisit later," not committed design.

---

# 13. The Opening Sequence — Cross-Reference

The full beat-by-beat design of the title screen through the first underworld screen (bedroom → school → recess incident → Billy → TV/commercial → parents' fight → angel → Saturday morning → stick/fetch → the fall → underworld arrival) is already fully specified, in production-ready detail, in **`Leprechaun_Intro_First_Underworld_PRD.md`**, and the corresponding dialogue is already implemented in `scripts/intro/*.gd` matching that document closely (verified directly against the source scripts while writing this document). That document remains the authority for the opening's exact staging, camera behavior, and acceptance criteria — this document does not repeat it, only the surrounding mythology that PRD deliberately left out of scope.

One detail from the original transcript is worth calling out because it did **not** make it into the intro PRD and is not yet implemented: the idea that the boy's sensitivity might let him **feel out which leprechauns are good** later in the game ("Maybe he can use this sensitivity and intuition to feel out who the good leprechauns are") — proposed as a possible extension of the same "clear vs. garbled speech" intuition mechanic already used for humans. This was floated, not fully designed, and is a strong candidate mechanic for whichever region/dungeon phase first introduces good leprechauns as characters.

---

# 14. Open Questions

These were raised during planning and never answered, or were answered in a way that contradicts something said elsewhere. They should be resolved deliberately before building the content that depends on them, rather than assumed.

1. **Leprechaun physical appearance.** Traditional Irish-folklore look vs. something darker/more alien? Are good and bad leprechauns visually distinguishable, or does the player have to learn to tell them apart entirely by behavior/intuition?
2. **Leprechaun size.** Tiny (1–2 ft), child-sized, human-sized, or variable with power level?
3. **What makes a powerful leprechaun visibly terrifying** (beyond narrative description)? Does it grow larger, distort its surroundings, project multiple copies of itself, speak barely above a whisper while controlling everything around it, or something else?
4. **Why don't good leprechauns fight the bad ones?** Weakness was given as the surface reason; several deeper possibilities (violence itself feeds the darkness, they've forgotten the old magic, fear, philosophy, waiting for an outsider) were proposed by the assistant during planning but never confirmed by the user.
5. **Does the sun still exist somewhere**, imprisoned or hidden, or was it destroyed outright? This was explicitly floated as a potentially major endgame hook and left open.
6. **Save system finalization** (Section 11) — genuinely unresolved; needs a deliberate design pass before any save/consequence system beyond the current intro slice is built.
7. **Capture-consequence specifics** (Section 7.4) — the tiered 1st/2nd/3rd-capture idea was proposed but never finalized in mechanical detail (what does confinement actually look like moment-to-moment; how does the player escape the first two times?).
8. **Map-fragment late-game reveal mechanic** (Section 12) — explicitly "a concept to revisit later."

---

*This document should be kept alongside `Leprechaun_Intro_First_Underworld_PRD.md` as the reference for any work beyond the currently-implemented opening slice — regions, the dog system, combat, dungeons, the Great Hall reveal, and the leprechaun society itself all live here.*
