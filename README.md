# Content Pipeline

Turn one long build-in-public stream into a batch of platform-ready clips — cut, captioned, reframed, and named — with a repeatable folder system and a set of small ffmpeg/Whisper scripts. Free, self-hosted, no subscription.

**The loop:** stream → transcript → pick the best moments → cut + caption + reframe per platform → publish → log.

You (or an AI assistant) do the clip-picking and copywriting; these scripts do the mechanical editing. Nothing here uploads to social platforms — you publish yourself.

---

## Requirements

- **ffmpeg** (with libx264, aac, libass) — the video engine.
- **Python 3.9+** — for the caption generator.
- **faster-whisper** — speech-to-text with word timing (installed by setup).

## Install

```bash
git clone https://github.com/<you>/contentpipeline.git
cd contentpipeline
bash scripts/setup.sh        # checks ffmpeg, installs faster-whisper
```

Don't have ffmpeg yet:
- macOS `brew install ffmpeg` · Ubuntu `sudo apt install ffmpeg` · Windows `winget install Gyan.FFmpeg`

---

## Quickstart

```bash
# 1. Start a new stream folder (parsed by platform)
bash scripts/new_stream.sh "building a new feature"

# 2. Read your transcript, decide the moments worth clipping, then for each:
#    make one platform-ready clip end-to-end (cut -> reframe -> caption -> normalize -> export)
bash scripts/make_clip.sh master.mp4 00:12:30 00:12:58 shorts ./out crop
bash scripts/make_clip.sh master.mp4 00:12:30 00:12:58 x       ./out
```

`make_clip.sh` picks the right shape automatically: `shorts|reels|tiktok|threads` → vertical 9:16, `x|youtube` → landscape 16:9.

---

## The workflow in full

1. **Record.** Stream + record locally (OBS recommended) at 1080p or higher — vertical crops need the pixels. Capture a transcript (any tool; the caption script can also generate one).
2. **Pick moments.** Read the transcript, choose the clippable moments, note their timestamps. (This is the judgment step — a human or an AI assistant does it.)
3. **Make clips.** Run `make_clip.sh` per moment, per platform. Output is named by convention and dropped in the platform folder.
4. **Write copy.** Title, description, tags, CTA per platform (see `docs/OPERATOR-GUIDE.md`).
5. **Publish.** Upload each clip yourself. Screenshot the live posts.
6. **Log.** Record what went where and how it performed.

---

## Scripts

| Script | Does |
|---|---|
| `setup.sh` | Check ffmpeg, install Python deps. |
| `new_stream.sh "<topic>"` | Scaffold a dated, platform-parsed stream folder. |
| `cut_clip.sh MASTER START END OUT` | Frame-accurate cut from the master. |
| `reframe.sh IN OUT [crop\|blurpad]` | 16:9 → 9:16. `crop` for faces, `blurpad` for screen shares. |
| `captions.py IN --ass OUT.ass [--burn OUT.mp4]` | Whisper → word-highlight captions → burn in. |
| `normalize.sh IN OUT` | Loudness to −14 LUFS. |
| `export.sh IN OUT` | Web-ready H.264 export (yuv420p, faststart). |
| `thumbnail.sh MASTER TS OUT` | 1280×720 thumbnail from a frame. |
| `make_clip.sh MASTER START END PLATFORM OUTDIR [mode]` | All of the above, chained, for one platform. |

Caption look is brand-customizable via env vars: `CP_FONT="Roboto" CP_HL="#22f08a" bash scripts/make_clip.sh ...`

---

## Folder structure & naming

One stream = one dated folder, parsed **by platform**:

```
Streams/2026-09-06 - building a new feature/
  transcript.txt
  raw/                 NN_raw_<start>-<end>.mp4
  YouTube-Long/  YouTube-Shorts/  Instagram-Reels/  TikTok/  Threads/  X/  Blog/
     <video> + copy.md + thumbnail
```

**Naming rule — one moment = one clip number, everywhere.** `clip01` is the same moment whether it becomes a Short, a Reel, or a TikTok; only platform + ratio change.
`YYYY-MM-DD_clipNN_<platform>_<ratio>.mp4` → `2026-09-06_clip01_shorts_9x16.mp4`
(Zero-pad clip numbers; lowercase platform tags; ratios `9x16`/`16x9`; use `m`/`s` not colons in raw timestamps — colons are illegal in Windows filenames.)

Full detail: `docs/TECHNICAL-RUNBOOK.md`.

---

## Use it with an AI assistant (optional)

`skills/content-pipeline/SKILL.md` is a portable skill for Claude. Point your assistant at this repo and it will run the judgment steps (clip selection, copywriting, logging) and drive these scripts for the mechanical steps.

## Customize the brand

Copy `templates/brand-skin.template.md`, fill in your colors, font, logo, and voice, and pass them to the caption script (`CP_FONT`, `CP_HL`). The defaults are neutral.

## Caveats (honest)

- **Nothing here posts for you** — publishing to any platform is manual by design.
- **Auto-captions and auto-crops need a quick review** — they're a strong first pass, not always perfect.
- **Big source files are slow** — clip from short sections, not the whole multi-GB recording, when you can.

## License

MIT — see `LICENSE`. Use it, fork it, ship it.
