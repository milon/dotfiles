#!/bin/zsh

# Shared map of dotfile symlinks.
# Sourced by support/sym_links.sh (creates them) and support/doctor.sh (verifies them).
# Key  = path inside files/   (e.g. home/zshrc)
# Value = absolute destination on disk (e.g. $HOME/.zshrc)

typeset -gA sym_links=(
    # $HOME root
    [home/zshrc]=$HOME/.zshrc
    [home/gitignore]=$HOME/.gitignore
    [home/skhdrc]=$HOME/.skhdrc
    [home/yabairc]=$HOME/.yabairc
    # $HOME/.config
    [config/sheldon]=$HOME/.config/sheldon
    [config/atuin]=$HOME/.config/atuin
    [config/nvim]=$HOME/.config/nvim
    [config/ghostty]=$HOME/.config/ghostty
    [config/fastfetch]=$HOME/.config/fastfetch
    [config/mise]=$HOME/.config/mise
    [config/topgrade.toml]=$HOME/.config/topgrade.toml
)
