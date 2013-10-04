# History settings
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt share_history  # Share across terminals.

# Use vim as editor.
export EDITOR=vi

# Use unified diffs by default.
export DIFF='diff -u'

# Vim mode
setopt appendhistory
bindkey -v

# Support Ctrl-R for history search despite vim mode.
bindkey '^R' history-incremental-search-backward

# Colors to be used for prompt below.
BLACK=$'\033[0m'
RED=$'\033[38;5;167m'
GREEN=$'\033[38;5;71m'
BLUE=$'\033[38;5;111m'
YELLOW=$'\033[38;5;228m'
ORANGE=$'\033[38;5;173m'

# Show the git branch in the prompt.
parse_git_branch () {
    git branch 2> /dev/null | grep "*" | sed -e 's/* \(.*\)/ (\1)/g'
}

function precmd() {
    export PROMPT="

%{$RED%}%n@%m%{$BLACK%}:%{$GREEN%}%~%{$YELLOW%}$(parse_git_branch)%{$BLACK%}%# "
}

# Use local tools in preference to system ones.
export PATH="/usr/local/bin:$PATH"

# Support 'g' for git.
alias g='git'

# Set up Go.
export GOROOT=/usr/local/go
export GOPATH=/Users/jacobsa/go
export PATH=$PATH:/Users/jacobsa/go/bin

# Use caching for expensive autocomplete scripts.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Auto-completion.
zstyle :compinstall filename '/Users/jacobsa/.zshrc'
autoload -Uz compinit
compinit
