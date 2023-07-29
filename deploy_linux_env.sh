#! /usr/bin/env bash

# Author: Alexander Vodianov <alexander.vodianov@proton.me>
# Date Created: 04.07.2023
# Date Changed: 26.07.2023
# Description: This script deploy environment on Linux

ln -sf $(pwd)/.env $HOME/.env
source $HOME/.env
OH_MY_ZSH_URL=$GITHUB_CONTENT/ohmyzsh/ohmyzsh/master/tools/install.sh 
FZF_URL=$GITHUB_CONTENT/junegunn/fzf/master/install

install_with_script () {
    wget $1 -O install.sh 2> /dev/null
    chmod +x install.sh
    ./install.sh > /dev/null
    rm install.sh
}

fixed_remote_repo () {
    pushd $HOME_DIR/$1
	git remote set-url origin git@$REPO_HOST:$REPO_USER/$1.git
    popd
}

# Copy dotfiles
cp $HOME_DIR/$DOTFILES_REPO/linux/.zprofile $HOME
cp -r $HOME_DIR/$DOTFILES_REPO/.config $HOME
cp -r $HOME_DIR/$DOTFILES_REPO/.ssh $HOME

# Install apps
echo "INFO: install apt-get apps"
sudo apt-get install zsh > /dev/null

echo "INFO: install snap apps"
sudo snap install nvim --classic > /dev/null 
sudo snap install telegram-desktop > /dev/null
sudo snap install bitwarden > /dev/null
sudo snap install chromium
sudo snap alias nvim vim

##install oh_my_zsh
install_with_script $OH_MY_ZSH_URL > /dev/null
install_with_script $FZF_URL > /dev/null
echo "source $HOME/.zprofile" >> $HOME/.zshrc
sudo mv bin/* /usr/local/bin/ && rm bin

#Add ssh-key
openssl enc -pbkdf2 -d -in $GITHUB_KEY.enc -out $GITHUB_KEY -aes-256-cbc
chmod 600 $GITHUB_KEY
ssh-add $GITHUB_KEY
rm $GITHUB_KEY.enc

#add myself scripts
sudo mkdir -p /usr/local/bin
sudo ln -sf $HOME_DIR/$SHCRIPTS_REPO/day_start_linux.sh \
	/usr/local/bin/day_start.sh
sudo ln -sf $HOME_DIR/$SHCRIPTS_REPO/day_end.sh /usr/local/bin/day_end.sh

#git settings
git config --global user.name "Alexander Vodianov"
git config --global user.email "alexander.vodianov@proton.me"
fixed_remote_repo $DOTFILES_REPO
fixed_remote_repo $SHCRIPTS_REPO
