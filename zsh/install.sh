#!/bin/bash
set -e

# Get source dir
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"


# install all programms required
xargs sudo apt-get install -y <$DIR/package.list

# Set zsh to standard 
sudo chsh -s $(which zsh)

# install oh-my-zsh
export ZSH="$DIR/oh-my-zsh"
echo -e "export ZSH=\"$ZSH/\"" >> ~/.profile

if [[ ! -d $ZSH ]]
then
    cd $DIR
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh) --unattended"
    cd ..
    ## install custom plugins
    ### Autosuggestion
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH}/plugins/zsh-autosuggestions

    ### Syntax Highlighing
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH}/plugins/zsh-syntax-highlighting
fi

# replace zshrc with symlink
rm $HOME/.zshrc
ln -s "$DIR/zshrc" $HOME/.zshrc 

sed -i "s+ZSH=\$HOME/.oh-my-zsh+ZSH=$DIR/oh-my-zsh+g" $DIR/zshrc
