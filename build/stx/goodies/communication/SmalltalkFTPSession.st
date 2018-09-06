"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

AbstractFTPSession subclass:#SmalltalkFTPSession
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-FTP'
!

!SmalltalkFTPSession class methodsFor:'documentation'!

copyright 
"
 COPYRIGHT (c) 2003 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    Helper class for the FTPServer.

    an FTPSession which allows for access to Smalltalk internals.
    Unfinished - this is a simple unfinished demo.

    [author:]
        Claus Gittinger

    [start with:]
        FTPServer verbose:true

        (FTPServer forPort:12345)
            sessionClass:SmalltalkFTPSession;
            start

        then, on the command line, try:
            ftp loalhost 12345
"
! !

!SmalltalkFTPSession methodsFor:'ftp protocol'!

canChangeWorkingDirectory:newDirectory
    "true if client is allowed to change to a new directory.
     Here, only the simulated virtual directories 'classes' and 'processes'
     are allowed."
     
    ( 
     #(
        '/'
        '/classes'
        '/processes'
      ) includes:newDirectory pathName
    ) ifTrue:[^ true].

    ^ false
!

doLIST:longFormat 
    "list of the virtual directories.
     Either lists classes or processes"
     
    |where pattern|

    self checkAndGetDataConnection.

    lastArgument notNil ifTrue:[
        where := self checkAndGetArgFilename.

        where isDirectory ifTrue:[
            pattern := '*'.
        ] ifFalse:[
            pattern := where baseName.
            where := where directory.   
        ].

        (self canChangeWorkingDirectory:where) ifFalse:[
            FTPServerException permissionDenied:lastArgument.
        ].
    ] ifFalse:[
        where := self checkAndGetCWD.
        pattern := '*'.
    ].

    socket nextPutLine:'150 Opening ASCII mode data connection LIST.'.
    dataSocket text; lineEndCRLF.

    where := where pathName.
    where = '/' ifTrue:[
        self doListServices:longFormat.
    ] ifFalse:[
        where = '/classes' ifTrue:[
            self doListClasses:longFormat.
        ] ifFalse:[
            where = '/processes' ifTrue:[
                self doListProcesses:longFormat.
            ] ifFalse:[
                self closeDataConnection.
                FTPServerException permissionDenied.
            ].
        ].
    ].  
    self closeDataConnection.
    socket nextPutLine:'226 Transfer complete.'.

    "Modified: / 13-02-2017 / 22:52:29 / cg"
    "Modified: / 11-04-2018 / 09:55:59 / stefan"
!

doListClasses:longFormat 
    "list class names as if they were files in a folder"

    (Smalltalk allClasses collect:[:each | each name]) asSortedCollection do:[:eachClass |
        self generateListLineForClassNamed:eachClass
    ].
!

doListProcesses:longFormat 
    "list process names as if they were files in a folder"

    (Process allInstances 
        select:[:p | p isDead not]
        thenCollect:[:each | each id]) asSortedCollection 
    do:[:eachPID |
        self generateListLineForProcessWithID:eachPID
    ].
!

doListServices:longFormat 
    dataSocket nextPutLine:'processes'.
    dataSocket nextPutLine:'classes'.
!

generateListLineForClassNamed:aClassName
    dataSocket nextPutLine:aClassName.
!

generateListLineForProcessWithID:pid
    dataSocket nextPutLine:(pid printString).
! !

!SmalltalkFTPSession methodsFor:'protocol testing'!

allowedToSeeDirectory:dir
    ^ true
!

allowedToWriteIntoDirectory:dir
    ^ false
! !

!SmalltalkFTPSession methodsFor:'queries'!

defaultDirectoryForUser:userName
    ^ UnixFilename named:'/'
!

loginUserNeedsPassword:userName 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ false
! !

!SmalltalkFTPSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SmalltalkFTPSession.st,v 1.8 2018-04-11 07:58:45 stefan Exp $'
! !

