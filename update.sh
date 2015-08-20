#!/bin/bash

# use git if available
hash git 2>/dev/null && git pull && exit

# fallback to wget
wget https://github.com/cheuer/dotfiles/archive/master.tar.gz
tar -xzf master.tar.gz
cp dotfiles-master/* ~/.dotfiles/
rm -rf master.tar.gz dotfiles-master
echo dotfiles updated!
