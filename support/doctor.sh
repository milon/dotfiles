#!/bin/zsh

# dotfiles doctor — non-destructive health check of the dev environment.
# Reports drift between what install.sh sets up and what's currently on disk.

source "$support_dir/functions.sh"

typeset -i errors=0
typeset -i warnings=0

note_error()   { errors+=1;   print_error "$1"; }
note_warning() { warnings+=1; print_info  "$1"; }

# ──────────────────────────────────────────────────────────────────────────
# Operating system
# ──────────────────────────────────────────────────────────────────────────
print_section "Operating system"
if [[ "$OSTYPE" == darwin* ]]; then
    print_success "macOS detected ($(sw_vers -productVersion 2>/dev/null || echo unknown))"
else
    note_error "Not running on macOS — most steps in this repo assume Darwin"
fi

# ──────────────────────────────────────────────────────────────────────────
# Xcode command line tools
# ──────────────────────────────────────────────────────────────────────────
print_section "Xcode command line tools"
if xcode-select -p &>/dev/null; then
    print_success "Installed at $(xcode-select -p)"
else
    note_error "Not installed — run: xcode-select --install"
fi

# ──────────────────────────────────────────────────────────────────────────
# Homebrew + Brewfile
# ──────────────────────────────────────────────────────────────────────────
print_section "Homebrew"
if command_exists brew; then
    print_success "brew on PATH ($(brew --version | head -n 1))"

    print_step "Checking Brewfile against installed packages..."
    if brew bundle check --file "$support_dir/Brewfile" --no-upgrade &>/dev/null; then
        print_success "Brewfile satisfied"
    else
        note_warning "Brewfile drift detected — run: dotfiles brew (or brew bundle --file $support_dir/Brewfile)"
        brew bundle check --file "$support_dir/Brewfile" --no-upgrade --verbose 2>&1 | sed 's/^/    /'
    fi
else
    note_error "brew not on PATH — run: dotfiles brew"
fi

# ──────────────────────────────────────────────────────────────────────────
# Symlinks
# ──────────────────────────────────────────────────────────────────────────
print_section "Symlinks"
source "$support_dir/symlinks_map.sh"
typeset -i sym_ok=0 sym_total=0
for key in ${(ko)sym_links}; do
    sym_total+=1
    val=${sym_links[$key]}
    src="${dotfiles_dir:A}/files/${key}"

    if [[ ! -e "$src" ]]; then
        note_error "Source missing in repo: $src"
        continue
    fi

    if [[ -L "$val" && ${val:A} == ${src:A} ]]; then
        sym_ok+=1
    elif [[ -L "$val" ]]; then
        note_error "Wrong target: $val -> ${val:A} (expected ${src:A})"
    elif [[ -e "$val" ]]; then
        note_error "Exists but not a symlink: $val (run: dotfiles symlinks)"
    else
        note_error "Missing: $val (run: dotfiles symlinks)"
    fi
done
print_info "$sym_ok / $sym_total symlinks OK"
unset val src

# ──────────────────────────────────────────────────────────────────────────
# mise
# ──────────────────────────────────────────────────────────────────────────
print_section "mise"
if command_exists mise; then
    print_success "mise installed ($(mise --version))"
    if mise_missing=$(mise ls --missing 2>/dev/null) && [[ -n "$mise_missing" ]]; then
        note_warning "Some mise tools are not installed:"
        echo "$mise_missing" | sed 's/^/    /'
        print_info "Run: dotfiles mise"
    else
        print_success "All configured mise tools installed"
    fi
else
    note_error "mise not on PATH — run: dotfiles mise"
fi

# ──────────────────────────────────────────────────────────────────────────
# Git configuration
# ──────────────────────────────────────────────────────────────────────────
print_section "Git"
git_name=$(git config --global --get user.name 2>/dev/null || true)
git_email=$(git config --global --get user.email 2>/dev/null || true)
if [[ -n "$git_name" && -n "$git_email" ]]; then
    print_success "user.name = $git_name"
    print_success "user.email = $git_email"
else
    note_warning "Git user.name / user.email not set globally — run: dotfiles git"
fi

# ──────────────────────────────────────────────────────────────────────────
# SSH key
# ──────────────────────────────────────────────────────────────────────────
print_section "SSH key"
ssh_found=0
for kt in ed25519 rsa ecdsa; do
    if [[ -f "$HOME/.ssh/id_${kt}" && -f "$HOME/.ssh/id_${kt}.pub" ]]; then
        print_success "Found ${kt} key at ~/.ssh/id_${kt}"
        ssh_found=1
    fi
done
(( ssh_found )) || note_warning "No SSH key found in ~/.ssh — git/SSH-based clones will fail"

# ──────────────────────────────────────────────────────────────────────────
# Essential commands on PATH
# ──────────────────────────────────────────────────────────────────────────
print_section "Essential commands on PATH"
typeset -a essentials=(zsh git vim nvim fzf zoxide starship eza bat mise topgrade gum)
for cmd in $essentials; do
    if command_exists "$cmd"; then
        print_success "$cmd"
    else
        note_warning "$cmd not found"
    fi
done

# ──────────────────────────────────────────────────────────────────────────
# Summary
# ──────────────────────────────────────────────────────────────────────────
echo
print_section "Summary"
if (( errors == 0 && warnings == 0 )); then
    print_success "All checks passed"
elif (( errors == 0 )); then
    print_info "$warnings warning(s); no errors"
else
    print_error "$errors error(s), $warnings warning(s)"
    return 1
fi
