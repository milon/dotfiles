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

print_step "Disabling Spotlight web / menu search suggestions..."
defaults write com.apple.Spotlight MenuWebSearchEnabled -bool false
defaults write com.apple.Spotlight showWebSuggestions -bool false 2>/dev/null || true
killall Spotlight 2>/dev/null || true
print_success "Spotlight suggestion defaults updated"

print_step "Enabling full keyboard access (focus all controls with Tab)..."
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
print_success "AppleKeyboardUIMode set to 3 (all controls)"

print_step "Setting Chrome as default browser (http/https/html)..."
if ! command_exists duti; then
    print_info "duti not in PATH (run brew bundle / brew install duti)"
elif [[ ! -d "/Applications/Google Chrome.app" ]]; then
    print_info "Google Chrome.app not found; skipped (install Chrome first)"
else
    duti -s com.google.Chrome http https html htm xhtml public.html
    print_success "Default handler set to Chrome (verify in System Settings > Desktop & Dock > Default web browser)"
fi

echo
print_success "Mac settings completed"