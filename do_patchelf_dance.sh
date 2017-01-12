#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Let's emulate the steps taken in https://github.com/NixOS/patchelf/issues/10#issuecomment-271873550
mkdir -p $DIR/lxml/.libs
cp -v $DIR/libexslt.so.0.orig $DIR/lxml/.libs/libexslt-ffbaa1db.so.0.8.17
$DIR/patchelf --set-rpath '$ORIGIN/.' $DIR/lxml/.libs/libexslt-ffbaa1db.so.0.8.17
cp -v $DIR/lxml/etree.cpython-36m-x86_64-linux-gnu.so.orig $DIR/lxml/etree.cpython-36m-x86_64-linux-gnu.so
$DIR/patchelf --debug --replace-needed libexslt.so.0 libexslt-ffbaa1db.so.0.8.17 $DIR/lxml/etree.cpython-36m-x86_64-linux-gnu.so
