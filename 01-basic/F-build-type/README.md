## 简介

CMake 拥有一系列内置的构建(#build)配置, 这些配置会被用于编译你的项目. 

下面这些配置指明了
1. 优化等级
2. 是否在编译的二进制文件里包含 debug 信息

优化等级有:

- Release - 向编译器传递 `-O3 -DNDEBUG` 选项(#flags)
- Debug - 传递 `-g` 选项(#flag)
- MinSizeRel - 传递 `-Os -DNDEBUG`
- RelWithDebInfo - 传递 `-O2 -g -DNDEBUG` 选项(#flags)

本例中的文件结构如下:

```shell
$ tree .
.
|-- CMakeLists.txt
|-- README.md
`-- main.cpp
```

## 概念

### 设置构建(#build)类型(#type)

构建类型可以通过以下方式设置:

- 使用 ccmake/cmake-gui 这类 gui 工具, 不过这不是本文的主旨
- 直接使用 cmake 工具
```shell
cmake . -DCMAKE_BUILD_TYPE=Release
```

**注意** 在 Windows 上, 如果你不指定编译器的话, cmake 会默认使用已经安装的 msvc 版本(其实是因为 Windows 版 cmake 内置的 CMAKE_CXX_COMPILER 是 msvc), 如果要在 windows 上让 cmake 使用 clang/clang++, 需要做一些[设置](https://stackoverflow.com/questions/38171878/how-do-i-tell-cmake-to-use-clang-on-windows), 设置完后, 使用的命令类似:

```shell
cmake -G"Visual Studio 15 2017" -T"LLVM_v141" . -DCMAKE_BUILD_TYPE=Release
```

**注意** 设置主要包括:
1. 安装 llvm binary
1. 安装 llvm-utils, 关于 llvm -> vs 的辅助工具, 参考[这里](https://github.com/zufuliu/llvm-utils)

对于 windows 上 clang++ 和 msbuild 的协同工作, 请参考

- https://devblogs.microsoft.com/cppblog/clang-llvm-support-in-visual-studio/
- https://llvm.org/docs/GettingStartedVS.html

### 设置默认的构建类型

CMake 内置的默认构建类型里, 都不包含任何对编译器优化选项(#flags). 对于某些项目, 你可能希望设置一些默认的构建类型, 这样你就不必总是去记忆这些优化选项了.

下面是一段定义你自己的构建类型的定义, 这段代码处于 CMakeLists.txt 的顶级:

```CMakeLists
if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  message("Setting build type to 'RelWithDebInfo' as none was specified.")
  set(CMAKE_BUILD_TYPE RelWithDebInfo CACHE STRING "Choose the type of build." FORCE)
  # Set the possible values of build type for cmake-gui
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release"
    "MinSizeRel" "RelWithDebInfo")
endif()
```

### 一些构建的日志

msvc 的

```shell
$ cmake . -DCMAKE_BUILD_TYPE=Release
-- Building for: Visual Studio 16 2019
-- The C compiler identification is MSVC 19.23.28106.4
-- The CXX compiler identification is MSVC 19.23.28106.4
-- Check for working C compiler: C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.23.28105/bin/Hostx64/x64/cl.exe
-- Check for working C compiler: C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.23.28105/bin/Hostx64/x64/cl.exe -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.23.28105/bin/Hostx64/x64/cl.exe
-- Check for working CXX compiler: C:/Program Files (x86)/Microsoft Visual Studio/2019/Community/VC/Tools/MSVC/14.23.28105/bin/Hostx64/x64/cl.exe -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: C:/Users/Richard/source/repos/richardo2016/clanglearn/samples/01-basic/F-build-type
```

clang 的
```
$ cmake -G"Visual Studio 15 2017" -T"LLVM_v141" . -DCMAKE_BUILD_TYPE=Release
-- The C compiler identification is Clang 9.0.0 with MSVC-like command-line
-- The CXX compiler identification is Clang 9.0.0 with MSVC-like command-line
-- Check for working C compiler: C:/Program Files/LLVM/bin/clang-cl.exe
-- Check for working C compiler: C:/Program Files/LLVM/bin/clang-cl.exe -- works
-- Detecting C compiler ABI info
-- Detecting C compiler ABI info - done
-- Detecting C compile features
-- Detecting C compile features - done
-- Check for working CXX compiler: C:/Program Files/LLVM/bin/clang-cl.exe
-- Check for working CXX compiler: C:/Program Files/LLVM/bin/clang-cl.exe -- works
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Configuring done
-- Generating done
-- Build files have been written to: C:/Users/Richard/source/repos/richardo2016/clanglearn/samples/01-basic/F-build-type
```