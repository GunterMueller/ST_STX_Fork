@REM -------
@REM make using Borland bcc32
@REM type bmake, and wait...
@REM do not edit - automatically generated from ProjectDefinition
@REM -------
@SET DEFINES=

make.exe -N -f bc.mak  %DEFINES% %*



@if not exist thrift goto skip_stx_goodies_communication_thrift
@echo "***********************************"
@echo "Building stx/goodies/communication/thrift"
@echo "***********************************"
@pushd thrift
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_communication_thrift
:skip_stx_goodies_communication_thrift
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/communication/thrift"
@echo "###################################"
exit /b 1
:done_stx_goodies_communication_thrift

@if not exist webdriver goto skip_stx_goodies_communication_webdriver
@echo "***********************************"
@echo "Building stx/goodies/communication/webdriver"
@echo "***********************************"
@pushd webdriver
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_communication_webdriver
:skip_stx_goodies_communication_webdriver
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/communication/webdriver"
@echo "###################################"
exit /b 1
:done_stx_goodies_communication_webdriver

@if not exist webdriverService goto skip_stx_goodies_communication_webdriverService
@echo "***********************************"
@echo "Building stx/goodies/communication/webdriverService"
@echo "***********************************"
@pushd webdriverService
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_communication_webdriverService
:skip_stx_goodies_communication_webdriverService
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/communication/webdriverService"
@echo "###################################"
exit /b 1
:done_stx_goodies_communication_webdriverService

@if not exist zeromq goto skip_stx_goodies_communication_zeromq
@echo "***********************************"
@echo "Building stx/goodies/communication/zeromq"
@echo "***********************************"
@pushd zeromq
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_communication_zeromq
:skip_stx_goodies_communication_zeromq
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/communication/zeromq"
@echo "###################################"
exit /b 1
:done_stx_goodies_communication_zeromq

@if not exist ssdp goto skip_stx_goodies_communication_ssdp
@echo "***********************************"
@echo "Building stx/goodies/communication/ssdp"
@echo "***********************************"
@pushd ssdp
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_communication_ssdp
:skip_stx_goodies_communication_ssdp
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/communication/ssdp"
@echo "###################################"
exit /b 1
:done_stx_goodies_communication_ssdp

@if not exist messagePack goto skip_stx_goodies_communication_messagePack
@echo "***********************************"
@echo "Building stx/goodies/communication/messagePack"
@echo "***********************************"
@pushd messagePack
@call bmake %1 %2 || exit /b "%errorlevel%"
@popd
@goto done_stx_goodies_communication_messagePack
:skip_stx_goodies_communication_messagePack
@echo "###################################"
@echo "FOLDER MISSING: stx/goodies/communication/messagePack"
@echo "###################################"
exit /b 1
:done_stx_goodies_communication_messagePack


