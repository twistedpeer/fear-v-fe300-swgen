#!/bin/bash

# Build CSmith
mkdir -p tools/csmith/build
cd tools/csmith
cmake -DCMAKE_INSTALL_PREFIX=./build .
make -j8 && make install -j8
cd ../..
