#! /usr/bin/env bash

# Author: Alexander Vodianov <alexander.vodianov@proton.me>
# Date Created: 04.07.2023
# Description: Prepare environment on new day for linux

sudo apt update && \
sudo apt upgrade -y && \
snap refresh
