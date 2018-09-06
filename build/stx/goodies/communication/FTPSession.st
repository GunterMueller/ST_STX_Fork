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

AbstractFTPSession subclass:#FTPSession
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-FTP'
!

!FTPSession class methodsFor:'documentation'!

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

    an FTP serverSession - subclass to add/change functionality

    the server's functionality is limited (by purpose):
        mkdir   - never allowed (see doDelete:)
        rmdir   - never allowed (see doDelete:)
        rm      - never allowed (see doDelete:)

        put     - only allowed for new files 
                  (i.e. existing files are never overwritten)

    be aware, that this FTPSession allows a client to GET all files
    which are readable by me (except for the white- and blacklists below).

    To limit access to certain folders, you can explicitly whiteList
    allowed folders (by setting whiteListedFolders) and/or exclude individual folders
    via a blackList (setting blackListedFolders).

    Whitelisting is done first, then blacklisting
    i.e. it is possible to allow everything under '/foo/...' by adding '/foo' to the whitelist,
    and still exclude individual subdirectories under it by adding (say) '/foo/bar/baz' to the blacklist.

    [author:]
        Claus Atzkern
        Claus Gittinger

    [start with:]
        FTPServer start.
        FTPServer startOnPort:portNr.
"
! !

!FTPSession methodsFor:'basic ftp user commands'!

doDELETE:recursive
    |file|

    file := self checkAndGetArgFilename.

    (self allowedToSeeDirectory:file directory) ifFalse:[
        FTPServerException permissionDenied:file name.
    ].
    (self allowedToWriteIntoDirectory:file directory) ifFalse:[
        FTPServerException permissionDenied:file name.
    ].

    file exists ifFalse:[
        ^ socket nextPutLine:('550 %1: No such file or directory' bindWith:lastArgument)
    ].

    recursive ifFalse:[
        (file isDirectory and:[file directoryContents notEmpty]) ifTrue:[
            ^ socket nextPutLine:('550 %1: Directory not empty' bindWith:lastArgument)
        ]
    ].
    Transcript showCR:'FTPSession: attempted delete file or directory: %1 (not deleted)' with:file pathName.

    "/ FOR NOW: DO NEVER delete, but always report an error
    FTPServerException permissionDenied.
!

doLIST:longFormat
    |contents dir pattern outStream pipe|

    outStream := self checkAndGetDataConnection.

    lastArgument notNil ifTrue:[
        dir := self checkAndGetArgFilename.

        dir isDirectory ifTrue:[
            pattern := '*'.
        ] ifFalse:[
            pattern := dir baseName.
            dir := dir directory.   
        ].

        (self canChangeWorkingDirectory:dir) ifFalse:[
            FTPServerException permissionDenied:lastArgument.
        ].
    ] ifFalse:[
        dir := self checkAndGetCWD.
        pattern := '*'.
    ].

    (self allowedToSeeDirectory:dir) ifFalse:[
        FTPServerException permissionDenied:dir name.
    ].

    socket nextPutLine:'150 Opening ASCII mode data connection LIST.'.

    dir exists ifTrue:[
        outStream text; lineEndCRLF.
        
        (longFormat and:[OperatingSystem isUNIXlike]) ifTrue:[
            pipe := PipeStream readingFrom:'ls -l' inDirectory:dir.

            pipe notNil ifTrue:[
                Exception handle:[:ex|
                ] do:[
                    [pipe atEnd] whileFalse:[outStream nextPutLine:(pipe nextLine)]
                ].
                pipe close
            ]
        ].

        pipe isNil ifTrue:[
            contents := dir directoryContents.
            contents := contents select:[:fn | pattern match:fn].

            contents sort do:[:el|
                longFormat ifTrue:[
                    outStream nextPutLine:el.
                ] ifFalse:[
                    outStream nextPutLine:el.
                ]
            ]
        ]
    ].

    self closeDataConnection.
    socket nextPutLine:'226 Transfer complete.'.

    "Modified: / 13-02-2017 / 22:52:18 / cg"
    "Modified: / 11-04-2018 / 09:55:22 / stefan"
!

doMKD:newDirectory
    |pdir|

    (self allowedToWriteIntoDirectory:newDirectory directory) ifFalse:[
        FTPServerException permissionDenied:newDirectory name.
    ].

    newDirectory exists ifTrue:[
        socket nextPutLine:('550 %1: exists.' bindWith:lastArgument).
        ^ self
    ].

    pdir := newDirectory directory.
    pdir exists ifFalse:[
        socket nextPutLine:('550 %1: No such file or directory.' bindWith:lastArgument).
        ^ self.
    ].

    (pdir isWritable and:[pdir isExecutable]) ifFalse:[
        FTPServerException permissionDenied
    ].

    Transcript showCR:('FTPSession: MKD: ', newDirectory pathName).

    "/ FOR NOW: DO NEVER create directory, but always report an error
    FTPServerException permissionDenied.
!

doRETR:file onTo:outStream
    |inStream n line size|

    (self allowedToSeeDirectory:file directory) ifFalse:[
        FTPServerException permissionDenied:file name.
    ].

    file isDirectory ifTrue:[
        self closeDataConnection.
        socket nextPutLine:('550 %1: not a plain file' bindWith:lastArgument).
        ^ self
    ].

    (inStream := file readStream) isNil ifTrue:[
        self closeDataConnection.

        file exists ifFalse:[
            socket nextPutLine:('550 %1: No such file or directory' bindWith:lastArgument).
            ^ self.
        ].
        FTPServerException permissionDenied:lastArgument
    ].

    socket nextPutLine:('150 Opening %1 mode data connection for %2 (%3 bytes).' 
                        bindWith:(mode asUppercase) with:lastArgument with:file fileSize).

    self isBinary ifTrue:[
        inStream  binary.
        outStream binary.
        size := 4096.
        line := ByteArray new:size.

        [inStream atEnd] whileFalse:[
            n := inStream nextBytes:size into:line startingAt:1.
            outStream nextPutBytes:n from:line startingAt:1.
        ].
    ] ifFalse:[
        inStream  text.
        outStream text; lineEndCRLF.

        [inStream atEnd] whileFalse:[
            line := inStream nextLine.
            outStream nextPutLine:line.
        ].
    ].

    inStream close.
    self closeDataConnection.
    socket nextPutLine:'226 Transfer complete.'.

    "Modified: / 11-04-2018 / 09:55:28 / stefan"
!

doSTORE:unique
    |file exists outStream inStream n line size fn|

    inStream := self checkAndGetDataConnection.
    file     := self checkAndGetArgFilename.

    (self allowedToWriteIntoDirectory:file directory) ifFalse:[
        FTPServerException permissionDenied:file name.
    ].

    ((exists := file exists) and:[file isDirectory]) ifTrue:[
        FTPServerException raiseErrorString:('553 %1: not a plain file' bindWith:lastArgument)
    ].

    (exists and:[unique]) ifTrue:[
        fn := file withoutSuffix.
        n  := 0.

        [   n := n + 1.
            file := fn withSuffix:(n printString).
            file exists
        ] whileTrue
    ].    

    file exists ifTrue:[
        "/ FOR NOW: DO NEVER allow writing over an existing file
        FTPServerException permissionDenied:lastArgument
    ].

    outStream := file writeStream.

    outStream isNil ifTrue:[
        FTPServerException permissionDenied:lastArgument
    ].

    socket nextPutLine:('150 Opening %1 mode data connection for %2.' 
                        bindWith:(mode asUppercase) with:lastArgument).

    self isBinary ifTrue:[
        outStream binary.
        inStream  binary.
        size := 4096.
        line := ByteArray new:4096.

        [inStream atEnd] whileFalse:[
            n := inStream nextBytes:size into:line startingAt:1.
            outStream nextPutBytes:n from:line startingAt:1.
        ].
    ] ifFalse:[
        outStream text.
        inStream  text; lineEndCRLF.

        [inStream atEnd] whileFalse:[
            line := inStream nextLine.
            outStream nextPutLine:line.
        ].
    ].

    outStream close.
    self closeDataConnection.
    unique ifTrue:[
        socket nextPutLine:('226 Transfer complete (unique file name:%1).'
                                 bindWith:(file baseName)
                           )
    ] ifFalse:[
        socket nextPutLine:'226 Transfer complete.'.
    ]

    "Modified: / 13-02-2017 / 22:52:24 / cg"
    "Modified: / 11-04-2018 / 09:55:36 / stefan"
! !

!FTPSession methodsFor:'protocol operations'!

defaultDirectoryForUser:user
    ^ Filename homeDirectory asAbsoluteFilename.
! !

!FTPSession methodsFor:'protocol testing'!

canChangeWorkingDirectory:aDirectory
    ^ aDirectory exists and:[aDirectory isExecutable]
!

checkPassword:aPassword for:aUser
    ^ true
!

loginUserNeedsPassword:aUser
    "checks whether user exists and need a password;
        - if the user is not known by the system an exception is raised
    "
    aUser = 'dummy' ifTrue:[
        FTPServerException loginIncorrect
    ].
    ^ aUser = 'pwd'
! !

!FTPSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/FTPSession.st,v 1.14 2018-04-11 07:58:07 stefan Exp $'
! !

