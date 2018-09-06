@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    pushd ..\..\rules
    call vcsetup.bat
    popd
)
@SET DEFINES=

make.exe -N -f bc.mak -DUSEVC=1 %DEFINES% %*


@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/analyzer
@echo "***********************************"
@pushd analyzer
@call vcmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/tests
@echo "***********************************"
@pushd tests
@call vcmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/smalltalk
@echo "***********************************"
@pushd parsers\smalltalk
@call vcmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/java
@echo "***********************************"
@pushd parsers\java
@call vcmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/compiler
@echo "***********************************"
@pushd compiler
@call vcmake %1 %2 || exit /b "%errorlevel%"
@popd


