# BIC-18 — Table anchor via Scene Manager with manual fallback

## Checklist

- [x] Create branch from `origin/main`
- [x] Add `TableAnchorPicker` and `TableAnchor`
- [x] Wire `xr_empty.tscn`, `table_surface.tscn`, `project.godot` scene_api
- [x] Add `tests/table_anchor_test.gd` and extend `xr_empty_scene_test.gd`
- [x] Update `ARCHITECTURE.md`
- [x] Run `./run_headless_tests.sh`
- [ ] Open PR and move BIC-18 to **In Review** with Quest 3 steps

## Review

- **Branch:** `comprasvictortorres/bic-18-table-anchor-via-scene-manager-with-manual-fallback`
- **Headless:** 55/55 passed (Godot 4.7.2; gdUnit exit 0)
- **Scene / project:** `scenes/xr_empty.tscn`, `scenes/table_surface.tscn`, `project.godot` (`openxr/extensions/meta/scene_api=true`)
