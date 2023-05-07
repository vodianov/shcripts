#!/bin/bash

source .env

for repo in $(find $HOME_DIR -type d -depth 1); do
    if [[ ! $(find $repo -type d -name '.git' -depth 1) ]]; then
	echo "There is $repo not repository"
    fi
done
## Check each repository for uncommitted changes and updates to master
#for repo in $(find "$HOME_DIR" -type d -name ".git"); do
#  cd "$(dirname "$repo")"
#  if [[ $(git status --porcelain) ]]; then
#    echo "There are uncommitted changes in $(basename "$(dirname "$repo")")."
#  fi
#done
#
## Check for files outside of repositories
#if [[ $(find "$HOME_DIR" -type f ! -path "$HOME_DIR/*/.git/*" | grep -vE "Downloads|Documents|Desktop") ]]; then
#  echo "There are files outside of repositories in $HOME_DIR."
#fi
#
## Check that the Downloads, Documents, and Desktop directories are empty
#if [[ $(find "$HOME_DIR/Downloads" -mindepth 1) || $(find "$HOME_DIR/Documents" -mindepth 1) || $(find "$HOME_DIR/Desktop" -mindepth 1) ]]; then
#  echo "The Downloads, Documents, or Desktop directory is not empty."
#fi
#
