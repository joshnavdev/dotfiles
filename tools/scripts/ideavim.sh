function config_ideavim() {
  echo ""
  echo "Config .ideavimrc file"
  DOTFILES="$(pwd)"

  IDEAVIMRC_PATH=$HOME/.ideavimrc

  is_file "$IDEAVIMRC_PATH"
  if [ $? -eq 1 ]; then
    echo "$IDEAVIMRC_PATH" file exists.
    # TODO: Ask for update it
  else
    echo "Creating soft link to $IDEAVIMRC_PATH"
    ln -s $DOTFILES/.ideavimrc $IDEAVIMRC_PATH
  fi
}
