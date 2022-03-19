#!/bin/bash

# Hide the desktop
defaults write com.apple.finder CreateDesktop -bool false && killall Finder

# hide last login info item2
touch ~/.hushlogin

# choosy as browser
# disable spotlight suggestions
# full keyboard access; all controls
# iterm use atom onedark theme
# iterm use jetbrains mono for powerline
# set caps lock as esc

# install vundle or whatever other vim bundler
vim +PluginInstall +qall
