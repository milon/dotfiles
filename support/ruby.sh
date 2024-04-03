#!/bin/zsh

echo 'Configuring ruby'

echo 'installing ruby'
frum install 2.7.8

echo 'Setting ruby version'
frum global 2.7.8

echo 'Verify ruby version'
frum versions