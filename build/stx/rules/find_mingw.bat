@REM -------
@REM determine which mingw compiler to use
@REM (a quick and dirty hack, indeed)
@REM sets the MINGW_DIR environment variable to the
@REM directory holding the bin and lib subdirs.
@REM -------

@IF not defined MINGW_DIR goto needSetup
@IF not defined MINGW goto needSetup
@IF not defined USEMINGW_ARG goto needSetup
@IF exist %MINGW_DIR%\bin goto mingwDirExists
@echo "configured MINGW_DIR (shell env: " %MINGW_DIR% ") does not exist. Trying to find it..."
goto needSetup

:mingwDirExists
@if defined MINGW_DIR goto l1
@echo "MINGW_DIR is not set..."
@goto needSetup

:l1
@if defined MINGW goto l2
@echo "MINGW is not set..."
@goto needSetup

:l2
@IF defined USEMINGW_ARG goto end
@echo "USEMINGW_ARG is not set..."

:needSetup
@echo "looking for c:\MINGW..."
@if not exist c:\MINGW goto notMINGWa
@if not exist c:\MINGW\bin goto notMINGWa
@set MINGW_DIR="c:\MINGW"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGWa
@echo "looking for c:\MINGW-W64"...
@if not exist c:\MINGW-W64 goto notMINGWa2
@if not exist "c:\MINGW-W64\bin" goto notMINGWa2
@set MINGW_DIR="c:\MINGW-W64"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGWa2
@echo "looking for c:\MINGW-W64\MINGW64"...
@if not exist c:\MINGW-W64\MINGW64 goto notMINGWa3
@if not exist "c:\MINGW-W64\MINGW64\bin" goto notMINGWa3
@set MINGW_DIR="c:\MINGW-W64\MINGW64"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGWa3
@echo "looking for c:\MINGW64"...
@if not exist c:\MINGW64 goto notMINGW64b
@if not exist "c:\MINGW64\bin" goto notMINGW64b
@set MINGW_DIR="c:\MINGW64"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGW64b
@echo "looking for " "%ProgramFiles%\MINGW-W64" "..."
@if not exist "%ProgramFiles%\MINGW-W64" goto notMINGW64c
@if not exist "%ProgramFiles%\MINGW-W64\bin" goto notMINGW64c
@set MINGW_DIR="%ProgramFiles%\MINGW-W64"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGW64c
@echo "looking for " "%ProgramFiles%\MINGW64" "..."
@if not exist "%ProgramFiles%\MINGW64" goto notMINGW64d
@if not exist "%ProgramFiles%\MINGW64\bin" goto notMINGW64d
@set MINGW_DIR="%ProgramFiles%\MINGW64"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGW64d
@echo "looking for " "%ProgramFiles%\mingw-w64\x86_64-7.2.0-win32-seh-rt_v5-rev1\mingw64" "..."
@if not exist "%ProgramFiles%\mingw-w64\x86_64-7.2.0-win32-seh-rt_v5-rev1\mingw64\bin" goto notMINGW64
@set MINGW_DIR="%ProgramFiles%\mingw-w64\x86_64-7.2.0-win32-seh-rt_v5-rev1\mingw64"
@set MINGW=__MINGW64__
@set USEMINGW_ARG="-DUSEMINGW64=1"
@goto start0

:notMINGW64
@echo "looking for "c:\MINGW32"..."
@if not exist c:\MINGW32 goto notMINGW32b
@if not exist c:\MINGW32\bin goto notMINGW32b
@set MINGW_DIR="c:\MINGW32"
@set MINGW=__MINGW32__
@set USEMINGW_ARG="-DUSEMINGW32=1"
@goto start0

:notMINGW32b
@echo "looking for " "%ProgramFiles%\MINGW" "..."
@if not exist "%ProgramFiles%\MINGW" goto notMINGW32c
@if not exist "%ProgramFiles%\MINGW\bin" goto notMINGW32c
@set MINGW_DIR="%ProgramFiles%\MINGW"
@set MINGW=__MINGW32__
@set USEMINGW_ARG="-DUSEMINGW32=1"
@goto start0

:notMINGW32c
@echo "looking for " "%ProgramFiles%\MINGW32" "..."
@if not exist "%ProgramFiles%\MINGW32" goto notMINGW32
@if not exist "%ProgramFiles%\MINGW32\bin" goto notMINGW32
@set MINGW_DIR="%ProgramFiles%\MINGW32"
@set MINGW=__MINGW32__
@set USEMINGW_ARG="-DUSEMINGW32=1"
@goto start0

:notMINGW32
@echo !!!
@echo !!!  Could not automatically find out where mingw is installed.
@echo !!!
@echo !!! Please install mingw (with bin and lib subdirs) either as
@echo !!!    C:\MINGW, C:\MINGW32, C:\MINGW64
@echo !!! or
@echo !!!    C:\Program Files\MINGW32, C:\Program Files\MINGW64
@echo !!!
@echo !!! I would have found mingw then.
@echo !!!
@echo !!! Alternatively (and preferred), set the shell variables:
@echo !!!   MINGW_DIR, MINGW and USEMINGW_ARG as appropriate (see README)
@echo !!!
@echo !!! For example:
@echo !!!     set MINGW=__MINGW64__
@echo !!!     set MINGW_DIR="c:\Program Files\mingw-w64\x86_64-5.3.0-win32-seh-rt_v4-rev0\mingw64"
@echo !!!     set USEMINGW_ARG="-DUSEMINGW64=1"
@echo !!!
@echo !!! Notice: the MINGW_DIR must be the one with bin and lib in it.
@echo !!!
@REM exit/b 1
@goto end

:start0
@echo ">>>> using:" %MINGW_DIR%
@set PATH=%PATH%;%MINGW_DIR%\bin
:end
@echo ">>>> using MINGW_DIR:" %MINGW_DIR%
