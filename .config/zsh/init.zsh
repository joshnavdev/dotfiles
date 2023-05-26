## ALIAS
# alias pbcopy='xclip -selection clipboard'
# Git
function acp() {
  git add .
  git commit -m "$1"
  git push
}

function fd() {
  preview="git diff $@ --color=always -- {-1}"
  git diff $@ --name-only | fzf -m --ansi --preview $preview
}

alias tmuxf="tmuxifier"
# Kubectl
# [ -f $ZSH_CUSTOM/.kubectl_aliases ] && source $ZSH_CUSTOM/.kubectl_aliases
# function kubectl() { echo "+ kubectl $@">&2; command kubectl $@; }


# Copy this plugins to ~/.zshrc file
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# plugins=(zsh-autosuggestions)
# plugins=(git z zsh-autosuggestions)
