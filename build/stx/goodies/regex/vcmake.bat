@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    call ..\..\rules\vcsetup.bat
)
make.exe -N -f bc.mak -DUSEVC %*


