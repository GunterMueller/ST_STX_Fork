@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%i in ('hg root') do SET HGROOT=%%i
@IF "%HGROOT%" NEQ "" SET DEFINES=%DEFINES% "-DHGROOT=%HGROOT%"

make.exe -N -f bc.mak  %DEFINES% %*

@echo "***********************************"
@echo "Buildung stx/libjava/examples/tomcat6"
@echo "***********************************"
@pushd tomcat6
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd


