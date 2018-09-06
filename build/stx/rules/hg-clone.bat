@ECHO OFF
REM $Header: /cvs/stx/stx/rules/hg-clone.bat,v 1.7 2014-07-10 07:37:32 vrany Exp $
REM
REM Simple script to clone Mercurial repository. Used from stub entries in CVS
REM to automatically fetch code from there.
REM
REM Usage: hg-clone.bat <repository> <packagedir>
REM

SETLOCAL ENABLEEXTENSIONS
SET REPO=%1
SET PKGDIR=%2
SET CLONE=%PKGDIR%.tmp

IF [%REPO%]==[] (
	ECHO "ERROR: repository not defined"
	GOTO error
)

IF [%PKGDIR%]==[] (
	ECHO "ERROR: package directory not defined"
	GOTO error
)

SET HGFOUND=0
FOR %%x in (hg.exe) do IF not [%%~$PATH:x]==[] SET HGFOUND=1

IF [%HGFOUND%] == [0] (	
	ECHO Could not find `hg` command, perhaps Mercurial client is not installed
	ECHO or not in your PATH. Please install mercurial and try again. You may find 
	ECHO pre-built packages and installation instructions at:	
  	ECHO     http://mercurial.selenic.com/wiki/Download  	
  	GOTO error  	
)

IF EXIST %PKGDIR%\.hg (
	ECHO "ERROR: %PKGDIR% is already a Mercurial repository"
	GOTO error
)

SET ERRORLEVEL=0
move %PKGDIR% %PKGDIR%.old
IF [%ERRORLEVEL%] NEQ [0] (	
	ECHO "ERROR: Cannot move old directory aside"
	GOTO error
)

IF EXIST %CLONE% (
	rmdir /S /Q %CLONE%
)

SET ERRORLEVEL=0
hg clone %REPO% %CLONE%
IF [%ERRORLEVEL%] NEQ [0] (
	ECHO "ERROR: Cannot clone repository"
	IF EXIST %CLONE% (
		ECHO "Cleaning up..."
		rmdir /S /Q %CLONE%
	)
	move %PKGDIR%.old %PKGDIR%
	GOTO error
)

IF NOT EXIST %CLONE% (
	ECHO "ERROR: Cannot clone repository"
	IF EXIST %CLONE% (
		ECHO "Cleaning up..."
		rmdir /S /Q %CLONE%
	)
	move %PKGDIR%.old %PKGDIR%
	GOTO error
)

SET ERRORLEVEL=0
move %CLONE% %PKGDIR%
IF [%ERRORLEVEL%] NEQ [0] (
	ECHO "ERROR: Cannot move clone to %PKGDIR%"
	ECHO "Cleaning up..."
	move %PKGDIR%.old %PKGDIR%
	rmdir /S /Q %CLONE%	
	GOTO error
)

GOTO done

:error
set ERRORLEVEL=1

:done



