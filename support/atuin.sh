#!/bin/zsh

source "$support_dir/functions.sh"

if ! command_exists atuin; then
    print_error "atuin is not installed — run: dotfiles brew"
    return 1
fi

hub="https://api.atuin.sh"
status_output=$(atuin status 2>&1) && logged_in=true || logged_in=false

if [[ $logged_in == true ]]; then
    username=$(print -r -- "$status_output" | awk -F': ' '/Username:/ { print $2 }')
    address=$(print -r -- "$status_output" | awk -F': ' '/Address:/ { print $2 }')
    print_info "Already logged in to Atuin Hub"
    print_info "  username = ${username:-<unknown>}"
    print_info "  address  = ${address:-$hub}"
else
    print_info "Not logged in to Atuin Hub ($hub)"

    if dotfiles_noninteractive; then
        print_info "Skipping Atuin Hub login in noninteractive mode — run: dotfiles atuin"
        return 0
    fi

    echo
    print_step "1) Log in to an existing account"
    print_step "2) Register a new account"
    print_step "3) Skip"
    echo
    choice=""
    while [[ $choice != 1 && $choice != 2 && $choice != 3 ]]; do
        read "choice?Choice (1/2/3): "
    done

    case $choice in
        1)
            atuin login || return 1
            ;;
        2)
            atuin register || return 1
            ;;
        3)
            print_info "Skipped Atuin Hub login"
            return 0
            ;;
    esac
fi

echo
if confirm_yn "Sync history with Atuin Hub now?"; then
    atuin sync || return 1
    print_success "Synced with Atuin Hub"
else
    print_info "Skipped sync"
fi
