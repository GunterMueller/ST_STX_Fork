@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

make.exe -N -f bc.mak  %DEFINES% %*

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/analyzer
@echo "***********************************"
@pushd analyzer
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/tests
@echo "***********************************"
@pushd tests
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/smalltalk
@echo "***********************************"
@pushd parsers\smalltalk
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/java
@echo "***********************************"
@pushd parsers\java
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/compiler
@echo "***********************************"
@pushd compiler
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd


