#!/bin/zsh

# hide last login info item2
touch ~/.hushlogin

# Avoid creating .DS_Store files on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Disable annoying disk eject warning
defaults write /Library/Preferences/SystemConfiguration/com.apple.DiskArbitration.diskarbitrationd.plist DADisableEjectNotification -bool YES && sudo pkill diskarbitrationd

# Change screenshot type to JPG
defaults write com.apple.screencapture type jpg

# choosy as browser
# disable spotlight suggestions
# full keyboard access; all controls
# iterm use atom onedark theme
# iterm use jetbrains mono for powerline
# set caps lock as esc
