#!/usr/bin/env bash

function bun_is_installed() {
  [ -x "$HOME/.bun/bin/bun" ] || validate_command bun
}

function bun_zsh_fragment() {
  write_zsh_fragment bun <<'ZSH'
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
ZSH
}

function install_bun() {
  if bun_is_installed; then
    already_installed "BUN"
    bun_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar BUN?" || return 0

  is_macos || run "Installing unzip" sudo apt-get install -y unzip curl
  run "Installing bun" bash -c 'curl -fsSL https://bun.sh/install | bash'
  bun_zsh_fragment
}
