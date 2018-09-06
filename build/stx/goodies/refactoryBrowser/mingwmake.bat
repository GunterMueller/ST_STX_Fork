@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@pushd ..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %USEMINGW_ARG% %*

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/helpers
@echo "***********************************"
@cd helpers
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/parser
@echo "***********************************"
@cd parser
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/changes
@echo "***********************************"
@cd changes
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/refactoring
@echo "***********************************"
@cd refactoring
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/browser
@echo "***********************************"
@cd browser
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/goodies/refactoryBrowser/lint
@echo "***********************************"
@cd lint
@call mingwmake %1 %2
@cd ..


