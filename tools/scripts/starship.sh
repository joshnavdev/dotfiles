#!/usr/bin/env bash

function install_starship() {
  echo ""
  echo "Check if StarShip is installed"

  validate_command_and_print "starship"
  if [ $? -eq 0 ]; then
   curl -sS https://starship.rs/install.sh | sh
  fi
}

function install_and_config_starship() {
  install_starship
}
