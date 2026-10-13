# RanchVille

Seated mixed-reality farming game for Meta Quest 3. Godot 4.x + OpenXR. Horizon Store MVP.

Project tracking: [Linear — RanchVille](https://linear.app/biccs/project/ranchville-d13837b7f800).

## Quest 3 export

Export presets live in `export_presets.cfg`. Run a headless build with:

```bash
GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot ./export_quest.sh --debug --format apk
```

Use `./export_quest.sh --help` for release signing and AAB output. See [AGENTS.md](AGENTS.md) for keystore env vars.

## Quest 3 live reload

This is not automatic. Cursor cannot push files to the headset. Godot must stay open and serve the project over USB.

Do this once per session:

1. Plug in the Quest 3. Keep USB debugging on.
2. Open this project in Godot (or run `./run_quest_live.sh`).
3. Click **Debug** in the Godot menu bar. Enable these three items:
   - **Deploy with Remote Debug**
   - **Synchronize Script Changes**
   - **Synchronize Scene Changes**
   Leave **Small Deploy with Network Filesystem** off. It crashes the Quest app.
4. In the top-right of Godot, click the **remote deploy** button (Android / phone icon next to Play). Wait until RanchVille opens on the headset.

After that first deploy:

- Save a script in Godot. The headset reloads that script.
- Save a script in Cursor. Godot reloads it, then the headset reloads it.
- Keep Godot open. If you close Godot, live reload stops.
- Add a new file, change `project.godot`, or change export settings. Click the remote deploy button again.

A full APK build (`./export_quest.sh`) does **not** live-reload. Use it only when you need a standalone install.
