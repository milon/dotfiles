#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    print_step "Applying macOS defaults..."
    touch ~/.hushlogin
    print_success "hushlogin enabled"

    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    print_success "Network .DS_Store files disabled"

    defaults write com.apple.screencapture type jpg
    print_success "Screenshot type set to JPG"

    defaults write com.apple.dock orientation -string "left"
    defaults write com.apple.dock autohide -bool true
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0.2
    killall Dock 2>/dev/null || true
    print_success "Dock: left, autohide on"

    defaults write com.apple.Spotlight MenuWebSearchEnabled -bool false
    defaults write com.apple.Spotlight showWebSuggestions -bool false 2>/dev/null || true
    killall Spotlight 2>/dev/null || true
    print_success "Spotlight web suggestions disabled"

    defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
    print_success "Full keyboard access enabled"

    # Default browser via duti (one http/https prompt is fine). Do NOT mass-assign
    # media types to IINA — each bind fights QuickTime and pops "Use IINA / Keep
    # QuickTime". Set IINA once in Finder Get Info → Open with → Change All.
    if command_exists duti; then
        if [[ -d "/Applications/Google Chrome.app" ]]; then
            duti -s com.google.Chrome http
            duti -s com.google.Chrome https
            print_success "Default browser set to Chrome"
        else
            print_warn "Google Chrome.app not found — skipping"
        fi
    else
        print_warn "duti not in PATH — run: dot brew"
    fi
}

cmd_check() {
    print_info "macOS defaults are write-mostly — spot-check Dock orientation"
    local orient
    orient=$(defaults read com.apple.dock orientation 2>/dev/null || true)
    if [[ "$orient" == left ]]; then
        print_success "Dock orientation = left"
    else
        print_warn "Dock orientation is '${orient:-unset}' — run: dot mac"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: mac.zsh apply|check"; exit 1 ;;
esac
