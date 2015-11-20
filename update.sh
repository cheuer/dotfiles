#!/bin/bash

dotfiles_dir=~/.dotfiles

# use git if available
hash git 2>/dev/null && git -C $dotfiles_dir pull && exit

# fallback to wget
wget https://github.com/cheuer/dotfiles/archive/master.tar.gz
tar -xzf master.tar.gz
[[ ! -d $dotfiles_dir ]] && mkdir $dotfiles_dir
cp --remove-destination dotfiles-master/* $dotfiles_dir/
rm -rf master.tar.gz dotfiles-master
echo Dotfiles updated!
