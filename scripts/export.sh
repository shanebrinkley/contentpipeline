#!/usr/bin/env bash
# Canonical web-ready export (H.264 High, yuv420p, faststart).
# Usage: ./export.sh IN OUT
set -euo pipefail
in="$1"; out="$2"
ffmpeg -y -i "$in" \
  -c:v libx264 -profile:v high -pix_fmt yuv420p -crf 18 -preset medium \
  -c:a aac -b:a 256k -ar 48000 -movflags +faststart "$out"
echo "Exported -> $out"
