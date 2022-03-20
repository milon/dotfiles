echo 'Checking dependencies...'
echo ''

if [ ! -d "$HOME/Dropbox" ]
then
    echo "Please link Dropbox first."
    exit
fi

declare -A SSH_FILES
SSH_FILES=(
    ["$HOME/Dropbox/Mackup/.ssh/config"]="$HOME/.ssh/config"
    ["$HOME/Dropbox/Mackup/.ssh/id_rsa"]="$HOME/.ssh/id_rsa"
    ["$HOME/Dropbox/Mackup/.ssh/id_rsa.pub"]="$HOME/.ssh/id_rsa.pub"
)

for key val in ${(kv)sym_links}; do
    if test -f "$val"; then
        echo "$val already exists; skipping symlink."
    else
        if [ -d "$val" ]; then
            echo "$val already exists; skipping symlink."
        else
            ln -s $key $val
            chmod 600 $val
        fi
    fi
done

prompt_quit_if_no "Do you have SSH keys linked that have access to everything important?"
prompt_quit_if_no "Have you signed into the Mac App Store manually?"
echo ''

echo 'XX -- Precheck done.'
