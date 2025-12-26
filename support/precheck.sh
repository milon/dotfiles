#!/bin/zsh

echo 'Checking dependencies...'
echo 

if [! -f "$HOME/.custom_aliases"]
then
    touch "$HOME/.custom_aliases"
fi

if [ ! -f "$HOME/.ssh/id_rsa" ] && [! -f "$HOME/.ssh/id_rsa.pub"]
then
    echo "Please generate SSH keys or copy that from previous computer."
    exit
fi

prompt_quit_if_no "Do you have SSH keys linked that have access to everything important?"
prompt_quit_if_no "Have you signed into the Mac App Store manually?"
echo ''

echo 'XX -- Precheck done.'
