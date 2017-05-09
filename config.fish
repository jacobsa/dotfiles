# Enable vim mode.
fish_vi_key_bindings

# Set up Google-specific things when at Google.
if test -e ~/.google-dotfiles/google-specific.fish
  . ~/.google-dotfiles/google-specific.fish
end
