@echo off
if exist C:\MSYS64\MINGW32 (
    set MINGW_DIR=C:\MSYS64\MINGW32
) else (
   set MINGW_DIR=C:\MINGW
)
set MINGW=__MINGW32__
set USEMINGW_ARG=-DUSEMINGW32
set PATH=%~dp0;%PATH%;%MINGW_DIR%\bin
echo Environment now set to compile 32bit code
echo To compile a package, type "mingwmake" in package directory