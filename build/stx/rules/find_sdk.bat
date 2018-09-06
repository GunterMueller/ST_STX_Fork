@REM -------
@REM determine where to find C-header files (where the SDK is)
@REM (a quick and dirty hack, indeed)
@REM sets the WindowsSdkDir environment variable
@REM -------

@if "%1" EQU "-f" goto force
@if "%WindowsSdkDir%" NEQ "" goto end

:force
@if not exist "C:\Program Files" goto notProgramFiles
@set PROGRAMS=C:\Program Files
@set PROGRAMS86=C:\Program Files (x86)
@goto lookForSDK

:notProgramFiles
@if not exist "C:\Programme" goto notProgramme
@set PROGRAMS=C:\Programme
@set PROGRAMS86=C:\Programme (x86)
@goto lookForSDK

:notProgramme
@echo [rules/find_sdk]: FixMe ("C:\Program Files" not found)
@goto end


:lookForSDK
@if not exist "%PROGRAMS86%\Microsoft SDKs\Windows\v7.1" goto notSDK71_1
set WindowsSdkDir=%PROGRAMS86%\Microsoft SDKs\Windows\v7.1\
@goto start0

:notSDK71_1
@if not exist "%PROGRAMS%\Microsoft SDKs\Windows\v7.1" goto notSDK71
set WindowsSdkDir=%PROGRAMS%\Microsoft SDKs\Windows\v7.1\
@goto start0

:notSDK71
@if not exist "%PROGRAMS86%\Microsoft SDKs\Windows\v7.0" goto notSDK70_1
set WindowsSdkDir=%PROGRAMS86%\Microsoft SDKs\Windows\v7.0\
@goto start0

:notSDK70_1
@if not exist "%PROGRAMS%\Microsoft SDKs\Windows\v7.0" goto notSDK70
set WindowsSdkDir=%PROGRAMS%\Microsoft SDKs\Windows\v7.0\
@goto start0

:notSDK70
@if not exist "%PROGRAMS86%\Microsoft SDKs\Windows\v7.0A" goto notSDK70a_1
set WindowsSdkDir=%PROGRAMS86%\Microsoft SDKs\Windows\v7.0A\
@goto start0

:notSDK70a_1
@if not exist "%PROGRAMS%\Microsoft SDKs\Windows\v7.0A" goto notSDK70a
set WindowsSdkDir=%PROGRAMS%\Microsoft SDKs\Windows\v7.0A\
@goto start0

:notSDK70a
@if not exist "%PROGRAMS86%\Microsoft SDKs\Windows\6.0" goto notSDK60_1
set WindowsSdkDir=%PROGRAMS86%\Microsoft SDKs\Windows\6.0\
@goto start0

:notSDK60_1
@if not exist "%PROGRAMS%\Microsoft SDKs\Windows\v6.0" goto notSDK60
set WindowsSdkDir=%PROGRAMS%\Microsoft SDKs\Windows\v6.0\
@goto start0

:notSDK60
@echo Please install a Microsoft SDK or modify "rules/find_sdk.bat"
@goto end

:start0
@echo ">>>> using" %WindowsSdkDir%

:end
