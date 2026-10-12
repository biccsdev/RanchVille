# BIC-10 — Set up headless test framework with one example test

## Checklist

- [x] Create branch from `origin/main`
- [x] Vendor gdUnit4 **6.2.2** under `addons/gdUnit4/`
- [x] Enable plugin in `project.godot` (`[editor_plugins]`)
- [x] Add `tests/example_test.gd` (one passing assert)
- [x] Add `run_headless_tests.sh` (matches AGENTS.md command)
- [x] Update AGENTS.md headless section (`--add res://tests`)
- [x] Ignore `reports/` and `GdUnitRunner.cfg` in `.gitignore`
- [x] Add `.github/workflows/headless-tests.yml`
- [x] Verify pass: `./run_headless_tests.sh` → exit **0**
- [x] Verify fail: broken assert → exit **100**
- [x] Add Biccs **issue** status **In Review** (Started)
- [x] Move [BIC-10](https://linear.app/biccs/issue/BIC-10) to **In Review**
- [x] Linear comment on BIC-10 with command and exit-code proof

## Review

- **Branch:** `comprasvictortorres/bic-10-set-up-headless-test-framework-with-one-example-test`
- **Godot (local):** `/Applications/Godot.app/Contents/MacOS/Godot` 4.7.2.stable
- **Command:**

  ```bash
  GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot ./run_headless_tests.sh
  ```

- **Exit codes:** 0 pass, 100 test failure (verified locally)
- **`project.godot`:** edited for BIC-10 scope (gdUnit4 plugin enabled)
