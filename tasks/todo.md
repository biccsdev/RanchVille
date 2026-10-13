# BIC-19 — Grabbable component and nearest-in-range grab

## Checklist

- [x] Create branch from `origin/main`
- [x] Add GrabSelector, Grabbable, GrabSystem (no OpenXR)
- [x] Add active_hand, FakeHandInput args, HandInputXr trigger adapter
- [x] Add debug_grabbable.tscn and wire xr_empty.tscn
- [x] Add/extend tests and ARCHITECTURE.md
- [x] Run `./run_headless_tests.sh`
- [x] Open PR and move BIC-19 to **In Review** with Quest 3 steps

## Review

- **Branch:** `comprasvictortorres/bic-19-grabbable-component-and-nearest-in-range-grab`
- **PR:** https://github.com/biccsdev/RanchVille/pull/15
- **Headless:** 86/86 passed (Godot 4.7.2; gdUnit exit 0)
- **Linear:** In Review (Quest 3 steps in issue comment)
- **Scene / project:** `scenes/xr_empty.tscn`, `scenes/debug_grabbable.tscn`
