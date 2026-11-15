#!/usr/bin/env bash

# install_and_config_nvim <version>   e.g. "0.11" -> builds branch release-0.11
function install_and_config_nvim() {
  if [ "$#" -ne 1 ]; then
    echo "Error: give the version as a argument"
    return 1
  fi

  local version="release-$1"

  if validate_command nvim; then
    already_installed "NeoVim ($(nvim --version | head -n 1))"
    return 0
  fi

  if is_macos; then
    ensure_homebrew
    run "Installing NeoVim (brew)" brew install neovim
    return $?
  fi

  run "Installing build dependencies" sudo apt-get install -y ninja-build gettext cmake unzip curl build-essential || return 1

  local src="$HOME/_neovim"
  if [ ! -d "$src/.git" ]; then
    run "Cloning neovim ($version)" git clone --depth 1 --branch "$version" https://github.com/neovim/neovim "$src" || return 1
  fi

  run "Compiling NeoVim (this takes a few minutes)" make -C "$src" CMAKE_BUILD_TYPE=Release || return 1
  run "Installing NeoVim" sudo make -C "$src" install
}
