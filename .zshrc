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

source "$HOME/.homesick/repos/homeshick/homeshick.sh"

[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# BEGIN NU_HOME ENV
source $HOME/.nurc
export NU_HOME="$HOME/dev/nu"
export NUCLI_HOME=$NU_HOME/nucli
export PATH="$NUCLI_HOME:/opt/idea/current/bin:$PATH"
# END NU_HOME ENV

export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# SETTING UP FOR GNUPG TTY
export GPG_TTY=$(tty)

# source /home/diegorabatone/.pyenv/.pyenvrc

fpath=(~/.zsh/completion $fpath)
source "${NU_HOME}/nucli/nu.bashcompletion"
eval "$(nodenv init -)"
fpath=(${ASDF_DIR}/completions $fpath)

# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit
alias lzd='lazydocker'

[ -f ~/.ssh/github ] && ssh-add ~/.ssh/github > /dev/null
