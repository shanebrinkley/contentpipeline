#!/usr/bin/env bash
# One-time setup: checks for ffmpeg and installs Python deps (faster-whisper).
set -euo pipefail
echo "Checking ffmpeg..."
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "  ffmpeg NOT found. Install it:"
  echo "    macOS:   brew install ffmpeg"
  echo "    Ubuntu:  sudo apt install ffmpeg"
  echo "    Windows: winget install Gyan.FFmpeg   (or scoop install ffmpeg)"
  exit 1
fi
echo "  ffmpeg OK: $(ffmpeg -version | head -1)"
echo "Installing Python deps (faster-whisper)..."
pip install -r "$(dirname "$0")/requirements.txt" || pip install -r "$(dirname "$0")/requirements.txt" --break-system-packages
echo "Setup complete."
