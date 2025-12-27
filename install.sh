#!/bin/zsh

# Get script directory
export dotfiles_dir=$(dirname "$(realpath "$0")")
export support_dir="$dotfiles_dir/support"

# Load functions
source "$support_dir/functions.sh"

# Display ascii art
ascii_art

# Pre-installation checks
run_step 'PRECHECK' "$support_dir/precheck.sh"
run_step 'MANUAL STEPS' "$support_dir/manual_steps.sh"
exit 0

# Core setup
run_step 'XCODE' "$support_dir/xcode.sh"
run_step 'SYM LINKS' "$support_dir/sym_links.sh"
run_step 'HOMEBREW' "$support_dir/brew.sh"

# Development tools
run_step 'GIT' "$support_dir/git.sh"
run_step 'COMPOSER' "$support_dir/composer.sh"
run_step 'VALET' "$support_dir/valet.sh"
run_step 'GIT CLONE' "$support_dir/git_clone.sh"

# Language environments
run_step 'NPM' "$support_dir/node.sh"
run_step 'PYENV' "$support_dir/python.sh"
run_step 'JENV' "$support_dir/java.sh"
run_step 'Ruby' "$support_dir/ruby.sh"

# Editors
run_step 'VIM' "$support_dir/vim.sh"
run_step 'NEOVIM' "$support_dir/neovim.sh"

# System configuration
run_step 'MACOS SETTINGS' "$support_dir/mac_settings.sh"
run_step 'MANUAL STEPS' "$support_dir/manual_steps.sh"
