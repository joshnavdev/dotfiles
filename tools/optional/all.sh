#!/usr/bin/env bash
# Loads every optional installer and runs them one by one (each asks first).

OPTIONAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for _f in fnm java bun docker orbstack go pyenv tmuxifier; do
  # shellcheck source=/dev/null
  source "$OPTIONAL_DIR/$_f.sh"
done
unset _f

function install_optional_tools() {
  echo "  ${C_DIM}Each tool asks y/N; already installed ones are skipped.${C_RESET}"
  install_fnm
  install_java
  install_bun
  install_docker
  install_orbstack
  install_go
  install_pyenv
  install_tmuxifier
}
