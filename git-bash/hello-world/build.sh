#!/usr/bin/env sh

DIR=`pwd`;

mkdir -p build && cd build && rm -rf ./*;
cmake -G"Unix Makefiles" \
    -Wno-dev \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    ..
make;

cd $DIR;