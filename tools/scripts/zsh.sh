#!/usr/bin/env bash

function install_zsh() {
  if validate_command zsh; then
    already_installed "zsh"
  else
    run "Installing zsh" install_dependency "zsh" --with-sudo --with-yes
  fi
}

function install_antigen() {
  local antigen_file="$HOME/antigen.zsh"

  if [ -s "$antigen_file" ]; then
    already_installed "antigen"
    return 0
  fi

  run "Downloading antigen" curl -fsSL https://raw.githubusercontent.com/zsh-users/antigen/master/bin/antigen.zsh -o "$antigen_file"
}

function config_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)" || return 1

  if [[ "$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)" == "$zsh_path" || "$SHELL" == "$zsh_path" ]]; then
    already_installed "zsh as login shell"
  else
    # sudo is already cached by request_sudo, so chsh does not ask for the password
    run "Setting zsh as login shell" sudo chsh -s "$zsh_path" "$USER"
  fi
}

function config_zsh() {
  config_shell
  mkdir -p "$ZSH_CONF_D"
  link_path "$DOTFILES/.zshrc" "$HOME/.zshrc"
}

function install_and_config_zsh() {
  install_zsh
  install_antigen
  config_zsh
}
