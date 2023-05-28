#!/bin/sh
echo "This is the initial installation created by JoshNavDev"

function install_dependencies() {
  declare -a basic_dependencies=(curl git vim tmux)

  install_basic_dependencies "${basic_dependencies[@]}"
  initial_config

  install_and_config_zsh
  install_and_config_starship
  install_and_config_tmux
}

# TODO: Install neovim
