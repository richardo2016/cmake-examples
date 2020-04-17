## 介绍

本节将展示一个创建和链接一个动态库库的 hello world 例子. 同时本节也展示如何创建一个别名目标(alias target).

本节包含的文件如下:

```shell
$ tree
.
├── CMakeLists.txt
├── include
│   └── shared
│       └── Hello.h
└── src
    ├── Hello.cpp
    └── main.cpp
```

- [CMakeLists.txt](./CMakeLists.txt) - 包含所有你编制的 CMake 命令

- [include/shared/Hello.h](./include/shared/Hello.h) - 要包含(include)的所有头文件

- [src/Hello.cpp](./src/Hello.cpp) - 要编译的源(source)文件

- [src/main.cpp](./src/main.cpp) - 主源(source)文件


## 概念

### 添加一个动态库

如果上一节添加添加静态库的例子. `add_library()` 方法也可以被用于从源文件创建一个动态链接库. 使用示例如下:

```shell
add_library(hello_library SHARED
    src/Hello.cpp
)
```

上述命令会被用于创建一个名为 `libhello_library.so` 的动态库.

### 编译目标别名(Alias Target)

当给 target 指定了 [别名](https://cmake.org/cmake/help/v3.0/manual/cmake-buildsystem.7.html#alias-targets) 的时候, 在整个上下文中要只读引入时, 这个别名都可以被代指那个实际的 target.

```shell
add_library(hello::library ALIAS hello_library)
```

如上所示, 当你要把库和别的库进行链接的时候, 可以使用别名来指代它.

### 链接一个动态库

链接一个动态库和链接一个静态库是一样的. 在创建你的可执行文件时, 使用 `target_link_libraries()` 方法来指明你要使用的库:

```shell
add_executable(hello_binary
    src/main.cpp
)

target_link_libraries(hello_binary
    PRIVATE
        hello::library
)
```

上述命令告诉 CMake, 在链接时, 通过别名, 把库 hello_library 链接到二进制 hello_library.

这个过程在链接器链接时可能是类似这样的

```shell
/usr/bin/c++ CMakeFiles/hello_binary.dir/src/main.cpp.o -o hello_binary -rdynamic libhello_library.so -Wl,-rpath,/home/matrim/workspace/cmake-examples/01-basic/D-shared-library/build
```

## 构建当前例子

```shell
$ mkdir build

$ cd build

$ cmake ../
-- The C compiler identification is AppleClang 10.0.1.10010046
-- The CXX compiler identification is AppleClang 10.0.1.10010046
-- Check for working C compiler: /usr/local/opt/ccache/libexec/cc
-- Check for working C compiler: /usr/local/opt/ccache/libexec/cc -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: /usr/local/opt/ccache/libexec/c++
-- Check for working CXX compiler: /usr/local/opt/ccache/libexec/c++ -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: /Users/richard/Projects/richardo2016/cmake-examples/01-basic/D-shared-library/build

$ make
Scanning dependencies of target hello_library
[ 25%] Building CXX object CMakeFiles/hello_library.dir/src/Hello.cpp.o
[ 50%] Linking CXX shared library libhello_library.dylib
[ 50%] Built target hello_library
Scanning dependencies of target hello_binary
[ 75%] Building CXX object CMakeFiles/hello_binary.dir/src/main.cpp.o
[100%] Linking CXX executable hello_binary
[100%] Built target hello_binary

$ ls
CMakeCache.txt          CMakeFiles              Makefile                cmake_install.cmake     hello_binary            libhello_library.dylib

$ ./hello_binary
Hello Shared Library!
```