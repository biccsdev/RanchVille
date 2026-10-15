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

1. Place the farm on the table.
2. Confirm one pad is grass (empty) and one pad is brown (tilled). Two cream seeds sit in front.
3. Pinch a seed. Confirm the yellow outline. Move it onto the **tilled** pad. Release pinch. The pad shows the planted bump. The seed disappears.
4. Pinch the second seed. Drop it on the **same planted** pad. The pad stays planted. The seed stays in the world.
5. Grab that seed. Drop it on the **empty** pad. The pad stays grass. The seed stays in the world.
6. Optional if BIC-17 poke is on the build: hold a seed over a fresh tilled pad and press A/X. The pad plants.
