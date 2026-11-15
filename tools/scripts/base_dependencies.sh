#!/usr/bin/env bash

function init_installation() {
  if is_macos; then
    ensure_homebrew
    run "Updating Homebrew" brew update
  else
    run "Updating apt package index" sudo apt-get update
  fi
}

# install_basic_dependencies pkg[:command] ...
# e.g. ripgrep:rg -> installs package "ripgrep", checks command "rg"
function install_basic_dependencies() {
  local entry package cmd
  for entry in "$@"; do
    package="${entry%%:*}"
    cmd="${entry#*:}"
    if validate_command "$cmd"; then
      already_installed "$package"
    else
      run "Installing $package" install_dependency "$package" --with-sudo --with-yes
    fi
  done
}
