#!/bin/zsh

# hide last login info item2
touch ~/.hushlogin

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Change screenshot type to JPG
defaults write com.apple.screencapture type jpg

# Disable autohide animation for dock 
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
killall Dock

# choosy as browser
# disable spotlight suggestions
# full keyboard access; all controls
# iterm use jetbrains mono for powerline
# set caps lock as esc
