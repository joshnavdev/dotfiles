#!/usr/bin/env bash

function init_installation() {
  sudo apt-get update
}

function install_basic_dependencies() {
  local basic_dependencies=("$@")

  for basic_dependency in "${basic_dependencies[@]}"
  do
    echo ""
    echo "Check if $basic_dependency is installed"
    validate_command_and_print $basic_dependency

    if [ $? -eq 0 ]; then
      echo "Installing..."
      install_dependency $basic_dependency --with-sudo --with-yes
    fi
  done
}

function initial_config() {
  DOTFILE="$(pwd)"
  CONFIG_FOLDER=$HOME/.config

  is_directory $CONFIG_FOLDER
  if [ $? -eq 0 ]; then
    echo "Creating soft link to $CONFIG_FOLDER"
    ln -s $DOTFILE/.config $HOME/.config
  fi
}
