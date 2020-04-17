## 概念

### 编译选项(#option)

CMake 会暴露一些选项给开发者，用于控制编译(compile)和链接(link)代码的程序

- CMAKE_C_COMPILER - 用于编译 c 代码的编译器
- CMAKE_CXX_COMPILER - 用于编译 c++ 代码的编译器
- CMAKE_LINKER - 用于链接你的库的链接器

**注意** 为了演示, 你可以先去 clang 的[官网](http://releases.llvm.org/download.html)下载适合你系统的 clang 二进制文件, 这里我们使用 [llvm-9.0.0 版本的 clang 编译器 Windows x64 版本](http://releases.llvm.org/9.0.0/LLVM-9.0.0-win64.exe)

**注意** 这是最基本也是最简单的调用 clang 的方式, 在未来的例子中, 可能会演示如何自己编译 clang :)

### 设置编译用的选项(#Flags)

看这一节前, 可以先参考下 [F-build-type](../F-build-type) 了解下最基本的编译选项. 通过 GUI 或者直接传选项(#flags)给命令行, 你可以设置 CMake 编译选项.

以下是一个通过命令行给编译器传递参数的例子:

```shell
cmake .. -DCMAKE_C_COMPILER=clang-3.6 -DCMAKE_CXX_COMPILER=clang++-3.6
```

在设置了这些选项后, 一旦你进行编译, clang 将会被用来编译出你的二进制文件. 以下是一个 unix 平台上的编译例子:

```shell
/usr/bin/clang++-3.6     -o CMakeFiles/hello_cmake.dir/main.cpp.o -c /home/matrim/workspace/cmake-examples/01-basic/I-compiling-with-clang/main.cpp
Linking CXX executable hello_cmake
/usr/bin/cmake -E cmake_link_script CMakeFiles/hello_cmake.dir/link.txt --verbose=1
/usr/bin/clang++-3.6       CMakeFiles/hello_cmake.dir/main.cpp.o  -o hello_cmake -rdynamic
```

**注意** 这里的编译, 在 unix 平台上或者在 mingw/wsl 等仿 unix 环境上是 make, 在 windows 环境下则是 msbuild.

### 构建示例

以下是构建这个的日志