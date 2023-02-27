#!/usr/bin/env bash

wd=$(pwd)

function _exit()
{
	rm -r $wd/build
}

trap _exit EXIT
mkdir build && cd build
lua_install.sh
lua-*/src/lua -v 
