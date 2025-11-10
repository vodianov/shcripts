#!/usr/bin/env bash

bash_conf="~/.bashrc"

if ! grep -q "Vodianov's settings" $bash_conf; then
    cat .env >> $bash_conf
echo "source $bash_conf"
fi
