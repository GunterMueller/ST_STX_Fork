@ECHO OFF
REM $Header: /cvs/stx/stx/rules/hg-clone-and-bmake.bat,v 1.2 2015-04-21 09:50:17 stefan Exp $
REM
REM Simple script to clone Mercurial repository and call bmake there. Used from stub 
REM entries in CVS to automatically fetch code from there.
REM
REM Usage: hg-clone-and-build.bat <repository> <TOP> <package>
REM

SETLOCAL ENABLEEXTENSIONS
SET REPO=%1
SET TOP=%2
SET PKG=%3

IF [%REPO%]==[] (
	ECHO "ERROR: repository not defined"
	GOTO error
)

IF [%TOP%]==[] (
	ECHO "ERROR: TOP directory not defined"
	GOTO error
)

IF [%PKG%]==[] (
	ECHO "ERROR: package not defined"
	GOTO error
)

pushd %TOP%\rules
call hg-clone %REPO% ..\..\%PKG%
IF [%ERRORLEVEL%] NEQ [0] (
	popd
	GOTO error
)
popd

bmake.bat %4

GOTO done

:error
set ERRORLEVEL=1

:done



