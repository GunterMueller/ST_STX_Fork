@REM -------
@REM make using lcc compiler
@REM type lccmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
make.exe -N -f bc.mak -DUSELCC=1 %*

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/helpers
@echo "***********************************"
@cd helpers
@call lccmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/parser
@echo "***********************************"
@cd parser
@call lccmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/changes
@echo "***********************************"
@cd changes
@call lccmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/refactoring
@echo "***********************************"
@cd refactoring
@call lccmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/browser
@echo "***********************************"
@cd browser
@call lccmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/lint
@echo "***********************************"
@cd lint
@call lccmake %1 %2
@cd ..


