# BIC-8 — Configure Quest 3 Android export preset and CLI export script

## Checklist

- [x] Create branch from `origin/main`
- [x] Add `export_presets.cfg` (Quest 3 APK + Quest 3 AAB)
- [x] Update `project.godot` (OpenXR, hand tracking, Meta passthrough)
- [x] Add `export_quest.sh` CLI wrapper
- [x] Update AGENTS.md, README.md, `.gitignore`
- [x] Add gdUnit4 export preset and script tests
- [x] Headless tests: `--xr-mode off` in runner (OpenXR enabled in project)
- [x] Verify pass: `./run_headless_tests.sh` → exit **0**
- [x] Open PR (mentions `export_presets.cfg` and `project.godot`)
- [x] Move [BIC-8](https://linear.app/biccs/issue/BIC-8) to **In Review**

## Review

- **Branch:** `comprasvictortorres/bic-8-configure-quest-3-android-export-preset-and-cli-export`
- **Godot (local):** `/Applications/Godot.app/Contents/MacOS/Godot` 4.7.2.stable
- **Export check:**

  ```bash
  ./export_quest.sh --check
  ```

- **Headless tests:**

  ```bash
  GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot ./run_headless_tests.sh
  ```

- **Exit code:** 0 (5 test cases)
- **Preset highlights:** Meta plugin, Quest 3 only, hand tracking optional, passthrough required, `com.biccs.ranchville`
- **PR:** https://github.com/biccsdev/RanchVille/pull/6
