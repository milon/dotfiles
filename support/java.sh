#!/bin/zsh

echo 'Configuring java'

echo 'Installing Temurin JDK 21'
brew install --cask temurin@21
jenv add /Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/

echo 'Setting java version'
jenv global 21

echo 'Java done.'
