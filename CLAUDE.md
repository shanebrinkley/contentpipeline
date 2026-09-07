# CLAUDE.md — Content Pipeline

You are working in the **Content Pipeline** repo. This file loads automatically each session — it's how you know what this project is and how to run it.

## What this is
A repeatable system for turning one long build-in-public stream into a batch of platform-ready clips + written posts. The human streams and publishes; **you** do clip selection, editing (via `scripts/`), copywriting, and logging. **You cannot upload to social platforms — the human always publishes.**

## Read these before acting
- `README.md` — overview + requirements + quickstart.
- `docs/OPERATOR-GUIDE.md` — the human workflow.
- `docs/TECHNICAL-RUNBOOK.md` — exact specs, commands, platform table, troubleshooting.
- `skills/content-pipeline/SKILL.md` — the step-by-step you follow.
- `templates/brand-skin.template.md` — the look to apply consistently.

## How to run it (the loop)
1. **Take both inputs up front.** The operator gives you the FULL transcript AND the full recording. You cut from the recording — the operator never manually chops video.
2. **Propose, don't produce.** Read the full transcript and come back with **~8 ranked proposed sections**: timestamp range, the hook (first ~3 sec must grab), the angle, why it lands, suggested platforms.
3. **Approval gate — discuss and wait.** The operator approves, kills, swaps, or adjusts in/out points. Do NOT cut or mass-produce until they greenlight the list.
4. **Make clips (after sign-off).** Per approved moment × platform: `bash scripts/make_clip.sh MASTER START END PLATFORM OUTDIR [crop|blurpad]`. Vertical (shorts/reels/tiktok/threads) → 9:16; x/youtube → 16:9. Face → crop, screen/demo → blurpad.
5. **Copy.** Per platform: title, description, tags, CTA (write to each platform folder's `copy.md`). Plus an X thread + build-in-public post from the same transcript.
6. **Publish.** Operator uploads + screenshots.
7. **Log.** From screenshots, record what posted where; +3–7 days log follows + click-throughs (not vanity views).

## Non-negotiables
- **Never post on the user's behalf.** Publishing is always manual.
- **Consistency above all.** Same naming, same specs, same brand skin every time. One moment = one clip number everywhere: `YYYY-MM-DD_clipNN_<platform>_<ratio>.mp4` (zero-pad; lowercase platform; ratio `9x16`/`16x9`; no colons in filenames).
- **Remind the operator** to run the pre-record privacy check (close secret files, financial dashboards, private messages — the screen is broadcast + recorded permanently).
- **Keep raw footage; edits are reproducible** from the scripts. Never commit media (see `.gitignore`).
- Timestamp log entries (YYYY-MM-DD).

## Setup (once)
`bash scripts/setup.sh` — checks ffmpeg, installs faster-whisper.
