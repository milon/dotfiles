#!/bin/zsh
# Command registry for bin/dot — help and dispatch both read this file.

typeset -ga DOT_CATEGORIES=(core setup repos system)

typeset -gA DOT_CATEGORY_LABEL=(
    [core]="CORE"
    [setup]="SETUP"
    [repos]="REPOS"
    [system]="SYSTEM"
)

typeset -gA DOT_CATEGORY_COLOR=(
    [core]="$YELLOW"
    [setup]="$BLUE"
    [repos]="$GREEN"
    [system]="$MAGENTA"
)

typeset -gA DOT_CATEGORY_ICON=(
    [core]=$'\ueb45'
    [setup]=$'\uf0ad'
    [repos]=$'\uea84'
    [system]=$'\uf179'
)

# Help display order within each category
typeset -ga DOT_CMDS_core=(doctor lint update clean symlinks precheck apply)
typeset -ga DOT_CMDS_setup=(brew shell git atuin xcode mise php lerd)
typeset -ga DOT_CMDS_repos=(clone pull)
typeset -ga DOT_CMDS_system=(mac hotkeys manual)

# Top-level command → module (+ optional default action)
# Format: module or module:action
typeset -gA DOT_CMD_MODULE=(
    [doctor]="doctor"
    [check]="doctor"
    [lint]="lint"
    [update]="update"
    [clean]="clean"
    [symlinks]="symlinks"
    [precheck]="precheck"
    [brew]="brew"
    [git]="git"
    [atuin]="atuin"
    [xcode]="xcode"
    [mise]="mise"
    [php]="php"
    [lerd]="lerd"
    [clone]="repos"
    [pull]="repos:pull"
    [mac]="mac"
    [hotkeys]="hotkeys"
    [manual]="manual"
    [shell]="shell"
)

typeset -gA DOT_CMD_DESC=(
    [doctor]="Diagnose installation drift"
    [lint]="Lint shell scripts (zsh -n + shellcheck)"
    [update]="Run Topgrade across all package managers"
    [clean]="Clean caches (brew, npm, Composer, mise)"
    [symlinks]="Create symlinks for dotfiles"
    [precheck]="Create local overrides; verify SSH / App Store"
    [apply]="Run full idempotent setup"
    [brew]="Install Homebrew and dependencies"
    [shell]="Refresh Sheldon lock for zsh plugins"
    [git]="Configure Git settings"
    [atuin]="Log in and sync shell history with Atuin Hub"
    [xcode]="Install Xcode / CLI tools"
    [mise]="Setup mise (node, python, ruby, java, go, rust)"
    [php]="Setup PHP and Composer"
    [lerd]="Setup Lerd (.test sites and dashboard)"
    [clone]="Clone personal Git repositories"
    [pull]="Update all Git repositories"
    [mac]="Configure macOS settings"
    [hotkeys]="Start/reload yabai + skhd"
    [manual]="Show remaining manual setup checklist"
)
