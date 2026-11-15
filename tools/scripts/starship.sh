#!/usr/bin/env bash

function install_starship() {
  if validate_command starship; then
    already_installed "starship"
  else
    run "Installing starship" bash -c 'curl -fsSL https://starship.rs/install.sh | sh -s -- -y'
  fi
}

function install_and_config_starship() {
  install_starship
}
