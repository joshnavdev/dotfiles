#!/bin/sh

function install_and_config_nvim() {
  if [ "$#" -ne 1 ]; then
    echo "Error: give the version as a argument"
    exit 1
  fi

  version="realse-$1"

  echo "NeoVim Installation with version $version"

  if [ -x "$(command -v nvim)" ]; then
    echo 'NeoVim is already installed.'
  else
    sudo apt-get install ninja-build gettext cmake unzip curl
    mkdir -p $HOME/_neovim
    git clone https://github.com/neovim/neovim $HOME/_neovim
    cd $HOME/_neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo
    git checkout $version
    sudo make install
  fi
}
