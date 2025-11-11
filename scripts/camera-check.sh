#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: $(basename "$0") <camera-ip-or-hostname>" >&2
  exit 1
fi

echo "[camera-check] Checking basic connectivity to $TARGET"
ping -c 3 "$TARGET" >/dev/null 2>&1 && echo "Ping: ok" || echo "Ping: failed"

echo "[camera-check] Resolving hostname (if applicable)"
getent hosts "$TARGET" || echo "No DNS entry found or using raw IP."

echo "[camera-check] Checking HTTP/HTTPS (if curl available)"
if command -v curl >/dev/null 2>&1; then
  curl -m 3 -sk "http://$TARGET" >/dev/null && echo "HTTP: responsive" || echo "HTTP: no response"
  curl -m 3 -sk "https://$TARGET" >/dev/null && echo "HTTPS: responsive (if supported)" || echo "HTTPS: no response or not enabled"
fi

echo
echo "Extend this script with RTSP, ONVIF, and vendor-specific checks as needed."
