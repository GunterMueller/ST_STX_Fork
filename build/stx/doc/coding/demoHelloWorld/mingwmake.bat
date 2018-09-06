@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

@pushd ..\..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %DEFINES% %USEMINGW_ARG% %*


@IF "%1" EQU "exe" exit /b 0
@IF "%1" EQU "setup" exit /b 0
@IF "%1" EQU "pluginSetup" exit /b 0



