# Source assets (not shipped)

Full-quality originals kept for future development. The `.gdignore` file makes
Godot skip this whole directory: nothing here is imported or exported into the
game. Ship-ready (compressed) versions live in `assets/`; import settings there
(lossy WebP, size limits, mipmaps) do the image compression at import time, so
the PNGs in `assets/` are also still full-res sources.

- `art/` — unreferenced or dev-only images (design studies, unused variants)
- `audio/` — original full-bitrate music/ambience; `assets/` ships transcoded copies
