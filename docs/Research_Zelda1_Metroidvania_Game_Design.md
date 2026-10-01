# Research: What Makes 2D Top-Down Adventure & Metroidvania Design Fun
## The Legend of Zelda (NES, 1986) + Metroid (NES, 1986) / Super Metroid (SNES, 1994)

**Purpose:** A deep-dive into the game and level design systems that make Zelda 1's top-down adventure formula work, with a side investigation into Metroid/Super Metroid's Metroidvania design, specifically to inform *Leprechaun*'s own design (which already draws on both — see `Leprechaun_Full_World_Bible.md` Sections 10.4–10.6 on exploration/dungeons, and the map-memory system in Section 12).

---

# Part 1 — The Legend of Zelda (NES)

## 1.1 The founding philosophy: *Hakoniwa* ("box garden")

Shigeru Miyamoto's design philosophy for Zelda is explicitly rooted in his own childhood — hiking without a map, stumbling onto a lake, finding small caves. He wanted the player to feel the same unscripted sense of discovery: *"I wanted to create a game where the player could experience the feeling of exploration as he travels about the world."* He describes his design approach as *hakoniwa* — a "miniature garden" or "box in a box" — handing the player a world full of secrets rather than a script to follow. Zelda is widely credited as one of the very first games built specifically to simulate this feeling of open-ended, personal exploration rather than a fixed obstacle course.

**Why it matters for fun:** the game is engineered to make the player feel like *they* found something, not like the designer told them where to go. This is the throughline behind nearly every system below.

## 1.2 Non-linear structure (the overworld is wide open from minute one)

The original Zelda lets the player walk in almost any direction from the start and, famously, attempt dungeons 3 or even 8 before dungeon 1 if they can survive it. Roughly **half the game's items are not strictly required to beat it** — items have broad, overlapping utility rather than being locked to one specific dungeon/puzzle, which is what makes free reordering possible at all. This is a different, looser kind of "non-linearity" than modern Metroidvania ability-gating: it's non-linear because the *world* doesn't block you, not because the items don't gate anything.

**Important nuance:** within each individual dungeon, the critical path is almost always linear, with only short branching offshoots near the entrance. The game creates an *illusion* of open design at the micro level (a few rooms to choose from early on, small hidden shortcuts that reward attentive players) sitting inside genuine open design at the macro (overworld) level. This two-layer trick — tightly linear rooms assembled into a free-roaming world — is a reusable lesson: non-linearity doesn't require literally non-linear content; it can be assembled from mostly-linear pieces arranged with real choice about *which piece to enter next*.

## 1.3 Secrets, and the social contract that makes them fair

Zelda 1 trained an entire generation of players on a specific grammar of secrets: bomb suspicious walls, burn suspicious bushes, push suspicious blocks, read gravestones, pay for hints. The dungeon-1 entrance itself — hidden under a bush you must burn — teaches this grammar in the first five minutes. Design analyses describe this as a *rule set the player learns and remembers*, not randomness: once you've learned "bombs open secret walls," that rule applies everywhere, which turns "search everything" from tedium into a legible, masterable skill.

A companion piece on designing mystery (Mark Brown / Game Maker's Toolkit) frames this as the core tension of all secret design: a secret has to be **findable without being obvious** — if it's too hidden it feels unfair (bomb literally every wall in the game, a real complaint about Zelda 1), and if it's too obvious it isn't a secret at all. Zelda 1's answer is partial, consistent visual tells (a suspicious lone tree, an oddly-placed rock, a dead end that doesn't quite feel like a dead end) combined with cheap, repeatable tools (bombs, candles) that make "testing a hunch" low-cost.

**The second quest reinforces this as deliberate systemic design, not accident:** when you beat the game once, the overworld layout stays the same but secrets are substantially rearranged (a dungeon entrance becomes a shop, a different lake hides the real entrance, etc.) — proving the designers thought of "secret placement over a fixed map" as its own tunable layer, separable from the map geometry itself.

## 1.4 The resource economy (rupees, bombs, keys) — and its real lesson

Rupees are simultaneously currency *and* ammunition (each bow shot costs one), the wallet caps at 255 (anything earned past the cap is simply lost), and bomb-capacity upgrades cost a flat 100 rupees — all of which is designed to make the player feel genuine tension about *whether to spend or save*. The game's own economy is honestly a little broken (only 40 rupees are strictly needed to finish the game, which undercuts the tension in the back half), and that's actually an instructive failure case: a resource system can look rich and interlocking on paper while still collapsing in practice if there's a "cheap path" around it. **For a game being built now, the lesson isn't "copy rupees" — it's "make sure your core resource is load-bearing for the whole game, not just the opening hours."**

## 1.5 Combat: simple inputs, high legibility, strong feedback

Zelda 1's combat is mechanically simple (walk into things, swing a sword, occasionally use a secondary item) but reviewers repeatedly single out its *feel*: the sword swing is "cathartic," has a satisfying little explosion effect and sound at the end, and the game is widely regarded as having one of the best early-NES enemy rosters because each enemy type demands a **different, specific tactic** rather than just more HP — Darknuts can only be hit from the side/behind, Goriyas throw returning boomerangs you can dodge or counter, Like-Likes have no knockback and will eat your shield if you let them grab you. Audio feedback is explicitly called out as part of what makes combat satisfying — the "ping" of an arrow or boomerang deflecting off a shield is a small, precise, information-carrying sound, not just noise.

**Lesson:** depth doesn't require complex controls — it can come entirely from *enemy variety that demands different player behavior*, paired with sharp, specific audio/visual feedback on hits, blocks, and kills.

## 1.6 Sound design as a reward system in its own right

Composer Koji Kondo's "secret found" chime — a fast arpeggio, originally a workaround for the NES's inability to render full chords smoothly — and the "item get" fanfare are both explicitly engineered as *reward signals*: a short, bright, unmistakable sound that fires exactly at the moment of discovery, independent of any visual confirmation. Game-sound writers describe this as triggering genuine dopamine-style satisfaction, and the series has reused and re-arranged variants of these two cues in nearly every subsequent entry. **This is a cheap, high-leverage technique:** a dedicated, consistent "you found something" sound, separate from your generic UI blips, makes every secret feel like an event.

## 1.7 World structure: a grid of discrete, flip-scrolling screens

Mechanically, Zelda 1's whole world — overworld and dungeons alike — is built from fixed-size screens (roughly 16×7 screens of ~14×10 tiles each on the overworld) that flip-scroll into place one at a time rather than scrolling continuously. This isn't just a technical artifact of the NES; it has a *design* consequence still worth noting: each screen is a discrete, author-designed "room" that can be hand-tuned for a specific secret, a specific enemy placement, or a specific vista, rather than being a procedurally-continuous landscape. It's the same reason the game's mini-map/overworld-map concept reads so cleanly: the world *is* a grid of distinct, memorable "panels," which is exactly the mental model *Leprechaun*'s own map-memory/notebook-fragment system (World Bible Section 12) is already built around.

## 1.8 The core loop, and why the three pillars reinforce each other

Multiple sources converge on the same conclusion: Zelda's fun comes from **exploration, combat, and puzzle-solving feeding each other in a loop**, not from any one of them being deep in isolation. Exploration finds you an item; that item is simultaneously a combat tool, a puzzle key, and an overworld-traversal upgrade (e.g., the raft lets you reach new land, fight certain enemies, and solve specific dungeon rooms). Because almost every item does triple duty, progress in any one axis (combat, puzzle, traversal) tends to open possibilities in the other two — which is what makes the moment-to-moment loop feel generative instead of repetitive, and is the single most load-bearing idea in the entire game's design.

---

# Part 2 — Metroid (NES, 1986) and Super Metroid (SNES, 1994)

## 2.1 Metroid NES: the founding "no map, no mercy" exploration design

Metroid's defining, genre-founding gesture is handing the player one of the largest explorable NES worlds ever built **with no in-game map and no area names** — a sharp departure from Zelda, which at least gave you a manual map and discrete dungeons. The game's famous opening trick (walking right immediately dead-ends at a wall you cannot pass) deliberately breaks the unstated "progress is usually to the right" rule 1986 players had been trained on by platformers, forcing the player to *reconsider the whole map* as something to be learned rather than assumed. The world itself is built from discrete one-screen "rooms" (256×240 px, exactly one NES screen) stitched into tunnels and shafts — architecturally similar to Zelda's screen-grid, but used for a continuous cave system instead of a dungeon-plus-overworld split.

**Isolation as a deliberate atmosphere, not a side effect:** Samus is alone for virtually the entire game, in bizarre, often-haunting locales, with mostly ambient (not melodic) music specifically used to reinforce isolation — every dead end and every unexpectedly-familiar corridor becomes part of a cumulative feeling of being lost in a hostile, uncaring place, which is itself the emotional payload of the genre.

## 2.2 The genre's defining loop: explore → gate → ability → re-explore

The canonical Metroidvania loop, which Metroid originated and Super Metroid perfected: **explore an area, hit an obstacle you can't yet overcome, remember where it is, find a new ability elsewhere, and return to convert that remembered dead-end into a new path.** This is formalized by designers as the "ability-gate" loop: intuitive action (moving, shooting, jumping) opens up exploration, exploration yields resources (items/abilities), and those resources unlock new avenues for intuitive action — a closed, self-reinforcing cycle. Backtracking, instead of being a tolerated cost, is the genre's actual *reward structure*: returning to an old area with a new tool and finally breaking through is explicitly described as "proof of mastery," not busywork — which only works if the game respects the player's time on the return trip (see 2.5).

## 2.3 Super Metroid: the "dependency graph" and curated-feeling open design

Mark Brown's *Boss Keys* analysis of Super Metroid describes its structure as a giant "dependency graph" of locks and keys — doors, terrain, and obstacles that are each tied to a specific ability or item, diagrammable as a chart of prerequisites from start to end. The player can often *physically wander* into areas "ahead of schedule," but the game is careful to make it immediately legible that they're early — a locked door, a wall they can't yet blow up, terrain they can't yet survive — rather than letting them get softly lost or stuck. Design writers go further and call this **"the invisible hand of Super Metroid"**: despite feeling like total freedom, the game is actually walking most players down a close-to-linear critical path, using environmental storytelling, subtle visual cues (something glowing faintly in the distance, a corridor that looks slightly "off"), and deliberate power-up placement to make the *designer's* intended order feel like the player's own discovery. The player experiences the game on two simultaneous levels — moment-to-moment survival in a corridor, and "macro mode" mental mapping of the whole explored world — and the game's trick is making the macro-level choices feel free while they are, in fact, heavily curated.

## 2.4 Ability recontextualization and sequence breaking

Super Metroid's single most celebrated design trick is that **some upgrades aren't items you find — they're techniques you discover you could always do.** The Wall Jump is the canonical example: it isn't handed to the player with fanfare, it's a physics capability embedded in Samus's base moveset from the start, and finding out "oh, I can do this" produces a different, more personal kind of satisfaction than picking up a glowing orb. This is explicitly tied to the game's famous sequence-breaking culture: the developers appear to have anticipated and tolerated players finding wall-jumps and bomb-jumps to reach items "out of order," since the game is engineered so that entering an area without the "intended" item is survivable rather than game-breaking or crash-prone. **Lesson for design:** a world built on ability-gates is more interesting, and more durable against player ingenuity, if at least some of the gates can be beaten by skill alone, not just by the intended key item — it rewards mastery instead of just punishing exploration.

## 2.5 Respecting backtracking: loop design and shortcuts

Because backtracking is structurally mandatory in this genre, bad backtracking (walking the exact same corridor you just walked, the exact same direction, with nothing new to see or do) is one of the genre's biggest failure modes. Super Metroid's answer, repeatedly cited by designers: build **loops**, not dead-end spurs — a one-way drop (a crumble-block floor, a one-way gate) should have a *different*, shorter return path waiting nearby rather than forcing a full backward retrace, and vertical shafts in particular are designed so the climb back up presents different challenges than the fall down, so the same space doesn't feel literally repeated. The broader principle stated by designers studying this: "respect the late-game commute" — interleave shortcuts and quick-travel-style connections as the player acquires faster movement options, so growing mastery is expressed as literal, felt speed through a world you increasingly understand, not as an increasingly long walk.

## 2.6 Atmosphere and music as a design system, not decoration

Super Metroid is widely held up as the series' (and arguably one of gaming's) best uses of *absence* of music: the opening section plays no melodic music at all until the Ridley fight, using only droning tones, ambient beeps, and diegetic station noise — a deliberate choice, not a technical limitation (the SNES could easily do more). Where music does appear, it leans on low drones, sparse percussion, and repetitive, non-"catchy" melodic figures, explicitly intended to feel like "nature's hum" rather than a hummable theme — composers have stated this avoidance of catchiness was intentional, against the era's trend. The payoff: because true silence and ambient dread are the baseline, the rare moments music *does* swell (a boss reveal, a late-game triumph) land far harder than they would in a game that uses melodic score throughout.

## 2.7 Boss design evolution: NES attrition → SNES choreography

A direct, useful contrast: Metroid NES bosses (including Kraid) are largely **wars of attrition** — tank a lot of hits, land a lot of hits, with little pattern to learn. Super Metroid explicitly redesigns this into **pattern-based choreography** — bosses with distinct telegraphed attacks the player must learn and react to, turning fights into a "gauntlet" of memorization and positioning rather than a damage race. The Kraid fight is the clearest before/after case: NES Kraid is fought at Samus's eye level as basically another big enemy; SNES Kraid immediately grows to tower over the screen, partly to show off SNES hardware, but the effect is to reframe the same boss as a dramatically bigger, more "proper" set-piece encounter. **Lesson:** making a boss *bigger* or *harder-hitting* is a weak lever on its own — making its attacks legible, learnable, and distinct is what actually elevates a fight.

## 2.8 Why exploration itself feels good (the psychological layer)

Writing specifically on Metroidvania psychology converges on self-determination theory: these games hook players not through points or flashy extrinsic rewards but through the need for **competence** (every new ability makes you measurably sharper) and **autonomy** (every sprawling map makes you believe the path is yours, even when it's curated per 2.3). The core described mechanism is a "notice → bookmark → earn power → cash the check" neurological loop: the player notices an obstacle they can't yet beat, mentally files it away, eventually earns the relevant ability elsewhere, and then gets to return and resolve that specific, personally-remembered obstacle — which research on curiosity in games ties to engagement rising specifically when uncertainty is mixed with a believable promise of eventual payoff (a locked door you can see is far more motivating than a locked door you're merely told exists).

---

# Part 3 — Cross-Cutting Synthesis: What Actually Makes Both of These Fun

Pulling the two investigations together, five mechanisms recur across both games and both genres, and all five are directly actionable for *Leprechaun*:

1. **Items/abilities should do more than one job.** Zelda's raft is traversal + combat-avoidance + puzzle key; Super Metroid's Speed Booster is traversal + a combat/puzzle tool + a sequence-break enabler. A single-purpose item is a weaker design than a multi-purpose one. *Leprechaun's* own design already leans this way (the stick that both detects secrets and sometimes finds safe sleeping spots) — this is worth deliberately extending to future items.
2. **Secrets need a learnable grammar, not just hidden content.** Zelda 1 teaches "burn bushes, bomb walls" in its first five minutes and then uses that rule everywhere. *Leprechaun's* planned non-"bomb every wall" rule (world bible §10.6 — subtle cues like the hair bristling / Gut Meter instead of blind interaction-testing) is explicitly a refinement of this exact lesson, learned from the real complaints about Zelda 1's secret design.
3. **Backtracking must be re-earned, not merely re-walked.** Super Metroid's loop-based map design and "respect the late-game commute" principle apply directly to *Leprechaun's* map-fragment/notebook system (world bible §12) — once an area is re-visited with a new ability or a new piece of the map, the return trip should ideally offer a shortcut or a changed challenge, not a flat repeat.
4. **Difficulty and discovery should both be legible, not arbitrarily hidden.** Super Metroid tells you *immediately* that you're in the wrong place too early (a visible locked gate) rather than letting you get softly lost; Zelda 1's worst-reviewed secrets are the ones with zero visual tell. *Leprechaun's* "no forced quest marker, but a readable Gut Meter / World Mood" approach (already specified in the intro PRD and world bible) is the right instinct, provided every real secret still has *some* perceivable tell, even a subtle one.
5. **Silence, sound, and restraint are gameplay systems, not polish.** Both Kondo's precise "reward" sound effects and Super Metroid's near-total absence of music are deliberate structural choices that directly shape how discovery and dread *feel*, decided early rather than bolted on. This is worth treating as a first-class design decision for *Leprechaun's* own "Gut Meter" moments and underworld ambience, not a late-stage audio pass.

---

# Sources

**Legend of Zelda:**
- [Learning From The Masters: Level Design In The Legend Of Zelda](https://www.gamedeveloper.com/design/learning-from-the-masters-level-design-in-i-the-legend-of-zelda-i-)
- [What elements make The Legend of Zelda's dungeon design stand out](https://famiboards.com/threads/what-elements-make-the-legend-of-zeldas-dungeon-design-stand-out.9515/)
- [Hyrule Blog — The Linearity Check: Dungeon Orders](https://touriantourist.blogspot.com/2013/08/the-linearity-check-dungeon-orders.html)
- [Overworld Map & Secrets — The Legend of Zelda (NES), Hyrule Archive](https://hyrulearchive.com/zelda1/overworld)
- [Overworld Quest — Z1R Wiki](https://z1r.fandom.com/wiki/Overworld_Quest)
- [Boss Keys — An Analysis of Zelda Dungeons, Room Escape Artist](https://roomescapeartist.com/2017/09/10/boss-keys-analysis-zelda-dungeons/)
- [Watch This Analysis of Zelda (NES) and Zelda II's Dungeons, Zelda Dungeon](https://www.zeldadungeon.net/watch-this-analysis-of-zelda-nes-and-zelda-iis-dungeons/)
- [Game Maker's Toolkit — Wikipedia](https://en.wikipedia.org/wiki/Game_Maker%27s_Toolkit)
- [The Miyamoto Method: Why Nintendo Games Feel Like Real...](https://screenwiseapp.com/guides/shigeru-miyamoto)
- [Zelda at 40: How Shigeru Miyamoto's childhood explorations inspired Nintendo's legendary classic](https://www.videogameschronicle.com/features/zelda-at-40-how-shigeru-miyamotos-childhood-explorations-inspired-nintendos-legendary-classic/)
- [In 1989, Miyamoto laid out his original design goals for Zelda](https://www.gamedeveloper.com/design/in-1989-miyamoto-laid-out-his-original-design-goals-for-i-zelda-i-)
- [The Secret to Designing Mysterious Games, Mark Brown / GMTK](https://gmtk.substack.com/p/the-secret-to-designing-mysterious)
- [Zelda On NES: Every Bombable Wall In Hyrule And Where To Find Them](https://www.thegamer.com/legend-of-zelda-nes-every-bombable-wall/)
- [Anatomy of a Game: The Legend of Zelda I](https://www.anatomyofgames.com/2012/09/04/anatomy-of-a-game-the-legend-of-zelda-i/)
- [Zelda Has a Rupee Problem](https://danielhaynes.co.uk/zelda-has-a-rupee-problem)
- [Bomb Upgrades — The Legend of Zelda (NES) Guide](https://zeldacentral.com/games/the-legend-of-zelda/bomb-upgrades/)
- [What's So Great About Zelda 1 — Celia Wagar's CritPoints](https://critpoints.net/2017/04/10/whats-so-great-about-zelda-1/)
- [The Legend of Zelda (NES Review), Indie Gamer Chick](https://indiegamerchick.com/2025/08/08/zelda1/)
- [Zelda: A Beep to the Past, Twenty Thousand Hertz](https://www.20k.org/fave-episodes/zeldabeep-arh5x)
- [The Legend of Zelda Series' Legacy of Iconic Sound Design](https://gamerant.com/the-legend-of-zelda-iconic-sound-design-jingles-legacy/)
- [Zelda 1: understanding the 'scrolling', NESDev Forum](https://forums.nesdev.org/viewtopic.php?t=21109)
- [Zelda Screen Transitions are Undefined Behaviour](https://www.gridbugs.org/zelda-screen-transitions-are-undefined-behaviour/)
- [The Triforce Of Gameplay — A study of Zelda's mechanics (academia.edu)](https://www.academia.edu/37374636/The_Triforce_Of_Gameplay_A_study_of_Zeldas_mechanics)
- [Gameplay Elements of The Legend of Zelda Series, Zelda Wiki](https://zelda.fandom.com/wiki/Gameplay_Elements_of_The_Legend_of_Zelda_Series)
- [Combat in Zelda games is an unmatched thrill, Zelda Universe](https://zeldauniverse.net/features/combat-in-zelda-games-is-an-unmatched-thrill/)

**Metroid / Super Metroid / Metroidvania genre:**
- [Map Data Downloaded: The Design of the Metroidvania Genre — Part 1](https://qwarq.medium.com/map-data-downloaded-the-design-of-the-metroidvania-genre-part-1-19342bcf65a6)
- [Pixelblog - 38 - Metroid Study, SLYNYRD](https://www.slynyrd.com/blog/2022/5/24/pixelblog-38-metroid-study)
- [The Map Matters: How Metroid is Meant to be Played, Goombastomp](https://goombastomp.com/metroid-nes-map-matters-retrospective/)
- [Metroidvania — Wikipedia](https://en.wikipedia.org/wiki/Metroidvania)
- [The history of the word "Metroidvania": how Metroid and Castlevania created a genre](https://www.generationamiga.com/2026/03/28/the-history-of-the-word-metroidvania-how-metroid-and-castlevania-created-a-genre/)
- [Looking back at the level design triumphs of Super Metroid](https://www.gamedeveloper.com/design/looking-back-at-the-level-design-triumphs-of-i-super-metroid-i-)
- [How 'Super Metroid' changed level design](https://henrique-lage.medium.com/how-super-metroid-changed-level-design-c6e612ea62a7)
- [The Opening Sequence To Super Metroid Is A Masterpiece, Kotaku](https://kotaku.com/the-opening-sequence-to-super-metroid-is-a-masterpiece-1672800828)
- [The 3 Essential Elements of Metroidvania Design, Game Wisdom](https://game-wisdom.com/critical/metroidvania-design)
- [Metroidvania, explained — design pillars, history, scope](https://allthings.how/metroidvania-explained-design-pillars-history-scope/)
- [The Invisible Hand of Super Metroid](https://www.gamedeveloper.com/design/the-invisible-hand-of-super-metroid)
- [Super Metroid: A Masterclass in Curated Open-World Design](https://medium.com/austin-school-of-game-design/super-metroid-a-masterclass-in-curated-open-world-design-5988f4e68098)
- [Sequence Breaking — Metroid Wiki](https://metroid.fandom.com/wiki/Sequence_Breaking)
- [Sequence breaking — Wikipedia](https://en.wikipedia.org/wiki/Sequence_breaking)
- [Super Metroid: Every Main Boss & How To Beat Them](https://www.thegamer.com/super-metroid-main-boss-guide/)
- [30 Years Later, Super Metroid's Foreboding Atmosphere Is Still Unmatched, Nintendo Life](https://www.nintendolife.com/features/soapbox-30-years-later-super-metroids-foreboding-atmosphere-is-still-unmatched)
- [How Super Metroid Portrays Atmosphere through Music](https://medium.com/@mchahn007/how-super-metroid-portrays-atmosphere-through-music-33f4641af0f8)
- [The Sound of Solitude: How Music Shapes the Atmosphere of Metroid](https://confusingmiddle.com/2025/03/21/the-sound-of-solitude-how-music-shapes-the-atmosphere-of-metroid/)
- [The Psychology of Metroidvania: Why We Can't Stop Exploring](https://medium.com/@sophia_schneider/the-psychology-of-metroidvania-why-we-cant-stop-exploring-32c92e87c909)
- [A Framework for Metroidvania Games (ResearchGate PDF)](https://www.researchgate.net/publication/346540910_A_Framework_for_Metroidvania_Games)
