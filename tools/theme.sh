#!/usr/bin/env bash
# Theme manager: applies one theme from themes/<name>/ to every tool at once.
#
#   themes/<name>/theme.env        names per tool (NVIM_COLORSCHEME, PTYXIS_PALETTE, ...)
#   themes/<name>/warp.yaml        Warp theme (copied to the Warp themes folder)
#   themes/<name>/*.palette        Ptyxis palette (copied to its palettes folder)
#   themes/<name>/tmux.conf        tmux colors (sourced by .config/tmux/theme.tmux.conf)
#
# The chosen theme is remembered per machine as a symlink:
#   ~/.config/dotfiles/theme -> <repo>/themes/<name>
# tmux and nvim read their files through that link.
#
# Usage: bash tools/theme.sh list | current | set <name>

if ! declare -F ask_yes_no >/dev/null; then
  # shellcheck source=scripts/commons.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/commons.sh"
fi
if ! declare -F warp_settings_file >/dev/null; then
  # shellcheck source=scripts/fonts.sh
  source "$DOTFILES/tools/scripts/fonts.sh"
fi

THEMES_DIR="$DOTFILES/themes"
THEME_STATE_LINK="$HOME/.config/dotfiles/theme"
PTYXIS_PALETTES_DIR="$HOME/.local/share/org.gnome.Ptyxis/palettes"

function theme_list() {
  local dir
  for dir in "$THEMES_DIR"/*/; do
    [[ -f "$dir/theme.env" ]] && basename "$dir"
  done
}

function theme_current() {
  [[ -L "$THEME_STATE_LINK" && -d "$THEME_STATE_LINK" ]] || return 1
  basename "$(readlink -f "$THEME_STATE_LINK")"
}

# theme_env <name> <VAR>: value of VAR in themes/<name>/theme.env
function theme_env() {
  (
    # shellcheck source=/dev/null
    source "$THEMES_DIR/$1/theme.env" && printf '%s' "${!2}"
  )
}

# Warp only loads custom themes from its own themes folder. settings.toml stores the
# path relative to it (same as the Warp UI does), so Warp's settings sync works on
# Linux and macOS alike
function warp_themes_dir() {
  if is_macos; then
    echo "$HOME/.warp/themes"
  else
    echo "${XDG_DATA_HOME:-$HOME/.local/share}/warp-terminal/themes"
  fi
}

# Where theme_set copies themes/<name>/warp.yaml for Warp
function warp_theme_file() {
  echo "$(warp_themes_dir)/dotfiles-$1.yaml"
}

function theme_apply_warp() {
  local name="$1" settings yaml target label
  yaml="$THEMES_DIR/$name/warp.yaml"
  [[ -f "$yaml" ]] || { skip_tool "Warp" "no warp.yaml"; return 0; }
  settings="$(warp_settings_file)" || return 0

  target="$(warp_theme_file "$name")"
  mkdir -p "$(dirname "$target")"
  cp -f "$yaml" "$target" || return 1

  label="$(theme_env "$name" WARP_THEME_NAME)"
  toml_set_key "$settings" appearance.themes system_theme "false" &&
    toml_set_key "$settings" appearance.themes theme "{ custom = { name = \"$label\", path = \"$(basename "$target")\" } }" || return 1
  theme_ok "Warp: $label ${C_DIM}(restart Warp if it does not refresh)${C_RESET}"
}

function theme_apply_ptyxis() {
  local name="$1" palette_id palette_file uuid
  validate_command ptyxis && validate_command gsettings || return 0

  palette_id="$(theme_env "$name" PTYXIS_PALETTE)"
  [[ -n "$palette_id" ]] || { skip_tool "Ptyxis" "no PTYXIS_PALETTE"; return 0; }

  # Custom palette shipped with the theme (otherwise it must be a built-in one)
  palette_file="$THEMES_DIR/$name/$palette_id.palette"
  if [[ -f "$palette_file" ]]; then
    mkdir -p "$PTYXIS_PALETTES_DIR"
    cp -f "$palette_file" "$PTYXIS_PALETTES_DIR/"
  fi

  uuid="$(gsettings get org.gnome.Ptyxis default-profile-uuid | tr -d "'")"
  gsettings set "org.gnome.Ptyxis.Profile:/org/gnome/Ptyxis/Profiles/$uuid/" palette "$palette_id" || return 1
  theme_ok "Ptyxis: $palette_id"
}

function theme_apply_tmux() {
  local name="$1"
  [[ -f "$THEMES_DIR/$name/tmux.conf" ]] || { skip_tool "tmux" "no tmux.conf"; return 0; }
  if validate_command tmux && tmux info >/dev/null 2>&1; then
    tmux source-file "$HOME/.tmux.conf" >/dev/null 2>&1
    theme_ok "tmux: reloaded"
  else
    theme_ok "tmux: applied on next start"
  fi
}

function theme_apply_nvim() {
  local colorscheme
  colorscheme="$(theme_env "$1" NVIM_COLORSCHEME)"
  [[ -n "$colorscheme" ]] || { skip_tool "nvim" "no NVIM_COLORSCHEME"; return 0; }
  theme_ok "nvim: $colorscheme ${C_DIM}(reopen nvim)${C_RESET}"
}

function theme_ok() { echo "  ${C_GREEN}✔${C_RESET} $1"; }
function skip_tool() { echo "  ${C_DIM}- $1 skipped ($2)${C_RESET}"; }

function theme_set() {
  local name="$1"
  if [[ -z "$name" || ! -f "$THEMES_DIR/$name/theme.env" ]]; then
    echo "  ${C_RED}✘${C_RESET} unknown theme '$name'. Available: $(theme_list | tr '\n' ' ')"
    return 1
  fi

  mkdir -p "$(dirname "$THEME_STATE_LINK")"
  ln -sfn "$THEMES_DIR/$name" "$THEME_STATE_LINK"
  echo "  Theme: $(theme_env "$name" THEME_LABEL)"

  theme_apply_warp "$name"
  theme_apply_ptyxis "$name"
  theme_apply_tmux "$name"
  theme_apply_nvim "$name"
  declare -F record_result >/dev/null && record_result ok "Theme: $name"
  return 0
}

# init.sh step: keeps the current theme, otherwise asks which one to use
function setup_theme() {
  local current themes choice default="kanagawa"
  if current="$(theme_current)"; then
    already_installed "Theme $current"
    return 0
  fi

  themes="$(theme_list | tr '\n' ' ')"
  echo "  Available themes: $themes"
  read -r -p "  Theme [$default]: " choice || choice=""
  theme_set "${choice:-$default}"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  case "${1:-}" in
    list) theme_list ;;
    current) theme_current || { echo "no theme set (run: bash tools/theme.sh set <name>)"; exit 1; } ;;
    set) theme_set "${2:-}" ;;
    *) echo "Usage: bash tools/theme.sh list | current | set <name>"; echo "Themes: $(theme_list | tr '\n' ' ')"; exit 1 ;;
  esac
fi
