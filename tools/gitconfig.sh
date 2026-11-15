#!/usr/bin/env bash
# Interactive ~/.gitconfig generator with per-folder profiles (work, personal, ...).
#
# Each profile = folder + email + SSH key. Git picks the profile with
# `includeIf "gitdir:<folder>/"`, so every repo under that folder commits with
# that email and pushes with that SSH key.
#
#   ~/.gitconfig                       name, editor, includeIf per profile
#   ~/.config/git/profiles/<name>.gitconfig   user.email + core.sshCommand
#
# Usage: bash tools/gitconfig.sh       (also sourced by init.sh: setup_gitconfig)

if ! declare -F ask_yes_no >/dev/null; then
  # shellcheck source=scripts/commons.sh
  source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/scripts/commons.sh"
fi

GIT_PROFILES_DIR="$HOME/.config/git/profiles"

# ask_value "Question" "default" -> echoes the answer (default when empty)
function ask_value() {
  local question="$1" default="${2:-}" reply
  if [[ -n "$default" ]]; then
    read -r -p "$question [$default]: " reply || reply=""
  else
    read -r -p "$question: " reply || reply=""
  fi
  echo "${reply:-$default}"
}

# Paths: expand ~ for checks, store with ~ in the config (portable between machines)
function expand_home() { echo "${1/#\~/$HOME}"; }
function tilde_home()  { [[ "$1" == "$HOME"* ]] && echo "~${1#"$HOME"}" || echo "$1"; }

# Choose an existing private key in ~/.ssh or create a new ed25519 one
function choose_ssh_key() {
  local profile="$1" email="$2" keys=() i choice key
  for pub in "$HOME"/.ssh/*.pub; do
    [[ -f "$pub" && -f "${pub%.pub}" ]] && keys+=("${pub%.pub}")
  done

  {
    echo "  SSH key for '$profile':"
    for i in "${!keys[@]}"; do echo "    $((i + 1))) $(tilde_home "${keys[$i]}")"; done
    echo "    n) create a new key (~/.ssh/$profile)"
    echo "    s) none (use the default ssh agent/keys)"
  } >&2
  read -r -p "  Choice: " choice || choice="s"

  if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= ${#keys[@]})); then
    key="${keys[$((choice - 1))]}"
  elif [[ "$choice" =~ ^[nN]$ ]]; then
    key="$HOME/.ssh/$profile"
    if [[ -e "$key" ]]; then
      echo "  $key already exists, reusing it" >&2
    else
      mkdir -p "$HOME/.ssh" && chmod 700 "$HOME/.ssh"
      ssh-keygen -t ed25519 -C "$email" -f "$key" >&2 || return 1
      echo "  Add this public key to GitHub/GitLab (Settings > SSH keys):" >&2
      cat "$key.pub" >&2
    fi
  else
    key=""
  fi
  echo "$key"
}

# configure_profile <name> <default folder> [--no-ask]
# Writes $tmp_dir/<name>.gitconfig and adds its includeIf to $tmp_global (set by setup_gitconfig)
function configure_profile() {
  local profile="$1" default_folder="$2" folder email key tmp_profile
  echo ""
  if [[ "${3:-}" != "--no-ask" ]]; then
    ask_yes_no "¿Configurar perfil '$profile'?" y || return 1
  fi

  folder="$(ask_value "  Carpeta de '$profile'" "$default_folder")"
  folder="$(tilde_home "$(expand_home "${folder%/}")")"
  email="$(ask_value "  Email de '$profile'" "$(git config --file "$GIT_PROFILES_DIR/$profile.gitconfig" user.email 2>/dev/null)")"
  key="$(choose_ssh_key "$profile" "$email")"

  tmp_profile="$tmp_dir/$profile.gitconfig"
  git config --file "$tmp_profile" user.email "$email"
  if [[ -n "$key" ]]; then
    git config --file "$tmp_profile" core.sshCommand "ssh -i $(tilde_home "$key") -o IdentitiesOnly=yes"
  fi
  git config --file "$tmp_global" "includeIf.gitdir:$folder/.path" "~/.config/git/profiles/$profile.gitconfig"
  mkdir -p "$(expand_home "$folder")"
}

function setup_gitconfig() {
  echo ""
  ask_yes_no "¿Configurar git (perfiles por carpeta: email + SSH)?" || return 0

  local tmp_global tmp_dir name editor
  tmp_dir="$(mktemp -d)"
  tmp_global="$tmp_dir/gitconfig"

  name="$(ask_value "Nombre para los commits" "$(git config --global user.name 2>/dev/null)")"
  editor="$(ask_value "Editor" "nvim")"

  git config --file "$tmp_global" user.name "$name"
  # No email outside a profile folder: git refuses to commit instead of guessing
  git config --file "$tmp_global" user.useConfigOnly true
  git config --file "$tmp_global" core.editor "$editor"
  git config --file "$tmp_global" init.defaultBranch main
  git config --file "$tmp_global" pull.rebase false
  git config --file "$tmp_global" push.autoSetupRemote true

  local profiles=() profile
  if configure_profile personal "~/workspace/own-projects"; then profiles+=(personal); fi
  if configure_profile work "~/workspace/work"; then profiles+=(work); fi
  while ask_yes_no "¿Agregar otro perfil?" n; do
    profile="$(ask_value "  Nombre del perfil (ej. freelance)" "")"
    [[ -z "$profile" ]] && break
    if configure_profile "$profile" "~/workspace/$profile" --no-ask; then profiles+=("$profile"); fi
  done

  echo ""
  echo "=== ~/.gitconfig (preview) ==="
  cat "$tmp_global"
  for profile in "${profiles[@]}"; do
    echo "=== ~/.config/git/profiles/$profile.gitconfig ==="
    cat "$tmp_dir/$profile.gitconfig"
  done
  echo ""

  if ! ask_yes_no "¿Guardar esta configuración?" y; then
    echo "  Nothing written."
    rm -rf "$tmp_dir"
    return 0
  fi

  if [[ -e "$HOME/.gitconfig" || -L "$HOME/.gitconfig" ]]; then
    local backup="$HOME/.gitconfig.bak.$(date +%Y%m%d%H%M%S)"
    mv -- "$HOME/.gitconfig" "$backup" && echo "  backup: $backup"
  fi
  mv -- "$tmp_global" "$HOME/.gitconfig"

  mkdir -p "$GIT_PROFILES_DIR"
  for profile in "${profiles[@]}"; do
    mv -- "$tmp_dir/$profile.gitconfig" "$GIT_PROFILES_DIR/$profile.gitconfig"
  done
  rm -rf "$tmp_dir"

  echo "  ${C_GREEN}saved${C_RESET} ~/.gitconfig + ${#profiles[@]} profile(s) in $(tilde_home "$GIT_PROFILES_DIR")"
  echo "  Check inside a repo with: git config user.email && git config core.sshCommand"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  setup_gitconfig
fi
