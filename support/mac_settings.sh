#!/bin/zsh

source "$support_dir/functions.sh"

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
killall Dock
print_success "Dock: left, autohide on"

defaults write com.apple.Spotlight MenuWebSearchEnabled -bool false
defaults write com.apple.Spotlight showWebSuggestions -bool false 2>/dev/null || true
killall Spotlight 2>/dev/null || true
print_success "Spotlight web suggestions disabled"

defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
print_success "Full keyboard access enabled (Tab focuses all controls)"

if command_exists duti; then
    if [[ -d "/Applications/Google Chrome.app" ]]; then
        duti -s com.google.Chrome http https html htm xhtml public.html
        print_success "Default browser set to Chrome"
        print_detail "Verify in System Settings → Desktop & Dock → Default web browser"
    else
        print_warn "Google Chrome.app not found — skipping default browser"
    fi

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
        print_success "Default media handler set to IINA"
    else
        print_warn "IINA.app not found — skipping media defaults"
    fi
else
    print_warn "duti not in PATH — skipping Chrome/IINA defaults (run: dotfiles brew)"
fi
