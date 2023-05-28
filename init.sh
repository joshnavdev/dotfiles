#!/bin/sh

source tools/scripts/commons.sh
source tools/scripts/base_dependencies.sh
source tools/install_dependencies.sh
source tools/scripts/zsh.sh
source tools/scripts/starship.sh
source tools/scripts/tmux.sh
source tools/neovim_install.sh

request_sudo
init_installation
install_dependencies
install_and_config_nvim "0.9"

# zsh


# bash tools/config_initial_sources.sh
# bash tools/neovim_install.sh

# zsh
