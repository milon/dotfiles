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

for dir path in ${(kv)repo_paths}; do
    if [ ! -d "$path" ]; then
        print_info "Skipping ${dir} (directory not found)"
        continue
    fi

    print_step "Pulling updates for ${dir}..."
    if ( cd "$path" && git pull --rebase ); then
        print_success "Updated ${dir}"
    else
        print_error "Failed to update ${dir}"
    fi
done

if [ "$UPDATE" = true ]; then
    echo
    print_step "Updating Composer Dependencies"
    echo

    for dir path in ${(kv)repo_paths}; do
        if [ ! -d "$path" ]; then
            continue
        fi

        if ( cd "$path" && [ -f composer.json ] ); then
            print_step "Updating dependencies for ${dir}..."
            if ( cd "$path" && composer update ); then
                if ( cd "$path" && [ -n "$(git status --porcelain)" ] ); then
                    if (
                        cd "$path" &&
                        git add . &&
                        git commit -m "Updates dependencies" &&
                        git push
                    ); then
                        print_success "Dependencies updated and committed for ${dir}"
                    else
                        print_error "Failed to commit or push dependencies for ${dir}"
                    fi
                else
                    print_info "No dependency updates for ${dir}"
                fi
            else
                print_error "Composer update failed for ${dir}"
            fi
        else
            print_info "Skipping ${dir} (not a PHP project)"
        fi
    done
fi
