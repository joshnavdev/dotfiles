#!/usr/bin/env bash
# Symlinks the folders/files of <repo>/.config into ~/.config.
#
# - Scans first and prints a status table (linked / missing / conflict).
# - Asks for confirmation before creating the missing links.
# - For each conflict (existing dir/file/other symlink) asks what to do:
#   replace (delete + link), backup (move aside + link) or skip.
#
# Usage: bash tools/link_config.sh [--yes]
#   --yes  create missing links without asking (conflicts are still asked)

set -u

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=scripts/commons.sh
source "$DOTFILES/tools/scripts/commons.sh"

SRC_DIR="$DOTFILES/.config"
DEST_DIR="${HOME}/.config"
ITEMS=(nvim tmux zsh starship.toml)

ASSUME_YES=0
[[ "${1:-}" == "--yes" ]] && ASSUME_YES=1

mkdir -p "$DEST_DIR"

MISSING=(); CONFLICTS=()

echo "Scanning $DEST_DIR (source: $SRC_DIR)"
echo
for item in "${ITEMS[@]}"; do
  src="$SRC_DIR/$item"; dest="$DEST_DIR/$item"
  case "$(link_status "$src" "$dest")" in
    linked)     printf "  %s[ok]      %s  already linked%s\n" "$C_GREEN" "$item" "$C_RESET" ;;
    missing)    MISSING+=("$item");   printf "  %s[missing] %s  not present, will be linked%s\n" "$C_YELLOW" "$item" "$C_RESET" ;;
    conflict)   CONFLICTS+=("$item"); printf "  %s[exists]  %s  %s%s\n" "$C_RED" "$item" "$(describe_conflict "$dest")" "$C_RESET" ;;
    broken-src) printf "  %s[skip]    %s  not found in repo (%s)%s\n" "$C_DIM" "$item" "$src" "$C_RESET" ;;
  esac
done
echo

# 1) missing -> one confirmation for the whole list
if ((${#MISSING[@]})); then
  echo "To create:"
  for item in "${MISSING[@]}"; do echo "  $DEST_DIR/$item -> $SRC_DIR/$item"; done
  if ((ASSUME_YES)) || ask_yes_no "Create these ${#MISSING[@]} link(s)?" n; then
    for item in "${MISSING[@]}"; do link_item "$SRC_DIR/$item" "$DEST_DIR/$item"; done
  else
    echo "  skipped."
  fi
  echo
fi

# 2) conflicts -> one decision per item
for item in "${CONFLICTS[@]}"; do
  resolve_conflict "$SRC_DIR/$item" "$DEST_DIR/$item"
  echo
done

echo "Done."
