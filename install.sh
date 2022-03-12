#!/bin/bash

# Init Git submodules
git submodule update --init

# Build CSmith
mkdir -p work/csmith
cd tools/csmith
cmake -DCMAKE_INSTALL_PREFIX=../../work/csmith .
make -j8 && make install -j8
cd ../..
