@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    pushd ..\..\rules
    call vcsetup.bat
    popd
)
make.exe -N -f bc.mak -DUSEVC %*

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/helpers
@echo "***********************************"
@cd helpers
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/parser
@echo "***********************************"
@cd parser
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/changes
@echo "***********************************"
@cd changes
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/refactoring
@echo "***********************************"
@cd refactoring
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/browser
@echo "***********************************"
@cd browser
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/lint
@echo "***********************************"
@cd lint
@call vcmake %1 %2
@cd ..


