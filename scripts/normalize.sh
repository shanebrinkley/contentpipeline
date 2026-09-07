#!/usr/bin/env bash
# Normalize loudness to -14 LUFS (single pass).
# Usage: ./normalize.sh IN OUT
set -euo pipefail
in="$1"; out="$2"
ffmpeg -y -i "$in" -af loudnorm=I=-14:TP=-1.5:LRA=11 -c:v copy "$out"
echo "Normalized -> $out"
