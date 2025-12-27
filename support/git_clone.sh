#!/bin/zsh

source "$support_dir/functions.sh"

CODE_DIR=$HOME/Code

declare -A git_repos
git_repos=(
    [resume]="git@github.com:milon/milon.github.io.git"
    [recipes]="git@github.com:milon/recipes.git"
    [takakori]="git@github.com:milon/takakori.git"
    [one-problem-a-day]="git@github.com:milon/one-problem-a-day.git"
    [system-design]="git@github.com:milon/system-design.git"
    [cv]="git@github.com:milon/cv.git"
)

mkdir -p "$CODE_DIR"
cd "$CODE_DIR" || exit 1

for dir repo in ${(kv)git_repos}; do
    print_step "Cloning ${dir}..."
    if git clone "$repo" "$dir" > /dev/null 2>&1; then
        print_success "Cloned ${dir}"
    elif [ $? -eq 128 ]; then
        print_info "${dir} already exists, pulling latest changes..."
        cd "$dir" || continue
        if git pull; then
            print_success "Updated ${dir}"
        else
            print_error "Failed to update ${dir}"
        fi
        cd "$CODE_DIR" || exit 1
    else
        print_error "Failed to clone ${dir}"
    fi
done
