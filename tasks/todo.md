# BIC-22 — Seed item and planting into a tile

## Checklist

- [x] Create branch from `origin/main`
- [x] Add SeedItem, SoilTileView, scenes
- [x] Add PlantingSystem and GrabSystem hooks
- [x] Wire `xr_empty.tscn`
- [x] Headless tests and ARCHITECTURE.md
- [x] Run `./run_headless_tests.sh`
- [ ] Open PR and move BIC-22 to **In Review** with Quest 3 steps

## Review

- **Branch:** `comprasvictortorres/bic-22-seed-item-and-planting-into-a-tile`
- **Headless:** 109/109 passed (Godot 4.7.2; gdUnit exit 0)
- **Scene changes:** `scenes/seed_item.tscn`, `scenes/soil_tile.tscn`, `scenes/xr_empty.tscn`
- **Linear:** (PR link after open)

### Quest 3 test steps

This issue does **not** till. The grass pad stays empty on purpose.

1. Place the farm on the table.
2. Layout: two cream seeds near the gray marker. One **green** pad (empty). One **brown** pad (pre-tilled, no bump yet).
3. Pinch a seed. Move it onto the **brown** pad. Release. The seed vanishes. A small cream bump stays on the brown pad.
4. Pinch the second seed. Drop it on that **same brown pad**. The bump stays. The seed stays in your hand world (not consumed).
5. Drop that seed on the **green** pad. The pad stays green. The seed stays. You cannot till in this build.
6. Optional if BIC-17 poke is on the build: hold a seed over a fresh brown pad and press A/X. The pad plants.
