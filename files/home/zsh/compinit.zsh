# compinit turns on zsh's completion system. It must run after completion
# functions are on fpath (zsh-completions) and before plugins that wrap
# completion widgets, such as autosuggestions and syntax highlighting.
autoload -Uz compinit && compinit
