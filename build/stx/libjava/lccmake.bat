@REM -------
@REM make using lcc compiler
@REM type lccmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak -DUSELCC=1 %*

@echo "***********************************"
@echo "Buildung stx/libjava/experiments
@echo "***********************************"
@pushd experiments
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/libjava/tools
@echo "***********************************"
@pushd tools
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd


