#!/usr/bin/env bash

# Docker Engine on Linux. On macOS use OrbStack (tools/optional/orbstack.sh)
function docker_ensure_group() {
  if ! id -nG "$USER" | grep -qw docker && ! getent group docker | grep -qw "$USER"; then
    sudo usermod -aG docker "$USER"
    echo "  Added $USER to the docker group (log out and back in, or: newgrp docker)"
  fi
}

function install_docker() {
  is_macos && return 0

  if validate_command docker; then
    already_installed "DOCKER"
    docker_ensure_group
    return 0
  fi

  ask_yes_no "¿Instalar DOCKER?" || return 0

  run "Installing Docker Engine" bash -c 'curl -fsSL https://get.docker.com | sudo sh'
  docker_ensure_group
}
