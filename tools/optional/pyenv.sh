#!/usr/bin/env bash

function pyenv_is_installed() {
  [ -d "$HOME/.pyenv" ] || validate_command pyenv
}

function pyenv_zsh_fragment() {
  write_zsh_fragment pyenv <<'ZSH'
export PYENV_ROOT="$HOME/.pyenv"
[ -d "$PYENV_ROOT/bin" ] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv >/dev/null && eval "$(pyenv init -)"
ZSH
}

function install_pyenv() {
  if pyenv_is_installed; then
    already_installed "PYENV (Python)"
    pyenv_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar PYENV (Python)?" || return 0

  if is_macos; then
    ensure_homebrew
    run "Installing pyenv (brew)" brew install pyenv
  else
    run "Installing Python build dependencies" sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
      libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils tk-dev \
      libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    run "Installing pyenv" bash -c 'curl -fsSL https://pyenv.run | bash'
  fi
  pyenv_zsh_fragment
}
