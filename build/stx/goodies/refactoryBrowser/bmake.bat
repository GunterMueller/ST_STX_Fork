@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak %*

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/helpers
@echo "***********************************"
@cd helpers
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/parser
@echo "***********************************"
@cd parser
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/changes
@echo "***********************************"
@cd changes
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/refactoring
@echo "***********************************"
@cd refactoring
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/browser
@echo "***********************************"
@cd browser
@call bmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/lint
@echo "***********************************"
@cd lint
@call bmake %1 %2
@cd ..


