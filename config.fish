# Enable vim mode.
fish_vi_key_bindings

# Disable the greeting. (https://stackoverflow.com/a/13995944/1505451)
set fish_greeting

# Disable the [I] and [N] indicators for vim mode.
# Cf. https://github.com/fish-shell/fish-shell/issues/2682#issuecomment-172391594
function fish_mode_prompt; end

# Set up Google-specific things when at Google.
if test -e ~/.google-dotfiles/google-specific.fish
  . ~/.google-dotfiles/google-specific.fish
end

# Convenient alias to auto-quote commit message.
function hgcm
  hg commit --message "$argv"
end

# Add to $PATH.
fish_add_path ~/.dotfiles/bin
fish_add_path ~/go/bin

# Set up tool config.
set -x EDITOR vim
set -x DIFF 'diff -u'

# Copied from `functions fish_prompt` and modified.
function fish_prompt --description 'Write out the prompt'
  # Save the last command's status, so that it doesn't get clobbered by
  # anything below (e.g. set_color).
  set -l prev_status $status

  # Calculate the host once, to save a few cycles when displaying the prompt.
  if not set -q __fish_prompt_hostname
    set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
  end

  # Choose pwd and suffix colors.
  set -l color_cwd
  set -l suffix
  switch $USER
  case root toor
    if set -q fish_color_cwd_root
      set color_cwd $fish_color_cwd_root
    else
      set color_cwd $fish_color_cwd
    end
    set suffix '#'
  case '*'
    set color_cwd $fish_color_cwd
    set suffix '>'
  end

  # Augment the suffix if the previous command failed.
  if test $prev_status -ne 0
    set suffix (echo -n -s (set_color red) " $prev_status" "$suffix" (set_color normal))
  end

  # Add a blank line.
  echo

  # Print the and hostname.
  echo -n -s "$USER" @ "$__fish_prompt_hostname"

  # Print the working directory.
  echo -n -s ' ' (set_color $color_cwd) (prompt_pwd) (set_color normal)

  # Print the suffix.
  echo -n -s "$suffix "
end

# Helper for a common task in mercurual.
function foldanddraft
  hg foldintofirst $argv
  and hg phase -d tip
end

# Parallel grep, for use when there is high I/O latency.
#
# Usage: lel_grep [grep flags] pcre_pattern directory
function lel_grep
    find $argv[-1] -type f | \
      xargs -n 1 -P 100 \
      grep -P -H --color=auto $argv[1..-3] $argv[-2]
end

# Parallel deletion of lines, avoiding citc pollution
# (http://yaqs/6849414282300358656).
#
# Usage: lel_delete_lines pcre_pattern directory directory ...
function lel_delete_lines
    set --local re $argv[1]
    for dir in $argv[2..-1]
        lel_grep -l $re $dir | \
            xargs -n 1 -P 10 \
            perl -n -i -e "print unless m/$re/"
    end
end

# Parallel find and replace, avoiding citc pollution
# (http://yaqs/6849414282300358656). Pattern must not contain unescaped
# semicolons.
#
# Usage: lel_replace pcre_pattern substitution directory directory ...
function lel_replace
    set --local re $argv[1]
    set --local substitution $argv[2]
    for dir in $argv[3..-1]
        lel_grep -l $re $dir | \
            xargs -n 1 -P 10 \
            perl -i -pe "s;$re;$substitution;g"
    end
end
