#!/usr/bin/env bash

export VERSION=5.4.4

curl -R -O http://www.lua.org/ftp/lua-${VERSION}.tar.gz
tar zxf lua-${VERSION}.tar.gz && rm lua-${VERSION}.tar.gz
cd lua-${VERSION}
make all test
