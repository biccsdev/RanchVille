#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GODOT_BIN="${GODOT_BIN:-godot}"

PRESET_APK="Quest 3"
PRESET_AAB="Quest 3 AAB"

MODE="debug"
FORMAT="apk"
OUTPUT=""
CHECK_ONLY=false

usage() {
	cat <<'EOF'
Usage: export_quest.sh [options]

Build RanchVille for Meta Quest 3 without opening the Godot editor.

Options:
  --debug          Export debug build (default)
  --release        Export release build (requires release keystore env vars)
  --format apk     Use Quest 3 APK preset (default)
  --format aab     Use Quest 3 AAB preset
  --output PATH    Output file (default: builds/ranchville.apk or .aab)
  --check          Validate options only; do not export
  -h, --help       Show this help

Release signing (env vars override export preset keystore fields):
  GODOT_ANDROID_KEYSTORE_RELEASE_PATH
  GODOT_ANDROID_KEYSTORE_RELEASE_USER
  GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD

Debug signing uses GODOT_ANDROID_KEYSTORE_DEBUG_* when set.
EOF
}

die() {
	echo "export_quest.sh: $*" >&2
	exit 1
}

require_release_keystore_env() {
	[[ -n "${GODOT_ANDROID_KEYSTORE_RELEASE_PATH:-}" ]] || die "missing GODOT_ANDROID_KEYSTORE_RELEASE_PATH"
	[[ -n "${GODOT_ANDROID_KEYSTORE_RELEASE_USER:-}" ]] || die "missing GODOT_ANDROID_KEYSTORE_RELEASE_USER"
	[[ -n "${GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD:-}" ]] || die "missing GODOT_ANDROID_KEYSTORE_RELEASE_PASSWORD"
}

resolve_preset_and_default_output() {
	case "$FORMAT" in
	apk)
		PRESET="$PRESET_APK"
		DEFAULT_OUTPUT="builds/ranchville.apk"
		;;
	aab)
		PRESET="$PRESET_AAB"
		DEFAULT_OUTPUT="builds/ranchville.aab"
		;;
	*)
		die "unknown format: $FORMAT (use apk or aab)"
		;;
	esac
}

while [[ $# -gt 0 ]]; do
	case "$1" in
	--debug)
		MODE="debug"
		shift
		;;
	--release)
		MODE="release"
		shift
		;;
	--format)
		[[ $# -ge 2 ]] || die "--format requires apk or aab"
		FORMAT="$2"
		shift 2
		;;
	--output)
		[[ $# -ge 2 ]] || die "--output requires a path"
		OUTPUT="$2"
		shift 2
		;;
	--check)
		CHECK_ONLY=true
		shift
		;;
	-h | --help)
		usage
		exit 0
		;;
	*)
		die "unknown argument: $1"
		;;
	esac
done

resolve_preset_and_default_output

if [[ "$MODE" == "release" ]]; then
	require_release_keystore_env
fi

if [[ "$CHECK_ONLY" == true ]]; then
	echo "export_quest.sh: check ok (preset=$PRESET mode=$MODE format=$FORMAT)"
	exit 0
fi

OUTPUT="${OUTPUT:-$DEFAULT_OUTPUT}"
if [[ "$OUTPUT" != /* ]]; then
	OUTPUT="$ROOT/$OUTPUT"
fi

OUT_DIR="$(dirname "$OUTPUT")"
mkdir -p "$OUT_DIR"

cd "$ROOT"

if [[ ! -d android/build ]]; then
	echo "export_quest.sh: installing Android build template..."
	"$GODOT_BIN" --headless --xr-mode off --path . --install-android-build-template --quit
fi

# Prevent Godot from importing Gradle res assets (creates invalid *.import in res/).
if [[ -d android/build ]] && [[ ! -f android/build/.gdignore ]]; then
	touch android/build/.gdignore
fi

EXPORT_FLAG="--export-debug"
if [[ "$MODE" == "release" ]]; then
	EXPORT_FLAG="--export-release"
fi

echo "export_quest.sh: exporting preset \"$PRESET\" to \"$OUTPUT\"..."
set +e
"$GODOT_BIN" --headless --xr-mode off --path . "$EXPORT_FLAG" "$PRESET" "$OUTPUT"
GODOT_EXIT=$?
set -e

if [[ "$GODOT_EXIT" -ne 0 ]]; then
	die "Godot export failed with exit code $GODOT_EXIT"
fi

if [[ ! -f "$OUTPUT" ]]; then
	die "export finished but output file is missing: $OUTPUT"
fi

if [[ ! -s "$OUTPUT" ]]; then
	die "export finished but output file is empty: $OUTPUT"
fi

echo "export_quest.sh: success ($OUTPUT)"
