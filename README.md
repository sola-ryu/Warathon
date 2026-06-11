# Warathon 🏃

Wario cheats his way to victory in a marathon. The race is rigged. The winner isn't.

## Quick Start

1. Install [Godot 4.x](https://godotengine.org/download)
2. Open `Project.godot` in the Godot editor
3. Press F5 to run the menu
4. Choose a game mode and start racing!

### Controls

| Key | Action |
|-----|--------|
| A | Sandwich Snatch — grab food, speed boost |
| B | Banana Barrage — throw 3 peels behind you |
| C | Fake Police — slow everyone with a cop |
| D | Oil Spill — pour oil, opponents slide past |
| E | Spectator Wall — crowd blocks rear runners |
| F | Energy Shot — massive burst speed |

## Game Modes

- **WARATHON** — Story mode across 5 themed stages
- **CHEAT FEVER** — Endless marathon, score-based
- **WALUIGI'S RETRATHON** — Rival race (both cheating)
- **MICROGAMES** — WarioWare-style mini-games between stages

## Microgames

| Game | Description |
|------|-------------|
| 🥪 Stealth Sandwich | Grab food without the guard seeing you |
| 🍌 Peel Master | Rapid-fire: place peels on named runners |
| 🎭 Disguise | Toggle Wario/spectator to avoid suspicion |
| 🌉 Bridge Builder | Assemble shortcut from random objects |

## Current Status

### ✅ Complete
- **GDD** — Full game design document with mechanics, roster, stages
- **Core Systems** — Cheat manager, course generator, chaos system, game data
- **Player Character** — Wario with 4 animation states (run/cheat/boost/slip)
- **Opponents** — 8 characters with personality-based reactions to cheats
- **Menu Screen** — Mode selector with WarioWare-style yellow title
- **Race Scene** — Auto-run, camera follow, HUD (score/position/fuel/chaos)
- **Results Screen** — Post-race stats with "Honesty: 0%" badge of honor
- **4 Microgames** — Stealth Sandwich, Peel Master, Disguise, Bridge Builder
- **Visual Juice** — Screen shake, DAM! flash text, WarioWare vignette border
- **Particle Effects** — Unique effects per cheat (peels, oil, sweat, sparks)
- **Spectator Rendering** — Random crowd figures in spectator zones
- **Parallax Backgrounds** — Stage-themed scrolling layers
- **Audio Manager** — Placeholder with stage music and cheat SFX mapping

### ⏳ Next
- [x] Sprite art (generated via ComfyUI — 38 assets)
- [ ] Actual audio/SFX integration
- [ ] Waluigi rival mode logic
- [ ] Cheat zone area triggers (food vendors, water stations, etc.)
- [ ] More microgames (Disguise variant, Bridge Builder variant)
- [ ] Post-race cheat codex unlock system
- [ ] Gold coin collectible economy
- [ ] Polish: squash/stretch, motion blur, Wario laugh SFX

## Architecture

```
src/
├── main/                    # Game scenes
│   ├── menu.tscn/gd         # Title screen + mode selector
│   ├── race.tscn/gd         # Core racing scene
│   ├── results.tscn/gd      # Post-race stats
│   ├── microgame_hub.tscn/gd  # Mini-game selection
│   ├── microgame_stealth.tscn/gd  # Stealth Sandwich
│   ├── microgame_peel.tscn/gd     # Peel Master
│   ├── microgame_disguise.tscn/gd # Disguise
│   └── microgame_bridge.tscn/gd   # Bridge Builder
├── characters/
│   ├── base_runner.gd       # Auto-run character base class
│   ├── wario.gd             # Player character (4 states)
│   ├── opponent.gd          # Opponent with personality reactions
│   └── opponent_sprite.gd   # Visual identity per opponent
├── systems/
│   ├── game_data.gd         # Global state, scores, cheat unlocks
│   ├── cheat_manager.gd     # Cheat cooldowns, fuel, execution
│   ├── course_generator.gd  # Procedural segments, stage themes
│   ├── chaos_system.gd      # Crowd reactions, multiplier decay
│   ├── cheat_zone.gd        # Zone areas for cheat triggers
│   ├── opponent_factory.gd  # Spawn configured opponents
│   ├── dam_flash.gd         # WarioWare "DAM!" text overlay
│   ├── screen_shake.gd      # Camera shake intensity levels
│   ├── vignette_effect.gd   # Garish border during cheats
│   ├── parallax_bg.gd       # Stage-themed scrolling backgrounds
│   ├── zone_renderer.gd     # Visual zone markers on course
│   ├── spectator_renderer.gd  # Crowd figures per zone
│   ├── particle_effects.gd  # Per-cheat visual feedback
│   ├── audio_manager.gd     # SFX/music placeholder
│   └── sprite_generator.gd  # Placeholder pixel art generator
└── assets/                  # Sprites, tiles, audio, fonts
docs/
└── GDD.md                   # Full game design document
```

## Design Philosophy

> *"Champions don't need to cheat. Wario is a champion."*

The race is rigged. Wario always wins. The fun is in **how** he cheats and the chaos that ensues. Every cheat should feel over-the-top and funny. Opponents have distinct personalities that react differently to each cheat type.

### Cheat Design Principles
- Each cheat has unique visual feedback (particles, flash text, vignette color)
- Timing matters: too early = opponents recover, too late = miss the window
- Fuel system ties cheats to spectator zones — you need to find crowds
- Chaos multiplier rewards chaining cheats together
- Losing is impossible. The game literally cannot let you lose.

## Generated Assets (38 images via ComfyUI)

All assets are in `images/` — names are descriptive for Godot integration.

### Characters (`images/characters/`)
| File | Opponent |
|------|----------|
| `wario_run.png` | Wario (player) |
| `mario_run.png` | Mario |
| `luigi_run.png` | Luigi |
| `peach_run.png` | Peach |
| `bowser_run.png` | Bowser |
| `toad_run.png` | Toad |
| `yoshi_run.png` | Yoshi |
| `dk_run.png` | Donkey Kong |
| `king_boo_run.png` | King Boo |
| `birdo_run.png` | Birdo |
| `daisy_run.png` | Daisy |
| `shy_guy_run.png` | Shy Guy |
| `waluigi_run.png` | Waluigi (rival) |

### Items (`images/items/`)
| File | Purpose |
|------|---------|
| `food_vendor.png` | Food vendor cart (fuel zone) |
| `water_station.png` | Water station (fuel zone) |
| `banana_peel.png` | Banana peel cheat item |
| `oil_can.png` | Oil can cheat item |
| `medical_tent.png` | Medical tent (fuel zone) |
| `bridge_gate.png` | Bridge gate piece |
| `sandwich_icon.png` | Stealth Sandwich microgame icon |
| `energy_drink.png` | Energy Shot cheat item |
| `lightning_bolt.png` | Speed boost indicator |
| `disguise_mask.png` | Disguise microgame item |
| `bridge_piece.png` | Bridge Builder microgame piece |
| `peel.png` | Loose peel (scatter cheat) |

### Backgrounds (`images/backgrounds/`)
| File | Stage |
|------|-------|
| `urban_city.png` | Stage 1 — City |
| `park.png` | Stage 2 — Park |
| `lava_castle.png` | Stage 3 — Bowser's Castle |
| `dreamland.png` | Stage 4 — Dream Land |
| `crowd.png` | Spectator zone filler |

### UI (`images/ui/`)
| File | Purpose |
|------|---------|
| `magnifying_glass.png` | Microgame selector icon |
| `timer.png` | Countdown timer frame |
| `fuel_bar.png` | Fuel meter bar |
| `score_counter.png` | Score display frame |
| `stage_map.png` | Course map overlay |

### Spectator Sprites (`images/sprites/`)
| File | Mood |
|------|-------|
| `spectator_cheering.png` | Cheering crowd |
| `spectator_excited.png` | Excited reaction |
| `spectator_disappointed.png` | Disappointed reaction |

---

*Built with Godot 4.x — June 2026*
