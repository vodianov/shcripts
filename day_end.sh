#!/bin/bash

source $HOME/.env

Directories="Downloads Documents Desktop"

#Check home dir
for repo in $(find $HOME_DIR -maxdepth 1 -mindepth 1 -type d); do
    if [[ ! $(find $repo -maxdepth 1 -mindepth 1 -type d -name '.git') ]]; then
	echo "There is $repo not repository"
    else
	cd $repo
	if [[ $(git status --porcelain) ]]; then
	    echo "There are uncommitted changes in $repo."
	fi
    fi
done
for file in $(find $HOME_DIR -maxdepth 1 -mindepth 1 -type f); do
    echo "There $file is unknown file in directory"
done

#Check that directories is empty
for dir in $Directories; do
    for file in $(find $HOME/$dir -maxdepth 1 -mindepth 1); do
	if [[ $file != $HOME_DIR \
	   && $file != $WORK_DIR \
	   && $file != "$HOME/$dir/.localized" ]]; then
	    echo "Unkown file: $file"
	fi
    done
done
