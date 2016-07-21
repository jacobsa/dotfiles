# History settings
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt share_history  # Share across terminals.

# Show colors in `ls` output.
export CLICOLOR=1

# Use vim as editor.
export EDITOR=vim

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

%{$RED%}%n@%m%{$BLACK%}:%{$GREEN%}%~%{$YELLOW%}$(parse_git_branch)%(?..%{$ORANGE%} [%?] )%{$BLACK%}%# "
}

# Use homebrew tools in preference to system ones.
export PATH="$HOME/.homebrew/bin:$PATH"

# Support 'g' for git.
alias g='git'

# Make mosh work correctly with Kerberos authentication.
alias mosh='mosh --ssh="ssh -o GSSAPITrustDns=no"'

# SSH without any proxy command.
alias office-ssh="ssh -o 'ProxyCommand none'"

# Prefer Go built from HEAD in ~/clients/go.
export PATH=$HOME/clients/go/bin:$PATH

# Look for Go sources in ~/go, and for binaries installed by 'go' in ~/go/bin.
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

# Cf. https://github.com/golang/go/commit/183cc0c
export GO15VENDOREXPERIMENT=1

# Use caching for expensive autocomplete scripts.
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Auto-completion.
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit

# Set up the gcloud tool.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  source "$HOME/google-cloud-sdk/path.zsh.inc"
  source "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# Tell Terminal.app the working directory, for opening new tabs in the same
# directory. Reference:
#
#     http://hints.macworld.com/article.php?story=20110722211753852
#
if [ "$TERM_PROGRAM" = "Apple_Terminal" ] && [ -z "$INSIDE_EMACS" ]; then
    update_terminal_cwd() {
        # Identify the directory using a "file:" scheme URL,
        # including the host name to disambiguate local vs.
        # remote connections. Percent-escape spaces.
        local SEARCH=' '
        local REPLACE='%20'
        local PWD_URL="file://$HOST${PWD//$SEARCH/$REPLACE}"
        printf '\e]7;%s\a' "$PWD_URL"
    }
    autoload add-zsh-hook
    add-zsh-hook chpwd update_terminal_cwd
    update_terminal_cwd
fi
