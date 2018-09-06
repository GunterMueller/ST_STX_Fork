@REM -------
@REM make using mingw
@REM -------

@REM borland make fails if classes.obj exists
del objmingw\classes.obj || REM ignore error

@call ..\rules\find_mingw
make.exe -N -f bc.mak %USEMINGW_ARG% %1 %2 %3
