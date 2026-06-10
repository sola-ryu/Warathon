# Warathon 🏃

Wario cheats his way to victory in a marathon.

## Quick Start

1. Install [Godot 4.x](https://godotengine.org/download)
2. Open `Project.godot` in the Godot editor
3. Press F5 to run the menu
4. Choose a game mode and start racing!

### Controls

| Key | Action |
|-----|--------|
| A | Sandwich Snatch |
| B | Banana Barrage |
| C | Fake Police |
| D | Oil Spill |
| E | Spectator Wall |
| F | Energy Shot |

## Project Structure

```
Warathon/
├── Project.godot           # Godot project config
├── src/
│   ├── main/               # Game scenes (menu, race, results)
│   ├── characters/         # Wario + opponent classes
│   ├── systems/            # Cheat manager, course gen, chaos
│   └── ui/                 # UI components
├── assets/                 # Sprites, tiles, audio, fonts
└── docs/
    └── GDD.md              # Game Design Document
```

## Current Status

- ✅ GDD complete
- ✅ Core game systems (cheat manager, course generator, chaos)
- ✅ Player character (Wario) base class
- ✅ Opponent base class with personality system
- ✅ Menu screen
- ✅ Race scene with HUD
- ✅ Results screen
- ⏳ Sprite art
- ⏳ Audio/SFX
- ⏳ Microgame mini-games
- ⏳ Waluigi rival mode
- ⏳ Polish & juice

## Design Philosophy

The race is rigged. Wario always wins. The fun is in **how** he cheats and the chaos that ensues. Every cheat should feel over-the-top and funny. Opponents have distinct personalities that react differently to each cheat type.

---

*Built with Godot 4.x — June 2026*
