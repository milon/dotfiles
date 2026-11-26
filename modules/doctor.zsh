#!/bin/zsh
# Aggregated health check — subsection style (matches old `dotfiles doctor`).
set -euo pipefail
source "${0:A:h}/_common.zsh"

doctor_main() {
    typeset -i errors=0
    typeset -i warnings=0

    note_error()   { errors+=1;   print_error "$1"; }
    note_warning() { warnings+=1; print_warn  "$1"; }

    print_subsection "Operating system"
    if [[ "$OSTYPE" == darwin* ]]; then
        print_success "macOS detected ($(sw_vers -productVersion 2>/dev/null || echo unknown))"
    else
        note_error "Not running on macOS — most steps in this repo assume Darwin"
    fi

    print_subsection "Xcode command line tools"
    if xcode-select -p &>/dev/null; then
        print_success "Installed at $(xcode-select -p)"
    else
        note_error "Not installed — run: xcode-select --install"
    fi

    print_subsection "Homebrew"
    local BREWFILE="${DOT_INVENTORY_DIR}/Brewfile"
    if command_exists brew; then
        print_success "brew on PATH ($(brew --version | head -n 1))"
        print_step "Checking Brewfile against installed packages..."
        if brew bundle check --file "$BREWFILE" --no-upgrade &>/dev/null; then
            print_success "Brewfile satisfied"
        else
            note_warning "Brewfile drift detected — run: dot brew"
            brew bundle check --file "$BREWFILE" --no-upgrade --verbose 2>&1 | print_stream || true
        fi
        if [[ -f "$HOME/.Brewfile.local" ]]; then
            if brew bundle check --file "$HOME/.Brewfile.local" --no-upgrade &>/dev/null; then
                print_success "~/.Brewfile.local satisfied"
            else
                note_warning "Per-machine Brewfile drift — run: dot brew"
            fi
        else
            note_warning "~/.Brewfile.local missing — run: dot precheck"
        fi
    else
        note_error "brew not on PATH — run: dot brew"
    fi

    print_subsection "Symlinks"
    dot_load_links
    typeset -i sym_ok=0 sym_total=0
    local key src dest
    for key in ${(ko)reply_links}; do
        sym_total+=1
        dest=$reply_links[$key]
        src="${DOT_CONFIG_DIR}/${key}"
        if [[ ! -e $src ]]; then
            note_error "Source missing in repo: $src"
            continue
        fi
        if [[ -L $dest && ${dest:A} == ${src:A} ]]; then
            sym_ok+=1
        elif [[ -L $dest ]]; then
            note_error "Wrong target: $dest -> ${dest:A}"
        elif [[ -e $dest ]]; then
            note_error "Exists but not a symlink: $dest (run: dot symlinks)"
        else
            note_error "Missing: $dest (run: dot symlinks)"
        fi
    done
    print_info "$sym_ok / $sym_total symlinks OK"

    print_subsection "mise"
    if command_exists mise; then
        print_success "mise installed ($(mise --version))"
        local mise_missing
        if mise_missing=$(mise ls --missing 2>/dev/null) && [[ -n "$mise_missing" ]]; then
            note_warning "Some mise tools are not installed — run: dot mise"
            print -r -- "$mise_missing" | print_stream
        else
            print_success "All configured mise tools installed"
        fi
    else
        note_error "mise not on PATH — run: dot mise"
    fi

    print_subsection "Git"
    local git_name git_email tracked_gitconfig hooks_path
    git_name=$(git config --global --get user.name 2>/dev/null || true)
    git_email=$(git config --global --get user.email 2>/dev/null || true)
    if [[ -n "$git_name" && -n "$git_email" ]]; then
        print_success "user.name = $git_name"
        print_success "user.email = $git_email"
    else
        note_warning "Git user.name / user.email not set globally — run: dot git"
    fi
    tracked_gitconfig="${DOT_CONFIG_DIR}/gitconfig"
    if git config --global --get-all include.path 2>/dev/null | grep -qxF "$tracked_gitconfig"; then
        print_success "include.path includes tracked gitconfig"
    else
        note_warning "Tracked gitconfig not in include.path — run: dot git"
    fi
    hooks_path=$(git -C "$DOTFILES_ROOT" config --local --get core.hooksPath 2>/dev/null || true)
    if [[ "$hooks_path" == ".githooks" ]]; then
        print_success "core.hooksPath = .githooks (this repo)"
    else
        note_warning "core.hooksPath not set to .githooks — run: dot git"
    fi

    print_subsection "Shell overrides"
    if [[ -f "$HOME/.zshrc.local" ]]; then
        print_success "~/.zshrc.local present"
        local local_mode
        local_mode=$(stat -f '%Lp' "$HOME/.zshrc.local" 2>/dev/null || true)
        if [[ -n $local_mode ]]; then
            if [[ "${local_mode[-2,-1]}" != "00" ]]; then
                note_warning "~/.zshrc.local is mode ${local_mode} (group/other readable) — chmod 600 ~/.zshrc.local"
            else
                print_success "~/.zshrc.local permissions are private (${local_mode})"
            fi
        fi
    else
        note_warning "~/.zshrc.local missing — run: dot precheck"
    fi

    print_subsection "Sheldon"
    local sheldon_toml="${HOME}/.config/sheldon/plugins.toml"
    local sheldon_lock="${HOME}/.local/share/sheldon/plugins.lock"
    if ! command_exists sheldon; then
        note_warning "sheldon not installed — run: dot brew"
    elif [[ ! -f $sheldon_toml ]]; then
        note_warning "sheldon plugins.toml missing — run: dot symlinks"
    elif [[ ! -f $sheldon_lock ]]; then
        note_warning "sheldon lock missing — run: sheldon lock"
    elif [[ $sheldon_toml -nt $sheldon_lock ]]; then
        note_warning "sheldon plugins.toml newer than lock — run: sheldon lock"
    else
        print_success "sheldon lock is up to date"
    fi

    print_subsection "Atuin"
    if ! command_exists atuin; then
        note_warning "atuin not installed — run: dot brew"
    elif atuin status &>/dev/null; then
        print_success "Logged in to Atuin Hub"
    else
        note_warning "Not logged in to Atuin Hub — run: dot atuin"
    fi

    print_subsection "PHP / Composer"
    local cmd
    for cmd in php composer pie; do
        if command_exists "$cmd"; then
            print_success "$cmd on PATH"
        else
            note_warning "$cmd not on PATH — run: dot brew && dot php"
        fi
    done
    if command_exists composer && composer global show tightenco/takeout &>/dev/null; then
        note_warning "tightenco/takeout still installed globally — remove with: composer global remove tightenco/takeout"
    fi

    print_subsection "Lerd"
    if ! command_exists podman; then
        note_warning "podman not on PATH — Lerd needs Podman"
    elif podman info &>/dev/null; then
        print_success "podman reachable"
    else
        note_warning "podman not reachable — run: lerd start (or podman machine start)"
    fi
    if ! command_exists lerd; then
        note_warning "lerd not installed — run: dot brew && dot lerd"
    elif lerd status &>/dev/null; then
        print_success "lerd status OK"
    else
        note_warning "lerd status reported problems — run: lerd status / lerd start"
    fi

    print_subsection "Window management"
    for cmd in yabai skhd; do
        if ! command_exists "$cmd"; then
            note_warning "$cmd not installed — run: dot brew && dot hotkeys"
            continue
        fi
        if pgrep -x "$cmd" >/dev/null 2>&1; then
            print_success "$cmd running"
        else
            note_warning "$cmd installed but not running — run: dot hotkeys"
        fi
    done

    print_subsection "SSH key"
    local ssh_key_type ssh_add_ec
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

    print_subsection "Essential commands on PATH"
    typeset -a essentials=(zsh git nvim fzf atuin zoxide starship eza bat mise topgrade gum shellcheck sheldon yabai skhd lerd php composer pie podman)
    for cmd in $essentials; do
        if command_exists "$cmd"; then
            print_success "$cmd"
        else
            note_warning "$cmd not found"
        fi
    done

    print_subsection "Summary"
    if (( errors == 0 && warnings == 0 )); then
        print_success "All checks passed"
    elif (( errors == 0 )); then
        print_warn "$warnings warning(s); no errors"
    else
        print_error "$errors error(s), $warnings warning(s)"
        return 1
    fi
}

case "${1:-apply}" in
    apply|check) doctor_main ;;
    *) print_error "Usage: doctor.zsh apply|check"; exit 1 ;;
esac
