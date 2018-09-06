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
@echo "Buildung nosql/cassandra
@echo "***********************************"
@cd cassandra
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/goods
@echo "***********************************"
@cd goods
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/mongoDB
@echo "***********************************"
@cd mongoDB
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/couchDB
@echo "***********************************"
@cd couchDB
@call vcmake %1 %2
@cd ..
