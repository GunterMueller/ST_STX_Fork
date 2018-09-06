@REM -------
@REM make using mingw compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@call ..\rules\find_mingw.bat
make.exe -N -f bc.mak %USEMINGW_ARG% %*
