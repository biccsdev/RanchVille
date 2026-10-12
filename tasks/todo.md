# BIC-11 — Enable passthrough in the empty scene

## Checklist

- [x] Create branch from `origin/main`
- [x] Transparent environment in `scenes/xr_empty.tscn` (no sky, no floor)
- [x] Passthrough bootstrap in `scripts/xr_bootstrap.gd`
- [x] `openxr/environment_blend_mode=2` in `project.godot`
- [x] Extend `tests/xr_empty_scene_test.gd`
- [x] Headless tests: `./run_headless_tests.sh` → gdUnit exit **0** (11 cases)
- [x] CLI export: `./export_quest.sh --debug --format apk` → `builds/ranchville.apk`
- [x] Open PR (mentions `.tscn` and `project.godot`)
- [x] Move [BIC-11](https://linear.app/biccs/issue/BIC-11) to **In Review** with headset test steps

## Review

- **Branch:** `comprasvictortorres/bic-11-enable-passthrough-in-the-empty-scene-and-verify-on-headset`
- **PR:** https://github.com/biccsdev/RanchVille/pull/8
- **Headless tests:** 11 cases, gdUnit exit **0**
- **Export:** `builds/ranchville.apk` (~87 MB). Export script may report non-zero if Godot segfaults on shutdown (OpenXR vendors on macOS).
