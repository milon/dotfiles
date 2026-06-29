#!/bin/zsh

source "$support_dir/functions.sh"

# ──────────────────────────────────────────────────────────────────────────
# Identity (user.name / user.email)
# ──────────────────────────────────────────────────────────────────────────
existing_name=$(git config --global --get user.name 2>/dev/null || true)
existing_email=$(git config --global --get user.email 2>/dev/null || true)

configure_user=true
if [[ -n "$existing_name" || -n "$existing_email" ]]; then
    print_info "Git identity already configured:"
    print_info "  user.name  = ${existing_name:-<unset>}"
    print_info "  user.email = ${existing_email:-<unset>}"
    echo
    if read -q "choice?Override existing Git identity? (y/n) "; then
        echo
    else
        echo
        print_info "Keeping existing Git identity"
        configure_user=false
    fi
fi

if [[ $configure_user == true ]]; then
    git_author_name=""
    while [[ -z $git_author_name ]]; do
        print_step "Enter your GitHub author name:"
        read git_author_name
        [[ -z $git_author_name ]] && print_error "Name cannot be empty"
    done

    git_author_email=""
    while [[ -z $git_author_email ]]; do
        print_step "Enter your GitHub user email:"
        read git_author_email
        [[ -z $git_author_email ]] && print_error "Email cannot be empty"
    done

    echo

    print_step "Setting Git user configuration..."
    git config --global user.name "$git_author_name"
    git config --global user.email "$git_author_email"
    print_success "Git user configured"
fi

# ──────────────────────────────────────────────────────────────────────────
# Static config: include the tracked gitconfig (idempotent)
# ──────────────────────────────────────────────────────────────────────────
tracked_gitconfig="${dotfiles_dir:A}/files/home/gitconfig"

if [[ ! -f $tracked_gitconfig ]]; then
    print_error "Tracked gitconfig not found: $tracked_gitconfig"
    return 1
fi

print_step "Linking tracked gitconfig via include.path..."
if git config --global --get-all include.path 2>/dev/null | grep -qxF "$tracked_gitconfig"; then
    print_info "include.path already points at ${tracked_gitconfig#$HOME/}"
else
    git config --global --add include.path "$tracked_gitconfig"
    print_success "Added include.path -> ${tracked_gitconfig#$HOME/}"
fi

# ──────────────────────────────────────────────────────────────────────────
# Pre-commit hook (repo-local, dotfiles checkout only)
# ──────────────────────────────────────────────────────────────────────────
# Point this repo at the tracked .githooks/ directory so `git commit` runs the
# lint + symlink-source checks. Scoped with --local so it never affects other
# repositories on the machine.
print_step "Enabling tracked git hooks for this repo..."
if [[ -d "${dotfiles_dir:A}/.githooks" ]]; then
    current_hooks_path=$(git -C "$dotfiles_dir" config --local --get core.hooksPath 2>/dev/null || true)
    if [[ "$current_hooks_path" == ".githooks" ]]; then
        print_info "core.hooksPath already set to .githooks"
    else
        git -C "$dotfiles_dir" config --local core.hooksPath .githooks
        print_success "Set core.hooksPath -> .githooks"
    fi
else
    print_info "No .githooks directory found, skipping hook setup"
fi
