#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

cmd_apply() {
    dot_load_repos
    mkdir -p "$reply_code_dir"
    typeset -i failures=0
    local dir repo
    for dir repo in ${(kv)reply_repos}; do
        print_step "Cloning ${dir}..."
        if [[ -d "${reply_code_dir}/${dir}/.git" ]]; then
            print_info "${dir} exists — pulling..."
            if ( cd "${reply_code_dir}/${dir}" && git pull ); then
                print_success "Updated ${dir}"
            else
                print_error "Failed to update ${dir}"
                failures+=1
            fi
        elif ( cd "$reply_code_dir" && git clone "$repo" "$dir" >/dev/null 2>&1 ); then
            print_success "Cloned ${dir}"
        else
            print_error "Failed to clone ${dir}"
            failures+=1
        fi
    done
    (( failures == 0 ))
}

cmd_pull() {
    local update=false
    [[ "${1:-}" == "--update" || "${1:-}" == "-u" ]] && update=true

    dot_load_repos
    typeset -A repo_paths
    local dir repo
    for dir repo in ${(kv)reply_repos}; do
        repo_paths[$dir]="${reply_code_dir}/${dir}"
    done
    repo_paths[dotfiles]="$DOTFILES_ROOT"

    typeset -i failures=0
    # Never name a local `path` — in zsh it is tied to PATH and clears the PATH.
    local repo_path
    for dir repo_path in ${(kv)repo_paths}; do
        if [[ ! -d $repo_path ]]; then
            print_warn "Skipping ${dir} — not found"
            continue
        fi
        print_step "Pulling ${dir}..."
        if ( cd "$repo_path" && git pull --rebase ); then
            print_success "Updated ${dir}"
        else
            print_error "Failed to update ${dir}"
            failures+=1
        fi
    done

    if [[ $update != true ]]; then
        (( failures == 0 ))
        return $?
    fi

    print_step "Composer dependency bumps (no auto-commit)"
    for dir repo_path in ${(kv)repo_paths}; do
        [[ ! -d $repo_path || ! -f "${repo_path}/composer.json" ]] && continue
        print_step "composer update in ${dir}..."
        if ( cd "$repo_path" && composer update ); then
            if [[ -n "$(cd "$repo_path" && git status --porcelain)" ]]; then
                print_warn "${dir} has lockfile changes — commit manually if desired"
            else
                print_info "No dependency updates for ${dir}"
            fi
        else
            print_error "composer update failed for ${dir}"
            failures+=1
        fi
    done
    (( failures == 0 ))
}

cmd_check() {
    dot_load_repos
    typeset -i missing=0
    local dir
    for dir in ${(k)reply_repos}; do
        if [[ -d "${reply_code_dir}/${dir}/.git" ]]; then
            print_success "$dir"
        else
            print_warn "Missing ${reply_code_dir}/${dir} — run: dot clone"
            missing+=1
        fi
    done
    (( missing == 0 ))
}

case "${1:-}" in
    apply) cmd_apply ;;
    pull)  shift; cmd_pull "$@" ;;
    check) cmd_check ;;
    *) print_error "Usage: repos.zsh apply|pull|check"; exit 1 ;;
esac
