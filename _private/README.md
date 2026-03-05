# _private

This folder is **gitignored** and **Godot-ignored** (via `.gdignore`). Nothing here is shared through Git, and nothing here appears in Godot's FileSystem dock.

Use it for personal notes, reference images, temp exports, or anything you don't want in the repo. Since Godot can't see this folder, you cannot accidentally reference its contents in scenes or scripts — which is the point.

If you're working on something that the project will eventually need, build it in `src/` or `_examples/` from the start.
