#!/usr/bin/env python3
"""Generate placeholder JPEGs for the Instagram section (v1 stand-ins).

Per CLAAAAA-132 + the locked ADR on CLAAAAA-143:
- square, 1080x1080 source
- JPEG, <=500KB each
- 5 tiles, named 01.jpg .. 05.jpg
- Viktoria replaces these with real curated photos in a follow-up commit
  (PM-locked per-deploy refresh rule on CLAAAAA-142).

Colors mirror the brand-cream / brand-ink / brand-orange / brand-yellow
tones from the original placeholder grid so the v1 stand-ins read as
"intentional placeholders" rather than broken images, and so the QA gate
can confirm the section renders 5 tiles with non-zero pixel content.
"""

from PIL import Image, ImageDraw, ImageFont
import os

OUT_DIR = os.path.join(
    os.path.dirname(__file__),
    "..",
    "static",
    "instagram",
)
OUT_DIR = os.path.abspath(OUT_DIR)
os.makedirs(OUT_DIR, exist_ok=True)

PALETTE = [
    ((231, 225, 210), (32, 32, 32), "01", "Studio still life"),
    ((32, 32, 32), (231, 225, 210), "02", "Outdoor walk"),
    ((232, 118, 55), (32, 32, 32), "03", "Photo book spread"),
    ((232, 200, 80), (32, 32, 32), "04", "Black forest"),
    ((231, 225, 210), (32, 32, 32), "05", "Behind the scenes"),
]

SIZE = 1080
FONT_BIG = None
FONT_SMALL = None
for path in [
    "/System/Library/Fonts/Helvetica.ttc",
    "/System/Library/Fonts/Supplemental/Arial.ttf",
    "/Library/Fonts/Arial.ttf",
]:
    if os.path.exists(path):
        try:
            FONT_BIG = ImageFont.truetype(path, 96)
            FONT_SMALL = ImageFont.truetype(path, 36)
            break
        except OSError:
            continue

if FONT_BIG is None:
    FONT_BIG = ImageFont.load_default()
    FONT_SMALL = ImageFont.load_default()


def render_tile(index: int) -> None:
    bg, fg, num, label = PALETTE[index]
    img = Image.new("RGB", (SIZE, SIZE), bg)
    draw = ImageDraw.Draw(img)

    # hairline frame
    draw.rectangle((24, 24, SIZE - 24, SIZE - 24), outline=fg, width=2)

    # tile number (eyebrow)
    num_text = f"No {num}"
    draw.text((72, 72), num_text, font=FONT_SMALL, fill=fg)

    # centered label
    bbox = draw.textbbox((0, 0), label, font=FONT_BIG)
    w, h = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(((SIZE - w) / 2, (SIZE - h) / 2), label, font=FONT_BIG, fill=fg)

    out_path = os.path.join(OUT_DIR, f"{num}.jpg")
    img.save(out_path, "JPEG", quality=82, optimize=True)
    size_kb = os.path.getsize(out_path) / 1024
    print(f"wrote {out_path} ({size_kb:.1f} KB)")


if __name__ == "__main__":
    for i in range(5):
        render_tile(i)
