#!/bin/bash

# change work path to ~/ 
cd ~

# install zsh
sudo yum install -y zsh
chsh -s $(which zsh)

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install powerline-fonts 
# clone powerlin-fonts git
git clone https://github.com/powerline/fonts.git --depth=1
# install
cd fonts
 sudo ./install.sh
# clean-up a bit
cd ..
rm -rf fonts
