#!/usr/bin/env bash
# Render an autonomous Raider Bay playthrough to an MP4 for promo/landing use.
#
# Drives the in-engine autopilot (main.gd, `-- --autoplay`) under Godot's Movie
# Maker, which renders decoupled from wall-clock at a locked framerate, then
# transcodes the intermediate AVI to a web-friendly H.264 MP4 with ffmpeg.
#
# Usage:  bash scripts/render-promo.sh        (or: npm run render:promo)
# Env:    GODOT=/path/to/Godot   FPS=60
set -euo pipefail

cd "$(dirname "$0")/.."

GODOT="${GODOT:-/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot}"
FPS="${FPS:-60}"
OUT_DIR="builds/promo"
AVI="$OUT_DIR/raider-bay.avi"
MP4="$OUT_DIR/raider-bay.mp4"

if [ ! -x "$GODOT" ]; then
  echo "Godot binary not found/executable at: $GODOT" >&2
  echo "Set GODOT=/path/to/Godot and retry." >&2
  exit 1
fi
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg not found on PATH." >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
rm -f "$AVI" "$MP4"

echo "▶ Rendering autopilot playthrough with Movie Maker (fps=$FPS)…"
# Movie Maker needs a real GPU context (no --headless). The window opens, plays
# the scripted run, and the engine quits itself (get_tree().quit() in autopilot).
"$GODOT" --path . --write-movie "$AVI" --fixed-fps "$FPS" -- --autoplay

if [ ! -f "$AVI" ]; then
  echo "Movie Maker produced no output at $AVI" >&2
  exit 1
fi

echo "▶ Transcoding to H.264 MP4…"
# -map ...? : keep it tolerant of a video-only AVI (Movie Maker may emit no audio
# track). Try with audio; if the AVI has none, ffmpeg simply carries video only.
ffmpeg -y -hide_banner -loglevel error \
  -i "$AVI" \
  -c:v libx264 -preset slow -crf 18 -pix_fmt yuv420p -movflags +faststart \
  -c:a aac -b:a 160k \
  "$MP4"

DUR="$(ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 "$MP4" 2>/dev/null || echo '?')"
echo "✔ Wrote $MP4  (${DUR}s)"
