#!/usr/bin/env bash
# Monaspace fonts (github.com/githubnext/monaspace) + Monaspace Xenon NF as terminal font.
#
#   Nerd Font variant (Monaspace * NF): terminal, needed for the starship icons
#   Static variant (Monaspace *):       editors / IDEs
#
# Usage: bash tools/scripts/fonts.sh   (also sourced by init.sh)

if ! declare -F ask_yes_no >/dev/null; then
  # shellcheck source=commons.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/commons.sh"
fi

MONASPACE_REPO="githubnext/monaspace"
MONASPACE_FALLBACK_VERSION="v1.400"
TERMINAL_FONT_FAMILY="Monaspace Xenon NF"
TERMINAL_FONT_SIZE="11"

function monaspace_font_dir() {
  if is_macos; then
    echo "$HOME/Library/Fonts"
  else
    echo "$HOME/.local/share/fonts/monaspace"
  fi
}

function monaspace_marker_file() {
  echo "$(monaspace_font_dir)/.monaspace-version"
}

function monaspace_latest_version() {
  local tag
  tag="$(curl -fsSL "https://api.github.com/repos/$MONASPACE_REPO/releases/latest" 2>/dev/null |
    sed -nE 's/.*"tag_name": *"([^"]+)".*/\1/p' | head -n 1)"
  echo "${tag:-$MONASPACE_FALLBACK_VERSION}"
}

# monaspace_download_and_copy <version>: downloads the NF + static zips and copies the .otf files
function monaspace_download_and_copy() {
  local version="$1" work_dir font_dir variant
  work_dir="$(mktemp -d)"
  font_dir="$(monaspace_font_dir)"
  mkdir -p "$font_dir"

  for variant in nerdfonts static; do
    curl -fsSL -o "$work_dir/$variant.zip" \
      "https://github.com/$MONASPACE_REPO/releases/download/$version/monaspace-$variant-$version.zip" || return 1
    mkdir -p "$work_dir/$variant"
    unzip -q -o "$work_dir/$variant.zip" -d "$work_dir/$variant" || return 1
    find "$work_dir/$variant" -type f -name 'Monaspace*.otf' -exec cp -f {} "$font_dir/" \;
  done

  rm -rf "$work_dir"
  echo "$version" >"$(monaspace_marker_file)"
}

function install_monaspace() {
  local installed latest
  installed="$(cat "$(monaspace_marker_file)" 2>/dev/null)"
  latest="$(monaspace_latest_version)"

  if [[ -n "$installed" && "$installed" == "$latest" ]]; then
    already_installed "Monaspace $installed"
    return 0
  fi

  local label="Installing Monaspace $latest"
  [[ -n "$installed" ]] && label="Updating Monaspace $installed -> $latest"
  run "$label (Nerd Font + static)" monaspace_download_and_copy "$latest" || return 1

  if ! is_macos; then
    run "Refreshing font cache" fc-cache -f "$(monaspace_font_dir)"
  fi
}

# --------------------------------------------------------------------------
# Terminal font
# --------------------------------------------------------------------------

function set_ptyxis_font() {
  validate_command ptyxis && validate_command gsettings || return 0

  local wanted="$TERMINAL_FONT_FAMILY $TERMINAL_FONT_SIZE" current use_system
  current="$(gsettings get org.gnome.Ptyxis font-name 2>/dev/null | tr -d "'")"
  use_system="$(gsettings get org.gnome.Ptyxis use-system-font 2>/dev/null)"

  if [[ "$use_system" == "false" && "$current" == "$TERMINAL_FONT_FAMILY"* ]]; then
    already_installed "Ptyxis font ($current)"
    return 0
  fi

  echo "  Ptyxis font now: $([[ "$use_system" == "true" ]] && echo "system font" || echo "$current")"
  ask_yes_no "  ¿Usar '$wanted' en Ptyxis?" y || return 0
  gsettings set org.gnome.Ptyxis use-system-font false &&
    gsettings set org.gnome.Ptyxis font-name "$wanted" &&
    echo "  ${C_GREEN}✔${C_RESET} Ptyxis font: $wanted" && record_result ok "Ptyxis font: $wanted"
}

function warp_settings_file() {
  local candidate
  for candidate in "$HOME/.config/warp-terminal/settings.toml" "$HOME/.warp/settings.toml"; do
    [[ -f "$candidate" ]] && { echo "$candidate"; return 0; }
  done
  return 1
}

# Sets appearance.text.font_name in Warp's settings.toml (toml_set_key keeps the rest of the file)
function set_warp_font() {
  local settings current
  settings="$(warp_settings_file)" || return 0

  current="$(sed -nE '/^\[appearance\.text\]/,/^\[/{s/^font_name *= *"([^"]*)".*/\1/p}' "$settings")"
  if [[ "$current" == "$TERMINAL_FONT_FAMILY" ]]; then
    already_installed "Warp font ($current)"
    return 0
  fi

  echo "  Warp font now: ${current:-default}"
  ask_yes_no "  ¿Usar '$TERMINAL_FONT_FAMILY' en Warp?" y || return 0

  toml_set_key "$settings" appearance.text font_name "\"$TERMINAL_FONT_FAMILY\"" || return 1
  echo "  ${C_GREEN}✔${C_RESET} Warp font: $TERMINAL_FONT_FAMILY ${C_DIM}(backup: $settings.bak, restart Warp)${C_RESET}"
  record_result ok "Warp font: $TERMINAL_FONT_FAMILY"
}

function install_and_config_fonts() {
  install_monaspace || return 1
  set_ptyxis_font
  set_warp_font
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  install_and_config_fonts
fi
