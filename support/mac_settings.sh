#!/bin/zsh

source "$support_dir/functions.sh"

print_step "Hiding last login info..."
touch ~/.hushlogin
print_success "Last login info hidden"

print_step "Disabling .DS_Store files on network volumes..."
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
print_success "Network .DS_Store files disabled"

print_step "Setting screenshot type to JPG..."
defaults write com.apple.screencapture type jpg
print_success "Screenshot type set to JPG"

print_step "Configuring Dock settings..."
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.2
killall Dock
print_success "Dock configured (position: left, autohide enabled)"

print_info "Note: Additional manual settings may be needed:"
print_info "  - Set Chrome as default browser"
print_info "  - Disable Spotlight suggestions"
print_info "  - Enable full keyboard access for all controls"
print_info "  - Set Caps Lock as Escape"
