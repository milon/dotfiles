# zsh infers its keymap from $EDITOR when neither bindkey -e nor bindkey -v
# runs. "nvim" matches "vi", so the env plugin above silently selects vi mode
# and Option+Backspace (Esc + ^?) drops to vicmd instead of killing a word.
bindkey -e
bindkey '^[^?' backward-kill-word
bindkey '^[[1;3D' backward-word
# Option+Right accepts one word of the grey suggestion (forward-word is a partial-accept widget).
bindkey '^[[1;3C' forward-word
