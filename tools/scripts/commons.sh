#!/usr/bin/env bash

function is_file() {
  if [ -f "$1" ]; then
    echo "$1 file exists"
    return 1
  else
    echo "$1 file does not exist"
    return 0
  fi
}

function is_directory() {
  if [ -d "$1" ]; then
    echo "$1 directory exists"
    return 1
  else
    echo "$1 directory does not exist"
    return 0
  fi
}

function validate_command() {
  input_command=$1

  command -v "$input_command" >/dev/null 2>&1
}

function validate_command_and_print() {
  input_command=$1

  if validate_command $input_command; then
    echo "$input_command is installed"
    return 1
  else
    echo "$input_command is not installed"
    return 0
  fi
}

# Detect if macOS (Darwin)
function is_macos() {
  [[ "$(uname)" == "Darwin" ]]
}

# Ensure Homebrew is available (install if missing) and load it in current shell
function ensure_homebrew() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  # Try common locations to init brew in current shell if already installed
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$('/opt/homebrew/bin/brew' shellenv)"
    return 0
  fi
  if [ -x "/usr/local/bin/brew" ]; then
    eval "$('/usr/local/bin/brew' shellenv)"
    return 0
  fi

  echo "Homebrew not found. Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Try to load brew again after installation
  if [ -x "/opt/homebrew/bin/brew" ]; then
    eval "$('/opt/homebrew/bin/brew' shellenv)"
  elif [ -x "/usr/local/bin/brew" ]; then
    eval "$('/usr/local/bin/brew' shellenv)"
  fi
}

function install_dependency() {
  local dependency="$1"
  local with_yes=""
  local with_sudo=""

  if [[ "$2" == "--with-sudo" ]]; then
    with_sudo="sudo"
  fi

  if [[ "$3" == "--with-yes" ]]; then
    with_yes="--yes"
  fi

  if is_macos; then
    ensure_homebrew
    echo "brew install $dependency >/dev/null"
    brew install "$dependency" >/dev/null
  else
    echo "$with_sudo apt-get install $with_yes $dependency>/dev/null"
    $with_sudo apt-get install $with_yes "$dependency" >/dev/null
  fi
}

request_sudo() {
  sudo -v
}
