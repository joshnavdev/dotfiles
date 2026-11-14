#!/usr/bin/env bash

# Claude Code (CLI) with the official native installer -> ~/.local/bin/claude
# ~/.local/bin is already in PATH via .zshrc, so no zsh fragment is needed
function claude_is_installed() {
  [ -x "$HOME/.local/bin/claude" ] || validate_command claude
}

function install_claude() {
  if claude_is_installed; then
    already_installed "CLAUDE CODE"
    return 0
  fi

  ask_yes_no "¿Instalar CLAUDE CODE?" || return 0

  run "Installing Claude Code" bash -c 'curl -fsSL https://claude.ai/install.sh | bash'
  echo "  ${C_DIM}Run 'claude' in a new terminal to sign in.${C_RESET}"
}
