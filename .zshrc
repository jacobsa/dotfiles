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

# Support 'g' for git.
alias g='git'

# Include Google-specific stuff.
if [ -f "$HOME/.google-dotfiles/zshrc-google.sh" ]; then
  . "$HOME/.google-dotfiles/zshrc-google.sh"
fi

# Look for Go sources in ~/go, and for Go built from HEAD in ~/clients/go.
export GOPATH=$HOME/go
export PATH=$HOME/clients/go/bin:$PATH

# Set up support for the version of Go in /usr/local/go if it exists. We do
# this in preference to using the ancient version in the Ubuntu golang-go
# package.
if [ -d "/usr/local/go" ]; then
  export PATH=$PATH:/usr/local/go/bin
fi

# Use caching for expensive autocomplete scripts.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Auto-completion. Do this after Google-specific stuff so it can configure
# completion functions.
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# Set up the gcloud tool.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi
