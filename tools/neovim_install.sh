#!/bin/sh
echo "NeoVim Installation"

if [ -x "$(command -v nvim)" ]; then
  echo 'NeoVim is already installed.'
else
  mkdir -p $HOME/_neovim
  curl -sL https://github.com/neovim/neovim/releases/download/v0.8.1/nvim-linux64.tar.gz | tar xzf - --strip-components=1 -C "${HOME}/_neovim"
  echo "PATH=\"${HOME}/_neovim/bin:${PATH}\"" >> "$(pwd)/.zshrc"
fi

