"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Object subclass:#AbstractTCPSession
	instanceVariableNames:'server sessionProcess socket'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication'
!


!AbstractTCPSession methodsFor:'accessing'!

server:aTCPServer
    server := aTCPServer.

    "Modified (format): / 18-02-2017 / 10:56:10 / cg"
! !

!AbstractTCPSession methodsFor:'debugging'!

log:aMessage
    server log:'[' , socket getPeerName , ']: ' , aMessage
! !

!AbstractTCPSession methodsFor:'serving'!

clientOn:aSocket
    "start and return a process for a new client"

    self subclassResponsibility.

    "/ redefine in concrete classes to something like:

    "/    aSocket isNil ifTrue:[^ nil].
    "/
    "/    sessionProcess := 
    "/        [
    "/            [ 
    "/                Exception handle:[:ex|
    "/                    (Object haltSignal handles:ex) ifTrue:[
    "/                        ex reject
    "/                    ].
    "/                    self log:('error caught: ' , ex description).
    "/                    "/ during debugging
    "/                    ex reject.
    "/                ] do:[
    "/                    self serveSocket:aSocket
    "/                ]
    "/            ] ensure:[
    "/                aSocket isOpen ifTrue:[
    "/                    aSocket shutDown
    "/                ].
    "/                self doReinitialize.
    "/                aSocket isOpen ifTrue:[
    "/                    aSocket close.
    "/                ]
    "/            ]
    "/        ] newProcess.
    "/
    "/    sessionProcess priority:(Processor userBackgroundPriority).
    "/    sessionProcess resume.
    "/    ^ sessionProcess

    "Created: / 18-02-2017 / 10:55:52 / cg"
!

serveSocket:aSocket
    self subclassResponsibility.

    "/ redefine in concrete classes to something like:
    "/
    "/ socket := aSocket.
    "/ [socket isOpen] whileTrue:[
    "/     self serveNextCommandFromSocket.
    "/ ].

    "Created: / 18-02-2017 / 10:54:10 / cg"
! !

!AbstractTCPSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/AbstractTCPSession.st,v 1.1 2017-02-18 09:57:54 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/AbstractTCPSession.st,v 1.1 2017-02-18 09:57:54 cg Exp $'
! !

