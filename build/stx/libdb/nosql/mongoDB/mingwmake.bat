@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@pushd ..\..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %USEMINGW_ARG% %*

@echo "***********************************"
@echo "Buildung stx/libdb/nosql/mongoDB/tests
@echo "***********************************"
@cd tests
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/libdb/nosql/mongoDB/stx
@echo "***********************************"
@cd stx
@call mingwmake %1 %2
@cd ..


