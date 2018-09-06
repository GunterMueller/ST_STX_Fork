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

AbstractTCPSocketServer subclass:#FTPServer
	instanceVariableNames:''
	classVariableNames:'LastServer Verbose'
	poolDictionaries:''
	category:'Net-Communication-FTP'
!

!FTPServer class methodsFor:'documentation'!

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
    an FTP server - subclass to add/change its functionality.

    the server's functionality is limited (by purpose)
    - see the comment in FTPSession

    [author:]
        Claus Atzkern

    [start with:]
        FTPServer start.

        FTPServer startOnPort:12345.

        (FTPServer forPort:12345)
            sessionClass:SmalltalkFTPSession;
            start
"
! !

!FTPServer class methodsFor:'instance creation'!

defaultPort
    "return the default port nr (21).
     Notice: this is a priviledged port, not normally accessible to users."

    ^ (Socket portOfService:'ftp').
! !

!FTPServer class methodsFor:'debugging'!

verbose:aBoolean
    Verbose := aBoolean

    "
     self verbose:true
     self verbose:false
    "
! !

!FTPServer class methodsFor:'obsolete'!

onPort:aPort
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #startOnPort:'.
    ^ self startOnPort:aPort.

    "
     FTPServer onPort:12387
    "
! !

!FTPServer class methodsFor:'tests'!

testClose
    |server|

    (server := LastServer) notNil ifTrue:[
        LastServer := nil.

        Exception handle:[:ex|]do:[
            server terminateWithAllSubprocesses.
            server waitUntilTerminated.
        ].
    ].
    ^ LastServer
!

testOpen
    |port|

    port := 12345.

    LastServer isNil ifTrue:[
        LastServer := FTPServer onPort:port.
        LastServer addExitAction:[
            Transcript showCR:'close server'.
            LastServer := nil
        ]
    ].
    Transcript showCR:('running on port: ', port printString).
    Transcript showCR:('ftp command: ftp data ', port printString).
    ^ LastServer
! !

!FTPServer methodsFor:'accessing'!

defaultSessionClass
    ^ FTPSession
! !

!FTPServer methodsFor:'debugging'!

log:aMessage
    Verbose == true ifTrue:[
        Transcript show:(Timestamp now); show:': '; showCR:aMessage
    ]
! !

!FTPServer methodsFor:'obsolete'!

onPort:aPort
    <resource: #obsolete>
    "obsolete (backward compatible) entry
    "

    self obsoleteMethodWarning:'use servePort:'.
    self servePort:aPort.
! !

!FTPServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/FTPServer.st,v 1.20 2017-01-27 23:08:51 cg Exp $'
! !

