@echo off
:
: $Header: /opt/data/cvs/stx/goodies/xmlsuite/xquery/distutils/src-win32/bin/xquery-workspace.bat,v 1.1 2007-02-11 22:58:21 vranyj1 Exp $
:
: startup script for smalltalk
: actually, simply calls stx, passing all arguments.
:
:
: In previous versions, smalltalk used to be the executable itself.
: This lead to problems on systems, where things like the PATH
: or STX_LIBDIR should be set in advance. 
: Now, here is a place to do such things ...
:

if {%1}=={--help} goto usage

:
: change the line below, if
: the support stuff is not found in the
: directory where stx.exe resides ...
set STX_LIBDIR=..\lib
set STX_PACKAGEPATH=..\applications\xquery-workspace\packages;..\packages

stx %1 %2 %3 %4 %5 %6 %7 %8 %9 %10 -f xquery-workspace.rc
goto end

:usage
echo.
echo usage: smalltalk stx-args
echo.
echo STX args:
stx --help

:end
