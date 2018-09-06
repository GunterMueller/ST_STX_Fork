@REM -------
@REM make using microsoft visual c
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
        call "C:\Program Files\Microsoft Visual Studio 10.0"\VC\bin\vcvars32.bat
)
make.exe -N -f bc.mak -DUSEVC %*


