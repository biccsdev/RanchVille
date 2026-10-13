#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"
DEBUG_PORT="${DEBUG_PORT:-6007}"

die() {
	echo "run_quest_live.sh: $*" >&2
	exit 1
}

if ! command -v adb >/dev/null 2>&1; then
	die "adb not found. Install Android platform-tools."
fi

DEVICE="$(adb devices | awk 'NR>1 && $2=="device" {print $1; exit}')"
if [[ -z "$DEVICE" ]]; then
	die "no Quest/Android device. Enable USB debugging and plug in the headset."
fi

echo "run_quest_live.sh: device $DEVICE"
adb -s "$DEVICE" reverse tcp:"$DEBUG_PORT" tcp:"$DEBUG_PORT" >/dev/null
echo "run_quest_live.sh: adb reverse tcp:$DEBUG_PORT ready"

if [[ ! -x "$GODOT_BIN" ]] && ! command -v "$GODOT_BIN" >/dev/null 2>&1; then
	if [[ -x /Applications/Godot.app/Contents/MacOS/Godot ]]; then
		GODOT_BIN=/Applications/Godot.app/Contents/MacOS/Godot
	else
		die "Godot not found. Set GODOT_BIN."
	fi
fi

echo "run_quest_live.sh: open the editor, then press the Android deploy button."
echo "run_quest_live.sh: keep the editor open. Save scripts to update the headset."
echo "run_quest_live.sh: Debug menu must enable Remote Debug, Small Deploy, Sync Scripts."
exec "$GODOT_BIN" --editor --path "$ROOT"
