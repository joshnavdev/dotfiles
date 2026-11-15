#!/usr/bin/env bash

function tmuxifier_zsh_fragment() {
  write_zsh_fragment tmuxifier <<'ZSH'
export TMUXIFIER_LAYOUT_PATH="$XDG_CONFIG_HOME/tmux/layouts"
[ -d "$HOME/.tmuxifier/bin" ] && export PATH="$HOME/.tmuxifier/bin:$PATH"
command -v tmuxifier >/dev/null && eval "$(tmuxifier init -)"
ZSH
}

function install_tmuxifier() {
  if [ -d "$HOME/.tmuxifier" ]; then
    already_installed "TMUXIFIER"
    tmuxifier_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar TMUXIFIER (layouts de tmux)?" || return 0

  run "Cloning tmuxifier" git clone https://github.com/jimeh/tmuxifier.git "$HOME/.tmuxifier"
  tmuxifier_zsh_fragment
}
