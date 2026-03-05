# src

Your game code. Everything here is project-specific — customize freely.

```
src/
├── core/
│   ├── autoloads/          # Game-specific autoloads
│   └── core_scenes/        # Loading screen, main menu, settings, credits
├── classes/                # Game-specific classes and resources
├── scenes/                 # Game scenes (levels, characters, HUD)
├── scripts/                # Standalone scripts not attached to scenes
└── shaders/
```

#### What goes where

**`core/`** contains the structural scenes and autoloads that your game needs to run — menus, loading screen, settings. These ship with the template as a starting point. Modify them to match your game's flow and UI.

**`classes/`** is for reusable scripts with `class_name` — things like custom resources, data containers, or base classes for your game objects.

**`scenes/`** is where your game lives — levels, characters, enemies, HUD elements, anything the player interacts with.

**`scripts/`** is for scripts that aren't attached to a specific scene node — helpers, generators, or systems that are referenced by path.

**`shaders/`** is for `.gdshader` files. See [Godot's shading documentation](https://docs.godotengine.org/en/stable/tutorials/shaders/) for an introduction.

#### The boundary with `addons/patate/`

`addons/patate/` is template infrastructure — it should work without modification across all Patate-based projects. `src/` is where you make the game yours. If you find yourself editing files in `addons/patate/` for game-specific reasons, the code probably belongs here instead.
