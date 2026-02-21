#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Remove macOS Gatekeeper quarantine attribute for a .app bundle.

Usage:
  unquarantine-app.sh "/Applications/Some App.app"

Tips:
  - You can drag the .app into Terminal to paste its path.
  - This script will ask for sudo (admin password) if needed.
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

APP_PATH="${1:-}"
if [[ -z "$APP_PATH" ]]; then
  echo "Please input the .app path (you can drag & drop the app into Terminal):"
  read -r APP_PATH
fi

# Trim possible surrounding quotes from drag&drop/paste.
APP_PATH="${APP_PATH%\"}"
APP_PATH="${APP_PATH#\"}"
APP_PATH="${APP_PATH%\'}"
APP_PATH="${APP_PATH#\'}"

if [[ ! -e "$APP_PATH" ]]; then
  echo "Not found: $APP_PATH" >&2
  exit 1
fi

if [[ ! -d "$APP_PATH" ]]; then
  echo "Not a directory (expected a .app bundle): $APP_PATH" >&2
  exit 1
fi

if [[ "$APP_PATH" != *.app ]]; then
  echo "Warning: path does not end with .app, continue anyway: $APP_PATH" >&2
fi

if [[ "${EUID:-$(id -u)}" -ne 0 ]]; then
  echo "Requesting admin permission (sudo) to modify extended attributes..."
  exec sudo -- "$0" "$APP_PATH"
fi

echo "Removing quarantine attribute..."
xattr -dr com.apple.quarantine "$APP_PATH" || true

echo "Done."
echo "You can try opening it again:"
echo "  open \"$APP_PATH\""

