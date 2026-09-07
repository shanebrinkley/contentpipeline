# Operator Guide

The human-facing walkthrough. If you've never run this, start here.

## Roles
- **Operator (you):** records the stream, picks moments (or lets an AI help), runs the scripts or asks the AI to, publishes, screenshots.
- **AI assistant (optional):** does clip selection, copywriting, and logging; drives the scripts for the mechanical edits.

## Before you record — the privacy check
Streaming broadcasts your whole screen and it's recorded permanently. Before going live, close anything sensitive: password/secret files, financial dashboards, private messages, email, autofill that reveals private URLs. If it would hurt you on screen forever, keep it closed.

## Step by step
1. **Record** at 1080p+ (OBS: record locally *and* stream). The local file is your clip master — it's higher quality than the platform VOD.
2. **Get a transcript** (any tool, or let `captions.py` generate one).
3. **Pick moments** from the transcript — the hooks, the payoffs, the surprising bits. Note timestamps. The first ~3 seconds of a clip must grab attention.
4. **Make clips:** `bash scripts/make_clip.sh master.mp4 START END PLATFORM ./out [mode]` for each moment × platform.
5. **Write copy** per platform: title, description, tags/hashtags, and a call-to-action pointing wherever you want traffic. Match each platform's style (search-keyword titles on YouTube; short and punchy on X; hook-led on TikTok/Reels).
6. **Repurpose the text** too: the same transcript makes an X thread, a blog post, a short recap — extra reach for free.
7. **Publish** each piece yourself and screenshot the live post.
8. **Log** what went where; a few days later, log the numbers that matter (follows, click-throughs), not just views.

## Cadence
Don't dump every clip at once — space them over days. Your tracker is also your calendar.

## FAQ
- **Can the AI post for me?** No — publishing is always manual.
- **How many clips per stream?** As many good moments as there are; post the best first.
- **The crop cut off my face.** Use `blurpad` mode, or re-cut with a tighter source.
