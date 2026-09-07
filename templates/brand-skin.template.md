# Brand Skin (template)

Copy this file, fill it in, and your clips carry a consistent look every time. Pass the key values to the scripts via env vars (`CP_FONT`, `CP_HL`).

## Colors
| Role | Hex | Use |
|---|---|---|
| Highlight (active caption word) | `#22f08a` | the signature pop — pass as `CP_HL` |
| Base text | `#eaf3ff` | caption body |
| Accent | `#45d4ff` | secondary highlights |
| Background / bars | `#07142b` | letterbox, endcards |

## Font
- Caption font: `Arial` (default) — set your brand font with `CP_FONT="Roboto"`.
- Big text: heaviest weight, tight tracking.

## Caption style
- ~7.5% of frame height, heavy outline + shadow, lower third (clears platform UI).
- Active word highlighted in your highlight color (karaoke style).

## Logo / watermark
- Put your logo files in `assets/` (not committed by default). Small, top-corner, inside the safe zone; or as a 1–2s endcard.

## Endcard / CTA
- Short endcard: logo + one-line pitch + your URL.

## Voice (for titles/descriptions/posts)
- Direct, plain-spoken, specific verbs.
- Keep it consistent: same sign-off, same CTA target, every time.

## Safe zones (9:16)
- Top ~12% clear, bottom ~20% clear, right ~10% clear (platform UI overlaps these).
