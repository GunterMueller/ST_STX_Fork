@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak %*

@echo "***********************************"
@echo "Buildung stx/libdb/nosql/goods/stx
@echo "***********************************"
@cd stx
@call bmake %1 %2
@cd ..


