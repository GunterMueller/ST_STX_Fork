@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    pushd ..\..\..\..\rules
    call vcsetup.bat
    popd
)
@SET DEFINES=

make.exe -N -f bc.mak -DUSEVC=1 %DEFINES% %*




