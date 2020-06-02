# on mac, you should install mingw firstly and add mingw64 path to clang's search default sysroot
# brew install mingw-w64
# sudo ln -sf /usr/local/Cellar/mingw-w64/7.0.0_2/toolchain-x86_64/x86_64-w64-mingw32 /usr/local/x86_64-w64-mingw32
# sudo ln -sf /usr/local/Cellar/mingw-w64/7.0.0_2/toolchain-x86_64/ /usr/local/x86_64-w64-mingw32/sys-root
MINGW_ENTRY=/usr/local/x86_64-w64-mingw32

# you can also use -B=$MINGW_ENTRY/sys-root/mingw/bin to specify binary search path for clang
clang -fuse-ld=$MINGW_ENTRY/sys-root/mingw/bin/ld --verbose -target x86_64-pc-windows test.c -otest.exe