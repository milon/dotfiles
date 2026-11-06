#!/bin/zsh

# dotfiles doctor — non-destructive health check of the dev environment.
# Reports drift between what install.sh sets up and what's currently on disk.

source "$support_dir/functions.sh"

typeset -i errors=0
typeset -i warnings=0

note_error()   { errors+=1;   print_error "$1"; }
note_warning() { warnings+=1; print_warn  "$1"; }

# ──────────────────────────────────────────────────────────────────────────
# Operating system
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Operating system"
if [[ "$OSTYPE" == darwin* ]]; then
    print_success "macOS detected ($(sw_vers -productVersion 2>/dev/null || echo unknown))"
else
    note_error "Not running on macOS — most steps in this repo assume Darwin"
fi

# ──────────────────────────────────────────────────────────────────────────
# Xcode command line tools
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Xcode command line tools"
if xcode-select -p &>/dev/null; then
    print_success "Installed at $(xcode-select -p)"
else
    note_error "Not installed — run: xcode-select --install"
fi

# ──────────────────────────────────────────────────────────────────────────
# Homebrew + Brewfile
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Homebrew"
if command_exists brew; then
    print_success "brew on PATH ($(brew --version | head -n 1))"

    print_step "Checking Brewfile against installed packages..."
    if brew bundle check --file "$support_dir/Brewfile" --no-upgrade &>/dev/null; then
        print_success "Brewfile satisfied"
    else
        note_warning "Brewfile drift detected — run: dotfiles brew"
        brew bundle check --file "$support_dir/Brewfile" --no-upgrade --verbose 2>&1 | print_stream
    fi

    if [[ -f "$HOME/.Brewfile.local" ]]; then
        if brew bundle check --file "$HOME/.Brewfile.local" --no-upgrade &>/dev/null; then
            print_success "~/.Brewfile.local satisfied"
        else
            note_warning "Per-machine Brewfile drift — run: dotfiles brew"
            brew bundle check --file "$HOME/.Brewfile.local" --no-upgrade --verbose 2>&1 | print_stream
        fi
    else
        note_warning "~/.Brewfile.local missing — run: dotfiles precheck"
    fi
else
    note_error "brew not on PATH — run: dotfiles brew"
fi

# ──────────────────────────────────────────────────────────────────────────
# Symlinks
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Symlinks"
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
print_subsection "mise"
if command_exists mise; then
    print_success "mise installed ($(mise --version))"
    if mise_missing=$(mise ls --missing 2>/dev/null) && [[ -n "$mise_missing" ]]; then
        note_warning "Some mise tools are not installed — run: dotfiles mise"
        print -r -- "$mise_missing" | print_stream
    else
        print_success "All configured mise tools installed"
    fi
else
    note_error "mise not on PATH — run: dotfiles mise"
fi

# ──────────────────────────────────────────────────────────────────────────
# Git configuration
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Git"
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

hooks_path=$(git -C "$dotfiles_dir" config --local --get core.hooksPath 2>/dev/null || true)
if [[ "$hooks_path" == ".githooks" ]]; then
    print_success "core.hooksPath = .githooks (this repo)"
else
    note_warning "core.hooksPath not set to .githooks — run: dotfiles git"
fi
unset hooks_path

# ──────────────────────────────────────────────────────────────────────────
# Per-machine shell overrides
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Shell overrides"
if [[ -f "$HOME/.zshrc.local" ]]; then
    print_success "~/.zshrc.local present"
    local_mode=$(stat -f '%Lp' "$HOME/.zshrc.local" 2>/dev/null || true)
    if [[ -n $local_mode ]]; then
        if [[ "${local_mode[-2,-1]}" != "00" ]]; then
            note_warning "~/.zshrc.local is mode ${local_mode} (group/other readable) — chmod 600 ~/.zshrc.local"
        else
            print_success "~/.zshrc.local permissions are private (${local_mode})"
        fi
    fi
    unset local_mode
else
    note_warning "~/.zshrc.local missing — run: dotfiles precheck"
fi

# ──────────────────────────────────────────────────────────────────────────
# Sheldon
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Sheldon"
sheldon_toml="${HOME}/.config/sheldon/plugins.toml"
sheldon_lock="${HOME}/.local/share/sheldon/plugins.lock"
if ! command_exists sheldon; then
    note_warning "sheldon not installed — run: dotfiles brew"
elif [[ ! -f $sheldon_toml ]]; then
    note_warning "sheldon plugins.toml missing — run: dotfiles symlinks"
elif [[ ! -f $sheldon_lock ]]; then
    note_warning "sheldon lock missing — run: sheldon lock"
elif [[ $sheldon_toml -nt $sheldon_lock ]]; then
    note_warning "sheldon plugins.toml newer than lock — run: sheldon lock"
else
    print_success "sheldon lock is up to date"
fi
unset sheldon_toml sheldon_lock

# ──────────────────────────────────────────────────────────────────────────
# Atuin
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Atuin"
if ! command_exists atuin; then
    note_warning "atuin not installed — run: dotfiles brew"
elif atuin status &>/dev/null; then
    print_success "Logged in to Atuin Hub"
else
    note_warning "Not logged in to Atuin Hub — run: dotfiles atuin"
fi

# ──────────────────────────────────────────────────────────────────────────
# Lerd
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Lerd"
if ! command_exists lerd; then
    note_warning "lerd not installed — run: dotfiles brew && dotfiles lerd"
elif lerd status &>/dev/null; then
    print_success "lerd status OK"
else
    note_warning "lerd status reported problems — run: lerd status / lerd start"
fi

# ──────────────────────────────────────────────────────────────────────────
# Window management (yabai + skhd)
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Window management"
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
# SSH key + agent
# ──────────────────────────────────────────────────────────────────────────
print_subsection "SSH key"
if ssh_key_type=$(detect_ssh_key); then
    print_success "Found ${ssh_key_type} key at ~/.ssh/id_${ssh_key_type}"
else
    note_warning "No SSH key found in ~/.ssh — git/SSH-based clones will fail"
fi

ssh-add -l >/dev/null 2>&1
ssh_add_ec=$?
if (( ssh_add_ec == 0 )); then
    print_success "ssh-agent has at least one loaded key"
elif (( ssh_add_ec == 1 )); then
    note_warning "ssh-agent has no loaded keys — run: ssh-add ~/.ssh/id_ed25519"
else
    note_warning "ssh-agent not reachable — start the agent and run ssh-add"
fi
unset ssh_add_ec

# ──────────────────────────────────────────────────────────────────────────
# Essential commands on PATH
# ──────────────────────────────────────────────────────────────────────────
print_subsection "Essential commands on PATH"
typeset -a essentials=(zsh git nvim fzf atuin zoxide starship eza bat mise topgrade gum shellcheck sheldon yabai skhd lerd)
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
print_subsection "Summary"
if (( errors == 0 && warnings == 0 )); then
    print_success "All checks passed"
elif (( errors == 0 )); then
    print_warn "$warnings warning(s); no errors"
else
    print_error "$errors error(s), $warnings warning(s)"
    return 1
fi
