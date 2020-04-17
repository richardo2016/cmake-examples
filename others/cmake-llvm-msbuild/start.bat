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