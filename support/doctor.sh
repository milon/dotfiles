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

    if [[ -f "$HOME/.Brewfile.local" ]]; then
        if brew bundle check --file "$HOME/.Brewfile.local" --no-upgrade &>/dev/null; then
            print_success "~/.Brewfile.local satisfied"
        else
            note_warning "Per-machine Brewfile drift — run: dotfiles brew"
            brew bundle check --file "$HOME/.Brewfile.local" --no-upgrade --verbose 2>&1 | sed 's/^/    /'
        fi
    else
        note_warning "~/.Brewfile.local missing — re-run precheck, or create it for machine-only packages"
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

tracked_gitconfig="${dotfiles_dir:A}/files/home/gitconfig"
if git config --global --get-all include.path 2>/dev/null | grep -qxF "$tracked_gitconfig"; then
    print_success "include.path includes tracked gitconfig"
else
    note_warning "Tracked gitconfig not in include.path — run: dotfiles git"
fi
unset tracked_gitconfig

# ──────────────────────────────────────────────────────────────────────────
# Per-machine shell overrides
# ──────────────────────────────────────────────────────────────────────────
print_section "Shell overrides"
if [[ -f "$HOME/.zshrc.local" ]]; then
    print_success "~/.zshrc.local present"
else
    note_warning "~/.zshrc.local missing — run: dotfiles (re-run precheck via ./install.sh) or create it"
fi

# ──────────────────────────────────────────────────────────────────────────
# Window management (yabai + skhd)
# ──────────────────────────────────────────────────────────────────────────
print_section "Window management"
for cmd in yabai skhd; do
    if ! command_exists "$cmd"; then
        note_warning "$cmd not installed — run: dotfiles brew && dotfiles hotkeys"
        continue
    fi
    if pgrep -x "$cmd" >/dev/null 2>&1; then
        print_success "$cmd running"
    else
        note_warning "$cmd installed but not running — run: dotfiles hotkeys"
    fi
done

# ──────────────────────────────────────────────────────────────────────────
# SSH key
# ──────────────────────────────────────────────────────────────────────────
print_section "SSH key"
if ssh_key_type=$(detect_ssh_key); then
    print_success "Found ${ssh_key_type} key at ~/.ssh/id_${ssh_key_type}"
else
    note_warning "No SSH key found in ~/.ssh — git/SSH-based clones will fail"
fi

# ──────────────────────────────────────────────────────────────────────────
# Essential commands on PATH
# ──────────────────────────────────────────────────────────────────────────
print_section "Essential commands on PATH"
typeset -a essentials=(zsh git nvim fzf atuin zoxide starship eza bat mise topgrade gum shellcheck sheldon yabai skhd)
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
