## 介绍

本文将展示一个很简单的 hello world 例子.

```bash
$ tree
.
├── CMakeLists.txt
└── main.cpp
```

- [CMakeLists.txt](./CMakeLists.txt) - 包含所有你编制的 CMake 命令
- [main.cpp](./main.cpp) - 一个简单的 "Hello World" cpp 文件

## 概念

### CMakeLists.txt

CMakeLists.txt 是用于存放你编制的 CMake 命令集的文件. 当你在一个目录下运行 `cmake` 时, 它会尝试寻找该目录下的该文件, 如果没找到就会报错.

### Minimum CMake Version

使用 CMake 创建一个项目时, 你可以指定支持该项目所需的最低 CMake 版本.

```cmake
cmake_minimum_required(VERSION 3.5)
```

### Projects

CMake 构建可以包含一个 project 命令, 用于指代该项目的名字, 以便在多个项目中更容易地引用变量

```cmake
project (hello_cmake)
```

### 创建一个可执行文件

在下面的例子中, `add_executable()` 命令指明了**要从哪些指定的源文件**构建出**哪个可执行文件**. `add_executable()` 方法的第一个参数指定二进制文件的名字, 第二个参数指定用于编译的源文件.

```cmake
add_executable(hello_cmake main.cpp)
```

**部分** 有些人会把项目名和可执行文件名保持一致, 这种用例可以写成下面这样:

```cmake
cmake_minimum_required(VERSION 2.6)
project (hello_cmake)
add_executable(${PROJECT_NAME} main.cpp)
```

在这里, `project()` 方法调用完后会产生一个变量 `${PROJECT_NAME}`, 其值为 `hello_cmake`. 这个变量可以传给 `add_executable()` 方法的第一个参数.

### 二进制目录

你运行 cmake 命令的根目录被称为是 CMAKE_BINARY_DIR, 它是你所有的二进制文件的根目录. CMake 支持以两种风格构建和生成二进制文件: 在源码同级(in-place) 和 在源码目录以外(out-of-source).

#### In-Place 构建

In-place 风格的构建会把所有的临时构建文件生成在源代码的同目录. 这意味着所有的 Makefiles 和 object 文件会和你的源代码混在一起.

要创建一个 in-place 风格的构建过程, 就在你的项目源代码直接运行 cmake (当然 CMakeLists.txt 也在这一层). 比如在这一节的例子中:

```shell
$ cmake .
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
-- Build files have been written to: /Users/richard/Projects/richardo2016/clanglearn/samples/01-basic/A-hello-cmake/

$ tree
.
├── CMakeCache.txt
├── CMakeFiles
│   ├── 3.15.5
│   │   ├── CMakeCCompiler.cmake
│   │   ├── CMakeCXXCompiler.cmake
│   │   ├── CMakeDetermineCompilerABI_C.bin
│   │   ├── CMakeDetermineCompilerABI_CXX.bin
│   │   ├── CMakeSystem.cmake
│   │   ├── CompilerIdC
│   │   │   ├── CMakeCCompilerId.c
│   │   │   ├── a.out
│   │   │   └── tmp
│   │   └── CompilerIdCXX
│   │       ├── CMakeCXXCompilerId.cpp
│   │       ├── a.out
│   │       └── tmp
│   ├── CMakeDirectoryInformation.cmake
│   ├── CMakeOutput.log
│   ├── CMakeTmp
│   ├── Makefile.cmake
│   ├── Makefile2
│   ├── TargetDirectories.txt
│   ├── cmake.check_cache
│   ├── hello_cmake.dir
│   │   ├── DependInfo.cmake
│   │   ├── build.make
│   │   ├── cmake_clean.cmake
│   │   ├── depend.make
│   │   ├── flags.make
│   │   ├── link.txt
│   │   └── progress.make
│   └── progress.marks
├── CMakeLists.txt
├── Makefile
├── cmake_install.cmake
└── main.cpp
```

#### Out-of-Source 风格的构建

Out-of-Source 风格的构建允许你在文件系统的任意位置创建一个单独的构建目录. 所有的临时构建文件和对象文件都会被放在这个目录中, 如此你的源代码就可以保持干净. 要创建 out-of-source 风格的构建过程, 就到你的构建文件夹中运行 cmake 命令, 并且要指定你项目的根目录(也就是 CMakeLists.txt 所在的顶级目录).

如果你想在必要的从头再创建你的构建过程, 建议你使用这种风格, 这样到时候你就只需要删除整个构建目录, 从头再来即可.

以这个例子来看, 像这样:

```shell
$ mkdir build && cd build/
$ cmake ..
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
-- Build files have been written to: /Users/richard/Projects/richardo2016/clanglearn/samples/01-basic/A-hello-cmake/build

$ tree ..
..
├── CMakeLists.txt
├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   │   ├── 3.15.5
│   │   │   ├── CMakeCCompiler.cmake
│   │   │   ├── CMakeCXXCompiler.cmake
│   │   │   ├── CMakeDetermineCompilerABI_C.bin
│   │   │   ├── CMakeDetermineCompilerABI_CXX.bin
│   │   │   ├── CMakeSystem.cmake
│   │   │   ├── CompilerIdC
│   │   │   │   ├── CMakeCCompilerId.c
│   │   │   │   ├── a.out
│   │   │   │   └── tmp
│   │   │   └── CompilerIdCXX
│   │   │       ├── CMakeCXXCompilerId.cpp
│   │   │       ├── a.out
│   │   │       └── tmp
│   │   ├── CMakeDirectoryInformation.cmake
│   │   ├── CMakeOutput.log
│   │   ├── CMakeTmp
│   │   ├── Makefile.cmake
│   │   ├── Makefile2
│   │   ├── TargetDirectories.txt
│   │   ├── cmake.check_cache
│   │   ├── hello_cmake.dir
│   │   │   ├── DependInfo.cmake
│   │   │   ├── build.make
│   │   │   ├── cmake_clean.cmake
│   │   │   ├── depend.make
│   │   │   ├── flags.make
│   │   │   ├── link.txt
│   │   │   └── progress.make
│   │   └── progress.marks
│   ├── Makefile
│   └── cmake_install.cmake
└── main.cpp
```

如无特殊说明, 接下里所有的示例都将始终 out-of-source 风格的构建过程.

## 构建例子

下面是构建这一节的例子的记录:

```shell
$ mkdir build && cd build/
$ cmake ..
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
-- Build files have been written to: /Users/richard/Projects/richardo2016/clanglearn/samples/01-basic/A-hello-cmake/build

$ tree ..
..
├── CMakeLists.txt
├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   │   ├── 3.15.5
│   │   │   ├── CMakeCCompiler.cmake
│   │   │   ├── CMakeCXXCompiler.cmake
│   │   │   ├── CMakeDetermineCompilerABI_C.bin
│   │   │   ├── CMakeDetermineCompilerABI_CXX.bin
│   │   │   ├── CMakeSystem.cmake
│   │   │   ├── CompilerIdC
│   │   │   │   ├── CMakeCCompilerId.c
│   │   │   │   ├── a.out
│   │   │   │   └── tmp
│   │   │   └── CompilerIdCXX
│   │   │       ├── CMakeCXXCompilerId.cpp
│   │   │       ├── a.out
│   │   │       └── tmp
│   │   ├── CMakeDirectoryInformation.cmake
│   │   ├── CMakeOutput.log
│   │   ├── CMakeTmp
│   │   ├── Makefile.cmake
│   │   ├── Makefile2
│   │   ├── TargetDirectories.txt
│   │   ├── cmake.check_cache
│   │   ├── hello_cmake.dir
│   │   │   ├── DependInfo.cmake
│   │   │   ├── build.make
│   │   │   ├── cmake_clean.cmake
│   │   │   ├── depend.make
│   │   │   ├── flags.make
│   │   │   ├── link.txt
│   │   │   └── progress.make
│   │   └── progress.marks
│   ├── Makefile
│   └── cmake_install.cmake
└── main.cpp

$ make
Scanning dependencies of target hello_cmake
[ 50%] Building CXX object CMakeFiles/hello_cmake.dir/main.cpp.o
[100%] Linking CXX executable hello_cmake
[100%] Built target hello_cmake

$ ./hello_cmake 
Hello CMake!
```