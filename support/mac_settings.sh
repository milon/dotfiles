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

if command_exists duti; then
    print_step "Setting Chrome as default browser (http/https/html)..."
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        duti -s com.google.Chrome http https html htm xhtml public.html
        print_success "Default handler set to Chrome (verify in System Settings > Desktop & Dock > Default web browser)"
    else
        print_info "Google Chrome.app not found; skipped (install Chrome first)"
    fi

    print_step "Setting IINA as default for media (audio / video)..."
    if [[ -d "/Applications/IINA.app" ]]; then
        typeset -a iina_ext=(
            3g2 3gp asf avi bik divx flv gifv m1v m2t m2ts m2v m4v mkv mod mov mp2 mp4 mpe mpeg mpg mpv mts mxf
            nsv ogm ogv qt ram rec rm rmvb tod ts vob webm wmv y4m
            3ga a52 aac ac3 adt adts aif aifc aiff alac amr ape au caf dts eac3 flac m4a m4b mka mpc ogg opus pcm
            ra shn spx tta wav wma wv
        )
        typeset -a iina_uti=(
            public.audio public.movie public.video public.audiovisual-content
            public.mpeg-4 public.mpeg-4-audio com.apple.quicktime-movie org.matroska.mkv
        )
        duti -s com.colliderli.iina "${iina_ext[@]}" "${iina_uti[@]}"
        print_success "IINA set as default for listed media types and UTIs (adjust per file in Finder: Get Info if needed)"
    else
        print_info "IINA.app not found; skipped (install IINA from Brewfile cask first)"
    fi
else
    print_info "duti not in PATH; skipping default apps for Chrome and IINA (run: brew bundle / brew install duti)"
fi

echo
print_success "Mac settings completed"