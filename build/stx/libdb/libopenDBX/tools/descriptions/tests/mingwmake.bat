@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@pushd ..\..\..\..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %USEMINGW_ARG% %*


