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

update_mathjax() {
  local version
  version=$(extract_version "mathjax")

  if [[ -z "$version" ]]; then
    echo "Error: could not read mathjax version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating mathjax to v${version}"

  local src_dir="$SCRIPT_DIR/node_modules/mathjax"
  local dest_dir="$SCRIPT_DIR/mathjax"

  if [[ ! -d "$src_dir" ]]; then
    echo "Error: $src_dir not found. Run 'npm install' first." >&2
    exit 1
  fi

  echo "Clearing: $dest_dir"
  rm -rf "$dest_dir"

  echo "Copying: $src_dir -> $dest_dir"
  cp -r "$src_dir" "$dest_dir"
  echo "Updated: $dest_dir"

  # Remove Node.js-specific files
  local node_files=(
    "node-main.js"
    "node-main.mjs"
    "node-main.cjs"
    "node-main-setup.cjs"
    "require.mjs"
  )

  for file in "${node_files[@]}"; do
    rm -f "$dest_dir/$file"
  done

  # Remove documentation files
  rm -f "$dest_dir/CONTRIBUTING.md" "$dest_dir/README.md" "$dest_dir/package.json"

  echo "Removed Node.js-specific and documentation files"
}

update_loading_attribute_polyfill() {
  local version
  version=$(extract_version "loading-attribute-polyfill")

  if [[ -z "$version" ]]; then
    echo "Error: could not read loading-attribute-polyfill version from package.json" >&2
    exit 1
  fi

  echo -e "\nUpdating loading-attribute-polyfill to v${version}"

  local base_url="https://cdn.jsdelivr.net/npm/loading-attribute-polyfill@${version}/dist"
  local base_dir="$SCRIPT_DIR/loading-attribute-polyfill"
  local files=(
    "loading-attribute-polyfill.min.css"
    "loading-attribute-polyfill.umd.min.js"
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

main() {
  local target=""

  for arg in "$@"; do
    case "$arg" in
    -f) FULL=true ;;
    -h)
      echo "Usage: $0 [-f] [-h] [PACKAGE]"
      echo ""
      echo "Update static assets in this repository based on versions defined in package.json."
      echo "Each dependency is compared against the version recorded in README.md;"
      echo "only changed dependencies are downloaded and updated."
      echo ""
      echo "Arguments:"
      echo "  PACKAGE  Only update the specified package (e.g., mathjax, dayjs, clipboard)."
      echo ""
      echo "Options:"
      echo "  -f  Force update: download regardless of the current README versions."
      echo "  -h  Show this help message and exit."
      exit 0
      ;;
    -*)
      echo "Usage: $0 [-f] [-h] [PACKAGE]" >&2
      exit 1
      ;;
    *) target="$arg" ;;
    esac
  done

  if ! command -v ncu &>/dev/null; then
    echo "Error: npm-check-updates (ncu) is not installed." >&2
    echo "Install it with: npm install -g npm-check-updates" >&2
    exit 1
  fi

  declare -A deps=(
    ["dayjs"]="Day\.js"
    ["clipboard"]="Clipboard"
    ["mermaid"]="Mermaid"
    ["mathjax"]="MathJax"
    ["@fortawesome/fontawesome-free"]="Font Awesome"
    ["glightbox"]="GLightbox"
    ["loading-attribute-polyfill"]="Loading-attribute-polyfill"
    ["tocbot"]="Tocbot"
  )

  local -a target_pkgs=()

  if [[ -n "$target" ]]; then
    local matched=false
    for pkg in "${!deps[@]}"; do
      if [[ "${pkg##*/}" == "$target" ]]; then
        target_pkgs+=("$pkg")
        matched=true
        break
      fi
    done

    if [[ "$matched" == false ]]; then
      echo "Error: unknown package '$target'" >&2
      echo "Available packages:" >&2
      for pkg in "${!deps[@]}"; do echo "  ${pkg##*/}" >&2; done
      exit 1
    fi

    echo -e "\nRunning ncu -u for $target..."
    ncu -u --packageFile "$PACKAGE_JSON" --filter "${target_pkgs[0]}"
  else
    echo -e "\nRunning ncu -u to upgrade package.json..."
    ncu -u --packageFile "$PACKAGE_JSON"
    target_pkgs=("${!deps[@]}")
  fi

  declare -A old_versions
  for pkg in "${target_pkgs[@]}"; do
    old_versions["$pkg"]=$(readme_version "${deps[$pkg]}")
  done

  for pkg in "${target_pkgs[@]}"; do
    readme_key="${deps[$pkg]}"
    pkg_name="${pkg##*/}"
    update_fn="update_${pkg_name//-/_}"
    run_if_updated "$pkg" "$readme_key" "$update_fn"
  done

  # Build update summary
  declare -a changed_pkgs=()
  declare -a changed_old=()
  declare -a changed_new=()
  for pkg in "${target_pkgs[@]}"; do
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
    max_new_len=0
    for i in "${!changed_pkgs[@]}"; do
      [[ ${#changed_pkgs[$i]} -gt $max_pkg_len ]] && max_pkg_len=${#changed_pkgs[$i]}
      [[ ${#changed_old[$i]} -gt $max_old_len ]] && max_old_len=${#changed_old[$i]}
      [[ ${#changed_new[$i]} -gt $max_new_len ]] && max_new_len=${#changed_new[$i]}
    done

    summary_lines=()
    for i in "${!changed_pkgs[@]}"; do
      summary_lines+=("$(printf " %-*s  %*s → %*s" \
        "$max_pkg_len" "${changed_pkgs[$i]}" \
        "$max_old_len" "${changed_old[$i]}" \
        "$max_new_len" "${changed_new[$i]}")")
    done

    sep() { printf "%-${1}s\n" "" | tr " " "-"; }

    echo -e "\n-- Suggested git commit message --"
    echo "chore(deps): update static assets"
    echo ""
    for line in "${summary_lines[@]}"; do echo "$line"; done
  fi
}

main "$@"
