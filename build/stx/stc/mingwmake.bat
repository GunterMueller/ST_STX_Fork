@REM -------
@REM ATTENTION: stc cannot (currently) be compiled with any but borland-C
@REM
@REM make using borland bcc
@REM type mingwmake, and wait...
@REM -------

@if not exist stcmain.c goto bin

@if "%1" EQU "clean" goto clobberOrClean
@if "%1" EQU "clobber" goto clobberOrClean

@call ..\rules\find_mingw

@if not exist objmingw\nul mkdir objmingw



make.exe -f STC.BPR %USEMINGW_ARG%=1 genOffsets.exe
genOffsets > stcVMoffsets.h
make.exe -f STC.BPR %USEMINGW_ARG%=1 %1 %2

copy stc.exe ..\projects\smalltalk

:bin
@if not exist ..\include\nul mkdir ..\include
@call stx-config.bat
copy stx-config.h ..\include
copy stc.h ..\include
copy stcIntern.h ..\include
copy ntIntern.h ..\include
copy stcVMoffsets.h ..\include
copy stcVMdata.h ..\include
copy stxTypeMacros.h ..\include
copy stxAsmMacros.h ..\include
copy stxOSDefs.h ..\include
copy stxNames.h ..\include
copy cpu_x86_64.h ..\include
copy cpu_i386.h ..\include
copy stx-config.h ..\include
copy thinlocks.h ..\include
goto end

:clobberOrClean
make.exe -f STC.BPR %USEMINGW_ARG%=1 %1
goto end

:end
