#!/usr/bin/env bash

FNM_DIR="$HOME/.local/share/fnm"

function fnm_is_installed() {
  [ -x "$FNM_DIR/fnm" ] || validate_command fnm
}

function fnm_zsh_fragment() {
  write_zsh_fragment fnm <<'ZSH'
[ -d "$HOME/.local/share/fnm" ] && export PATH="$HOME/.local/share/fnm:$PATH"
command -v fnm >/dev/null && eval "$(fnm env --use-on-cd)"
ZSH
}

function install_fnm() {
  if fnm_is_installed; then
    already_installed "FNM (Node)"
    fnm_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar FNM (Node)?" || return 0

  if is_macos; then
    ensure_homebrew
    run "Installing fnm (brew)" brew install fnm
  else
    run "Installing fnm" bash -c "curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir '$FNM_DIR' --skip-shell"
  fi
  fnm_zsh_fragment

  export PATH="$FNM_DIR:$PATH"
  if ask_yes_no "  ¿Instalar Node LTS con fnm?" y; then
    run "Installing Node LTS" fnm install --lts
  fi
}
