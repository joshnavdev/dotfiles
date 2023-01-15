# ENV
WORKPLACE="$HOME/workplace"
DOTFILES="$WORKPLACE/projects/dotfiles"
XDG_CONFIG_HOME="$DOTFILES/.config"
ZSH_CUSTOM="$XDG_CONFIG_HOME/zsh"

source $HOME/antigen.zsh

# Antigen
antigen use oh-my-zsh

antigen bundle git
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# Starship
eval "$(starship init zsh)"

# NVM
NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
