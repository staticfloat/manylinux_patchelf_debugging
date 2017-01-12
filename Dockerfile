FROM quay.io/pypa/manylinux1_x86_64

# Install tmux so I can have multiple windows open at once, gdb so I can debug, etc...
RUN yum install -y tmux gdb

# Copy in libraries to /src
COPY src/libexslt.so.0 /src/libexslt.so.0
COPY src/libxml2.so.2 /src/libxml2.so.2
COPY src/libxslt.so.1 /src/libxslt.so.1
COPY src/lxml-3.7.2-cp36-cp36m-linux_x86_64.whl /src/
RUN cd /src && unzip lxml-3.7.2-cp36-cp36m-linux_x86_64.whl
RUN rm -f /src/lxml-3.7.2-cp36-cp36m-linux_x86_64.whl

# Download/build a debug version of binutils so we can step through `strip`
COPY src/binutils-2.27.tar.bz2 /src
RUN cd /src && tar jxf binutils-2.27.tar.bz2 && cd /src/binutils-2.27 && ./configure CFLAGS="-g -O0" CPPFLAGS="-g -O0" CXXFLAGS="-g -O0" && make && make install
RUN rm -f /src/binutils-2.27.tar.bz2

# Setup a workspace where we've already got the original .so files
RUN mkdir -p /workspace
RUN for f in libexslt.so.0 libxml2.so.2 libxslt.so.1; do cp /src/$f /workspace/$f.orig; chmod +x /workspace/$f.orig; done
RUN cp -a /src/lxml /workspace/lxml
RUN for f in etree.cpython-36m-x86_64-linux-gnu.so objectify.cpython-36m-x86_64-linux-gnu.so; do cp /workspace/lxml/$f /workspace/lxml/$f.orig; done

# Load in the local checkout of the patchelf repo. You should have already run the following on your local machine:
# (git clone https://github.com/staticfloat/patchelf -b sf/pr_10; cd patchelf && ./bootstrap.sh)
COPY src/patchelf /src/patchelf
RUN cd /src/patchelf && ./configure CFLAGS="-g -O0" CPPFLAGS="-g -O0" CXXFLAGS="-g -O0" && make
RUN cp /src/patchelf/src/patchelf /workspace/patchelf

# Copy script to do a single patchelf application
WORKDIR /workspace
COPY do_patchelf_dance.sh /workspace/
