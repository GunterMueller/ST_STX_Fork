@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

make.exe -N -f bc.mak  %DEFINES% %*

@IF "%1" EQU "exe" exit /b 0
@IF "%1" EQU "setup" exit /b 0
@IF "%1" EQU "pluginSetup" exit /b 0


