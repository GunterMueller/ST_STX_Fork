@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@call ..\..\rules\find_mingw.bat
make.exe -N -f bc.mak %USEMINGW_ARG% %*

@echo "***********************************"
@echo "Buildung nosql/cassandra
@echo "***********************************"
@cd cassandra
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/goods
@echo "***********************************"
@cd goods
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/mongoDB
@echo "***********************************"
@cd mongoDB
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/couchDB
@echo "***********************************"
@cd couchDB
@call mingwmake %1 %2
@cd ..
