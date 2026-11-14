#!/usr/bin/env bash

function go_zsh_fragment() {
  write_zsh_fragment go <<'ZSH'
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
ZSH
}

function install_go() {
  if validate_command go; then
    already_installed "GO"
    go_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar GO?" || return 0

  if is_macos; then
    ensure_homebrew
    run "Installing Go (brew)" brew install go
  else
    run "Installing Go" sudo apt-get install -y golang-go
  fi
  go_zsh_fragment
}
