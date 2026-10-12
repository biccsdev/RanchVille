#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"

cd "$ROOT"
exec "$GODOT_BIN" --headless --xr-mode off --path . \
	-s res://addons/gdUnit4/bin/GdUnitCmdTool.gd \
	--add res://tests \
	--ignoreHeadlessMode
