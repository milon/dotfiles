#!/bin/zsh

# PHP and Composer themselves are installed via the Brewfile (taps: shivammathur/php,
# shivammathur/extensions). This script only handles the bits Homebrew can't:
# global Composer packages used by the rest of the workflow (Valet, Takeout, Psy).

source "$support_dir/functions.sh"

if ! command_exists php; then
    print_error "php not found — run 'dotfiles brew' to install it from the Brewfile"
    return 1
fi

if ! command_exists pie; then
    print_error "pie not found — run 'dotfiles brew' to install it from the Brewfile"
    return 1
fi

if ! command_exists composer; then
    print_error "composer not found — run 'dotfiles brew' to install it from the Brewfile"
    return 1
fi

print_info "PHP version: $(php --version | head -n 1)"
print_info "pie version: $(pie --version | head -n 1)"
print_info "Composer version: $(composer --version | head -n 1)"

print_step "Installing global Composer packages..."
if composer global require laravel/valet tightenco/takeout:~2.0 psy/psysh; then
    print_success "Global Composer packages installed"
else
    print_error "Some global packages failed to install"
    return 1
fi
