#!/bin/zsh

# Shared map of dotfile symlinks.
# Sourced by support/sym_links.sh (creates them) and support/doctor.sh (verifies them).
# Key  = path inside files/   (e.g. home/zshrc)
# Value = absolute destination on disk (e.g. $HOME/.zshrc)

typeset -gA sym_links
sym_links=(
    # $HOME root
    [home/zshrc]=$HOME/.zshrc
    [home/vimrc]=$HOME/.vimrc
    [home/antigenrc]=$HOME/.antigenrc
    [home/gitignore]=$HOME/.gitignore
    [home/skhdrc]=$HOME/.skhdrc
    [home/yabairc]=$HOME/.yabairc
    # $HOME/.vim
    [vim/plugins.vim]=$HOME/.vim/plugins.vim
    # $HOME/.config
    [config/nvim]=$HOME/.config/nvim
    [config/ghostty/config]=$HOME/.config/ghostty/config
    [config/ghostty/Ghostty.icns]=$HOME/.config/ghostty/Ghostty.icns
    [config/fastfetch/config.jsonc]=$HOME/.config/fastfetch/config.jsonc
    [config/mise/config.toml]=$HOME/.config/mise/config.toml
    [config/topgrade.toml]=$HOME/.config/topgrade.toml
)
