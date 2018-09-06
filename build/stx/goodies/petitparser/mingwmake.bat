@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

@pushd ..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %DEFINES% %USEMINGW_ARG% %*

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/analyzer
@echo "***********************************"
@pushd analyzer
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/tests
@echo "***********************************"
@pushd tests
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/smalltalk
@echo "***********************************"
@pushd parsers\smalltalk
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/parsers/java
@echo "***********************************"
@pushd parsers\java
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd

@echo "***********************************"
@echo "Buildung stx/goodies/petitparser/compiler
@echo "***********************************"
@pushd compiler
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd


