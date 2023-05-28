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

  echo "$with_sudo apt-get install $with_yes $dependency>/dev/null"
  $with_sudo apt-get install $with_yes $dependency>/dev/null
}

request_sudo() {
  sudo -v
}
