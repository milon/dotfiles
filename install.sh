#!/bin/zsh

# Get script directory
export dotfiles_dir=$(dirname "$(realpath "$0")")
export support_dir="$dotfiles_dir/support"

# Load functions
source "$support_dir/functions.sh"

# install.sh is fail-fast: any step that returns non-zero aborts the install.
# bin/dotfiles leaves this unset so single-command runs return instead.
export DOTFILES_EXIT_ON_STEP_FAILURE=1

# Display ascii art
ascii_art

# Pre-installation checks
run_step 'PRECHECK' precheck.sh

# Core setup
run_step 'XCODE'    xcode.sh
run_step 'SYMLINKS' sym_links.sh
run_step 'HOMEBREW' brew.sh

# Development tools
run_step 'GIT'       git.sh
run_step 'PHP'       php.sh
run_step 'VALET'     valet.sh
run_step 'GIT CLONE' git_clone.sh

# Language environments (via mise)
run_step 'MISE' mise.sh

# Editors
run_step 'VIM'    vim.sh
run_step 'NEOVIM' neovim.sh

# System configuration
run_step 'MACOS SETTINGS' mac_settings.sh
run_step 'MANUAL STEPS'   manual_steps.sh
