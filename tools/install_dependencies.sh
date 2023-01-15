#!/bin/sh
echo "This is the initial installation created by JoshNavDev"

declare -a basic_dependencies=(curl git vim tmux)

for basic_dependency in "${basic_dependencies[@]}"
do
  echo "Check if $basic_dependency need to be installed"
  if [ -x "$(command -v $basic_dependency)" ]; then
    echo "skip: $basic_dependency is installed"
  else
    echo "Not installed. Installing $basic_dependency..."
    # TODO: MacOS don't use apt
    sudo apt-get install --yes $basic_dependency > /dev/null
  fi
  echo "$i"
done


echo "Check for ZSH"
if [ -x "$(command -v zsh)" ]; then
  echo "ZSH is currently installed."
else
  echo "Installing ZSH"
  sudo apt-get install --yes zsh > /dev/null
fi

echo "Check SHELL config"
if [ $SHELL != "/bin/zsh" ]; then
  echo "Updating SHELL to /bin/zsh"
  chsh -s /bin/zsh
fi

echo "Check for AntiGen"
ANTIGEN_FILE=$HOME/antigen.zsh

if [ -f "$ANTIGEN_FILE" ]; then
  echo "Antigen is currently installed."
else
  echo "Installing AntiGen"
  sudo curl -L git.io/antigen > $HOME/antigen.zsh
fi

echo "Check for StarShip"
if [ -x "$(command -v starship)" ]; then
  echo "StarShip is currently installed."
else
  echo "Installing StarShip"
  curl -sS https://starship.rs/install.sh | sh
fi

echo "Check for Tmux Plugin Manager (tpm)"
TPM_FOLDER=$HOME/.tmux/plugins/tpm

if [ -d "$TPM_FOLDER" ]; then
  echo "TPM is currently installed."
else
  echo "Installing TPM"
  git clone https://github.com/tmux-plugins/tpm $TPM_FOLDER
fi


# TODO: Install neovim
