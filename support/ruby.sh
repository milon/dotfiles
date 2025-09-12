#!/bin/zsh

echo 'Configuring ruby'

echo 'installing ruby'
frum install 3.4.5

echo 'Setting ruby version'
frum global 3.4.5

echo 'Verify ruby version'
frum versions