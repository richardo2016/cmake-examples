## 介绍

该例展示了如何生成一个 `make install` target 把编译后的文件和二进制安装到你的系统中. 本例基于上一节的动态链接库例子.

本节包含的文件如下:

```shell
$ tree
.
├── CMakeLists.txt
├── cmake-examples.conf
├── include
│   └── installing
│       └── Hello.h
└── src
    ├── Hello.cpp
    └── main.cpp
```

- [CMakeLists.txt](./CMakeLists.txt) - 包含所有你编制的 CMake 命令

- [cmake-examples.conf]([./cmake-examples.conf]) - 一个示例的配置文件

- [include/shared/Hello.h](./include/shared/Hello.h) - 要包含(include)的所有头文件

- [src/Hello.cpp](./src/Hello.cpp) - 要编译的源(source)文件

- [src/main.cpp](./src/main.cpp) - 主源(source)文件

## 概念

### 安装

CMake 提供安装能力, 通过添加一个 `make install` target, 可以允许用户安装二进制文件, 库和别的文件.

安装基础位置由变量 `CMAKE_INSTALL_PREFIX` 控制, 该变量可以用 `ccmake` 或者带编译指令运行(`cmake .. -DCMAKE_INSTALL_PREFIX=/install/location`)来设置.

要安装的文件可以通过 [install()](https://cmake.org/cmake/help/v3.0/command/install.html) 方法来控制.

```shell
install (TARGETS cmake_examples_inst_bin
    DESTINATION bin)
```

从 target cmake_examples_inst_bin 安装生成的二进制文件到目标位置 `{CMAKE_INSTALL_PREFIX}/bin`.

```shell
install (TARGETS cmake_examples_inst
    LIBRARY DESTINATION lib)
```

从 target cmake_examples_inst_bin 安装生成的动态链接库到目标位置 `{CMAKE_INSTALL_PREFIX}/lib`.

**注意** 这个安装动态链接库的动作可能在 Windows 上无效. 对于 DLL 格式的 targets, 你可能需要添加以下命令:

```shell
install (TARGETS cmake_examples_inst
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin)
```

从 target cmake_examples_inst_bin 安装头文件到目标位置 `{CMAKE_INSTALL_PREFIX}/lib`.

```shell
install(DIRECTORY ${PROJECT_SOURCE_DIR}/include/
    DESTINATION include)
```

安装配置文件到目标位置 `${CMAKE_INSTALL_PREFIX}/etc`.

```shell
install (FILES cmake-examples.conf
    DESTINATION etc)
```

在 `make install` 运行之后, CMake 会生成一个 `install_manifest.txt` 文件, 其中包含了所有待安装文件的细节.

**注意** 如果你以 root 用户运行 `make install`,  则 `install_manifest.txt` 文件会被 root 用户持有.

## 构建当前例子

```shell
$ mkdir build

$ cd build/

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
-- Build files have been written to: /Users/richard/Projects/richardo2016/cmake-examples/01-basic/E-installing/build

$ make
Scanning dependencies of target cmake_examples_inst
[ 25%] Building CXX object CMakeFiles/cmake_examples_inst.dir/src/Hello.cpp.o
[ 50%] Linking CXX shared library libcmake_examples_inst.dylib
[ 50%] Built target cmake_examples_inst
Scanning dependencies of target cmake_examples_inst_bin
[ 75%] Building CXX object CMakeFiles/cmake_examples_inst_bin.dir/src/main.cpp.o
[100%] Linking CXX executable cmake_examples_inst_bin
[100%] Built target cmake_examples_inst_bin

$ sudo make install
Password:
[ 50%] Built target cmake_examples_inst
[100%] Built target cmake_examples_inst_bin
Install the project...
-- Install configuration: ""
-- Installing: /usr/local/bin/cmake_examples_inst_bin
-- Installing: /usr/local/lib/libcmake_examples_inst.dylib
-- Up-to-date: /usr/local/include
-- Installing: /usr/local/include/installing
-- Installing: /usr/local/include/installing/Hello.h
-- Installing: /usr/local/etc/cmake-examples.conf

$ cat install_manifest.txt 
/usr/local/bin/cmake_examples_inst_bin
/usr/local/lib/libcmake_examples_inst.dylib
/usr/local/include/installing/Hello.h
/usr/local/etc/cmake-examples.conf

$ ls /usr/local/bin/ | grep cmake_examples_inst
cmake_examples_inst_bin

$ ls /usr/local/lib | grep cmake_examples_inst
libcmake_examples_inst.dylib

$ ls /usr/local/etc/ | grep cmake-examples
cmake-examples.conf

$ LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib cmake_examples_inst_bin
Hello Install!
```

**注意** 如果 `/usr/local/lib` 不在你的库文件路径里, 则在运行二进制文件之前, 你必须把它加到路径里.

### 额外的注意点

#### 覆盖默认安装位置

正如上文所述, 默认的安装位置是根据 `CMAKE_INSTALL_PERFIX` 得到的, 如果不在项目中指定, 则这个变量默认为 `/usr/local/`

如果你想对所有用户都改变这个默认安装位置, 你可以将下面的代码加入到你的顶级 `CMakeLists.txt` 中, 使得这段代码的优先级高于后续的任何二进制文件和库.

```cmake
if( CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT )
  message(STATUS "Setting default CMAKE_INSTALL_PREFIX path to ${CMAKE_BINARY_DIR}/install")
  set(CMAKE_INSTALL_PREFIX "${CMAKE_BINARY_DIR}/install" CACHE STRING "The path to use for make install" FORCE)
endif()
```

该示例将默认的安装位置改到了你的构建目录下.

#### DESTDIR

如果你想将你的安装暂存, 以确保所有的文件是否被包含, 可以使用 `make install` 所支持的 DESTDIR 参数.

```shell
make install DESTDIR=/tmp/stage
```
上述命令会对你所有的待安装文件创建安装目录 `${DESTDIR}/${CMAKE_INSTALL_PREFIX}`. 在这个例子中, 所有的文件会被安装到 `/tmp/stage/usr/local`.

```shell
$ tree /tmp/stage
/tmp/stage
└── usr
    └── local
        ├── bin
        │   └── cmake_examples_inst_bin
        ├── etc
        │   └── cmake-examples.conf
        ├── include
        │   └── installing
        │       └── Hello.h
        └── lib
            └── libcmake_examples_inst.dylib
```

#### 卸载

默认情况下 CMake 不会添加一个 `make uninstall` target. 如果要生成一个 uninstall target, 可以参见 [FAQ](https://cmake.org/Wiki/CMake_FAQ#Can_I_do_.22make_uninstall.22_with_CMake.3F)

如果想快速移除本节例子产生的文件, 可以使用这个命令:

```shell
sudo xargs rm < install_manifest.txt
```

