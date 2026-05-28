#!/usr/bin/env bash
set -euo pipefail

godot_version="${GODOT_VERSION:-4.6.2}"
godot_status="${GODOT_STATUS:-stable}"
godot_release="${godot_version}-${godot_status}"
template_version="${godot_version}.${godot_status}"
cache_root="${NETLIFY_CACHE_DIR:-$PWD/.cache}"

host_os="$(uname -s)"
mac_godot="/Users/clark/Downloads/Godot.app/Contents/MacOS/Godot"

if command -v godot >/dev/null 2>&1; then
	godot_bin="$(command -v godot)"
elif [ "$host_os" = "Darwin" ] && [ -x "$mac_godot" ]; then
	godot_bin="$mac_godot"
fi

if [ -n "${godot_bin:-}" ]; then
	godot_reported_version="$("$godot_bin" --version || true)"
	if [[ "$godot_reported_version" =~ ^([0-9]+\.[0-9]+(\.[0-9]+)?)\.([a-z]+) ]]; then
		godot_version="${BASH_REMATCH[1]}"
		godot_status="${BASH_REMATCH[3]}"
		godot_release="${godot_version}-${godot_status}"
		template_version="${godot_version}.${godot_status}"
	fi
elif [ "$host_os" = "Linux" ]; then
	cache_dir="${cache_root}/godot-${godot_release}"
	mkdir -p "$cache_dir"
	godot_zip="${cache_dir}/godot-linux.zip"
	godot_bin="${cache_dir}/Godot_v${godot_release}_linux.x86_64"
  if [ ! -x "$godot_bin" ]; then
    curl -L --fail --retry 3 -o "$godot_zip" \
      "https://github.com/godotengine/godot-builds/releases/download/${godot_release}/Godot_v${godot_release}_linux.x86_64.zip"
		unzip -q -o "$godot_zip" -d "$cache_dir"
		chmod +x "$godot_bin"
	fi
else
	echo "Godot was not found. Install Godot or add a godot executable to PATH." >&2
	exit 1
fi

cache_dir="${cache_root}/godot-${godot_release}"
if [ "$host_os" = "Darwin" ]; then
	templates_dir="${HOME}/Library/Application Support/Godot/export_templates/${template_version}"
else
	templates_dir="${HOME}/.local/share/godot/export_templates/${template_version}"
fi
mkdir -p "$cache_dir" "$templates_dir" builds/web

if [ ! -f "${templates_dir}/web_nothreads_release.zip" ]; then
  templates_tpz="${cache_dir}/export_templates.tpz"
  templates_extract="${cache_dir}/templates"
  curl -L --fail --retry 3 -o "$templates_tpz" \
    "https://github.com/godotengine/godot-builds/releases/download/${godot_release}/Godot_v${godot_release}_export_templates.tpz"
  rm -rf "$templates_extract"
  mkdir -p "$templates_extract"
  unzip -q -o "$templates_tpz" -d "$templates_extract"
  cp "${templates_extract}/templates/"* "$templates_dir/"
fi

project_backup="$(mktemp)"
cp project.godot "$project_backup"
cleanup() {
  cp "$project_backup" project.godot
  rm -f "$project_backup"
}
trap cleanup EXIT

perl -0pi -e 's/renderer\/rendering_method="[^"]+"/renderer\/rendering_method="gl_compatibility"/' project.godot

"$godot_bin" --headless --import || true
"$godot_bin" --headless --export-release "Web" builds/web/index.html
touch builds/web/.nojekyll
bash scripts/apply-phone-shell.sh builds/web/index.html
ls -lh builds/web
