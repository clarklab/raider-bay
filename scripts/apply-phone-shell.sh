#!/usr/bin/env bash
set -euo pipefail

html_path="${1:-builds/web/index.html}"
css_path="${2:-web/phone-shell.css}"
manifest_path="${3:-web/manifest.webmanifest}"
tmp_path="${html_path}.tmp"
output_dir="$(dirname "$html_path")"

LC_ALL=C perl -0pi -e 's/<meta name="viewport" content="[^"]*">/<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover">/i' "$html_path"

if [ -f "$manifest_path" ]; then
	cp "$manifest_path" "$output_dir/manifest.webmanifest"
fi

if [ -f "assets/app-icon-192.png" ]; then
	cp "assets/app-icon-192.png" "$output_dir/app-icon-192.png"
fi

if [ -f "assets/ios/app-icon-1024.png" ]; then
	cp "assets/ios/app-icon-1024.png" "$output_dir/app-icon-1024.png"
fi

awk -v css_path="$css_path" '
  BEGIN {
    while ((getline line < css_path) > 0) {
      css = css line "\n"
    }
    head = "<meta name=\"theme-color\" content=\"#050c17\">\n"
    head = head "<meta name=\"mobile-web-app-capable\" content=\"yes\">\n"
    head = head "<meta name=\"apple-mobile-web-app-capable\" content=\"yes\">\n"
    head = head "<meta name=\"apple-mobile-web-app-title\" content=\"Raider Bay\">\n"
    head = head "<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black-translucent\">\n"
    head = head "<link rel=\"manifest\" href=\"manifest.webmanifest\">\n"
    head = head "<link rel=\"apple-touch-icon\" href=\"app-icon-192.png\">\n"
    head = head "<style id=\"raider-bay-phone-shell\">\n"
    head = head css
    head = head "</style>"
  }
  /<\/head>/ {
    sub(/<\/head>/, head "\n</head>")
  }
  { print }
' "$html_path" > "$tmp_path"

mv "$tmp_path" "$html_path"
