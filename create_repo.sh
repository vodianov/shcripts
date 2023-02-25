#!/usr/bin/env bash

REPO_NAME=$1
LOGIN=$2

if [ -z $REPO_NAME ]; then
	echo "enter REPO_NAME please" && exit
fi

if [ -z $LOGIN ]; then
	echo "enter LOGIN please" && exit
fi

if [ -z $USER_NAME ]; then
	USER_NAME="alexander.vodianov"
fi

if [ -z $USER_MAIL ]; then
	USER_MAIL="alexander.vodianov@proton.me"
fi

echo "# ${REPO_NAME}" >> README.md
git init
git config user.name "$USER_NAME"
git config user.mail "$USER_MAIL"
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:${LOGIN}/${REPO_NAME}.git
git push -u origin main
