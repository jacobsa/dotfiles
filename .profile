# Show the current git branch in the prompt.
function promptcmd() {
  GITBRANCH=$(basename "$(git symbolic-ref HEAD 2>/dev/null)")
  PS1="\[\033[00;35m\]\u@\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\]${GITBRANCH:+*\[\033[00;32m\]\$GITBRANCH\[\033[00m\]}\$ "
}

export PROMPT_COMMAND=promptcmd

# Enable vim mode in bash.
set -o vi

# Turn on colors for 'ls'.
export CLICOLOR=1

# Enable auto-completion of git commands.
source ~/.dotfiles/bash/git-completion.bash

# Support 'g' for git, with completion.
alias g='git'
complete -o bashdefault -o default -o nospace -F _git g
