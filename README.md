# RanchVille

Seated mixed-reality farming game for Meta Quest 3. Godot 4.x + OpenXR. Horizon Store MVP.

Project tracking: [Linear — RanchVille](https://linear.app/biccs/project/ranchville-d13837b7f800).

## Quest 3 export

Export presets live in `export_presets.cfg`. Run a headless build with:

```bash
GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot ./export_quest.sh --debug --format apk
```

Use `./export_quest.sh --help` for release signing and AAB output. See [AGENTS.md](AGENTS.md) for keystore env vars.
