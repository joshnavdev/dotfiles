#!/usr/bin/env bash
# Bootstrap this machine with the dotfiles.
#
# Usage: bash init.sh [--verbose]
#   --verbose  show the full output of every command (default: spinner + log file)

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES
cd "$DOTFILES" || exit 1

for arg in "$@"; do
  case "$arg" in
    -v|--verbose) export VERBOSE=1 ;;
    -h|--help) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
  esac
done

export DOTFILES_LOG="$HOME/.dotfiles-install.log"
export STEP_TOTAL=10

source tools/scripts/commons.sh
source tools/scripts/base_dependencies.sh
source tools/install_dependencies.sh
source tools/scripts/zsh.sh
source tools/scripts/starship.sh
source tools/scripts/fonts.sh
source tools/scripts/tmux.sh
source tools/gitconfig.sh
source tools/theme.sh
source tools/neovim_install.sh
source tools/optional/all.sh

: >"$DOTFILES_LOG"
log_line "dotfiles install - $(date)" "DOTFILES=$DOTFILES"

banner "dotfiles · JoshNavDev" "$(uname -s) · log: $DOTFILES_LOG"
[[ "$VERBOSE" == "1" ]] || echo "  ${C_DIM}Command output goes to the log. Use --verbose to see it live.${C_RESET}"

request_sudo || { echo "sudo is required"; exit 1; }

step "System packages"
init_installation
install_dependencies

step "Zsh" "antigen + login shell + .zshrc"
install_and_config_zsh

step "Starship" "prompt"
install_and_config_starship

step "Fonts" "Monaspace · Xenon NF in the terminal"
install_and_config_fonts

step "Tmux" "config + TPM plugins"
install_and_config_tmux

step "NeoVim" "release-0.11"
install_and_config_nvim "0.11"

step "Config links" "~/.config"
bash tools/link_config.sh

step "Theme" "Warp · Ptyxis · tmux · nvim"
setup_theme

step "Git" "profiles per folder"
setup_gitconfig

step "Optional tools"
install_optional_tools

print_summary

banner "Health check" "tools/doctor.sh"
bash tools/doctor.sh

echo ""
echo "Manual steps (only if needed):"
echo "  - IntelliJ + IdeaVim: bash tools/manual/ideavim.sh"
echo "  - Re-run git profiles: bash tools/gitconfig.sh"
echo "  - Change theme: bash tools/theme.sh set <name>"
echo "  - Health check: bash tools/doctor.sh"
echo ""
echo "${C_BOLD}Done.${C_RESET} Open a new terminal (or run: exec zsh) to load the new config."
