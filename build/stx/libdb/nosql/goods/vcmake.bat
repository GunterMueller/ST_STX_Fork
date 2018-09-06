@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    pushd ..\..\..\rules
    call vcsetup.bat
    popd
)
make.exe -N -f bc.mak -DUSEVC %*

@echo "***********************************"
@echo "Buildung stx/libdb/nosql/goods/stx
@echo "***********************************"
@cd stx
@call vcmake %1 %2
@cd ..


