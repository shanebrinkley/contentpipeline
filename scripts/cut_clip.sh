#!/usr/bin/env bash
# Frame-accurate cut from the master recording.
# Usage: ./cut_clip.sh MASTER START END OUT
#   START/END accept HH:MM:SS.s   e.g. 00:12:30.0
set -euo pipefail
master="$1"; start="$2"; end="$3"; out="$4"
ffmpeg -y -ss "$start" -to "$end" -i "$master" \
  -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p \
  -c:a aac -b:a 256k "$out"
echo "Cut -> $out"
