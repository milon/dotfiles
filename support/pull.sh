#!/bin/zsh

source "$support_dir/functions.sh"
source "$support_dir/repos.sh"

UPDATE=false
if [[ "$1" == "--update" || "$1" == "-u" ]]; then
    UPDATE=true
fi

# Build the (dir -> path) list: every repo from repos.sh under $CODE_DIR,
# plus this dotfiles checkout itself.
typeset -A repo_paths
for dir repo in ${(kv)git_repos}; do
    repo_paths[$dir]="$CODE_DIR/$dir"
done
repo_paths[dotfiles]="$HOME/.dotfiles"

# Pull each repo, in its own subshell so cd never leaks across iterations.
for dir repo_path in ${(kv)repo_paths}; do
    if [[ ! -d $repo_path ]]; then
        print_info "Skipping ${dir} (directory not found)"
        continue
    fi

    print_step "Pulling updates for ${dir}..."
    if ( cd "$repo_path" && git pull --rebase ); then
        print_success "Updated ${dir}"
    else
        print_error "Failed to update ${dir}"
    fi
done

[[ $UPDATE != true ]] && return 0

echo
print_step "Updating Composer Dependencies"
echo

# Update composer-managed PHP projects: install latest deps and, if the lockfile
# changed, commit + push the bump. One subshell per repo keeps cd contained and
# any failure short-circuits the rest of that repo's flow without affecting others.
for dir repo_path in ${(kv)repo_paths}; do
    [[ ! -d $repo_path ]] && continue

    (
        cd "$repo_path" || exit 1

        if [[ ! -f composer.json ]]; then
            print_info "Skipping ${dir} (not a PHP project)"
            exit 0
        fi

        print_step "Updating dependencies for ${dir}..."
        if ! composer update; then
            print_error "Composer update failed for ${dir}"
            exit 1
        fi

        if [[ -z "$(git status --porcelain)" ]]; then
            print_info "No dependency updates for ${dir}"
            exit 0
        fi

        if git add . && git commit -m "Updates dependencies" && git push; then
            print_success "Dependencies updated and committed for ${dir}"
        else
            print_error "Failed to commit or push dependencies for ${dir}"
            exit 1
        fi
    )
done
