@REM -------
@REM make using mingw gnu compiler
@REM type mingwmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=
@REM Kludge got Mercurial, cannot be implemented in Borland make
@FOR /F "tokens=*" %%i in ('hg root') do SET HGROOT=%%i
@IF "%HGROOT%" NEQ "" SET DEFINES=%DEFINES% "-DHGROOT=%HGROOT%"

@pushd ..\..\..\rules
@call find_mingw.bat
@popd
make.exe -N -f bc.mak %DEFINES% %USEMINGW_ARG% %*



@if not exist spelling goto skip_stx_goodies_refactoryBrowser_lint_spelling
@echo "***********************************"
@echo "Building stx/goodies/refactoryBrowser/lint/spelling"
@echo "***********************************"
@pushd spelling
@call mingwmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_refactoryBrowser_lint_spelling
:skip_stx_goodies_refactoryBrowser_lint_spelling
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/refactoryBrowser/lint/spelling"
@echo "###################################"
exit /b 1
:done_stx_goodies_refactoryBrowser_lint_spelling


