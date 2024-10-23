#!/bin/bash

# Ensure git and curl is installed
sudo apt install git
sudo apt install curl

# install vim-plug:  https://github.com/junegunn/vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo apt install exuberant-ctags -y
# sudo apt install nodejs -y
# sudo apt install npm -y


