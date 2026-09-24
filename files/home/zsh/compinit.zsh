# compinit turns on zsh's completion system. It must run after completion
# functions are on fpath (zsh-completions) and before plugins that wrap
# completion widgets, such as autosuggestions and syntax highlighting.
# Rebuild the dump once a day. -C skips that check on later shells.
autoload -Uz compinit
zmodload zsh/datetime
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f $zcompdump ]] || (( EPOCHSECONDS - $(stat -f %m "$zcompdump") > 86400 )); then
    compinit
else
    compinit -C
fi
unset zcompdump
