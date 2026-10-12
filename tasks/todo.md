# BIC-9 — Empty XR scene builds and runs on Quest 3

## Checklist

- [x] Create branch from `origin/main`
- [x] Add `scenes/xr_empty.tscn` and `scripts/xr_bootstrap.gd`
- [x] Set `run/main_scene` in `project.godot`
- [x] Add `tests/xr_empty_scene_test.gd`
- [x] Headless tests: `./run_headless_tests.sh` → exit **0**
- [x] CLI export: `./export_quest.sh --debug --format apk`
- [ ] Open PR (mentions `.tscn` and `project.godot`)
- [ ] Move [BIC-9](https://linear.app/biccs/issue/BIC-9) to **In Review** with headset test steps

## Review

- **Branch:** `comprasvictortorres/bic-9-empty-xr-scene-builds-and-runs-on-quest-3`
- **Godot (local):** `/Applications/Godot.app/Contents/MacOS/Godot` 4.7.2.stable
- **Headless tests:** 8 cases, exit **0**
- **Export:** `builds/ranchville.apk` (~87 MB). First run needs Android build template under `android/build` (gitignored) and `android/.build_version`.
- **Also changed:** `export_presets.cfg` (`[preset.1.options]` typo), `export_quest.sh` (`--xr-mode off`, `.gdignore` guard), `project.godot` ETC2/ASTC for Android.
