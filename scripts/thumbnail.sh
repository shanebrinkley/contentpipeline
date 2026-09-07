#!/usr/bin/env bash
# Grab a frame and size it to a 1280x720 thumbnail.
# Usage: ./thumbnail.sh MASTER TIMESTAMP OUT   e.g. ./thumbnail.sh master.mp4 00:00:05 thumb.png
set -euo pipefail
master="$1"; ts="$2"; out="$3"
ffmpeg -y -ss "$ts" -i "$master" -frames:v 1 -vf "scale=1280:720" -q:v 2 "$out"
echo "Thumbnail -> $out"
