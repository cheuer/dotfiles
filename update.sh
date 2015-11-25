#!/bin/bash

dotfiles_dir=~/.dotfiles

function git_update() {
	git -C $dotfiles_dir pull && exit
}

function wget_update() {
	wget https://github.com/cheuer/dotfiles/archive/master.tar.gz 2>/dev/null
	tar -xzf master.tar.gz
	[[ ! -d $dotfiles_dir ]] && mkdir $dotfiles_dir
	cp dotfiles-master/* $dotfiles_dir/
	rm -rf master.tar.gz dotfiles-master
}

if hash git 2>/dev/null; then
	git_update
else
	wget_update
fi

echo Dotfiles updated!
