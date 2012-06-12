# Include .bashrc if it exists and we're running bash.
if [ -n "$BASH_VERSION" ]; then
  if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
  fi
fi

# Give a nicer prompt.
export PS1="\\h: [\\w]$ "

# Don't use 'more' for git diff and friends.
export GIT_PAGER=cat

# vim mode in bash
set -o vi

# svn
export SVN_EDITOR=/usr/bin/vim

# ls colors
export CLICOLOR=1

# Go
export GOROOT=/Users/jacobsa/go/root
export GOPATH=/Users/jacobsa/go/third_party:/Users/jacobsa/go/clients
export PATH=$GOROOT/bin:$PATH
export PATH=/Users/jacobsa/go/clients/bin:$PATH
export PATH=/Users/jacobsa/go/third_party/bin:$PATH

# Auto-completion of git commands
source ~/.dotfiles/bash/git-completion.bash

# Support 'g' for git, with completion.
alias g='git'
complete -o bashdefault -o default -o nospace -F _git g
