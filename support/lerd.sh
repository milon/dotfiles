#!/bin/zsh

# Lerd serves .test on both machines. PHP and static projects in ~/Code are
# parked. A Docker Compose app stays on 127.0.0.1 and gets a proxy block in
# its own .lerd.yaml, then `lerd link`. Host PHP stays installed for CLI tools.

source "$support_dir/functions.sh"

if ! command_exists lerd; then
    print_error "lerd not found — run 'dotfiles brew' to install it from the Brewfile"
    return 1
fi

# Lerd binds ports 80 and 443 and the .test resolver. Stop every Valet
# service first. `valet uninstall --force` also removes Homebrew PHP, so
# nginx and dnsmasq are uninstalled on their own after Lerd is up.
if command_exists valet; then
    print_step "Stopping Valet so Lerd can serve .test..."
    if valet stop all; then
        print_success "Valet stopped"
    else
        print_error "Could not stop Valet"
        return 1
    fi
fi

print_step "Installing Lerd services..."
if lerd install; then
    print_success "Lerd installed"
    lerd path:disable >/dev/null || true
else
    print_error "Lerd installation failed"
    return 1
fi

print_step "Setting up Code directory..."
mkdir -p "$HOME/Code"

print_step "Parking Lerd in the Code directory..."
if lerd park "$HOME/Code"; then
    print_success "Lerd parked in ~/Code"
else
    print_error "Failed to park Lerd"
    return 1
fi

if command_exists valet; then
    print_step "Removing Valet sudoers entries..."
    valet trust --off || print_error "Could not remove Valet sudoers entries"
fi

if command_exists brew; then
    print_step "Removing Valet's nginx and dnsmasq..."
    for formula in nginx dnsmasq; do
        if brew list --formula "$formula" &>/dev/null; then
            if brew uninstall "$formula"; then
                print_success "$formula removed"
            else
                print_error "Could not remove $formula"
                return 1
            fi
        fi
    done
fi

if command_exists composer && composer global show laravel/valet &>/dev/null; then
    print_step "Removing Laravel Valet from global Composer packages..."
    if composer global remove --no-interaction laravel/valet; then
        print_success "Laravel Valet removed"
    else
        print_error "Could not remove laravel/valet"
        return 1
    fi
fi

print_info "Projects in ~/Code are served at <folder>.test."
print_info "A Compose app needs proxy.port in its .lerd.yaml, then: lerd link"
