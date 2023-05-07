#! /usr/bin/env bash

# Author: Alexander Vodianov <alexander.vodianov@proton.me>
# Date Created: 07.05.2023
# Description: This script deploy environment on MacOS

GITHUB_CONTENT=https://raw.githubusercontent.com
BREW_URL=$GITHUB_CONTENT/Homebrew/install/HEAD/install.sh 
OH_MY_ZSH_URL=$GITHUB_CONTENT/robbyrussell/oh-my-zsh/master/tools/install.sh 
GITHUB_KEY=~/.ssh/github

install_with_script () {
    curl -fsSL $1 > install.sh
    chmod +x install.sh
    ./install.sh
    rm install.sh
}

# Copy dotfiles
cp $HOME_DIR/$DOTFILES_REPO/.zprofile $HOME
cp -r $HOME_DIR/$DOTFILES_REPO/.config $HOME
cp -r $HOME_DIR/$DOTFILES_REPO/.ssh $HOME

source $HOME/.zprofile

# Install apps
##install brew
install_with_script $BREW_URL

brew install neovim \
	     fzf

brew install --cask iterm2 \
		    firefox \
		    telegram \
	            bitwarden

##install zsh
install_with_script $OH_MY_ZSH_URL
echo "source $HOME/.zprofile" >> $HOME/.zshrc

# create links for apps
ln -sf Applications/Bitwarden.app/Contents/MacOS/Bitwarden \
    /opt/homebrew/bin/bitwarden
ln -sf /opt/homebrew/nvim /opt/homebrew/vim

#Add ssh-key
openssl aes-256-cbc -d -a -in $GITHUB_KEY.enc -out $GITHUB_KEY
chmod 600 $GITHUB_KEY
ssh-add $GITHUB_KEY
rm $GITHUB_KEY.enc

#add myself scripts
sudo mkdir -p /usr/local/bin
sudo ln -sf $HOME_DIR/$SHCRIPTS_REPO/start_day.sh /usr/local/bin/start_day.sh

#git settings
git config --global user.name "Alexander Vodianov"
git config --global user.email "alexander.vodianov@proton.me"

