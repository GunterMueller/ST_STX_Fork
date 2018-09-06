@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if exist bc.mak (
	make.exe -N -f bc.mak %*
)

@echo "***********************************"
@echo "Buildung nonsql/kyotocabinet
@echo "***********************************"
@cd kyotocabinet
@call bmake %1 %2
@cd ..
