#!/bin/sh

DOTFILES="$(pwd)"

touch $DOTFILES/.zshrc
echo "DOTFILES=$DOTFILES" >> $DOTFILES/.zshrc
cat $DOTFILES/tools/.zshrc.init >> $DOTFILES/.zshrc

ZSHRC=$HOME/.zshrc
if [ -f "$ZSHRC" ]; then
  echo "$ZSHRC file exists."
  # TODO: Ask fo update it
else
  echo "Creating soft link to $ZSHRC"
  ln -s $DOTFILES/.zshrc $ZSHRC 
fi

CONFIG_FOLDER=$HOME/.config
if [ -d "$CONFIG_FOLDER" ]; then
  echo "$CONFIG_FOLDER directory exists."
else
  echo "Creating soft link to $CONFIG_FOLDER"
  ln -s $DOTFILES/.config $HOME/.config
fi

TMUX_CONF=$HOME/.tmux.conf
if [ -f "$TMUX_CONF" ]; then
  echo "$TMUX_CONF file exists."
  # TODO: Ask fo update it
else
  echo "Creating soft link to $TMUX_CONF"
  ln -s $DOTFILES/.config/tmux/tmux.conf $TMUX_CONF
fi

