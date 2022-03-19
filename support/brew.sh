echo 'Installing Homebrew'
echo '-------------------'

if (! command -v brew &> /dev/null); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    echo 'Installed.'
else
    echo 'Already installed; skipping.'
fi

echo ''
echo 'Installing Homebrew dependencies'
echo '---------------------------------------'
brew bundle --file $support_dir/Brewfile

echo 'XX -- Homebrew done.'
