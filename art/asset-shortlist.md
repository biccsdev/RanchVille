# Asset shortlist — low-poly farm packs

Linear: [BIC-14](https://linear.app/biccs/issue/BIC-14/shortlist-low-poly-asset-packs-and-check-licenses)

Style reference: [direction.md](direction.md) (BIC-13). Do not import packs from this ticket.

**License check date:** 2026-10-11 (store pages and publisher support text).

## Horizon Store bar

A pack gets **Commercial / Quest / Horizon Store = yes** when:

- Commercial use is allowed.
- Meshes may ship inside a compiled Quest app (not as raw standalone files).
- The grant does not ban selling the game or VR distribution.

**Style fit** is separate. A pack can be **yes** for the store but **poor** for token art.

Kenney support: [kenney.nl/support](https://kenney.nl/support) — assets on asset pages are CC0, including commercial projects.

## Candidate packs

| Pack | Store link | License | Cost (2026-10-11) | Commercial / Quest / Horizon Store | Style fit | Recolor fit | Crops | Tools | Decorations |
|------|------------|---------|-------------------|-------------------------------------|-----------|-------------|-------|-------|-------------|
| Quaternius Ultimate Crops Pack | [quaternius.com](https://quaternius.com/packs/ultimatecrops.html), [OpenGameArt](https://opengameart.org/content/lowpoly-crops-pack) | CC0 | $0 | **yes** | Good — low poly, growth stages | Textured meshes; retexture or replace materials for Hearth Day | **Strong** — 100+ crops, 5 stages each | — | — |
| Kenney Survival Kit | [kenney.nl](https://www.kenney.nl/assets/survival-kit), [itch.io](https://kenney-assets.itch.io/survival-kit) | CC0 1.0 | $0 (name your price) | **yes** | Good — token scale, simple silhouettes | Shared `colormap.png`; remap to palette | — | **Partial** — shovel, hoe, bucket, barrel, fence; **no watering can** in kit | Crates, barrels, camp props |
| Kenney Nature Kit | [kenney.nl](https://www.kenney.nl/assets/nature-kit), [OpenGameArt](https://opengameart.org/content/nature-kit) | CC0 | $0 | **yes** | Good — simple nature tokens | Shared colormap; remap | — | — | **Strong** — rocks, plants, camp items (pick small pieces only) |
| Kenney Food Kit | [kenney.nl](https://kenney.nl/assets/food-kit), [itch.io](https://kenney-assets.itch.io/food-kit) | CC0 1.0 | $0 (name your price) | **yes** | Good — readable food tokens | Shared colormap; remap | Harvest props only (not growth stages) | — | Shop / sell-bin props |
| Grimnir Free Big Low Poly Farm | [itch.io](https://grimnir-random.itch.io/free-big-low-poly-asset-pack) | Custom: free personal + commercial; no standalone resale | $0 | **yes** | Moderate — cozy farm; larger than table tokens | Shared texture atlas; baked hues | **Strong** — 8 crops × 3 stages | **Strong** — watering can, shovel, wheelbarrow | Scarecrows, fences, flowers |
| KayKit Restaurant Bits | [itch.io](https://kaylousberg.itch.io/restaurant-bits) | CC0 1.0 | $0 | **yes** | Moderate — food props, not field crops | Gradient atlas 1024²; hard to match mask pipeline | Produce tokens | — | Kitchen / food décor |
| KayKit Forest Nature Pack | [itch.io](https://kaylousberg.itch.io/kaykit-forest) | CC0 1.0 | $0 free tier; Extra ~$9.99 | **yes** | **Poor** for MVP — trees/foliage; direction rejects sculpted leaves | Gradient atlas | — | — | Trees, rocks (use sparingly on table) |
| Quaternius Farm Buildings Pack | [quaternius.com](https://quaternius.com/packs/farmbuildings.html) | CC0 (pack page: personal + commercial) | $0 | **yes** | **Poor** for table — barn-scale buildings | Textured | — | — | Large structures |
| PolyForge Low Poly Farming Pack | [itch.io](https://polyforge21.itch.io/low-poly-farming-pack) | Custom: commercial games OK; no asset resale | Essentials paid tier | **yes** | Moderate — warm palette; AI-assisted pipeline noted on page | Single shared material palette | Yes | Yes | Yes |
| Akochan Low Poly Farm Crops Pack (50) | [itch.io](https://akochan-lu.itch.io/low-poly-farm-crops-pack-50) | Royalty-free commercial; no asset resale | from $2.99 | **yes** | Moderate — stylized fields | Shared atlas | **Strong** | — | Barn / orchard props |
| Synty POLYGON Farm Pack | [syntystore.com](https://syntystore.com/products/polygon-farm-pack) | Standard Unity Asset Store EULA; Restricted Single Entity | $49.99 USD (listed 2026-10-11) | **yes** if embedded in shipped game; do not redistribute raw files | **Poor** — high detail vs Townscaper tokens | Synty materials; not mask workflow | Yes | Yes (incl. watering can in changelog) | Yes | **Do not buy on BIC-14.** |
| Kenney Isometric Miniature Farm | [itch.io](https://kenney-assets.itch.io/isometric-miniature-farm) | CC0 1.0 | $0 | **yes** | **N/A** — 2D isometric tiles, not 3D table tokens | Tile art | Tiles only | — | — |
| Tolee Mi FARMING: CROPS 16×16 | [itch.io](https://tolee-mi.itch.io/farming-crops) | Personal + commercial game; credit requested; no asset resale | Paid (see store) | **yes** for 2D game ship | **N/A** — 2D pixel, not MR table 3D | Pixel palette | 2D only | 2D icons | 2D tiles |

## Packs marked **no** for store ship

These fail the license bar for a paid Horizon Store title (or the author forbids commercial ship).

| Pack | Store link | Why **no** |
|------|------------|------------|
| Lyud — Farming Sim Lowpoly Pixel | [Sketchfab](https://sketchfab.com/3d-models/farming-sim-lowpoly-pixel-6edb55ec1cad4d588a1a27dc996527e1) | Author text: forbids sell and claiming the art. Not a safe commercial grant. |
| Typical Sketchfab **CC-BY-NC** farm scenes | (varies) | Non-commercial license blocks paid store ship. Mark **no** unless the page shows CC0 or commercial OK. |

## Approved for MVP (2026-10-12)

Use this combo for Horizon Store MVP (plant, water, harvest, sell). **Do not download into the repo until an import ticket runs.**

| Need | Pack | Notes |
|------|------|-------|
| Crops + 3–5 growth stages | **Quaternius Ultimate Crops Pack** | Scale down to table tokens; retexture for Hearth Day when art pipeline lands. |
| Tools, fence, sell-bin props | **Kenney Survival Kit** | Shovel, hoe, bucket, barrel, fence, crate. |
| Table decorations | **Kenney Nature Kit** | Small rocks, simple plants, camp props — avoid large trees on the board. |

Optional for MVP shop/sell read: **Kenney Food Kit** (whole produce tokens at the bin, not growth on the tile).

## MVP vs restaurant scale (Later)

MVP and a future **restaurant** mode need **two art lanes**, not one mesh set.

| Lane | Job | These three packs |
|------|-----|-------------------|
| **Farm** | Stages on soil, harvest as whole crop | Quaternius + Kenney props — **good for MVP** |
| **Kitchen** | Ingredients and dishes (raw, chopped, cooked, plated) | **Not covered** by field crop meshes |

Quaternius stalks and heads are **plants in the ground**, not prep states. You cannot reuse them as chopped tomato, dough, or a plated meal without breaking readability and scale.

For restaurant Later, plan a **separate ingredient catalog** (data + meshes), not “same mesh, different shader.” Candidates already on this shortlist:

- [KayKit Restaurant Bits](https://kaylousberg.itch.io/restaurant-bits) — ingredients by state (CC0).
- [Kenney Food Kit](https://kenney.nl/assets/food-kit) — whole foods and kitchen props (CC0).

**Design hook (when restaurant ships):** map each `CropData` id to **harvest yield** (sell bin) and optionally to **kitchen ingredient ids** that point at Food/KayKit meshes — do not point dish recipes at Quaternius growth-stage paths.

Restaurant mode stays on the [BIC-5](https://linear.app/biccs/issue/BIC-5) Later list until MVP ships; no purchase or import required now.

### Gaps and fallbacks

1. **Watering can ([BIC-23](https://linear.app/biccs/issue/BIC-23)):** Kenney Survival Kit has no watering-can mesh (verified via public Survival Kit inventories: bucket, shovel, hoe, barrel — no can). **Fallback:** Grimnir pack watering can (commercial OK, $0) or a primitive placeholder until import.
2. **Recolor:** Kenney kits use a shared **colormap**, not vertex masks from direction.md. MVP can remap the colormap to Hearth Day hex values before mask shaders exist.
3. **Quaternius scale:** Crop meshes may read large at seated table scale; normalize in a later import issue.
4. **Consistency:** Quaternius + Kenney share low-poly language but different palettes until recolor passes.

## Out of scope (BIC-14)

- Importing FBX/GLB into Godot.
- Purchasing paid packs (Synty, Akochan, KayKit Extra, PolyForge paid tiers).
- Implementing mask shaders or `PaletteSet` resources.

## Follow-up issues

- **Import ticket (next, after this PR lands):** download the three approved packs off-repo first. Import only the meshes MVP needs. Do not commit unused farm buildings or large trees.
- **BIC-23 watering can:** primitive placeholder or Grimnir can. Do not buy a pack for the can.
- **CropData (BIC-29 / BIC-32):** farm fields only — growth, prices, farm mesh paths. No recipe or kitchen ids.
- **Restaurant Later:** new kitchen catalog + KayKit Restaurant Bits / Kenney Food Kit. Do not point dishes at Quaternius growth meshes.
- Store listing may credit Kenney / Quaternius. CC0 does not require credit.
