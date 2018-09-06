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



@if not exist experiments goto skip_stx_libjava_experiments
@echo "***********************************"
@echo "Building stx/libjava/experiments"
@echo "***********************************"
@pushd experiments
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_libjava_experiments
:skip_stx_libjava_experiments
@echo "###################################"
@echo "FOLDER MISSING: stx/libjava/experiments"
@echo "###################################"
exit /b 1
:done_stx_libjava_experiments

@if not exist tools goto skip_stx_libjava_tools
@echo "***********************************"
@echo "Building stx/libjava/tools"
@echo "***********************************"
@pushd tools
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_libjava_tools
:skip_stx_libjava_tools
@echo "###################################"
@echo "FOLDER MISSING: stx/libjava/tools"
@echo "###################################"
exit /b 1
:done_stx_libjava_tools


