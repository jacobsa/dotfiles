# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/usr/local/google/home/jacobsa/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

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
    export PROMPT="%{$RED%}%n@%m%{$BLACK%}:%{$GREEN%}%~%{$YELLOW%}$(parse_git_branch)%{$BLACK%}%# "
}
