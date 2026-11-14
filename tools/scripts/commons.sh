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
  sudo -v || return 1
  # Keep the sudo timestamp alive while the script runs, so commands behind
  # the spinner never stop to ask for the password
  ( while kill -0 "$$" 2>/dev/null; do sudo -n true 2>/dev/null; sleep 50; done ) &
}

# ---------------------------------------------------------------------------
# Shared helpers (paths, prompts, symlinks, zsh fragments)
# ---------------------------------------------------------------------------

# Absolute path of the repo, independent of the current directory
DOTFILES="${DOTFILES:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
export DOTFILES
ZSH_CONF_D="$DOTFILES/.config/zsh/conf.d"

if [[ -t 1 ]]; then
  C_GREEN=$'\e[32m'; C_YELLOW=$'\e[33m'; C_RED=$'\e[31m'; C_DIM=$'\e[2m'; C_RESET=$'\e[0m'
else
  C_GREEN=""; C_YELLOW=""; C_RED=""; C_DIM=""; C_RESET=""
fi

# ask_yes_no "question" [default y|n] -> 0 when yes
function ask_yes_no() {
  local question="$1" default="${2:-n}" hint reply
  [[ "$default" == "y" ]] && hint="[Y/n]" || hint="[y/N]"
  read -r -p "$question $hint " reply || reply=""
  reply="${reply:-$default}"
  [[ "$reply" =~ ^[yYsS]$ ]]
}

# Status of a link: linked | missing | conflict | broken-src
function link_status() {
  local src="$1" dest="$2"
  [[ -e "$src" ]] || { echo "broken-src"; return; }
  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$(readlink -f "$dest")" == "$(readlink -f "$src")" ]]; then
      echo "linked"
    else
      echo "conflict"
    fi
  else
    echo "missing"
  fi
}

function describe_conflict() {
  local dest="$1"
  if [[ -L "$dest" ]]; then
    echo "symlink -> $(readlink "$dest")"
  elif [[ -d "$dest" ]]; then
    echo "directory (real)"
  else
    echo "file (real)"
  fi
}

function link_item() {
  mkdir -p "$(dirname "$2")"
  ln -sfn "$1" "$2" && echo "  ${C_GREEN}linked${C_RESET} $2 -> $1"
}

# Ask what to do with an existing dest: replace / backup / skip
function resolve_conflict() {
  local src="$1" dest="$2" reply backup
  echo "$dest already exists: $(describe_conflict "$dest")"
  read -r -p "  [r]eplace (delete + link) / [b]ackup + link / [s]kip? [r/b/S] " reply || reply=""
  case "$reply" in
    r|R)
      if [[ -d "$dest" && ! -L "$dest" ]]; then
        ask_yes_no "  Really DELETE directory $dest and its contents?" n || { echo "  skipped."; return 0; }
      fi
      rm -rf -- "$dest" && link_item "$src" "$dest"
      ;;
    b|B)
      backup="$dest.bak.$(date +%Y%m%d%H%M%S)"
      mv -- "$dest" "$backup" && echo "  backup: $backup" && link_item "$src" "$dest"
      ;;
    *) echo "  skipped." ;;
  esac
}

# link_path <src> <dest>: link if missing, report if ok, ask if conflict
function link_path() {
  local src="$1" dest="$2"
  case "$(link_status "$src" "$dest")" in
    linked)     echo "  ${C_GREEN}[ok]${C_RESET} $dest already linked" ;;
    missing)    link_item "$src" "$dest" ;;
    conflict)   resolve_conflict "$src" "$dest" ;;
    broken-src) echo "  ${C_RED}[skip]${C_RESET} source not found: $src" ;;
  esac
}

# write_zsh_fragment <name>: stdin -> .config/zsh/conf.d/<name>.zsh
# Idempotent: overwrites, and stays quiet when the content did not change
function write_zsh_fragment() {
  local file="$ZSH_CONF_D/$1.zsh" content
  content="$(cat)"
  mkdir -p "$ZSH_CONF_D"
  if [[ -f "$file" && "$(cat "$file")" == "$content" ]]; then
    return 0
  fi
  printf '%s\n' "$content" > "$file"
  echo "  zsh config written: $file"
}

# already_installed <label>: message used by optional installers before skipping
function already_installed() {
  echo "  ${C_GREEN}✔${C_RESET} $1 ${C_DIM}already installed, skipping${C_RESET}"
  declare -F record_result >/dev/null && record_result skip "$1"
}

# shellcheck source=ui.sh
source "$(dirname "${BASH_SOURCE[0]}")/ui.sh"
