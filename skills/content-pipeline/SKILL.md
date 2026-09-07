---
name: content-pipeline
description: Turn a build-in-public stream (transcript + recording) into platform-ready clips with captions, per-platform copy, and a logged tracker. Use when the user says "new stream", "process my stream", "run the content pipeline", or hands over a transcript to clip.
---

# Content Pipeline

Turn one long stream into a batch of platform-ready clips + written posts. The human streams and publishes; you do clip selection, editing (via this repo's scripts), copywriting, and logging. **You cannot upload to social platforms — the human always publishes.**

This skill assumes the [contentpipeline repo](.) is available (its `scripts/` and `docs/`). Read `docs/TECHNICAL-RUNBOOK.md` for exact specs.

## First, once per stream
Remind the operator to run the privacy check before recording: close secret/credential files, financial dashboards, private messages — the whole screen is broadcast and recorded permanently.

## Folder + naming
One stream = one dated folder, parsed by platform (`new_stream.sh`). Naming: one moment = one clip number everywhere — `YYYY-MM-DD_clipNN_<platform>_<ratio>.mp4`.

## Stages
1. **Take both inputs up front.** The operator gives the FULL transcript AND the full recording. You cut from the recording — the operator never manually chops video.
2. **Propose, don't produce.** Read the FULL transcript and return **~8 ranked proposed sections**: timestamp range, the hook (first ~3 sec must grab), the angle, why it lands, suggested platforms. Some moments are better as an X thread than a clip — say so.
3. **Approval gate.** The operator approves, kills, swaps, or adjusts in/out points. Do NOT cut or mass-produce until they greenlight. Never take the recording and auto-produce without this conversation.
4. **Make clips (after sign-off).** For each approved moment × platform run `scripts/make_clip.sh MASTER START END PLATFORM OUTDIR [crop|blurpad]`. Vertical platforms (shorts/reels/tiktok/threads) → 9:16; x/youtube → 16:9. Face → crop, screen/demo → blurpad.
5. **Copy.** Per platform: title (YouTube SEO / X punchy / TikTok-IG hook-led), description, tags, CTA. Every CTA points to the product/goal. Write to each platform folder's `copy.md`. Also produce an X thread + a build-in-public post from the same transcript.
6. **Publish.** Operator uploads + screenshots.
7. **Log.** From screenshots, record what posted where; +3–7 days log follows + click-throughs (not vanity views). Note what worked → feeds smarter selection next time.

## Standing rules
- Never post on the user's behalf.
- Keep output consistent: same naming, same brand skin (`templates/brand-skin.template.md`), same voice every time.
- Timestamp log entries (YYYY-MM-DD).
- Keep raw footage; edits are reproducible from the scripts.
