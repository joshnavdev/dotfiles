#!/usr/bin/env bash
# Manual step (only if you use IntelliJ / JetBrains IDEs with the IdeaVim plugin):
#   bash tools/manual/ideavim.sh
# Links ~/.ideavimrc -> <repo>/.ideavimrc. Not run by init.sh.

if ! declare -F link_path >/dev/null; then
  # shellcheck source=../scripts/commons.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)/scripts/commons.sh"
fi

function config_ideavim() {
  echo ""
  echo "Config .ideavimrc file"
  link_path "$DOTFILES/.ideavimrc" "$HOME/.ideavimrc"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  config_ideavim
fi
