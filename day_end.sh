#!/bin/bash

source $HOME/.env

Directories="Downloads Documents Desktop"

#Check home dir
for repo in $(find $HOME_DIR -type d -depth 1); do
    if [[ ! $(find $repo -type d -name '.git' -depth 1) ]]; then
	echo "There is $repo not repository"
    else
	cd $repo
	if [[ $(git status --porcelain) ]]; then
	    echo "There are uncommitted changes in $repo."
	fi
    fi
done
for file in $(find $HOME_DIR -type f -depth 1); do
    echo "There $file is unknown file in directory"
done

#Check that directories is empty
for dir in $Directories; do
    for file in $(find $HOME/$dir -depth 1); do
	if [[ $file != $HOME_DIR \
	   && $file != $WORK_DIR \
	   && $file != "$HOME/$dir/.localized" ]]; then
	    echo "Unkown file: $file"
	fi
    done
done
