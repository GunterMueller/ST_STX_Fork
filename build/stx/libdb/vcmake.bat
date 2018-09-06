@REM -------
@REM make using Microsoft Visual C compiler
@REM type vcmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------

@if not defined VSINSTALLDIR (
    pushd ..\rules
    call vcsetup.bat
    popd
)
@SET DEFINES=
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%i in ('hg root') do SET HGROOT=%%i
@IF "%HGROOT%" NEQ "" SET DEFINES=%DEFINES% "-DHGROOT=%HGROOT%"
make.exe -N -f bc.mak -DUSEVC=1 %DEFINES% %*



@echo "***********************************"
@echo "Buildung stx/libdb/libodbc
@echo "***********************************"
@cd libodbc
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/libdb/libsqlite
@echo "***********************************"
@cd libsqlite
@call vcmake %1 %2
@cd ..

@echo "***********************************"
@echo "Buildung stx/libdb/nosql
@echo "***********************************"
@cd nosql
@call vcmake %1 %2
@cd ..
