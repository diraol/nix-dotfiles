source ~/.critical-keys
source ~/.env

#export TERM="rxvt-unicode-256color"

### Extra paths
[[ -s ~/.zsh_aliases ]] && source ~/.zsh_aliases

# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#
# Load my rc
source "${HOME}/.diraol/rc"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

path=(
  ${HOME}/.local/bin
  ${HOME}/tools/bin
  $path
)

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# Icons:
# VCS_GIT_GITHUB_ICON=
# VCS_GIT_GITLAB_ICON=

# zsh/zprezto-contrib enhancd plugin
ENHANCD_DOT_ARG="..."

bindkey -M viins '^r' history-incremental-search-backward
bindkey -M vicmd '^r' history-incremental-search-backward

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# BEGIN NU_HOME ENV
source $HOME/.nurc

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SETTING UP FOR GNUPG TTY
export GPG_TTY=$(tty)

# source /home/diraol/.pyenv/.pyenvrc

fpath=(~/.zsh/completion $fpath)
source "${NU_HOME}/nucli/nu.bashcompletion"
eval "$(nodenv init -)"

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
alias lzd='lazydocker'

[ -f ~/.ssh/github ] && ssh-add ~/.ssh/github > /dev/null

if [ -e /home/diraol/.nix-profile/etc/profile.d/nix.sh ]; then . /home/diraol/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
