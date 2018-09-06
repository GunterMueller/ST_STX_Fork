@REM In a Visual-C build, this script is invoked
@REM in the environment iff VSINSTALLDIR is NOT defined
@REM Please change it to point to your installed Visual-C directory.
@REM

@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 15.0" goto noVC15a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 15.0"\VC\bin\vcvars32.bat
@goto end

:noVC15a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 15.0" goto noVC15
call "%ProgramFiles%\Microsoft Visual Studio 15.0"\VC\bin\vcvars32.bat
@goto end

:noVC15
@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0" goto noVC14a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 14.0"\VC\bin\vcvars32.bat
@goto end

:noVC14a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 14.0" goto noVC14
call "%ProgramFiles%\Microsoft Visual Studio 14.0"\VC\bin\vcvars32.bat
@goto end

:noVC14
@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 13.0" goto noVC13a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 13.0"\VC\bin\vcvars32.bat
@goto end

:noVC13a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 13.0" goto noVC13
call "%ProgramFiles%\Microsoft Visual Studio 13.0"\VC\bin\vcvars32.bat
@goto end

:noVC13
@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0" goto noVC12a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 12.0"\VC\bin\vcvars32.bat
@goto end

:noVC12a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 12.0" goto noVC12
call "%ProgramFiles%\Microsoft Visual Studio 12.0"\VC\bin\vcvars32.bat
@goto end

:noVC12
@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 11.0" goto noVC11a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 11.0"\VC\bin\vcvars32.bat
@goto end

:noVC11a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 11.0" goto noVC11
call "%ProgramFiles%\Microsoft Visual Studio 11.0"\VC\bin\vcvars32.bat
@goto end

:noVC11
@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 10.0" goto noVC10a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 10.0"\VC\bin\vcvars32.bat
@goto end

:noVC10a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 10.0" goto noVC10
call "%ProgramFiles%\Microsoft Visual Studio 10.0"\VC\bin\vcvars32.bat
@goto end

:noVC10
@if not exist "%ProgramFiles(x86)%\Microsoft Visual Studio 9.0" goto noVC9a
call "%ProgramFiles(x86)%\Microsoft Visual Studio 9.0"\VC\bin\vcvars32.bat
@goto end

:noVC9a
@if not exist "%ProgramFiles%\Microsoft Visual Studio 9.0" goto noVC9
call "%ProgramFiles%\Microsoft Visual Studio 9.0"\VC\bin\vcvars32.bat
@goto end

:noVC9
@echo "***********************************************************"
@echo "Error in rules\vcsetup.bat: Don't know which VisualC to use"
@echo "***********************************************************"
exit/b 1

:end
@if "%WindowsSdkDir%" NEQ "" goto end2
call find_sdk

:end2
@if exist "%WindowsSdkDir%" goto end3
call find_sdk

:end3
