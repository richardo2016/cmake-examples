## 简介

clang 在 windows 上可以使用 msbuild 编译, 为了使用 msbuild, 需要借助一下 vs(这里使用 2017+) 的开发者工具.

```bat
@ECHO OFF

SETLOCAL EnableExtensions EnableDelayedExpansion

PUSHD %~dp0

if EXIST build rmdir /S/Q build
REM RD /Q /S "build
mkdir build
CD /D build
cmake -mcpu=x86-64 -G"Visual Studio 15 2017" -T"LLVM_v141" %~dp0src -DCMAKE_BUILD_TYPE=Release

PUSHD %~dp0

SET VSWHERE=%ProgramFiles(x86)%\Microsoft Visual Studio\Installer\vswhere.exe
@rem Visual Studio 2017
FOR /f "delims=" %%A IN ('"%VSWHERE%" -property installationPath -prerelease -version [15.0^,16.0^)') DO (
	SET VCV_PATH=%%A
	IF EXIST "!VCV_PATH!" (
        ECHO Build Binary With Visual Studio 2017: !VCV_PATH!
        call "!VCV_PATH!\VC\Auxiliary\Build\vcvars64.bat" && cmd /k build.cmd
        exit
    )
)
```

如上, 是一个简单的生成 cmake 项目后, 尝试启动 VS2017 的开发者工具来帮助构建 cmake 生成的工程文件的 [start.bat](./start.bat), 其中调用了 [build.cmd](./build.cmd) 来完成编译工作, 被调用的 cmd 内容很简单:

```bat
@echo off

SETLOCAL ENABLEDELAYEDEXPANSION

if defined ProgramFiles(x86) (set HOST_ARCH=amd64) else (set HOST_ARCH=i386)
set TARGET_ARCH=!HOST_ARCH!

REM set BUILD_TYPE=debug
REM set ARG_ERROR=no
REM set MT=

set BUILD_TYPE=Release
set Platform=win32
set MT=/m

msbuild .\build\build_type.sln /t:Build /p:Configuration=!BUILD_TYPE!;Platform=!Platform!;PlatformToolset=v141!XP! !MT!

exit
```

## 构建该示例

我不习惯在 windows 上使用 cmd, 还是还是用 shell 完成

```shell
$ ./start.bat

-- Selecting Windows SDK version 10.0.18362.0 to target Windows 10.0.19041.
-- The C compiler identification is Clang 8.0.1 with MSVC-like command-line
-- The CXX compiler identification is Clang 8.0.1 with MSVC-like command-line
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
-- Build files have been written to: C:/Users/Richard/source/repos/richardo2016/cmake-examples/others/clang-cm

(之后 msbuild) 的过程省略
```

编译好后运行例子:

```shell
$ ./build/Release/cmake_examples_build_type.exe
Hello Build Type!
```