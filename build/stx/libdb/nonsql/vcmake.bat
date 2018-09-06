@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    call ..\..\rules\vcsetup.bat
)
make.exe -N -f bc.mak -DUSEVC %*

@echo "***********************************"
@echo "Buildung nonsql/kyotocabinet
@echo "***********************************"
@cd kyotocabinet
@call vcmake %1 %2
@cd ..
