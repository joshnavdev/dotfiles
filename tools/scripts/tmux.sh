#!/usr/bin/env bash

function install_tpm() {
  local tpm_folder="$HOME/.tmux/plugins/tpm"

  if [ -d "$tpm_folder" ]; then
    already_installed "TPM"
  else
    run "Cloning TPM (tmux plugin manager)" git clone https://github.com/tmux-plugins/tpm "$tpm_folder"
  fi

  # Install the plugins declared in tmux config (no-op if already installed)
  if [ -x "$tpm_folder/bin/install_plugins" ]; then
    run "Installing tmux plugins" env TMUX_PLUGIN_MANAGER_PATH="$HOME/.tmux/plugins/" "$tpm_folder/bin/install_plugins"
  fi
}

function config_tmux() {
  link_path "$DOTFILES/.config/tmux/tmux.conf" "$HOME/.tmux.conf"
}

function install_and_config_tmux() {
  config_tmux
  install_tpm
}
