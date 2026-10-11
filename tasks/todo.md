# BIC-7 — Create Godot 4.x project and install Meta OpenXR Vendors plugin

## Checklist

- [x] Create branch from `origin/main`
- [x] Add minimal `project.godot` (Godot 4.7, Forward Plus default)
- [x] Add default `icon.svg` and import metadata
- [x] Install Godot OpenXR Vendors **5.1.0-stable** under `addons/godotopenxrvendors/`
- [x] Remove `addons/.gitkeep`
- [x] Verify headless editor: GDExtension loads, no plugin errors in log
- [x] Commit, open PR (mention `project.godot`); Linear **In Review** state not configured — left In Progress with PR comment

## Review

- **Branch:** `comprasvictortorres/bic-7-create-godot-4x-project-and-install-meta-openxr-vendors`
- **Plugin:** [5.1.0-stable](https://github.com/GodotVR/godot_openxr_vendors/releases/tag/5.1.0-stable) via `godotopenxrvendorsaddon.zip`
- **Enabled:** v5 ships as GDExtension (`plugin.gdextension`, `android_aar_plugin=true`); no `plugin.cfg`. Editor verifies GDExtensions on startup.
- **Out of scope:** gameplay scenes, `export_presets.cfg`, OpenXR project settings, Android templates (BIC-8), gdUnit4 (BIC-10).
- **Headless note:** Godot 4.7.2 may SIGSEGV on `--editor --quit` after layout load; initialization and GDExtension verification complete before exit.
