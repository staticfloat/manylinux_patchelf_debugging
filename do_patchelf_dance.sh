#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Let's emulate the steps taken in https://github.com/NixOS/patchelf/issues/10#issuecomment-271873550
mkdir -p $DIR/lxml/.libs
echo
echo "Copying in libexslt.so, and patching etree..."
cp -v $DIR/libexslt.so.0.orig $DIR/lxml/.libs/libexslt-ffbaa1db.so.0.8.17
$DIR/patchelf --set-rpath '$ORIGIN/.' $DIR/lxml/.libs/libexslt-ffbaa1db.so.0.8.17
cp -v $DIR/lxml/etree.cpython-36m-x86_64-linux-gnu.so.orig $DIR/lxml/etree.cpython-36m-x86_64-linux-gnu.so
$DIR/patchelf --debug --replace-needed libexslt.so.0 libexslt-ffbaa1db.so.0.8.17 $DIR/lxml/etree.cpython-36m-x86_64-linux-gnu.so

echo
echo "Copying in libxml2.so, and patching etree..." 
cp -v $DIR/libxml2.so.2.orig $DIR/lxml/.libs/libxml2-8d315a96.so.2.9.3
$DIR/patchelf --set-rpath '$ORIGIN/.' $DIR/lxml/.libs/libxml2-8d315a96.so.2.9.3
$DIR/patchelf --replace-needed libxml2.so.2 libxml2-8d315a96.so.2.9.3 lxml/etree.cpython-36m-x86_64-linux-gnu.so

echo
echo "Copying in libxslt.so, and patching etree..."
cp -v $DIR/libxslt.so.1.orig $DIR/lxml/.libs/libxslt-655d9087.so.1.1.29
$DIR/patchelf --set-rpath '$ORIGIN/.' $DIR/lxml/.libs/libxslt-655d9087.so.1.1.29
$DIR/patchelf --replace-needed libxslt.so.1 libxslt-655d9087.so.1.1.29 lxml/etree.cpython-36m-x86_64-linux-gnu.so



# Now, try to strip everything
for f in .libs/libexslt-ffbaa1db.so.0.8.17 .libs/libxml2-8d315a96.so.2.9.3 .libs/libxslt-655d9087.so.1.1.29 etree.cpython-36m-x86_64-linux-gnu.so; do
    echo
    echo "Trying to strip $f..."
    /usr/local/bin/strip -vS lxml/$f -o lxml/$f.stripped
done
