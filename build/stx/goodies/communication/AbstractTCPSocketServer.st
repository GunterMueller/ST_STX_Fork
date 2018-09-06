"{ Encoding: utf8 }"

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

Object subclass:#AbstractTCPSocketServer
	instanceVariableNames:'serverProcess acceptorSocket portNumber sessionClass
		activeSessions singleConnectionOnly'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'* obsolete *'
!

!AbstractTCPSocketServer class methodsFor:'documentation'!

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
    common abstract superclass for TCP socket servers
    (like FTPServer and others).
    Only handles connection setup and session startup.
    Does not implement any concrete protocol - this must be done in the session instance.

    [author:]
        Claus Atzkern

    [see also:]
        FTPServer FTPSession

    [start with:]
        FTPServer start.

        FTPServer startOnPort:12345.

        (FTPServer forPort:12345)
            sessionClass:SmalltalkFTPSession;
            start
"
! !

!AbstractTCPSocketServer class methodsFor:'instance creation'!

defaultPort
    self subclassResponsibility.
!

forPort:aPort
    "return a server for the given port"

    ^ self basicNew port:aPort.

    "
     (FTPServer forPort:12387) start
    "
!

start
    "start a server on the default port (21).
     Notice: this is a priviledged port, not normally accessible to users."

    ^ self startOnPort:self defaultPort.

    "
     FTPServer start
    "
!

startOnPort:aPort
    "start a server on the given port"

    ^ self new servePort:aPort.

    "
     FTPServer startOnPort:12387
    "

    "Modified: / 14-02-2017 / 01:13:47 / cg"
! !

!AbstractTCPSocketServer class methodsFor:'queries'!

isAbstract
    "Return if this class is an abstract class.
     True is returned here for myself only; false for subclasses.
     Abstract subclasses must redefine this again."

    ^ self == AbstractTCPSocketServer.
! !

!AbstractTCPSocketServer methodsFor:'accessing'!

activeSessions
    ^ activeSessions

    "Created: / 12-10-2017 / 12:59:11 / cg"
!

defaultSessionClass
    self subclassResponsibility
!

port:aPortNumber
    portNumber := aPortNumber.
!

sessionClass
    sessionClass notNil ifTrue:[^ sessionClass ].
    ^ self defaultSessionClass
!

sessionClass:something
    sessionClass := something.
!

singleConnectionOnly
    ^ singleConnectionOnly
!

singleConnectionOnly:aBoolean
    singleConnectionOnly := aBoolean.

    "Modified (format): / 07-04-2017 / 15:09:41 / cg"
! !

!AbstractTCPSocketServer methodsFor:'debugging'!

log:aMessage
    Verbose == true ifTrue:[
        Transcript show:(Timestamp now); show:': '; showCR:aMessage
    ]
! !

!AbstractTCPSocketServer methodsFor:'initialization'!

initialize
    singleConnectionOnly := singleConnectionOnly ? false.

    "Created: / 07-04-2017 / 15:06:37 / cg"
! !

!AbstractTCPSocketServer methodsFor:'queries'!

isServing
    ^ serverProcess notNil 
    and:[ serverProcess isDead not
    and:[ acceptorSocket notNil
    and:[ acceptorSocket isOpen ]]]

    "Created: / 20-03-2017 / 14:53:50 / cg"
! !

!AbstractTCPSocketServer methodsFor:'serving'!

servePort:aPort
    "start a TCP-Server on a port
    "

    self port:aPort.
    self start.
!

start
    "start a TCP-Server"

    acceptorSocket := Socket newTCPserverAtPort:portNumber.
    acceptorSocket isNil ifTrue:[
        self error:'cannot create socket on port: ' , portNumber printString.
    ].

    (acceptorSocket listenFor:2) ifFalse:[
        acceptorSocket shutDown.
        self error:'listen failed on port: ' , portNumber printString.
    ].

    serverProcess := [ 
                        [   
                            self serverLoop
                        ] ensure:[
                            acceptorSocket notNil ifTrue:[
                                acceptorSocket shutDown.
                                acceptorSocket := nil.
                            ].
                        ].
                     ] newProcess.

    serverProcess priority:(Processor userSchedulingPriority).
    serverProcess name:(self class name,' [<1p>]' expandMacrosWith:portNumber).
    serverProcess resume.

    "Modified: / 18-02-2017 / 10:44:07 / cg"
!

stop
    "start a TCP-Server"

    |"s" p|

    "/ done by terminating server...    
    "/    (s := acceptorSocket) notNil ifTrue:[
    "/        acceptorSocket := nil.
    "/        s close.
    "/    ].
    (p := serverProcess) notNil ifTrue:[
        serverProcess := nil.
        p terminate
    ].

    "Created: / 18-02-2017 / 10:18:11 / cg"
    "Modified: / 20-03-2017 / 12:48:50 / cg"
! !

!AbstractTCPSocketServer methodsFor:'serving-private'!

addToActiveSessions:aSession
    activeSessions isNil ifTrue:[
        activeSessions := SharedCollection for:(OrderedCollection new).
    ].
    activeSessions add:aSession

    "Created: / 18-02-2017 / 10:49:39 / cg"
!

removeFromActiveSessions:aSession
    activeSessions isNil ifTrue:[^ self].
    activeSessions remove:aSession ifAbsent:[]

    "Created: / 18-02-2017 / 10:50:07 / cg"
!

serverLoop
    |session clientProcess connection peerName|

    [
        [acceptorSocket notNil] whileTrue:[
            Error handle:[:ex|
                ex description infoPrintCR.
                (acceptorSocket notNil and:[acceptorSocket isOpen not]) ifTrue:[
                    acceptorSocket := nil
                ].    
            ] do:[
                self log:'Waiting for a connection'.
                acceptorSocket readWait.
                self log:'Accepting'.
                connection := acceptorSocket accept.
                peerName := connection getPeerName.
                self log:'connection from ' , peerName.
                (singleConnectionOnly and:[activeSessions size > 0]) ifTrue:[
                    connection close.
                ] ifFalse:[    
                    session := (self sessionClass) new.
                    session server:self.
                    self addToActiveSessions:session.
                    clientProcess := session clientOn:connection.
                    clientProcess notNil ifTrue:[
                        clientProcess name:(session class name,' [%1:%2]' bindWith:peerName with:portNumber).
                    ]
                ]
            ]
        ]
    ] ensure:[
        |s|

        (s := acceptorSocket) notNil ifTrue:[
            acceptorSocket := nil.
            s close
        ].
    ].

    "Modified: / 07-04-2017 / 15:08:40 / cg"
! !

!AbstractTCPSocketServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/AbstractTCPSocketServer.st,v 1.12 2018-01-19 22:28:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/AbstractTCPSocketServer.st,v 1.12 2018-01-19 22:28:17 cg Exp $'
! !

