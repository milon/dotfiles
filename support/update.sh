#!/bin/zsh

source "$support_dir/functions.sh"

print_section "Updating Packages"

print_step "Updating Homebrew and Mac App Store apps..."
if brew cu --all --include-mas --yes --cleanup 2>/dev/null; then
    print_success "Homebrew casks updated"
else
    print_info "brew-cask-upgrade not available, skipping cask updates"
fi

print_step "Upgrading Homebrew packages..."
if brew upgrade; then
    print_success "Homebrew packages upgraded"
else
    print_error "Some Homebrew packages failed to upgrade"
fi

echo
print_step "Updating mise and tools..."
if mise self-update 2>/dev/null; then
    print_success "mise updated"
fi
if mise upgrade; then
    print_success "mise tools upgraded"
else
    print_info "Some mise tools may have failed to upgrade"
fi

echo
print_step "Updating Composer and global dependencies..."
if composer self-update && composer global update; then
    print_success "Composer updated"
else
    print_info "Composer not available, skipping"
fi

echo
print_success "All packages updated successfully"
