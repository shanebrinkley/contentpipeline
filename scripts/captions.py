#!/usr/bin/env python3
"""
captions.py — auto-generate word-highlight captions from a clip's audio and
(optionally) burn them into the video.

Pipeline:
  1. Transcribe with faster-whisper (word-level timestamps).
  2. Write a styled .ass subtitle file with karaoke-style word highlighting.
  3. Optionally burn the .ass into the video with ffmpeg.

Usage:
  python captions.py IN.mp4 --ass OUT.ass                 # just make captions
  python captions.py IN.mp4 --ass OUT.ass --burn OUT.mp4  # make + burn in
Options:
  --model    base|small|medium|large-v3   (default: base)
  --font     caption font name            (default: Arial)  e.g. "Roboto"
  --highlight  hex color for active word   (default: #22f08a)
  --base       hex color for base text     (default: #eaf3ff)
  --chunk    words shown at once           (default: 3)
  --height   frame height (for sizing)     (default: 1920)
"""
import argparse, subprocess, sys, os

def hex_to_ass(hex_color: str) -> str:
    """#RRGGBB -> ASS &HBBGGRR& (ASS is BGR, no alpha here)."""
    h = hex_color.lstrip("#")
    r, g, b = h[0:2], h[2:4], h[4:6]
    return f"&H00{b}{g}{r}".upper()

def fmt_time(t: float) -> str:
    """seconds -> H:MM:SS.cc for ASS."""
    cs = int(round(t * 100))
    h, cs = divmod(cs, 360000)
    m, cs = divmod(cs, 6000)
    s, cs = divmod(cs, 100)
    return f"{h}:{m:02d}:{s:02d}.{cs:02d}"

def collect_words(path, model_size):
    from faster_whisper import WhisperModel
    model = WhisperModel(model_size, compute_type="int8")
    segments, _ = model.transcribe(path, word_timestamps=True)
    words = []
    for seg in segments:
        for w in (seg.words or []):
            txt = w.word.strip()
            if txt:
                words.append((w.start, w.end, txt))
    return words

def build_ass(words, font, base_hex, hi_hex, chunk, height):
    fontsize = int(height * 0.075)          # ~7.5% of frame height
    margin_v = int(height * 0.22)           # keep above platform UI (~lower third)
    base = hex_to_ass(base_hex)
    hi = hex_to_ass(hi_hex)
    header = f"""[Script Info]
ScriptType: v4.00+
PlayResX: 1080
PlayResY: {height}
WrapStyle: 2

[V4+ Styles]
Format: Name, Fontname, Fontsize, PrimaryColour, OutlineColour, BackColour, Bold, Outline, Shadow, Alignment, MarginL, MarginR, MarginV
Style: Base,{font},{fontsize},{base},&H00000000,&H00000000,-1,6,3,2,80,80,{margin_v}
Style: Hi,{font},{fontsize},{hi},&H00000000,&H00000000,-1,6,3,2,80,80,{margin_v}

[Events]
Format: Layer, Start, End, Style, Name, MarginL, MarginR, MarginV, Effect, Text
"""
    events = []
    # group words into chunks; within a chunk, each word gets its moment highlighted
    for i in range(0, len(words), chunk):
        group = words[i:i+chunk]
        for j, (ws, we, _) in enumerate(group):
            parts = []
            for k, (_, _, txt) in enumerate(group):
                if k == j:
                    parts.append(f"{{\\c{hi}}}{txt}{{\\c{base}}}")
                else:
                    parts.append(txt)
            line = " ".join(parts)
            start = fmt_time(ws)
            end = fmt_time(we if we > ws else ws + 0.3)
            events.append(f"Dialogue: 0,{start},{end},Base,,0,0,0,,{line}")
    return header + "\n".join(events) + "\n"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("input")
    ap.add_argument("--ass", required=True)
    ap.add_argument("--burn")
    ap.add_argument("--model", default="base")
    ap.add_argument("--font", default="Arial")
    ap.add_argument("--highlight", default="#22f08a")
    ap.add_argument("--base", default="#eaf3ff")
    ap.add_argument("--chunk", type=int, default=3)
    ap.add_argument("--height", type=int, default=1920)
    a = ap.parse_args()

    print(f"Transcribing {a.input} with faster-whisper ({a.model})...")
    words = collect_words(a.input, a.model)
    if not words:
        print("No words detected — is there speech in the clip?", file=sys.stderr)
        sys.exit(1)
    ass = build_ass(words, a.font, a.base, a.highlight, a.chunk, a.height)
    with open(a.ass, "w", encoding="utf-8") as f:
        f.write(ass)
    print(f"Captions -> {a.ass} ({len(words)} words)")

    if a.burn:
        ass_esc = a.ass.replace("\\", "/").replace(":", "\\:")
        subprocess.run([
            "ffmpeg", "-y", "-i", a.input,
            "-vf", f"ass={ass_esc}",
            "-c:v", "libx264", "-crf", "18", "-preset", "medium", "-pix_fmt", "yuv420p",
            "-c:a", "copy", a.burn
        ], check=True)
        print(f"Burned -> {a.burn}")

if __name__ == "__main__":
    main()
