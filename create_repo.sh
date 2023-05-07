#!/usr/bin/env bash

# Set default values for the named parameters
name=""
repo_name=""
license=""

# Parse the command-line options using getopts
while getopts "n:r:l" opt; do
  case ${opt} in
	n ) name="$OPTARG";;
	l ) license="$OPTARG";;
	r ) repo_name="$OPTARG";;
	\? ) echo "Invalid option: -$OPTARG" 1>&2; exit 1;;
	: ) echo "Option -$OPTARG requires an argument" 1>&2; exit 1;;
  esac
done
shift $((OPTIND -1))

# Print the named parameters
echo "Name: $name"
echo "Age: $age"
echo "License: $license"
#REPO_NAME=$1
#LOGIN=$2
#
#if [ -z $REPO_NAME ]; then
#	echo "enter REPO_NAME please" && exit
#fi
#
#if [ -z $LOGIN ]; then
#	echo "enter LOGIN please" && exit
#fi
#
#if [ -z $USER_NAME ]; then
#	USER_NAME="alexander.vodianov"
#fi
#
#if [ -z $USER_MAIL ]; then
#	USER_MAIL="alexander.vodianov@proton.me"
#fi
#
#echo "# ${REPO_NAME}" >> README.md
#git init
#git config user.name "$USER_NAME"
#git config user.mail "$USER_MAIL"
#git add README.md
#git commit -m "first commit"
#git branch -M main
#git remote add origin git@github.com:${LOGIN}/${REPO_NAME}.git
#git push -u origin main
