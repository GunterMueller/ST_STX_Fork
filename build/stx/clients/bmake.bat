@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

make.exe -N -f bc.mak  %DEFINES% %*



@if not exist DrawTool goto skip_stx_clients_DrawTool
@echo "***********************************"
@echo "Building stx/clients/DrawTool"
@echo "***********************************"
@pushd DrawTool
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_clients_DrawTool
:skip_stx_clients_DrawTool
@echo "###################################"
@echo "FOLDER MISSING: stx/clients/DrawTool"
@echo "###################################"
exit /b 1
:done_stx_clients_DrawTool
