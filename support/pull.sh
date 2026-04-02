#!/bin/zsh

source "$support_dir/functions.sh"

CODE_DIR=$HOME/Code

declare -A git_repos
git_repos=(
    [resume]=$CODE_DIR/resume
    [recipes]=$CODE_DIR/recipes
    [one-problem-a-day]=$CODE_DIR/one-problem-a-day
    [system-design]=$CODE_DIR/system-design
    [cv]=$CODE_DIR/cv
    [dotfiles]=$HOME/.dotfiles
)

UPDATE=false
if [[ "$1" == "--update" || "$1" == "-u" ]]; then
    UPDATE=true
fi

for dir repo in ${(kv)git_repos}; do
    if [ ! -d "$repo" ]; then
        print_info "Skipping ${dir} (directory not found)"
        continue
    fi

    print_step "Pulling updates for ${dir}..."
    if ( cd "$repo" && git pull --rebase ); then
        print_success "Updated ${dir}"
    else
        print_error "Failed to update ${dir}"
    fi
done

if [ "$UPDATE" = true ]; then
    echo
    print_step "Updating Composer Dependencies"
    echo

    for dir repo in ${(kv)git_repos}; do
        if [ ! -d "$repo" ]; then
            continue
        fi

        if ( cd "$repo" && [ -f composer.json ] ); then
            print_step "Updating dependencies for ${dir}..."
            if ( cd "$repo" && composer update ); then
                if ( cd "$repo" && [ -n "$(git status --porcelain)" ] ); then
                    if (
                        cd "$repo" &&
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
