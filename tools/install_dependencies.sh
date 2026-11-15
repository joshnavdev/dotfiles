#!/usr/bin/env bash

function install_dependencies() {
  install_basic_dependencies curl git vim tmux ripgrep:rg unzip

  # fc-cache registers the fonts installed by tools/scripts/fonts.sh
  is_macos || install_basic_dependencies fontconfig:fc-cache
}
