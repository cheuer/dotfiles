#!/bin/bash

ln -svf ~/.dotfiles/bash_profile ~/.bash_profile 
ln -svf ~/.dotfiles/bashrc ~/.bashrc
cp ~/.dotfiles/gitconfig_base ~/.gitconfig
ln -svf ~/.dotfiles/vimrc ~/.vimrc
curl -s https://ohmyposh.dev/install.sh | bash -s
