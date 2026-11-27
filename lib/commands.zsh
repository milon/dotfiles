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

# ---------------------------------------------------------------------------
# Shared options (Symfony-style): define once, opt in per command.
#
# Easy use:
#   1. Add a shared flag to DOT_SHARED_OPTS (key → short|long<TAB>desc).
#   2. Opt a command in:  DOT_CMD_SHARED[cmd]="yes"   (space-separated keys)
#   3. Command-only flags stay in DOT_CMD_OPTS (never repeat shared ones).
#
# `help` is always attached — do not list it in DOT_CMD_SHARED.
# Help, completions, and `dot help` all read these tables via the helpers below.
# ---------------------------------------------------------------------------
typeset -gA DOT_SHARED_OPTS=(
    [help]=$'h|help\tDisplay help for the command'
    [yes]=$'y|yes\tNoninteractive / assume yes'
)

# Space-separated shared option keys this command accepts (besides help).
typeset -gA DOT_CMD_SHARED=(
    [apply]="yes"
    [brew]="yes"
    [git]="yes"
    [atuin]="yes"
    [precheck]="yes"
)

# Command-specific options only (short|long<TAB>desc, or long<TAB>desc; one per line).
typeset -gA DOT_CMD_OPTS=(
    [pull]=$'u|update\tRun composer update in PHP repos; commit and push lockfile bumps'
)

# True if command $1 opts into shared option $2. `help` is always true.
dot_cmd_has_shared() {
    local cmd=$1 key=$2
    [[ $key == help ]] && return 0
    [[ " ${DOT_CMD_SHARED[$cmd]:-} " == *" $key "* ]]
}

# Print merged option lines for command $1: shared (minus help), then specific, then help.
# Each line: short|long<TAB>desc  or  long<TAB>desc
dot_cmd_option_lines() {
    local cmd=$1
    local key line
    for key in ${(s: :)DOT_CMD_SHARED[$cmd]:-}; do
        [[ $key == help ]] && continue
        line=${DOT_SHARED_OPTS[$key]:-}
        [[ -n $line ]] && print -r -- "$line"
    done
    local specific=${DOT_CMD_OPTS[$cmd]:-}
    if [[ -n $specific ]]; then
        local row
        for row in ${(f)specific}; do
            print -r -- "$row"
        done
    fi
    print -r -- "${DOT_SHARED_OPTS[help]}"
}

# Canonical command names that opt into shared option $1, in help-display order.
dot_cmds_with_shared() {
    local key=$1
    local category cmds_var name
    local -a cmds
    for category in $DOT_CATEGORIES; do
        cmds_var="DOT_CMDS_${category}"
        cmds=( ${(P)cmds_var} )
        for name in $cmds; do
            if [[ " ${DOT_CMD_SHARED[$name]:-} " == *" $key "* ]]; then
                print -r -- "$name"
            fi
        done
    done
    return 0
}

# Print zsh `_arguments` specs for one option line (safe for dynamic arrays).
# Input: short|long<TAB>desc  or  long<TAB>desc
# Output: one or two lines, e.g.  (-y --yes)-y[desc]  and  (-y --yes)--yes[desc]
dot_opt_comp_spec() {
    local line=$1
    local keys=${line%%	*}
    local desc=${line#*	}
    local short long
    if [[ $keys == *\|* ]]; then
        short=${keys%%\|*}
        long=${keys#*\|}
        print -r -- "(-${short} --${long})-${short}[${desc}]"
        print -r -- "(-${short} --${long})--${long}[${desc}]"
    else
        print -r -- "--${keys}[${desc}]"
    fi
}
