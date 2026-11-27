#!/bin/zsh
set -euo pipefail
source "${0:A:h}/_common.zsh"

# True when the worktree has tracked modifications (blocks pull.rebase).
# Untracked-only trees are fine — git rebase does not refuse those.
repo_is_dirty() {
    local repo_path=$1
    [[ -n "$(git -C "$repo_path" status --porcelain -uno 2>/dev/null)" ]]
}

# pull.rebase=true (global here) turns every `git pull` into a rebase, which
# refuses dirty trees. Skip with a clear warn instead of a cryptic git error.
repo_pull() {
    local repo_path=$1
    local repo_name=${2:-${repo_path:t}}
    if repo_is_dirty "$repo_path"; then
        print_warn "${repo_name}: uncommitted changes — commit, stash, or discard, then re-run"
        return 2
    fi
    git -C "$repo_path" pull --rebase
}

cmd_apply() {
    dot_load_repos
    mkdir -p "$reply_code_dir"
    typeset -i failures=0
    local dir repo ec
    for dir repo in ${(kv)reply_repos}; do
        print_step "Cloning ${dir}..."
        if [[ -d "${reply_code_dir}/${dir}/.git" ]]; then
            print_info "${dir} exists — pulling..."
            set +e
            repo_pull "${reply_code_dir}/${dir}" "$dir"
            ec=$?
            set -e
            if (( ec == 0 )); then
                print_success "Updated ${dir}"
            elif (( ec == 2 )); then
                # Repo is present; dirty skip is not a clone failure.
                print_info "Left ${dir} unchanged"
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
    local repo_path ec
    for dir repo_path in ${(kv)repo_paths}; do
        if [[ ! -d $repo_path ]]; then
            print_warn "Skipping ${dir} — not found"
            continue
        fi
        print_step "Pulling ${dir}..."
        set +e
        repo_pull "$repo_path" "$dir"
        ec=$?
        set -e
        if (( ec == 0 )); then
            print_success "Updated ${dir}"
        elif (( ec != 2 )); then
            print_error "Failed to update ${dir}"
            failures+=1
        fi
    done

    if [[ $update != true ]]; then
        (( failures == 0 ))
        return $?
    fi

    print_step "Updating Composer dependencies"
    for dir repo_path in ${(kv)repo_paths}; do
        [[ ! -d $repo_path || ! -f "${repo_path}/composer.json" ]] && continue
        print_step "Updating dependencies for ${dir}..."
        set +e
        (
            cd "$repo_path" || exit 1
            composer update || exit 1
            if [[ -z "$(git status --porcelain)" ]]; then
                print_info "No dependency updates for ${dir}"
                exit 0
            fi
            if git add . && git commit -m "Updates dependencies" && git push; then
                print_success "Dependencies updated and pushed for ${dir}"
                exit 0
            fi
            print_error "Failed to commit or push dependencies for ${dir}"
            exit 1
        )
        ec=$?
        set -e
        (( ec == 0 )) || failures+=1
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
