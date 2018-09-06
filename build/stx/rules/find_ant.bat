@REM -------
@REM determine which ant to use
@REM (a quick and dirty hack, indeed)
@REM sets the ANT_DIR environment variable to the
@REM directory holding the bin and lib subdirs.
@REM -------

@IF not defined ANT_DIR goto needSetup
@IF not defined ANT goto needSetup
@IF exist %ANT_DIR%\bin goto antDirExists
@echo "configured ANT_DIR (shell env: " %ANT_DIR% ") does not exist. Trying to find it..."
goto needSetup

:antDirExists
@if defined ANT_DIR goto l1
@echo "ANT_DIR is not set..."
@goto needSetup

:l1
@if defined ANT goto needSetup
@echo "ANT is not set..."
@goto needSetup

:needSetup
@echo "looking for " "%ProgramFiles%\apache-ant-1.10.1" "..."
@if not exist "%ProgramFiles%\apache-ant-1.10.1" goto notANT1
@if not exist "%ProgramFiles%\apache-ant-1.10.1\bin" goto notANT1
@set ANT_DIR="%ProgramFiles%\apache-ant-1.10.1"
@set ANT="%ANT_DIR%\bin\ant"
@goto start0

:notANT1
@echo "looking for " "%ProgramFiles(x86)%\apache-ant-1.10.1" "..."
@if not exist "%ProgramFiles(x86)%\apache-ant-1.10.1" goto notANT2
@if not exist "%ProgramFiles(x86)%\apache-ant-1.10.1\bin" goto notANT2
@set ANT_DIR="%ProgramFiles(x86)%\apache-ant-1.10.1"
@set ANT="%ANT_DIR%\bin\ant"
@goto start0

:notMINGW32
@echo !!!
@echo !!!  Could not automatically find out where ant is installed.
@echo !!!
@echo !!! Please install ant (with bin and lib subdirs) as
@echo !!!    C:\Program Files\apache-ant-1.10.1
@echo !!!
@echo !!! I would have found ant then.
@echo !!!
@echo !!! Alternatively (and preferred), set the shell variables:
@echo !!!   ANT_DIR and ANT as appropriate (see README)
@echo !!!
@echo !!! For example:
@echo !!!     set ANT_DIR="C:\Program Files\apache-ant-1.10.1"
@echo !!!     set ANT="%ANT_DIR%\bin\ant"
@echo !!!
@echo !!! Notice: the ANT_DIR must be the one with bin and lib in it.
@echo !!!
@REM exit/b 1
@goto end

:start0
@echo ">>>> using:" %ANT_DIR%
@set PATH=%PATH%;%ANT_DIR%\bin
:end
@echo ">>>> using ANT_DIR:" %ANT_DIR%
