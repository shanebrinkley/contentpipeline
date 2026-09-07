#!/usr/bin/env bash
# End-to-end: cut -> reframe -> captions -> normalize -> export, for one platform.
# Usage: ./make_clip.sh MASTER START END PLATFORM OUTDIR [reframe_mode]
#   PLATFORM: shorts|reels|tiktok|threads   -> 9:16
#             x|youtube                      -> 16:9 (no reframe)
#   reframe_mode (vertical only): crop (default) | blurpad
# Example: ./make_clip.sh master.mp4 00:12:30 00:12:58 shorts ./out crop
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
master="$1"; start="$2"; end="$3"; platform="$4"; outdir="$5"; mode="${6:-crop}"
mkdir -p "$outdir"; tmp="$(mktemp -d)"
date="$(date +%F)"; base="${date}_clip_${platform}"

"$here/cut_clip.sh" "$master" "$start" "$end" "$tmp/cut.mp4"

case "$platform" in
  shorts|reels|tiktok|threads)
    "$here/reframe.sh" "$tmp/cut.mp4" "$tmp/vert.mp4" "$mode"; stage="$tmp/vert.mp4"; H=1920 ;;
  x|youtube)
    stage="$tmp/cut.mp4"; H=1080 ;;
  *) echo "Unknown platform: $platform"; exit 1 ;;
esac

# captions (uses brand defaults; override FONT/HL via env if you like)
python3 "$here/captions.py" "$stage" --ass "$tmp/cap.ass" --burn "$tmp/cap.mp4" \
  --height "$H" --font "${CP_FONT:-Arial}" --highlight "${CP_HL:-#22f08a}"

"$here/normalize.sh" "$tmp/cap.mp4" "$tmp/norm.mp4"
"$here/export.sh" "$tmp/norm.mp4" "$outdir/${base}.mp4"

rm -rf "$tmp"
echo "DONE -> $outdir/${base}.mp4"
