## 介绍

本节将展示一个创建和链接一个静态库的 hello world 例子. 例子中我们简单地展示了如何在同目录中同时构建静态库和可执行文件. 但一般来说这样的构建是出现在像 `02-sub-projects` 这一节展示的带子项目的例子中.

本节包含的文件如下:

```shell
$ tree
.
├── CMakeLists.txt
├── include
│   └── static
│       └── Hello.h
└── src
    ├── Hello.cpp
    └── main.cpp
```

- [CMakeLists.txt](./CMakeLists.txt) - 包含所有你编制的 CMake 命令

- [include/static/Hello.h](./include/static/Hello.h) - 要包含(include)的所有头文件

- [src/Hello.cpp](./src/Hello.cpp) - 要编译的源(source)文件

- [src/main.cpp](./src/main.cpp) - 主源(source)文件

## 概念

### 添加一个静态库

`add_library()` 方法被用于从源文件创建一个库. 使用示例如下:

```cmake
add_library(hello_library STATIC
    src/Hello.cpp
)
```

上述命令会被用于创建一个名为 `libhello_library.a` 的静态库.

**注意** 正如在上一节示例中所说, 我们会直接按照现代 CMake 工程的惯例. 把源文件用 GLOB 风格指令传给 add_library 方法.


### 保留包含目录(Including Directories)中的文件

在本例中, 我们使用 `target_include_directories()` 方法把标记为 PUBLIC 域的包含文件包含进去.

```shell
target_include_directories(hello_library
    PUBLIC
        ${PROJECT_SOURCE_DIR}/include
)
```

这使得被包含的目录可以在以下场景使用:

- 编译该库的时候.

- 编译别的任何链接该库的 target 的时候.

域(scopes)的含义如下:

`PRIVATE` - 目录**仅**会被添加到 target 的包含目录中.
`INTERFACE` - 目录**仅**会被添加到任何链接了该库的编译 target 的包含目录中.
`PUBLIC` - 既会被添加到 `target` 的包含目录, 也对任何链接了该库的别的 target 有效.

**提示**
对于公开的头文件而言, 把你的包含目录根据子目录做"命名空间化"是一种好的实践.

传给 `target_include_directories` 的目录会成为你的包含目录树的根目录, 你的 C++ 文件可以从这个目录开始 include 文件. 比如, 对当前一节的例子来说, 就可以:

```
#include "static/Hello.h"
```

使用这个方法, 意味着在项目中使用多个库的时候, 你可以少些一些斜线.


### 链接一个库

当要使用你的库来创建一个可执行文件的时, 你必须要通过 `target_link_libraries()` 方法, 把这个库告诉编译器.

```shell
add_executable(hello_binary
    src/main.cpp
)

target_link_libraries( hello_binary
    PRIVATE
        hello_library
)
```

上述命令告诉 CMake, 在链接时, 把库 hello_library 链接到二进制 hello_library. 同时它会把任何被链接中标记为 PUBLIC 或 INTERFACE 域的头文件打出来.

这个过程在编译器编译时可能是类似这样的:

```
/usr/bin/c++ CMakeFiles/hello_binary.dir/src/main.cpp.o -o hello_binary -rdynamic libhello_library.a
```

## 构建当前例子

```shell
$ mkdir build

$ cd build

$ cmake ..
cmake ..
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
-- Build files have been written to: /Users/richard/Projects/richardo2016/cmake-examples/01-basic/C-static-library/build

$ make
Scanning dependencies of target hello_library
[ 25%] Building CXX object CMakeFiles/hello_library.dir/src/Hello.cpp.o
[ 50%] Linking CXX static library libhello_library.a
[ 50%] Built target hello_library
Scanning dependencies of target hello_binary
[ 75%] Building CXX object CMakeFiles/hello_binary.dir/src/main.cpp.o
[100%] Linking CXX executable hello_binary
[100%] Built target hello_binary

$ ls
CMakeCache.txt          CMakeFiles              Makefile                cmake_install.cmake     hello_binary            libhello_library.a

$ ./hello_binary
Hello Static Library!
```


