# compinit turns on zsh's completion system. It must run after completion
# functions are on fpath (zsh-completions) and before plugins that wrap
# completion widgets, such as autosuggestions and syntax highlighting.
# Rebuild the dump once a day. -C skips that check on later shells.

# Repo completions (dot, …) — must be on fpath before compinit.
dot_completions="${DOTFILES_ROOT:-}/config/zsh/completions"
if [[ -n ${DOTFILES_ROOT:-} && -d $dot_completions ]]; then
    fpath=($dot_completions $fpath)
fi
unset dot_completions

# Lerd (and other tools) install into ~/.local/share/zsh/site-functions
lerd_completions="$HOME/.local/share/zsh/site-functions"
if [[ -d $lerd_completions ]]; then
    fpath=($lerd_completions $fpath)
fi
unset lerd_completions

autoload -Uz compinit
zmodload zsh/datetime
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f $zcompdump ]] || (( EPOCHSECONDS - $(stat -f %m "$zcompdump") > 86400 )); then
    compinit
else
    compinit -C
fi
unset zcompdump
