#!/usr/bin/env bash

mkdir build && cd build
	../../lua_install.sh
cd .. && rm -r build
