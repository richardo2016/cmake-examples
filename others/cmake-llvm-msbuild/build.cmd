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