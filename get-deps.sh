#!/bin/bash

mkdir -p src

cd src
wget -c https://dl.dropboxusercontent.com/u/5743203/tmp/lxml-3.7.2-cp36-cp36m-linux_x86_64.whl
wget -c https://dl.dropboxusercontent.com/u/5743203/tmp/libexslt.so.0
wget -c https://dl.dropboxusercontent.com/u/5743203/tmp/libxml2.so.2
wget -c https://dl.dropboxusercontent.com/u/5743203/tmp/libxslt.so.1
wget -c https://ftp.gnu.org/gnu/binutils/binutils-2.27.tar.bz2

if [[ ! -d patchelf ]]; then
    git clone https://github.com/staticfloat/patchelf -b sf/pr_10
fi

cd patchelf
./bootstrap.sh

