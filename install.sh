#!/bin/zsh

# Get script directory
export dotfiles_dir=$(dirname "$(realpath "$0")")
export support_dir="$dotfiles_dir/support"

# Load functions
source "$support_dir/functions.sh"

# Global flags: ./install.sh --yes
dotfiles_consume_yes_args "$@"
set -- "${REPLY[@]}"

# install.sh is fail-fast: any step that returns non-zero aborts the install.
# bin/dotfiles leaves this unset so single-command runs return instead.
export DOTFILES_EXIT_ON_STEP_FAILURE=1

# Display ascii art
ascii_art

if dotfiles_noninteractive; then
    print_info "Noninteractive install (--yes): prompts auto-answered"
fi

# Pre-installation checks
run_step 'Precheck' precheck.sh

# Core setup
run_step 'Xcode'    xcode.sh
run_step 'Symlinks' sym_links.sh
run_step 'Homebrew' brew.sh

# Development tools
run_step 'Git'       git.sh
run_step 'PHP'       php.sh
run_step 'Lerd'      lerd.sh
run_step 'Git clone' git_clone.sh

# Language environments (via mise)
run_step 'Mise' mise.sh

# System configuration
run_step 'Mac settings' mac_settings.sh
run_step 'Hotkeys'      hotkeys.sh

# Optional Atuin Hub login/sync (skipped entirely in --yes mode)
if dotfiles_noninteractive; then
    print_section 'Atuin'
    print_warn "Skipping Atuin Hub login in noninteractive mode — run: dotfiles atuin"
else
    echo
    if confirm_yn "Set up Atuin Hub login/sync now?"; then
        run_step 'Atuin' atuin.sh
    else
        print_warn "Skipping Atuin — run later: dotfiles atuin"
    fi
fi

run_step 'Manual steps' manual_steps.sh
