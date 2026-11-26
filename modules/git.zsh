#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    local existing_name existing_email configure_user=true
    existing_name=$(git config --global --get user.name 2>/dev/null || true)
    existing_email=$(git config --global --get user.email 2>/dev/null || true)

    if [[ -n "$existing_name" || -n "$existing_email" ]]; then
        print_info "Git identity already configured"
        print_detail "user.name  = ${existing_name:-<unset>}"
        print_detail "user.email = ${existing_email:-<unset>}"
        if ! confirm_yn "Override existing Git identity?"; then
            configure_user=false
        fi
    elif dot_noninteractive; then
        print_error "Git user.name / user.email not set — configure before --yes"
        return 1
    fi

    if [[ $configure_user == true ]]; then
        local git_author_name="" git_author_email=""
        while [[ -z $git_author_name ]]; do
            print_step "Git author name:"
            read git_author_name
        done
        while [[ -z $git_author_email ]]; do
            print_step "Git author email:"
            read git_author_email
        done
        git config --global user.name "$git_author_name"
        git config --global user.email "$git_author_email"
        print_success "Git user configured"
    fi

    local tracked_gitconfig="${DOT_CONFIG_DIR}/gitconfig"
    [[ -f $tracked_gitconfig ]] || { print_error "Missing $tracked_gitconfig"; return 1; }

    print_step "Linking tracked gitconfig via include.path..."
    if git config --global --get-all include.path 2>/dev/null | grep -qxF "$tracked_gitconfig"; then
        print_info "include.path already set"
    else
        git config --global --add include.path "$tracked_gitconfig"
        print_success "Added include.path -> config/gitconfig"
    fi

    print_step "Enabling tracked git hooks..."
    if [[ -d "${DOTFILES_ROOT}/.githooks" ]]; then
        git -C "$DOTFILES_ROOT" config --local core.hooksPath .githooks
        print_success "core.hooksPath -> .githooks"
    fi
}

cmd_check() {
    local git_name git_email
    git_name=$(git config --global --get user.name 2>/dev/null || true)
    git_email=$(git config --global --get user.email 2>/dev/null || true)
    if [[ -n "$git_name" && -n "$git_email" ]]; then
        print_success "user.name = $git_name"
        print_success "user.email = $git_email"
    else
        print_warn "Git identity not set — run: dot git"
    fi

    local tracked="${DOT_CONFIG_DIR}/gitconfig"
    if git config --global --get-all include.path 2>/dev/null | grep -qxF "$tracked"; then
        print_success "include.path includes config/gitconfig"
    else
        print_warn "Tracked gitconfig not in include.path — run: dot git"
    fi

    local hooks
    hooks=$(git -C "$DOTFILES_ROOT" config --local --get core.hooksPath 2>/dev/null || true)
    if [[ "$hooks" == ".githooks" ]]; then
        print_success "core.hooksPath = .githooks"
    else
        print_warn "core.hooksPath not set — run: dot git"
    fi
}

case "${1:-}" in
    apply) cmd_apply ;;
    check) cmd_check ;;
    *) print_error "Usage: git.zsh apply|check"; exit 1 ;;
esac
