#!/bin/zsh

echo ''
echo 'Update existing software'
echo '------------------------'

softwareupdate --install --all

echo ''
echo 'Installing XCode command line tools'
echo '-----------------------------------'

if [[ $(xcode-select --version) ]]; then
  echo Xcode command tools already installed
else
  echo "Installing Xcode commandline tools"
  $(xcode-select --install)
fi
