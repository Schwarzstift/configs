#!/bin/bash
set -e

# Set config directory
CUSTOM_CONFIG_PATH="$HOME/.config/custom/"

echo -e "export CUSTOM_CONFIG_PATH=\"$CUSTOM_CONFIG_PATH\"" >> ~/.profile

# clone all config repos and execute install.sh
repos=$(cat config_repos.list)
echo $repos

mkdir -p $CUSTOM_CONFIG_PATH
cd $CUSTOM_CONFIG_PATH


function cloneAndInstall {
    reponame=${1##*/}
    reponame=${reponame%.git}
    git clone "$1" "$reponame";
    cd "$reponame";
    chmod +x install.sh
    ./install.sh;
    cd ..;
}

for repo in $repos
do 
    cloneAndInstall $repo    
done

