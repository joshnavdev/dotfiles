ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME=""

# Would you like to use another custom folder than $ZSH/custom?
WORKPLACE="$HOME/workplace"
DOTFILES="$WORKPLACE/projects/dotfiles"
XDG_CONFIG_HOME="$DOTFILES/.config"
ZSH_CUSTOM="$XDG_CONFIG_HOME/zsh"

# Plugins
plugins=(git zsh-autosuggestions)
source $ZSH/oh-my-zsh.sh

#Star ship
eval "$(starship init zsh)"

NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
