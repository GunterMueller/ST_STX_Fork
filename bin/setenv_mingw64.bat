@echo off
if exist C:\MSYS64\MINGW64 (
    set MINGW_DIR=C:\MSYS64\MINGW64
) else (
   set MINGW_DIR=C:\MINGW64
)
set MINGW=__MINGW64__
set USEMINGW_ARG=-DUSEMINGW64
set PATH=%~dp0;%PATH%;%MINGW_DIR%\bin
echo Environment now set to compile 64bit code
echo To compile a package, type "mingwmake" in package directory

