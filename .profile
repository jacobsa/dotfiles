# Include .bashrc if it exists and we're running bash.
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Give a nicer prompt.
export PS1="\\h: [\\w]$ "

# Enable vim mode in bash.
set -o vi

# Turn on colors for 'ls'.
export CLICOLOR=1

# Enable auto-completion of git commands.
source ~/.dotfiles/bash/git-completion.bash

# Support 'g' for git, with completion.
alias g='git'
complete -o bashdefault -o default -o nospace -F _git g

# Make sure ssh-agent works when connected over SSH.
if [ -x /usr/bin/ssx-agents ] ; then
  eval `/usr/bin/ssx-agents $SHELL`
fi
