#!/bin/zsh

set +x
#my_dir="$(dirname "$0")"
my_dir="$HOME/.dotfiles"
support_dir="$my_dir/support"

cd $my_dir

# Load functions
source "$support_dir/functions.sh"

# Check and prompt for necessary dependencies
source "$support_dir/precheck.sh" && cd $my_dir

title 'XCODE'
#source "$support_dir/xcode.sh" && cd $my_dir

title 'DEPENDENCIES'
source "$support_dir/dependencies.sh" && cd $my_dir

title 'SYM LINKS'
source "$support_dir/sym_links.sh" && cd $my_dir
exit

title 'HOMEBREW'
source "$support_dir/brew.sh" && cd $my_dir

title 'GIT'
source "$support_dir/git.sh" && cd $my_dir

title 'COMPOSER'
source "$support_dir/composer.sh" && cd $my_dir

title 'VALET'
source "$support_dir/valet.sh" && cd $my_dir

title 'GIT CLONE'
source "$support_dir/git_clone.sh" && cd $my_dir

title 'NPM'
source "$support_dir/node.sh" && cd $my_dir

title 'MACOS SETTINGS'
source "$support_dir/mac_settings.sh"

title 'MANUAL STEPS'
source "$support_dir/manual_steps.sh"
