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



@if not exist spelling goto skip_stx_goodies_refactoryBrowser_lint_spelling
@echo "***********************************"
@echo "Building stx/goodies/refactoryBrowser/lint/spelling"
@echo "***********************************"
@pushd spelling
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_refactoryBrowser_lint_spelling
:skip_stx_goodies_refactoryBrowser_lint_spelling
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/refactoryBrowser/lint/spelling"
@echo "###################################"
exit /b 1
:done_stx_goodies_refactoryBrowser_lint_spelling


