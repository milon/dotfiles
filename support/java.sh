#!/bin/zsh

echo 'Configuring java'

echo 'Installing Temurin JDK 17'
brew install --cask temurin17
jenv add /Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home/

echo 'Setting java version'
jenv global 17.0

echo 'Java done.'
