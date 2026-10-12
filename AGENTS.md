# Agent guide — RanchVille

Coding agents working in this repo. Linear project: [RanchVille](https://linear.app/biccs/project/ranchville-d13837b7f800).

## Folder structure

The repo root is the Godot project root (once `project.godot` exists in BIC-7).

| Path | Role |
|------|------|
| `addons/` | Godot plugins (Meta OpenXR Vendors, gdUnit4, etc.) |
| `art/` | Art direction, asset shortlists, design notes |
| `audio/` | SFX, music, `licenses.md` |
| `resources/` | Data resources (e.g. CropData `.tres`) |
| `scenes/` | Game and UI `.tscn` files |
| `scripts/` | GDScript game logic, managers, components |
| `store/` | Horizon Store copy, icons, screenshots |
| `tasks/` | Agent task notes (`todo.md`, lessons) |
| `tests/` | Headless unit and integration tests |

System design (autoloads, signals, input abstraction) lives in [ARCHITECTURE.md](ARCHITECTURE.md) after BIC-12. Do not contradict this file; link it instead.

## Naming

- **Folders:** lowercase (`scripts/`, `resources/`).
- **GDScript files:** `snake_case.gd` (e.g. `hand_input.gd`, `coin_manager.gd`).
- **Classes:** PascalCase matching domain types (`HandInput`, `CropData`, `CoinManager`).
- **Resources:** `snake_case.tres` (e.g. `wheat_crop.tres`).

## Never touch (unless the issue requires it)

Do not edit these without an explicit issue scope. If you must change them, say so in the PR.

- `export_presets.cfg`
- `project.godot`
- Any `.tscn` file

Game logic (crops, economy, save/load) stays in plain scripts and resources. It must not import OpenXR APIs directly. Use the input abstraction described in ARCHITECTURE.md.

## Headless tests

Preferred runner: **gdUnit4** (installed in BIC-10).

Command (exact):

```bash
godot --headless --xr-mode off --path . -s res://addons/gdUnit4/bin/GdUnitCmdTool.gd --add res://tests --ignoreHeadlessMode
```

Use `--xr-mode off` so headless runs do not wait on OpenXR when `openxr/enabled` is true in `project.godot`.

Local wrapper (same command; set `GODOT_BIN` if `godot` is not on PATH, e.g. macOS `/Applications/Godot.app/Contents/MacOS/Godot`):

```bash
./run_headless_tests.sh
```

Run this before moving an issue to **In Review**. Exit code 0 means pass; non-zero means fail (gdUnit4 uses 100 on test failure).

## Quest 3 export (CLI)

Headless Android export for Meta Quest 3 (presets **Quest 3** and **Quest 3 AAB** in `export_presets.cfg`). Do not commit keystore files or passwords; use env vars (see Godot [Android export environment variables](https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html#environment-variables)).

Local wrapper (set `GODOT_BIN` if `godot` is not on PATH):

```bash
./export_quest.sh --check
./export_quest.sh --debug --format apk
./export_quest.sh --release --format aab
```

Release builds require `GODOT_ANDROID_KEYSTORE_RELEASE_PATH`, `GODOT_ANDROID_KEYSTORE_RELEASE_USER`, and `GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD`. The script exits non-zero on export failure or missing release signing env.

## Working rules (from Linear)

- One issue **In Progress** at a time.
- Branch name = issue git branch name (e.g. `comprasvictortorres/bic-6-…`).
- Small commits. One PR per issue.
- Run the headless test command before **In Review** (when it exists).
- Never move **needs-device-test** issues to **Done**. Stop at **In Review** with exact Quest 3 test steps.
- If an issue is too big or unclear, split it or comment with questions instead of guessing.

## Labels (quick reference)

- **agent-ok:** agents may implement.
- **needs-device-test:** requires Quest 3; agents stop at In Review.
- **human-only:** only the developer completes.
- **design-decision:** open product question; do not pick defaults without approval.
