# 🏃 WARATHON 🏃

## Game Design Document

> *"Champions don't need to cheat... but Wario is a champion, so he cheats anyway."*

---

## HIGH CONCEPT

A chaotic, WarioWare-style racing game where you play as **Wario** running a marathon against absurdly determined opponents. The twist: **the race is rigged**. Wario's cheating is baked into the game design — his "special moves" are just him stealing food from spectators, throwing banana peels, and bribing officials.

Think *Mario Kart* meets *WarioWare Inc.* meets *Canabalt*, but it's a marathon and everyone knows Wario's cheating and they're all too tired to stop him.

---

## CORE LOOP

```
Run → Encounter Cheat Opportunity → Execute Cheat → Gain Advantage → 
Opponents React → Chaos Ensues → Finish First (Always)
```

### Run Phase
- Side-scrolling auto-run with player control over timing of cheats
- Wario runs automatically; player focuses on **when** to cheat
- Spectators line the course — they're your "cheat fuel"

### Cheat Opportunity
- Specific zones along the course trigger cheat events:
  - **Food Vendor** → Steal a sandwich (speed boost)
  - **Water Station** → Swap water for oil (slip hazard behind you)
  - **Spectator Zone** → Tripping, banana peels, fake police
  - **Medical Tent** → "Accidentally" inject energy drink
  - **Bridge/Shortcut** → Cut across private property

### Execute Cheat
- Player chooses WHICH cheat to use (up to 3 equipped at a time)
- Timing matters: execute too early = opponents recover; too late = miss the window
- Each cheat has a "cheat meter" cooldown

### Chaos & Advantage
- Opponents react based on their personality types
- Some fall for it, some fight back, some just give up
- Position shifts happen in real-time with over-the-top animations

---

## CHEAT ROSTER (The "Power-Ups")

| Cheat | Icon | Effect | WarioWare Microgame Style |
|-------|------|--------|---------------------------|
| **Sandwich Snatch** | 🥪 | Grab food from vendor → speed boost for 5s | Tap sandwich before it gets eaten! |
| **Banana Barrage** | 🍌🍌🍌 | Throw 3 peels behind you → chain slips | Click rapidly to peel! |
| **Fake Police** | 👮 | Sprinting cop appears → everyone slows | Tap X to run from the cop! |
| **Oil Spill** | 🛢️ | Pour behind you → opponents slide past | Hold to pour, release at right time |
| **Spectator Wall** | 🧱 | Crowd forms barrier → blocks rear opponents | Swipe to push crowd together |
| **Energy Shot** | 💉 | "Medical" injection → massive burst speed | Tap in rhythm! |
| **Shortcut Gate** | 🚧 | Tear down barrier → cut 100m off course | Mash button to rip! |
| **Sweat Slip** | 😅 | Wario sweats profusely → opponents slip on it | Hold and release at peak |

### Legendary Cheats (Ultimates)
- **Wario Man Transformation** → Full superhero mode for 8 seconds
- **Treasure Radar** → Find hidden shortcut, steal opponents' shoes
- **Wario-Man Stampede** → Call Wario Man army to trample course

---

## OPPONENT ROSTER (The "Runners")

### The Serious Ones (Easy to cheat on)
- **Mario** — Too honorable, believes in fair play. Easily confused by bribes.
- **Luigi** — Nervous, panics when cheated on. Trips over himself.
- **Peach** — Polite to a fault. Won't retaliate even when sabotaged.

### The Suspicious Ones (Medium)
- **Toad** — Very alert, but small and easily overwhelmed by chaos.
- **Yoshi** — Hungry! Can be bribed with food (which Wario also steals).
- **Donkey Kong** — Strong enough to resist some cheats, but dumb.

### The Feral Ones (Hard)
- **Bowser** — Will fight back. Throws fireballs at Wario.
- **King Boo** — Teleports past cheats. Haunts Wario's running shoes.
- **Waluigi** — Wario's rival! Also cheats. Becomes the real antagonist.

### The "Just Here for the Vibes"
- **Birdo** — Too busy doing their own thing.
- **Daisy** — Actually enjoys the chaos. Might help or hinder randomly.
- **Shy Guy** — Can't see well. Falls for every trick.

---

## GAME MODES

### 1. WARATHON (Story Mode)
Wario enters a marathon to win the gold medal (which is actually just a giant gold coin). Each stage is a different themed course:

- **Stage 1: Wario City** — Urban course, food vendors everywhere
- **Stage 2: Mushroom Kingdom Park** — Nature course, spectators + wildlife
- **Stage 3: Bowser's Castle Road** — Lava, obstacles, Koopa troops as "course officials"
- **Stage 4: Dream Land** — Surreal WarioWare-style stages, reality breaks down
- **Final Stage: The Finish Line** — Everything goes wrong, epic cheating finale

### 2. CHEAT FEVER (Arcade Mode)
Endless marathon. How far can you cheat? Score based on:
- Distance cheated (not run honestly)
- Chaos multiplier (how many opponents affected simultaneously)
- Style points (creative cheat combos)

### 3. WALUIGI'S RETRATHON
Waluigi enters too. Now it's a race within a race. Both of you are cheating. The course tries to stop both of you. Spectators are confused.

### 4. MICROGAMES (WarioWare-style)
Between stages, mini cheat microgames:
- **Stealth Sandwich** — Grab food without being seen
- **Peel Master** — Place banana peels on specific runners
- **Disguise** — Become a spectator to get close to the finish line
- **Bridge Builder** — Build a shortcut from random objects

---

## VISUAL STYLE

### Aesthetic
- **WarioWare Inc.** meets **Mario Kart Wii** course design
- Bright, garish color palette (Wario's signature: yellow + purple)
- Exaggerated expressions and squash-and-stretch animations
- "Cheating vignette" — screen gets a WarioWare-style border when executing cheats

### UI Design
- Cheat meter at bottom: fills as you run, depletes on cheat use
- Position display: "1st Place (Obviously)"
- Spectator count per zone as fuel gauge
- Wario's expression changes based on cheat readiness (hungry → mischievous → evil grin)

### Screen Effects
- When cheating: screen shakes, WarioWare "DAM!" text flashes
- Opponents falling: cartoon stars, exaggerated physics
- Speed boost: motion blur + Wario's signature laugh lines
- Finish line: gold coin explosion, Wario flexing

---

## AUDIO DIRECTION

### Music
- Main theme: Upbeat, cheesy jazz-funk (WarioWare aesthetic)
- Each course has a themed remix that gets more chaotic as cheats increase
- "Victory" music: Wario's laugh woven into the melody
- Cheat execution: sound effects from classic WarioWare microgames

### SFX
- Wario's grunts, laughs, and "Wah!" sounds for everything
- Opponent reaction sounds (confusion, anger, resignation)
- Crowd reactions (cheering, gasping, confused murmurs)
- Cheat-specific sounds (ripping fabric, splashing, slipping)

---

## SCORING & PROGRESSION

### Within a Race
- **Cheating Score** — Points for each successful cheat
- **Chaos Multiplier** — Combo system for chaining cheats
- **Spectator Rating** — How entertained the crowd is (more cheering = more fuel next time)
- **Honesty Penalty** — Running normally gives 0 points. You're supposed to cheat.

### Meta Progression
- Unlock new cheats by completing challenges
- Collect gold coins → buy cosmetic cheats (fancy banana peels, diamond-encrusted sandwiches)
- Unlock opponent variants (harder to cheat on, more chaotic reactions)
- "Cheat Codex" — encyclopedia of every cheat ever used

---

## THEMATIC HONESTY

The game **winks at the player** about its own rigged nature:

- Tutorial literally says "This game is rigged. Good job!"
- Opponents sometimes break the fourth wall: "Oh great, here we go again"
- The finish line announcer always says "Wario wins! ...Again."
- Post-race stats include "Honesty: 0%" as a badge of honor
- Losing is impossible. The game literally cannot let you lose.

---

## TECHNICAL NOTES

### Engine: Godot 4.x
- 2D side-scroller with parallax backgrounds
- TileMap for course construction
- AnimationPlayer for character sprites
- Area2D for cheat zone detection
- Particles for chaos effects (banana peels, sweat, etc.)

### Architecture
```
scenes/
  main/
    menu.tscn          — Main title screen
    race.tscn          — Core race scene
    results.tscn       — Post-race stats
  characters/
    wario.tscn         — Player character (animated sprite)
    opponent_*.tscn    — Opponent base class + variants
  systems/
    cheat_manager.gd   — Cheat cooldowns, execution, effects
    opponent_ai.gd     — Opponent behavior trees
    course_generator.gd — Procedural course segments
    chaos_system.gd    — Multiplier, spectator reactions
  ui/
    cheat_meter.tscn
    position_display.tscn
    score_overlay.tscn
  stages/
    stage_1_city.tscn
    stage_2_park.tscn
    ...
assets/
  sprites/
  tiles/
  audio/
  fonts/
docs/
  GDD.md
  ARTSTYLE.md
  LEVELS.md
```

---

## FUTURE EXPANSION IDEAS

- **Online "Fair Race" Mode** — Where you play as someone else trying to beat Wario honestly (impossible but fun)
- **Cheat Editor** — Design your own cheats, share with community
- **Seasonal Courses** — Halloween Warathon, Christmas Warathon, etc.
- **WarioWare Crossover** — Actual microgames from the series as bonus content
- **Photo Mode** — Capture the most ridiculous cheat moments

---

## TAGLINE OPTIONS

- *"Champions don't need to cheat. Wario is a champion."*
- *"The race is rigged. The winner isn't."*
- *"Every marathon needs a Wario."*
- *"Winning isn't everything. It's the only thing. (Wario says so)"*

---

*Document v1.0 — June 2026 — Let's make this glorious.*
