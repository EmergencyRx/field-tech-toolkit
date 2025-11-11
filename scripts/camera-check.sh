#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: $(basename "$0") <camera-ip-or-hostname>" >&2
  exit 1
fi

echo "[camera-check] Checking connectivity to $TARGET"
ping -c 3 "$TARGET" || echo "Ping failed"
echo "Extend this script with RTSP/HTTP checks as needed."
