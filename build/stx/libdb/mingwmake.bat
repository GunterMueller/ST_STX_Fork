@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%i in ('hg root') do SET HGROOT=%%i
@IF "%HGROOT%" NEQ "" SET DEFINES=%DEFINES% "-DHGROOT=%HGROOT%"

@pushd ..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %DEFINES% %USEMINGW_ARG% %*

@echo "***********************************"
@echo "Buildung stx/libdb/libodbc
@echo "***********************************"
@cd libodbc
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/libdb/libsqlite
@echo "***********************************"
@cd libsqlite
@call mingwmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/libdb/nosql
@echo "***********************************"
@cd nosql
@call mingwmake %1 %2
@cd ..
