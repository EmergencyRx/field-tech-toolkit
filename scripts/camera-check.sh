#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"

if [[ -z "$TARGET" ]]; then
  echo "Usage: $(basename "$0") <camera-ip-or-hostname>" >&2
  exit 1
fi

echo "[camera-check] Target: $TARGET"

echo
echo "[step] DNS resolution"
if getent hosts "$TARGET" >/dev/null 2>&1; then
  getent hosts "$TARGET"
else
  echo "No DNS entry or direct IP in use."
fi

echo
echo "[step] ICMP reachability"
if ping -c 3 -W 1 "$TARGET" >/dev/null 2>&1; then
  echo "Ping: reachable"
else
  echo "Ping: no reply"
fi

echo
echo "[step] HTTP probe"
if command -v curl >/dev/null 2>&1; then
  if curl -m 3 -sk "http://$TARGET" >/dev/null 2>&1; then
    echo "HTTP: responsive"
  else
    echo "HTTP: no response or non-HTTP device"
  fi
else
  echo "curl not available; skipping HTTP check."
fi

echo
echo "[step] RTSP quick probe (optional)"
if command -v ffprobe >/dev/null 2>&1; then
  echo "If you know the RTSP path, try:"
  echo "  ffprobe -v error -select_streams v:0 -show_entries stream=codec_name -of default=nw=1 \"rtsp://USER:PASS@$TARGET/PATH\""
else
  echo "ffprobe not installed; RTSP check documented but not executed."
fi

echo
echo "[result] Use this output with site templates to document install or incident."
