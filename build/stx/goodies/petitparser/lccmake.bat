@REM -------
@REM make using lcc compiler
@REM type lccmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak -DUSELCC=1 %*

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/analyzer
@echo "***********************************"
@pushd analyzer
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/tests
@echo "***********************************"
@pushd tests
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/smalltalk
@echo "***********************************"
@pushd parsers\smalltalk
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/java
@echo "***********************************"
@pushd parsers\java
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/compiler
@echo "***********************************"
@pushd compiler
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd


