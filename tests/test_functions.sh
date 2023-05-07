#!/usr/bin/env bash

wd=$(pwd)

function _exit()
{
	rm -r $wd/build
}

function run_test()
{
	$1 > /dev/null && echo "OK" || echo "FAIL"
}

trap _exit EXIT

mkdir build && cd build

echo "Testing lua install script:"
run_test "lua_install.sh"
