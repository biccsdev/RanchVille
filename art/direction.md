# Art direction — RanchVille tabletop farm

Linear: [BIC-13](https://linear.app/biccs/issue/BIC-13/pick-art-style-and-color-palette)

## Style sentence

Minimal low-poly farm tokens: few faces, at most five mask colors per asset, and one-shape silhouettes, readable at table scale in mixed-reality passthrough.

## Form rules

- Build from boxes, wedges, cylinders, and cones.
- Block out in 3D early. Check the seated three-quarter view, not only top-down.
- Keep a crop to 2–4 meshes (stem plus fruit or leaf).
- Prefer Kenney / Islanders / Townscaper token scale over sculpted foliage.

## Recolor pipeline (direction only)

Inspired by [Dorfromantik’s mask workflow](https://80.lv/articles/how-dorfromantik-expands-its-cozy-world-through-minimalist-design). Adapt to Godot when the project exists. **Do not implement shaders on BIC-13.**

1. Paint up to **five vertex-color masks** per mesh: red, green, blue, yellow, purple.
2. Godot `COLOR` gives RGBA (four slots). Use those four for MVP. Add a fifth slot later only if a crop needs it.
3. Optional grayscale albedo may tint value. Do not bake final hue into a texture.
4. A future `PaletteSet` resource maps each mask to a hex. MVP ships one set: **Hearth Day**.
5. Later sets (Autumn, Night, Snow, extra location) swap the same masks. Do not duplicate meshes.
6. One asset must not use more than five mask colors. More color in a small token creates noise.

### Mask-to-role map (for later shader work)

| Mask   | Role                         |
|--------|------------------------------|
| Red    | Wood / structure             |
| Green  | Grass / leaf                 |
| Blue   | Water / cool accent          |
| Yellow | Harvest / cream highlight    |
| Purple | Soil / shade                 |

Tomato (`#C24B3A`) is a named accent in the palette. Use it on fruit faces via Yellow or a dedicated slot when a crop needs a ripe cue.

## Hearth Day palette (8 hex colors)

| Name    | Hex       | Use                                      |
|---------|-----------|------------------------------------------|
| Soil    | `#5C3D2E` | Tilled earth, dark wood                  |
| Grass   | `#6F9148` | Leaves, lawn (mid olive, not neon)       |
| Wood    | `#C48A4A` | Fences, can, sell bin                    |
| Cream   | `#F3E4C4` | Board, seeds, UI fill                    |
| Harvest | `#E8B84A` | Wheat, coins, ready-crop cue               |
| Tomato  | `#C24B3A` | Ripe crop, shop accent                   |
| Water   | `#4E8794` | Watering can, wet soil                   |
| Shade   | `#2A221C` | Contact shadow and text (not `#000000`)  |

## Placeholder art (until packs land)

- Use flat `StandardMaterial3D` albedo from this table for colored meshes.
- When mask shaders exist, placeholders should still follow the mask roles above.

## Rejected looks

- Unique painted color textures per asset
- One material duplicate per season
- Detailed Sketchfab-style farm dioramas
- Sculpted leaves, baked AO as primary read
- Photoreal PBR
- Pastel kawaii, high-saturation plastic toys
- Thin black outlines that read as holes in passthrough

## References (view only — do not import)

- [Townscaper](https://www.townscapergame.com/) — block tokens, few colors, toy scale
- [ISLANDERS on Steam](https://store.steampowered.com/app/1046030/ISLANDERS/) — minimal pieces, flat color, simple silhouettes
- [Dorfromantik readability (80.lv)](https://80.lv/articles/how-dorfromantik-expands-its-cozy-world-through-minimalist-design) — mask colors, biome sets, cut noise

## Notes for follow-up issues

- **BIC-14:** Prefer recolorable low-poly meshes, not baked-hue packs.
- **BIC-48:** Warm table lighting and optional day/night tint; passthrough stays visible.
- **BIC-55 / BIC-65:** Use approved palette sets; seasonal themes swap `PaletteSet`, not meshes.

## Out of scope on this document

- Engine, lighting, and shader implementation (BIC-7, BIC-12, BIC-48)
- Buying or importing asset packs (BIC-14)
