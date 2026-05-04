#!/bin/zsh

source "$support_dir/functions.sh"

manage_service() {
    local cmd=$1

    if ! command_exists "$cmd"; then
        print_step "Installing ${cmd}..."
        if ! brew install "koekeishiya/formulae/${cmd}"; then
            print_error "Failed to install ${cmd}"
            return 1
        fi
        print_success "${cmd} installed"
    fi

    print_step "Reloading ${cmd}..."
    if "${cmd}" --restart-service >/dev/null 2>&1; then
        print_success "${cmd} restarted"
        return 0
    fi

    if "${cmd}" --start-service; then
        print_success "${cmd} started"
    else
        print_error "Failed to start ${cmd}"
        return 1
    fi
}

manage_service yabai || return 1
manage_service skhd  || return 1
