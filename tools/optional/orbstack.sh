#!/usr/bin/env bash

# OrbStack is macOS only
function orbstack_zsh_fragment() {
  write_zsh_fragment orbstack <<'ZSH'
[ -S "$HOME/.orbstack/run/docker.sock" ] && export DOCKER_HOST="unix://$HOME/.orbstack/run/docker.sock"
ZSH
}

function install_orbstack() {
  is_macos || return 0

  if [ -d "/Applications/OrbStack.app" ]; then
    already_installed "ORBSTACK"
    orbstack_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar ORBSTACK (OrbStack)?" || return 0

  ensure_homebrew
  run "Installing OrbStack" brew install --cask orbstack
  orbstack_zsh_fragment
}
