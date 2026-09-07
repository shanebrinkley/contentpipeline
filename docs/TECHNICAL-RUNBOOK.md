# Technical Runbook

The settings, commands, and specs behind each step.

## Recording (OBS)
- Canvas + output **1920×1080** minimum; **60 fps** if the machine allows.
- Record locally as the clip master (MP4; if MKV, remux: `ffmpeg -i in.mkv -c copy out.mp4`).
- Rate control CQP ~18 or CBR 20–25 Mbps. Record mic + desktop on separate tracks if possible.
- Keep facecam large enough that a vertical center-crop still frames the face.

## Cutting
Frame-accurate, re-encoded so cuts land exactly:
```bash
ffmpeg -ss START -to END -i master.mp4 -c:v libx264 -crf 18 -preset medium -pix_fmt yuv420p -c:a aac -b:a 256k clip.mp4
```

## Reframing 16:9 → 9:16
- **Center-crop** (faces): `crop=ih*9/16:ih,scale=1080:1920`
- **Blurred-pad** (screen/demo, keeps whole frame): scale-to-fill blurred bg + centered foreground.
Rule: face → crop; code/screen → blurpad; both on screen → blurpad.

## Captions
1. Transcribe word-level with faster-whisper.
2. Generate a styled `.ass` (word-highlight, brand color, heavy outline, lower third).
3. Burn: `ffmpeg -i in.mp4 -vf "ass=captions.ass" ... out.mp4`
Style: ~7.5% of frame height, baseline ~420 px up (clears platform UI), side margins ≥10%.

## Audio
Normalize to broadcast-ish loudness: `loudnorm=I=-14:TP=-1.5:LRA=11`.

## Export (canonical)
```
-c:v libx264 -profile:v high -pix_fmt yuv420p -crf 18 -preset medium -c:a aac -b:a 256k -ar 48000 -movflags +faststart
```
`yuv420p` is required or some platforms show black video; `+faststart` makes uploads preview instantly.

## Platform specs (verify — platforms change these)
| Platform | Aspect / size | Max length | Title / caption | Hashtags |
|---|---|---|---|---|
| YouTube Shorts | 9:16 · 1080×1920 | ~3 min | title ≤100 · desc ≤5000 | 3–5 |
| Instagram Reels | 9:16 · 1080×1920 | ~3 min | caption ≤2200 | 3–5 (max 30) |
| TikTok | 9:16 · 1080×1920 | up to 10 min | caption ~2200 | 3–5 |
| Threads | 9:16 (or 1:1/16:9) | ~5 min | post ≤500 | 1–3 |
| X | 16:9 or 1:1 | ~2:20 (more if verified) | 280 (more if premium) | 1–2 |
| YouTube long | 16:9 · 1920×1080 | — | title ≤100 · desc ≤5000 | tags ≤500 chars |

## Safe zones (9:16)
Top ~12%, bottom ~20%, right ~10% overlap platform UI — keep captions and key visuals out of these.

## Naming convention
One moment = one clip number everywhere.
`YYYY-MM-DD_clipNN_<platform>_<ratio>.mp4` → `2026-09-06_clip01_shorts_9x16.mp4`
Zero-pad numbers; lowercase platform tags; ratios `9x16`/`16x9`; raw timestamps use `m`/`s` (no colons — illegal in Windows filenames).

## Troubleshooting
| Symptom | Fix |
|---|---|
| Video plays black | Missing `-pix_fmt yuv420p`; re-export. |
| Vertical clip soft | Source below 1080p or deep crop upscaled; record higher / use blurpad. |
| Captions behind buttons | Raise baseline; respect bottom-20% safe zone. |
| Audio out of sync | Use accurate seek + re-encode (as shown), not stream-copy on a non-keyframe. |
| Wrong caption words | Bigger Whisper model (`base`→`small`/`medium`); hand-correct the `.ass`. |
| File too big to upload | Raise CRF to 20–22. |
| MKV won't open | Remux: `ffmpeg -i in.mkv -c copy out.mp4`. |
