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
run_step 'PRECHECK' precheck.sh

# Core setup
run_step 'XCODE'    xcode.sh
run_step 'SYMLINKS' sym_links.sh
run_step 'HOMEBREW' brew.sh

# Development tools
run_step 'GIT'       git.sh
run_step 'PHP'       php.sh
run_step 'LERD'      lerd.sh
run_step 'GIT CLONE' git_clone.sh

# Language environments (via mise)
run_step 'MISE' mise.sh

# System configuration
run_step 'MACOS SETTINGS' mac_settings.sh
run_step 'HOTKEYS'        hotkeys.sh

# Optional Atuin Hub login/sync (skipped entirely in --yes mode)
if dotfiles_noninteractive; then
    print_section 'ATUIN'
    print_info "Skipping Atuin Hub login in noninteractive mode — run: dotfiles atuin"
else
    echo
    if confirm_yn "Set up Atuin Hub login/sync now?"; then
        run_step 'ATUIN' atuin.sh
    else
        print_info "Skipped Atuin — run later: dotfiles atuin"
    fi
fi

run_step 'MANUAL STEPS' manual_steps.sh
