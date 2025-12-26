#!/bin/zsh

# Functions

ascii_art () {
    cat << 'EOF'
   _     _   ___ _ _         
 _| |___| |_|  _|_| |___ ___ 
| . | . |  _|  _| | | -_|_ -|
|___|___|_| |_| |_|_|___|___|
EOF
}

confirm_or_exit() {
    local prompt_message=$1
    
    if read -q "choice?${prompt_message} (y/n) "; then
        echo
    else
        echo
        echo "Quitting..."
        exit 1
    fi
}

title () {
    title=$1
    title_length=${#title}
    leftover=$(expr 30 - $title_length)

    echo 
    printf "$title "
    printf '=%.0s' {1..$leftover}
    echo 
}

run_step() {
    local step_name=$1
    local script=$2
    
    title "$step_name"
    source "$script"
    cd "$dotfiles_dir"
}
