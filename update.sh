#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_JSON="$SCRIPT_DIR/package.json"
FULL=false

# Extract the minimum version of a package from package.json (strips prefixes like ^, ~, >=, =)
extract_version() {
  local pkg="$1"
  grep "\"${pkg}\"" "$PACKAGE_JSON" | sed -E 's/.*"[^0-9]*([0-9]+\.[0-9]+\.[0-9]+)".*/\1/'
}

# Extract version from the README.md Versions table by row keyword
readme_version() {
  local keyword="$1"
  grep "${keyword}" "$SCRIPT_DIR/README.md" | sed -E "s/.*\`([0-9]+\.[0-9]+\.[0-9]+)\`.*/\1/"
}

# Update version in the README.md Versions table
update_readme_version() {
  local keyword="$1"
  local new_version="$2"
  sed -i "/${keyword}/s/\`[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\`/\`${new_version}\`/" "$SCRIPT_DIR/README.md"
}

# ── dayjs ──────────────────────────────────────────────────────────────────────
update_dayjs() {
  local version
  version=$(extract_version "dayjs")

  if [[ -z "$version" ]]; then
    echo "Error: could not read dayjs version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating dayjs to v${version}"

  local base_url="https://cdn.jsdelivr.net/npm/dayjs@${version}"
  local base_dir="$SCRIPT_DIR/dayjs"
  local files=(
    "dayjs.min.js"
    "locale/en.js"
    "plugin/localizedFormat.js"
    "plugin/relativeTime.js"
  )

  for file in "${files[@]}"; do
    local url="${base_url}/${file}"
    local dest="${base_dir}/${file}"
    mkdir -p "$(dirname "$dest")"
    echo "Downloading: $url"
    wget -q --show-progress -O "$dest" "$url"
    echo "Updated: $dest"
  done
}

# ── clipboard ─────────────────────────────────────────────────────────────────
update_clipboard() {
  local version
  version=$(extract_version "clipboard")

  if [[ -z "$version" ]]; then
    echo "Error: could not read clipboard version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating clipboard to v${version}"

  local url="https://cdn.jsdelivr.net/npm/clipboard@${version}/dist/clipboard.min.js"
  local dest="$SCRIPT_DIR/clipboard/clipboard.min.js"

  mkdir -p "$(dirname "$dest")"
  echo "Downloading: $url"
  wget -q --show-progress -O "$dest" "$url"
  echo "Updated: $dest"
}

# ── mermaid ───────────────────────────────────────────────────────────────────
update_mermaid() {
  local version
  version=$(extract_version "mermaid")

  if [[ -z "$version" ]]; then
    echo "Error: could not read mermaid version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating mermaid to v${version}"

  local url="https://cdn.jsdelivr.net/npm/mermaid@${version}/dist/mermaid.min.js"
  local dest="$SCRIPT_DIR/mermaid/mermaid.min.js"

  mkdir -p "$(dirname "$dest")"
  echo "Downloading: $url"
  wget -q --show-progress -O "$dest" "$url"
  echo "Updated: $dest"
}

# ── fontawesome-free ───────────────────────────────────────────────────────────
update_fontawesome_free() {
  local version
  version=$(extract_version "@fortawesome/fontawesome-free")

  if [[ -z "$version" ]]; then
    echo "Error: could not read @fortawesome/fontawesome-free version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating fontawesome-free to v${version}"

  local fa_zip="fontawesome-free-${version}-web.zip"
  local fa_url="https://use.fontawesome.com/releases/v${version}/${fa_zip}"
  local fa_zip_path="$SCRIPT_DIR/${fa_zip}"
  local fa_extract_dir="$SCRIPT_DIR/fontawesome-free-${version}-web"
  local fa_dest="$SCRIPT_DIR/fontawesome-free"
  local files=(
    "LICENSE.txt"
    "css/all.min.css"
    "webfonts"
  )

  echo "Downloading: $fa_url"
  mkdir -p "$fa_dest"
  wget -q --show-progress -O "$fa_zip_path" "$fa_url"

  echo "Extracting: $fa_zip_path"
  unzip -q "$fa_zip_path" -d "$SCRIPT_DIR"

  for file in "${files[@]}"; do
    local src="${fa_extract_dir}/${file}"
    local dest="${fa_dest}/${file}"
    if [[ -d "$src" ]]; then
      rm -rf "$dest"
      mv "$src" "$dest"
    else
      mkdir -p "$(dirname "$dest")"
      cp "$src" "$dest"
    fi
    echo "Updated: $dest"
  done

  rm -f "$fa_zip_path"
  rm -rf "$fa_extract_dir"
  echo "Temporary files removed"
}

# ── glightbox ─────────────────────────────────────────────────────────────────
update_glightbox() {
  local version
  version=$(extract_version "glightbox")

  if [[ -z "$version" ]]; then
    echo "Error: could not read glightbox version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating glightbox to v${version}"

  local base_url="https://cdn.jsdelivr.net/npm/glightbox@${version}/dist"
  local base_dir="$SCRIPT_DIR/glightbox"
  local files=(
    "js/glightbox.min.js"
    "css/glightbox.min.css"
  )

  for file in "${files[@]}"; do
    local url="${base_url}/${file}"
    local dest="${base_dir}/${file##*/}"
    mkdir -p "$(dirname "$dest")"
    echo "Downloading: $url"
    wget -q --show-progress -O "$dest" "$url"
    echo "Updated: $dest"
  done
}

# ── tocbot ────────────────────────────────────────────────────────────────────
update_tocbot() {
  local version
  version=$(extract_version "tocbot")

  if [[ -z "$version" ]]; then
    echo "Error: could not read tocbot version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating tocbot to v${version}"

  local base_url="https://cdn.jsdelivr.net/npm/tocbot@${version}/dist"
  local base_dir="$SCRIPT_DIR/tocbot"
  local files=(
    "tocbot.min.js"
    "tocbot.min.css"
  )

  for file in "${files[@]}"; do
    local url="${base_url}/${file}"
    local dest="${base_dir}/${file}"
    mkdir -p "$(dirname "$dest")"
    echo "Downloading: $url"
    wget -q --show-progress -O "$dest" "$url"
    echo "Updated: $dest"
  done
}

run_if_updated() {
  local pkg="$1"
  local readme_key="$2"
  local update_fn="$3"

  local pkg_ver readme_ver
  pkg_ver=$(extract_version "$pkg")
  readme_ver=$(readme_version "$readme_key")

  if [[ "$FULL" == true || "$pkg_ver" != "$readme_ver" ]]; then
    "$update_fn"
    update_readme_version "$readme_key" "$pkg_ver"
  fi
}

# ── main ───────────────────────────────────────────────────────────────────────
while getopts "fh" opt; do
  case $opt in
  f) FULL=true ;;
  h)
    echo "Usage: $0 [-f] [-h]"
    echo ""
    echo "Update static assets in this repository based on versions defined in package.json."
    echo "Each dependency is compared against the version recorded in README.md;"
    echo "only changed dependencies are downloaded and updated."
    echo ""
    echo "Options:"
    echo "  -f  Run a full update: download all dependencies regardless of the current README versions."
    echo "  -h  Show this help message and exit."
    exit 0
    ;;
  *)
    echo "Usage: $0 [-f] [-h]" >&2
    exit 1
    ;;
  esac
done

# ── check ncu ─────────────────────────────────────────────────────────────────
if ! command -v ncu &>/dev/null; then
  echo "Error: npm-check-updates (ncu) is not installed." >&2
  echo "Install it with: npm install -g npm-check-updates" >&2
  exit 1
fi

echo -e "\nRunning ncu -u to upgrade package.json..."
ncu -u --packageFile "$PACKAGE_JSON"

declare -A deps=(
  ["dayjs"]="Day\.js"
  ["clipboard"]="Clipboard"
  ["mermaid"]="Mermaid"
  ["@fortawesome/fontawesome-free"]="Font Awesome"
  ["glightbox"]="GLightbox"
  ["tocbot"]="Tocbot"
)

# Capture README versions before updating
declare -A old_versions
for pkg in "${!deps[@]}"; do
  old_versions["$pkg"]=$(readme_version "${deps[$pkg]}")
done

for pkg in "${!deps[@]}"; do
  readme_key="${deps[$pkg]}"
  pkg_name="${pkg##*/}"
  update_fn="update_${pkg_name//-/_}"
  run_if_updated "$pkg" "$readme_key" "$update_fn"
done

# Build update summary
declare -a changed_pkgs=()
declare -a changed_old=()
declare -a changed_new=()
for pkg in "${!deps[@]}"; do
  old_ver="${old_versions[$pkg]}"
  new_ver=$(extract_version "$pkg")
  if [[ "$old_ver" != "$new_ver" ]]; then
    changed_pkgs+=("$pkg")
    changed_old+=("$old_ver")
    changed_new+=("$new_ver")
  fi
done

if [[ ${#changed_pkgs[@]} -gt 0 ]]; then
  max_pkg_len=0
  max_old_len=0
  for i in "${!changed_pkgs[@]}"; do
    [[ ${#changed_pkgs[$i]} -gt $max_pkg_len ]] && max_pkg_len=${#changed_pkgs[$i]}
    [[ ${#changed_old[$i]} -gt $max_old_len ]] && max_old_len=${#changed_old[$i]}
  done

  summary_lines=()
  for i in "${!changed_pkgs[@]}"; do
    summary_lines+=("$(printf " %-*s  %*s  ->  %s" \
      "$max_pkg_len" "${changed_pkgs[$i]}" \
      "$max_old_len" "${changed_old[$i]}" \
      "${changed_new[$i]}")")
  done

  sep() { printf "%-${1}s\n" "" | tr " " "-"; }

  echo -e "\n-- Suggested git commit message --"
  echo "chore(deps): update static assets"
  echo ""
  for line in "${summary_lines[@]}"; do echo "$line"; done
fi
