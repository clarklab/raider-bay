#!/usr/bin/env bash
set -euo pipefail

html_path="${1:-builds/web/index.html}"
css_path="${2:-web/phone-shell.css}"
tmp_path="${html_path}.tmp"

awk '
  BEGIN {
    while ((getline line < css_path) > 0) {
      css = css line "\n"
    }
  }
  /<\/head>/ {
    print "<style id=\"raider-bay-phone-shell\">"
    printf "%s", css
    print "</style>"
  }
  { print }
' css_path="$css_path" "$html_path" > "$tmp_path"

mv "$tmp_path" "$html_path"
