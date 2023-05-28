function install_zsh() {
  echo "Check if ZSH is installed"
  validate_command_and_print "zsh"

  if [ $? -eq 0 ]; then
    echo "Installing..."
    install_dependency "zsh" --with-sudo --with-yes
  fi
}

function install_antigen() {
  echo ""
  echo "Check if  AntiGen is installed"

  ANTIGEN_FILE=$HOME/antigen.zsh

  validate_command_and_print "antigen"
  if [ $? -eq 0 ]; then
    echo "Validate if there is a AntiGen file"

    is_file "$ANTIGEN_FILE"
    if [ $? -eq 1 ]; then
      echo "Removing old AntiGen file"
      rm -rf $ANTIGEN_FILE
    fi

    echo "Installing..."
    sudo curl -L git.io/antigen > $HOME/antigen.zsh
  fi
}

function config_shell() {
  echo ""
  echo "Check SHELL config"

  if [[ "$SHELL" != "/bin/zsh" ]]; then
    echo "Update SHELL to /bin/zsh"
    chsh -s /bin/zsh
  else
    echo "SHELL is currentlly using ZSH"
  fi
}

function config_zsh() {
  config_shell

  echo ""
  echo "Config .zshrc file"
  DOTFILES="$(pwd)"

  touch $DOTFILES/.zshrc
  echo "DOTFILES=$DOTFILES" >> $DOTFILES/.zshrc
  cat $DOTFILES/tools/.zshrc.init >> $DOTFILES/.zshrc

  ZSHRC_PATH=$HOME/.zshrc

  is_file "$ZSHRC_PATH"
  if [ $? -eq 1 ]; then
    echo "$ZSHRC_PATH file exists."
    # TODO: Ask fo update it
  else
    echo "Creating soft link to $ZSHRC_PATH"
    ln -s $DOTFILES/.zshrc $ZSHRC_PATH 
  fi
}


function install_and_config_zsh() {
  echo ""

  install_zsh
  install_antigen
  config_zsh
}
