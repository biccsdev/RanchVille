# BIC-17 — Controller fallback mapped to HandInput

## Checklist

- [x] Create branch from `origin/main`
- [x] Add ControllerMapping and tests (no OpenXR)
- [x] Wire HandInputXr poke (ax_button) and reuse mapper for pinch
- [x] Update ARCHITECTURE.md
- [x] Run `./run_headless_tests.sh`
- [x] Open PR and move BIC-17 to **In Review** with Quest 3 steps

## Review

- **Branch:** `comprasvictortorres/bic-17-controller-fallback-mapped-to-handinput`
- **PR:** https://github.com/biccsdev/RanchVille/pull/16
- **Headless:** 96/96 passed (Godot 4.7.2; gdUnit exit 0)
- **Linear:** In Review (needs-device-test)
- **Scene / project:** no `.tscn` changes; `project.godot` unchanged
