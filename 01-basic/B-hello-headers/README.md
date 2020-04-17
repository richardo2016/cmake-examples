## 介绍

本节演示 source 文件和 include 文件存在不同目录中的情形. 本节包含的如下:

```shell
$ tree
.
├── CMakeLists.txt
├── include
│   └── Hello.h
└── src
    ├── Hello.cpp
    └── main.cpp
```

- [CMakeLists.txt](./CMakeLists.txt) - 包含所有你编制的 CMake 命令

- [include/Hello.h](./include/Hello.h) - 要包含(include)的所有头文件

- [src/Hello.cpp](./src/Hello.cpp) - 要编译的源(source)文件

- [src/main.cpp](./src/main.cpp) - 主源(source)文件

## 概念

### 目录路径

CMake 语法预置了一系列[变量](https://cmake.org/Wiki/CMake_Useful_Variables), 这些变量可以用于在项目中找到一些必要的目录. 这些变量包括:

| 变量 |  含义 | 
|--|--|
| CMAKE_SOURCE_DIR | 源文件的根目录.
| CMAKE_CURRENT_SOURCE_DIR | 如果有使用子项目(sub-projects)或者子文件夹, 则表示当前的源文件目录.
| PROJECT_SOURCE_DIR | 当前 cmake 项目的源文件夹.
| CMAKE_BINARY_DIR | 根二进制/根构建目录. 所有的 cmake 指令就是运行在这个目录中.
| CMAKE_CURRENT_BINARY_DIR | 当前你所在的构建(build)目录
| PROJECT_BINARY_DIR | 当前项目的构建(build)目录

### 源文件变量

你可以创建指代源文件地址的变量, 然后再多个指令中使用, 比如, 用在 `add_executable()` 中.

```cmake
# Create a sources variable with a link to all cpp files to compile
set(SOURCES
    src/Hello.cpp
    src/main.cpp
)

add_executable(${PROJECT_NAME} ${SOURCES})
```

**注意** 对于上述例子中的 SOURCES, 你也可以使用 GLOB 风格的通配符指令来指代同样的一批文件.

**提示** 对于现代 CMake 工程而言, 一般不推荐用变量来表达源文件位置, 而是直接在 `add_xxx` 用 GLOB 风格的指令声明这些文件. 在新增了一个新的不被现有的 GLOB 指令所包括的源文件的情况下, 这种行为尤为重要.

### 包含目录

当你有不同的包含目录(include folders) 时, 你可以使用 `target_include_directories()` [方法](https://cmake.org/cmake/help/v3.0/command/target_include_directories.html)来把这些目录传递给你的编译器. 具体到编译的时候, 这些目录会被 `-I` 编译选项传过去, 类似于 `-I/directory/path` 这样.

```cmake
target_include_directories(target
    PRIVATE
        ${PROJECT_SOURCE_DIR}/include
)
```

PRIVATE 符表明了要包含(include)的域(scope), 对于类库而言, 这个设置很重要, 我们会在之后的例子中解释. 关于这个方法更多的细节可以参考 [这里](https://cmake.org/cmake/help/v3.0/command/target_include_directories.html)


## 构建这个例子

### 标准输出

构建产生的标准输出如下:

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
-- Build files have been written to: /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build

$ make
Scanning dependencies of target hello_headers
[ 33%] Building CXX object CMakeFiles/hello_headers.dir/src/Hello.cpp.o
[ 66%] Building CXX object CMakeFiles/hello_headers.dir/src/main.cpp.o
[100%] Linking CXX executable hello_headers
[100%] Built target hello_headers

$ ./hello_headers
Hello Headers!
```

### 带调试信息的输出

在之前的例子中, 运行 `make` 命令的时候只显示了构建的状态码. 如果看完整的调试信息, 你可以在运行 `make` 命令添加一个 `VERBOSE=1` 选项.

带 VERBOSE 的输出显示如下, 其中还有一些检查信息, 展示了包含目录(include directoris) 如何被添加到 C++ 的编译指令中.

```shell
$ make clean

$ make VERBOSE=1
/usr/local/Cellar/cmake/3.15.5/bin/cmake -S/Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers -B/Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build --check-build-system CMakeFiles/Makefile.cmake 0
/usr/local/Cellar/cmake/3.15.5/bin/cmake -E cmake_progress_start /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build/CMakeFiles /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build/CMakeFiles/progress.marks
/Applications/Xcode.app/Contents/Developer/usr/bin/make -f CMakeFiles/Makefile2 all
/Applications/Xcode.app/Contents/Developer/usr/bin/make -f CMakeFiles/hello_headers.dir/build.make CMakeFiles/hello_headers.dir/depend
cd /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build && /usr/local/Cellar/cmake/3.15.5/bin/cmake -E cmake_depends "Unix Makefiles" /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build/CMakeFiles/hello_headers.dir/DependInfo.cmake --color=
/Applications/Xcode.app/Contents/Developer/usr/bin/make -f CMakeFiles/hello_headers.dir/build.make CMakeFiles/hello_headers.dir/build
[ 33%] Building CXX object CMakeFiles/hello_headers.dir/src/Hello.cpp.o
/usr/local/opt/ccache/libexec/c++   -I/Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/include  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk   -o CMakeFiles/hello_headers.dir/src/Hello.cpp.o -c /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/src/Hello.cpp
[ 66%] Building CXX object CMakeFiles/hello_headers.dir/src/main.cpp.o
/usr/local/opt/ccache/libexec/c++   -I/Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/include  -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk   -o CMakeFiles/hello_headers.dir/src/main.cpp.o -c /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/src/main.cpp
[100%] Linking CXX executable hello_headers
/usr/local/Cellar/cmake/3.15.5/bin/cmake -E cmake_link_script CMakeFiles/hello_headers.dir/link.txt --verbose=1
/usr/local/opt/ccache/libexec/c++   -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.14.sdk -Wl,-search_paths_first -Wl,-headerpad_max_install_names  CMakeFiles/hello_headers.dir/src/Hello.cpp.o CMakeFiles/hello_headers.dir/src/main.cpp.o  -o hello_headers 
[100%] Built target hello_headers
/usr/local/Cellar/cmake/3.15.5/bin/cmake -E cmake_progress_start /Users/richard/Projects/richardo2016/cmake-examples/01-basic/B-hello-headers/build/CMakeFiles 0
```