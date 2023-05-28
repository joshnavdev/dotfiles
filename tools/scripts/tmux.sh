#!/usr/bin/env bash

function install_tpm() {
  TPM_FOLDER="$HOME/.tmux/plugins/tpm"

  is_directory "$TPM_FOLDER"
  if [ $? -eq 0 ]; then
    echo "Installing TPM"

    git clone https://github.com/tmux-plugins/tpm $TPM_FOLDER
  fi
}

function config_tmux() {
  DOTFILES="$(pwd)"
  TMUX_CONF="$HOME/.tmux.conf"

  is_file "$TMUX_CONF"
  if [ $? -eq 0 ]; then
    echo "Creating soft link to $TMUX_CONF"
    ln -s $DOTFILES/.config/tmux/tmux.conf $TMUX_CONF
  fi
}

function install_and_config_tmux() {
  install_tpm
  config_tmux
}
