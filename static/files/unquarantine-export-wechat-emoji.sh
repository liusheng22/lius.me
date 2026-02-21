#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Remove macOS Gatekeeper quarantine attribute for:
  /Applications/导出微信表情包.app

Usage:
  unquarantine-export-wechat-emoji.sh

Optional:
  unquarantine-export-wechat-emoji.sh "/path/to/导出微信表情包.app"
EOF
}

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  usage
  exit 0
fi

APP_PATH="${1:-/Applications/导出微信表情包.app}"

if [[ ! -e "$APP_PATH" ]]; then
  echo "Not found: $APP_PATH" >&2
  echo "Tip: If your app is in a different location, pass the full path as the first argument." >&2
  exit 1
fi

if [[ ! -d "$APP_PATH" ]]; then
  echo "Not a directory (expected a .app bundle): $APP_PATH" >&2
  exit 1
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

