@echo off
IF EXIST "%PROGRAMFILES(X86)%" (
	%~dp0\setenv_mingw64.bat
) ELSE (
    %~dp0\setenv_mingw32.bat
)
