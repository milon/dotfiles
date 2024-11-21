#!/bin/zsh

set +x

export dotfiles_dir=$(dirname "$(realpath "$0")")

# load config
export support_dir="$dotfiles_dir/support"

# Load functions
source "$support_dir/functions.sh"

# Load ascii art
ascii_art

# Check and prompt for necessary dependencies
source "$support_dir/precheck.sh" && cd $dotfiles_dir

title 'XCODE'
source "$support_dir/xcode.sh" && cd $dotfiles_dir

title 'DEPENDENCIES'
source "$support_dir/dependencies.sh" && cd $dotfiles_dir

title 'SYM LINKS'
source "$support_dir/sym_links.sh" && cd $dotfiles_dir

title 'HOMEBREW'
source "$support_dir/brew.sh" && cd $dotfiles_dir

title 'GIT'
source "$support_dir/git.sh" && cd $dotfiles_dir

title 'COMPOSER'
source "$support_dir/composer.sh" && cd $dotfiles_dir

title 'VALET'
source "$support_dir/valet.sh" && cd $dotfiles_dir

title 'GIT CLONE'
source "$support_dir/git_clone.sh" && cd $dotfiles_dir

title 'NPM'
source "$support_dir/node.sh" && cd $dotfiles_dir

title 'PYENV'
source "$support_dir/python.sh" && cd $dotfiles_dir

title 'JENV'
source "$support_dir/java.sh" && cd $dotfiles_dir

title 'Ruby'
source "$support_dir/ruby.sh" && cd $dotfiles_dir

title 'VIM'
source "$support_dir/vim.sh" && cd $dotfiles_dir

title 'NEOVIM'
source "$support_dir/neovim.sh" && cd $dotfiles_dir

title 'MACOS SETTINGS'
source "$support_dir/mac_settings.sh" && cd $dotfiles_dir

title 'MANUAL STEPS'
source "$support_dir/manual_steps.sh" && cd $dotfiles_dir
