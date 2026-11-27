#!/bin/zsh
# Command registry for bin/dot — help, dispatch, and completions read this file.

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

# One-line summary (list help + Description header)
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

# Extra Description paragraphs (optional, newline-separated)
typeset -gA DOT_CMD_HELP=(
    [doctor]="Checks Homebrew, symlinks, mise, PHP, Lerd/Podman, git, Sheldon, Atuin, yabai/skhd, SSH, and PATH."
    [apply]="With no arguments, runs the full install order. With names, runs only those modules (public command names accepted)."
    [pull]="Fetches updates for inventory repos plus this dotfiles checkout. Dirty worktrees are skipped with a warning. With --update, also runs composer update and commits/pushes lockfile bumps."
    [clone]="Clones missing repos from inventory/repos.toml into ~/Code (or code_dir). Existing repos are pulled."
    [symlinks]="Links config/ onto ~ and ~/.config per inventory/links.toml. Conflicts are backed up under ~/.local/share/dot/backup/."
    [lerd]="Installs Lerd (once), parks ~/Code, refreshes completions, and keeps tracked ~/.zshrc free of Lerd snippets."
    [shell]="Runs sheldon lock so plugins.toml changes take effect."
    [precheck]="Creates ~/.zshrc.local and ~/.Brewfile.local when missing; verifies SSH keys and App Store login."
    [mac]="Writes a small set of macOS defaults and sets Chrome as the default browser for http/https via duti."
    [hotkeys]="Writes generated/skhd-bin and restarts yabai + skhd."
    [update]="Uses ~/.config/topgrade.toml when present, otherwise the repo copy."
    [git]="Sets include.path to config/gitconfig, enables repo hooks, and prompts for user.name/email when unset."
)

# Usage suffix after: dot <command>
typeset -gA DOT_CMD_USAGE=(
    [apply]="[<module>...]"
    [pull]="[-u|--update]"
)

# Arguments: lines of name<TAB>description
typeset -gA DOT_CMD_ARGS=(
    [apply]=$'modules\tOptional public command or module names (e.g. brew symlinks clone). Not: pull.'
)

# Options: lines of short|long<TAB>description (or long only).
# -h/--help is always implied. Only list -y/--yes on commands that prompt.
typeset -gA DOT_CMD_OPTS=(
    [apply]=$'y|yes\tNoninteractive / assume yes (skips Atuin login during full apply)'
    [brew]=$'y|yes\tNoninteractive Homebrew install (NONINTERACTIVE=1)'
    [git]=$'y|yes\tNoninteractive / assume yes (skip identity override prompts)'
    [atuin]=$'y|yes\tNoninteractive / assume yes (skip Hub login/sync prompts)'
    [precheck]=$'y|yes\tNoninteractive / assume yes (fail if SSH keys missing)'
    [pull]=$'u|update\tRun composer update in PHP repos; commit and push lockfile bumps'
)
