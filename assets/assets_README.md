# assets

All game assets — art, audio, fonts, text, and UI themes. This folder is organized so that anyone on the team can contribute without needing to open a code editor.

```
assets/
├── art/
│   ├── characters/         # Character sprites, animations, portraits
│   ├── levels/             # Tilesets, backgrounds, level-specific art
│   ├── props/              # Objects, items, decorations
│   ├── tilesets/           # Tilemap source images
│   └── ui/                 # UI elements: icons, frames, cursors
│       └── temp/           # Kenney placeholder packs (replace with your own)
├── audio/
│   ├── atmospheres/        # Ambient loops (rain, wind, crowd noise)
│   ├── dialogue/           # Voice lines, narration
│   ├── music/              # Background music tracks
│   ├── sfx/                # Gameplay sound effects (footsteps, impacts, pickups)
│   └── ui_sfx/             # Interface sounds (button clicks, menu transitions)
├── bitfonts/               # Bitmap/pixel fonts
├── fonts/                  # Vector fonts (.ttf, .otf)
├── texts/                  # Localization files (CSV or PO)
└── themes/                 # Godot UI themes
    ├── debug_theme/        # Used by the debug overlay
    └── default_game_theme/ # Default theme applied to all game UI
```

#### For artists

Drop files in the matching subfolder. Use lowercase names with underscores: `player_idle.png`, not `Player Idle.png`. Godot reimports assets automatically when it detects changes.

The `temp/` folder inside `art/ui/` contains [Kenney](https://kenney.nl/) placeholder packs. Replace them with your own assets as the project matures — they're there so the game has usable visuals from day one.

Useful tools: [Aseprite](https://www.aseprite.org/) for pixel art and animation, [Krita](https://krita.org/) for painting and illustration, [Inkscape](https://inkscape.org/) for vector graphics.

See [Godot's 2D sprite documentation](https://docs.godotengine.org/en/stable/tutorials/2d/) and [import settings](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html) for how Godot handles images.

#### For sound designers

The audio folder maps to the game's audio bus layout. Place files in the subfolder that matches their bus: `music/` for the music bus, `sfx/` for the sfx bus, and so on. Supported formats: `.ogg` (recommended for music and loops), `.wav` (recommended for short sound effects).

Useful tools: [Audacity](https://www.audacityteam.org/) for editing and conversion, [sfxr](https://sfxr.me/) or [jsfxr](https://sfxr.me/) for procedural sound effects.

See [Godot's audio documentation](https://docs.godotengine.org/en/stable/tutorials/audio/) for bus configuration and playback.

#### For writers

Localization files live in `texts/`. Godot supports two formats:

- **CSV** — one row per string key, one column per language. Simple to edit in any spreadsheet editor (LibreOffice Calc, Google Sheets, Excel).
- **PO** — the standard gettext format, better suited for larger projects with plural forms and translator comments. Use [Poedit](https://poedit.net/) to edit these.

The game's scenes already reference translation keys like `MAIN_MENU_PLAY` and `SETTINGS_TITLE` — add translations by filling in new entries for each language.

See [Godot's localization documentation](https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html) for the full workflow and file format details.
