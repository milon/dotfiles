#!/bin/zsh

# Shared command registry for bin/dotfiles and support/help.sh.
# Add new subcommands here only — help and dispatch both read this file.

# Display order of help categories
typeset -ga DOTFILES_CATEGORIES=(core setup repos system)

typeset -gA DOTFILES_CATEGORY_LABEL=(
    [core]="CORE"
    [setup]="SETUP"
    [repos]="REPOS"
    [system]="SYSTEM"
)

typeset -gA DOTFILES_CATEGORY_COLOR=(
    [core]="$YELLOW"
    [setup]="$BLUE"
    [repos]="$GREEN"
    [system]="$MAGENTA"
)

# Nerd Font icons (same as the previous hand-written help)
typeset -gA DOTFILES_CATEGORY_ICON=(
    [core]=$'\ueb45'
    [setup]=$'\uf0ad'
    [repos]=$'\uea84'
    [system]=$'\uf179'
)

# Commands in help-display order within each category
typeset -ga DOTFILES_CMDS_core=(doctor lint update clean symlinks precheck)
typeset -ga DOTFILES_CMDS_setup=(brew git atuin xcode mise php lerd)
typeset -ga DOTFILES_CMDS_repos=(clone pull)
typeset -ga DOTFILES_CMDS_system=(mac hotkeys manual)

typeset -gA DOTFILES_CMD_SCRIPT=(
    [doctor]="doctor.sh"
    [lint]="lint.sh"
    [update]="update.sh"
    [clean]="clean.sh"
    [symlinks]="sym_links.sh"
    [precheck]="precheck.sh"
    [brew]="brew.sh"
    [git]="git.sh"
    [atuin]="atuin.sh"
    [xcode]="xcode.sh"
    [mise]="mise.sh"
    [php]="php.sh"
    [lerd]="lerd.sh"
    [clone]="git_clone.sh"
    [pull]="pull.sh"
    [mac]="mac_settings.sh"
    [hotkeys]="hotkeys.sh"
    [manual]="manual_steps.sh"
)

typeset -gA DOTFILES_CMD_DESC=(
    [doctor]="Diagnose installation drift"
    [lint]="Lint shell scripts (zsh -n + shellcheck)"
    [update]="Run Topgrade across all package managers"
    [clean]="Clean caches (brew, npm, Composer, mise)"
    [symlinks]="Create symlinks for dotfiles"
    [precheck]="Create local overrides; verify SSH / App Store"
    [brew]="Install Homebrew and dependencies"
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

# Flat map used by bin/dotfiles for dispatch (same keys/values as DOTFILES_CMD_SCRIPT)
typeset -gA COMMAND_SCRIPTS=( ${(kv)DOTFILES_CMD_SCRIPT} )
