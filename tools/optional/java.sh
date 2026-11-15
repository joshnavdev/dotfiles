#!/usr/bin/env bash

# Java (+ Maven) through SDKMAN, so no hardcoded JAVA_HOME paths are needed
SDKMAN_DIR_PATH="$HOME/.sdkman"

function java_is_installed() {
  [ -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ] && [ -e "$SDKMAN_DIR_PATH/candidates/java/current" ]
}

function java_zsh_fragment() {
  # SDKMAN must be initialised at the END of the zsh startup (zz- prefix)
  write_zsh_fragment zz-sdkman <<'ZSH'
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
ZSH
}

# `sdk` is a shell function: run it in a subshell that sources the init file
function sdk_run() {
  bash -c "source '$SDKMAN_DIR_PATH/bin/sdkman-init.sh' && sdk $*"
}

function install_java() {
  if java_is_installed; then
    already_installed "JAVA (SDKMAN)"
    java_zsh_fragment
    return 0
  fi

  ask_yes_no "¿Instalar JAVA (SDKMAN)?" || return 0

  if [ ! -s "$SDKMAN_DIR_PATH/bin/sdkman-init.sh" ]; then
    is_macos || run "Installing zip/unzip" sudo apt-get install -y zip unzip curl
    run "Installing SDKMAN" bash -c 'curl -fsSL "https://get.sdkman.io?rcupdate=false" | bash'
  fi

  # Never block on SDKMAN prompts
  sed -i.bak 's/^sdkman_auto_answer=.*/sdkman_auto_answer=true/' "$SDKMAN_DIR_PATH/etc/config" && rm -f "$SDKMAN_DIR_PATH/etc/config.bak"
  java_zsh_fragment

  local java_version=""
  read -r -p "  Versión de Java (ej. 21-tem, vacío = default de SDKMAN): " java_version || true
  run "Installing Java ${java_version:-(default)}" sdk_run install java "$java_version"

  if [ ! -e "$SDKMAN_DIR_PATH/candidates/maven/current" ] && ask_yes_no "  ¿Instalar Maven?" y; then
    run "Installing Maven" sdk_run install maven
  fi
}
