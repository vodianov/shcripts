#/usr/bin/env sh

#version: 0.0-1
#autor: asvodyanov <asvodyanov@gmail.com>
#date_create: 22.02.2022

set -Eeuo pipefail

ASV_DLM=' > '

if [ -z $1 ]; then
    read -p "Please enter a project name${ASV_DLM}" project_name
else
    project_name=$1
fi

echo "name of new project: $project_name"
exit 0