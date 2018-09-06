@ECHO OFF
REM $Header: /cvs/stx/stx/rules/hg-update.bat,v 1.3 2014-07-08 09:26:55 vrany Exp $
REM
REM Simple script to update code in Mercurial working copy. Called but
REM stx/update.bat and expecco/update.bat
REM
REM Usage: hg-update.bat [-r|--tag <revision>] <packagedir>
REM
REM

SETLOCAL ENABLEEXTENSIONS
set REVISION=

:loop
IF NOT "%1"=="" (
    IF "%1"=="-r" (
        SET REVISION=%2
        SHIFT
        SHIFT
        GOTO :loop
    )
    IF "%1"=="--tag" (    	
        SET REVISION=%2
        SHIFT
        SHIFT
        GOTO :loop
    )	      
)

SET PKGDIR=%1

IF [%PKGDIR%]==[] (
	ECHO "ERROR: repository not defined"
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

IF NOT EXIST %PKGDIR%\.hg (
	IF NOT EXIST %PKGDIR%\CVS (
		ECHO "ERROR: %PKGDIR% doesn't look like Mercurial repository"	
		GOTO error
	) ELSE (
		ECHO "INFO: %PKGDIR% is CVS"
		pushd %PKGDIR%
		cvs upd -d
		popd
		GOTO done
	)		
)


REM some versions of CVS sometimes recreate CVS directory when doing
REM `cvs upd -d`. We have to remove that CVS directory as otherwise
REM stc will detect both CVS and HG working copy and will complain.
IF EXIST %PKGDIR%\CVS (
	rmdir /S /Q "%PKGDIR%\CVS"
)

SET ERRORLEVEL=0
hg --cwd %PKGDIR% pull
IF [%ERRORLEVEL%] NEQ [0] (
	ECHO Cannot pull changes into %PKGDIR%
	GOTO error
)


IF [%REVISION%]==[] (
    hg --cwd %PKGDIR% update    
    IF [%ERRORLEVEL%] NEQ [0] (
	    ECHO Cannot update working copy in %PKGDIR%
	    GOTO error
    )    
) ELSE  (
	ECHO INFO: Updating to revision %REVISION%
    hg --cwd %PKGDIR% update -r %REVISION%    
    IF [%ERRORLEVEL%] NEQ [0] (
	    ECHO Cannot update working copy in %PKGDIR%
	    GOTO error
    )        
)



ECHO ** %PKGDIR% updated, now at: **
hg --cwd %PKGDIR% summary

GOTO done

:error
cd %PKGDIR%
set ERRORLEVEL=1

:done



