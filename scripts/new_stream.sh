#!/usr/bin/env bash
# Scaffold a dated stream folder from the template, parsed by platform.
# Usage: ./new_stream.sh "<topic>" [streams_dir]
#   e.g. ./new_stream.sh "building a new feature"
set -euo pipefail
topic="${1:-untitled}"
streams_dir="${2:-./Streams}"
here="$(cd "$(dirname "$0")/.." && pwd)"
tmpl="$here/templates/stream-folder"
date="$(date +%F)"
dest="$streams_dir/$date - $topic"
mkdir -p "$streams_dir"
cp -r "$tmpl" "$dest"
echo "Created: $dest"
echo "Next: drop the full transcript in the stream folder, then run clip selection."
