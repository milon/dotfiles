#!/bin/zsh

source "$support_dir/functions.sh"

if ! command_exists brew; then
    print_step "Homebrew not found, installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    brew_dir=$(brew_prefix) || {
        print_error "Homebrew install completed but brew binary not found at /opt/homebrew or /usr/local"
        return 1
    }

    # Persist shellenv for future login shells, then load it for this session.
    if ! grep -q "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
        echo "eval \"\$(${brew_dir}/bin/brew shellenv)\"" >> "$HOME/.zprofile"
    fi
    eval "$(${brew_dir}/bin/brew shellenv)"

    print_success "Homebrew installed (prefix: ${brew_dir})"
else
    print_info "Homebrew already installed, skipping installation"
fi

echo
print_step "Installing Homebrew dependencies from Brewfile..."
if brew bundle --file "$support_dir/Brewfile"; then
    print_success "Shared Homebrew dependencies installed"
else
    print_error "Some Homebrew dependencies failed to install"
    return 1
fi

# Per-machine packages. Same idea as ~/.zshrc.local: not tracked, optional.
local_brewfile="$HOME/.Brewfile.local"
if [[ -f $local_brewfile ]]; then
    echo
    print_step "Installing per-machine packages from ~/.Brewfile.local..."
    if brew bundle --file "$local_brewfile"; then
        print_success "Per-machine Homebrew dependencies installed"
    else
        print_error "Some per-machine Homebrew dependencies failed to install"
        return 1
    fi
else
    print_info "No ~/.Brewfile.local — skipping per-machine packages"
fi
