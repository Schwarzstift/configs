#!/bin/bash
set -e
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"


# install all programms required
xargs sudo apt-get install -y <$DIR/package.list

# Set zsh to standard 
sudo chsh -s $(which zsh)

# install oh-my-zsh
ZSH="$DIR/oh-my-zsh"
if [[ ! -d $ZSH ]]
then
    cd $DIR
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
    cd ..
fi

## install custom zsh plugins
if [[ ! -d ${ZSH}/plugins/zsh-autosuggestions ]]
then
    ### Autosuggestion
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH}/plugins/zsh-autosuggestions
fi
if [[ ! -d ${ZSH}/plugins/zsh-syntax-highlighting ]]
then
    ### Syntax Highlighing
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH}/plugins/zsh-syntax-highlighting
fi

# replace zshrc with symlink
rm $HOME/.zshrc
ln -s "$DIR/zshrc" $HOME/.zshrc 

# Set correct path to oh-my-zsh clone into the zshrc
sed -i "s+ZSH=\$HOME/.oh-my-zsh+ZSH=$DIR/oh-my-zsh+g" $DIR/zshrc
