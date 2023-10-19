#!/bin/zsh

valet install
valet trust
mkdir -p $HOME/Code
cd $HOME/Code
valet park

echo 'XX -- Valet done.'