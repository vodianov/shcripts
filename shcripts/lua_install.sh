#!/usr/bin/env bash

export VERSION=5.4.4

echo "Download lua"
curl -ROs http://www.lua.org/ftp/lua-${VERSION}.tar.gz

echo "Unpacking lua"
tar zxf lua-${VERSION}.tar.gz && rm lua-${VERSION}.tar.gz

echo "Build lua:"
cd lua-${VERSION}
make all test
