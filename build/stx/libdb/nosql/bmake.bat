@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if exist bc.mak (
	make.exe -N -f bc.mak %*
)

@echo "***********************************"
@echo "Buildung nosql/cassandra
@echo "***********************************"
@cd cassandra
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/goods
@echo "***********************************"
@cd goods
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/mongoDB
@echo "***********************************"
@cd mongoDB
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung nosql/couchDB
@echo "***********************************"
@cd couchDB
@call bmake %1 %2
@cd ..
