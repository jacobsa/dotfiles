# Show the current git branch in the prompt.
function promptcmd() {
  GITBRANCH=$(basename "$(git symbolic-ref HEAD 2>/dev/null)")
  PS1="\n\n\[\033[00;31m\]\u@\h\[\033[00m\]:\[\033[00;34m\]\w\[\033[00m\]${GITBRANCH:+*\[\033[00;32m\]\$GITBRANCH\[\033[00m\]}\$ "
}

export PROMPT_COMMAND=promptcmd

# Enable vim mode in bash.
set -o vi

# Set the appropriate editor.
export EDITOR=vi

# Turn on colors for 'ls'.
export CLICOLOR=1

# Enable auto-completion of git commands.
source ~/.dotfiles/bash/git-completion.bash

# Support 'g' for git, with completion.
alias g='git'
complete -o bashdefault -o default -o nospace -F _git g

# Make sure various tools use color by default.
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Include Google-specific stuff.
if [ -f "$HOME/.google-dotfiles/profile-google.sh" ]; then
  . "$HOME/.google-dotfiles/profile-google.sh"
fi

# Set up ssh-agent.
if [ -x /usr/bin/ssx-agents ] ; then
   [ "$PS1" ] && eval `/usr/bin/ssx-agents $SHELL`
fi

# Append to the history file; don't overwrite it.
shopt -s histappend

# Put multi-line commands on a single history line.
shopt -s cmdhist

# Keep lots of history.
export HISTSIZE=100000
export HISTFILESIZE=1000000000

# Append to the history file immediately rather when the shell exists, in case
# the machine crashes with a long-running shell.
trap 'history -a' DEBUG

# Improve the presentation of the 'history' command.
export HISTTIMEFORMAT='%Y-%m-%d %H:%M:%S: '


########################################################################
# Interactive magic
########################################################################

# Open scrollback buffer in vim. Make sure to use a sub-shell so the traps don't
# persist after leaving vim.
open_scrollback_in_vim() {
  (
    local filename="$(mktemp)"
    trap "rm -f -- '$filename'" 0
    trap 'exit 2' 1 2 3 15
    tmux capture-pane -S -32000
    tmux save-buffer "$filename"
    tmux delete-buffer
    # Use - because we want to call scrollback from within zle
    OUTPUT_FILE="$1" command vim -c "runtime! macros/scrollback_less.vim" - < "$filename"
    # Move back up over the annoying text which vim writes.
    tput cuu 2
  )
}

alias sb=open_scrollback_in_vim
