#!/usr/bin/env bash
# Reframe a 16:9 clip to vertical 9:16 (1080x1920).
# Usage: ./reframe.sh IN OUT [mode]
#   mode = crop     (center-crop; best for talking-head/facecam)   [default]
#        = blurpad  (fit whole frame over blurred bg; best for screen/demo)
set -euo pipefail
in="$1"; out="$2"; mode="${3:-crop}"
if [ "$mode" = "blurpad" ]; then
  ffmpeg -y -i "$in" -filter_complex \
    "[0:v]scale=1080:1920:force_original_aspect_ratio=increase,crop=1080:1920,boxblur=20:5[bg];[0:v]scale=1080:-1[fg];[bg][fg]overlay=(W-w)/2:(H-h)/2" \
    -c:a copy "$out"
else
  ffmpeg -y -i "$in" -vf "crop=ih*9/16:ih,scale=1080:1920:flags=lanczos,setsar=1" -c:a copy "$out"
fi
echo "Reframe ($mode) -> $out"
