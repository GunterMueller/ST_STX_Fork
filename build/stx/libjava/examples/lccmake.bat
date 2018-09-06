@REM -------
@REM make using lcc compiler
@REM type lccmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak -DUSELCC=1 %*

@echo "***********************************"
@echo "Buildung stx/libjava/examples/tomcat6
@echo "***********************************"
@pushd tomcat6
@call lccmake %1 %2 || exit /b "%errorlevel%"
@popd


