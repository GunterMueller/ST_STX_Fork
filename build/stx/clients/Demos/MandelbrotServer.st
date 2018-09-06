"{ NameSpace: Demos }"

Object subclass:#MandelbrotServer
	instanceVariableNames:'socket myPortNumber connectProcess'
	classVariableNames:'BadHosts OkHosts'
	poolDictionaries:''
	category:'demos-Graphics'
!


!MandelbrotServer class methodsFor:'class initialization'!

initialize
    "Initialize class variables."

    BadHosts := Set new.
    OkHosts := Set new.

    "
     MandelbrotServer initialize.
    "

    "Created: / 15.7.1998 / 16:49:03 / cg"
! !

!MandelbrotServer class methodsFor:'defaults'!

algorithmClass
    "the processor"

    ^ MandelbrotAlgorithm

    "Created: / 15.7.1998 / 18:03:51 / cg"
!

defaultPortNumber
    "the port we are listening on (by default)."

    ^ 8005

    "Created: / 15.7.1998 / 16:46:36 / cg"
! !

!MandelbrotServer class methodsFor:'hosts management'!

allowHost:aHostname
    "allow a host"

    OkHosts add: aHostname.
    BadHosts remove:aHostname ifAbsent:[].

    "
     MandelbrotServer allowHost:'localhost'
     MandelbrotServer allowHost:'193.12.12.0'
     MandelbrotServer allowHost:'fooHost'
    "

    "Modified: / 20.5.1998 / 18:34:49 / cg"
    "Created: / 15.7.1998 / 16:49:29 / cg"
!

denyHost:aHostname
    "disallow a host"

    BadHosts add: aHostname.
    OkHosts remove:aHostname ifAbsent:[].


    "
     MandelbrotServer denyHost:'untrustedHost'
    "

    "Modified: / 20.5.1998 / 18:34:55 / cg"
    "Created: / 15.7.1998 / 16:49:42 / cg"
! !

!MandelbrotServer class methodsFor:'server destruction'!

killAll
    "Destroy all instances of the server. (overkill)"

    self allInstances do: [:a | a release].
    self allInstances do: [:a | a becomeNil].

    ^nil

    "
     MandelbrotServer killAll.
    "

    "Modified: / 20.5.1998 / 18:23:29 / cg"
    "Created: / 15.7.1998 / 16:45:24 / cg"
! !

!MandelbrotServer class methodsFor:'startup'!

start
    "Start a mandel server on the default port."

    ^ self new startServer

    "
     MandelbrotServer start.
    "

    "Created: / 15.7.1998 / 16:42:09 / cg"
!

startAt: aPortNumber 
    "Start an rdoit server on a specified port."

    ^ self new startServerAt: aPortNumber

    "
     MandelbrotServer startAt:9000.
    "

    "Created: / 15.7.1998 / 16:46:58 / cg"
! !

!MandelbrotServer methodsFor:'constants'!

handlePriority
    "The priority a handler process should run at."

    ^ Processor systemBackgroundPriority

    "Modified: / 15.7.1998 / 16:41:17 / cg"
!

serverPriority
    "The priority the server process should run at."

    ^ Processor lowIOPriority

    "Created: / 15.7.1998 / 16:38:45 / cg"
! !

!MandelbrotServer methodsFor:'handle clients'!

handleClient:aSocket 
    "This method is forked off when a new connection arrives.
     It checks the host (allow/deny), possibly asking via a Dialog,
     then calls #handleOKClient: to do the real work."

    | hostName ok|

    hostName := aSocket getPeerName.
    hostName = '127.0.0.1' ifTrue:[
        hostName := 'localhost'
    ].

    Processor activeProcess name:'mandel (from: ' , hostName , ')'.

    ok := false. 
    (BadHosts includes: hostName) ifFalse:[ 
        (OkHosts includes: hostName) ifTrue: [
            ok := true.
        ] ifFalse: [
            (self confirmNewHost:hostName) ifTrue: [
                ok := true
            ]
        ]
    ].

    ok ifTrue:[
        [(self handleOkClient: aSocket) ~~ #Error] whileTrue.
        aSocket close.
    ] ifFalse:[
        'MandelServer: Denied rdoit attempt from: ' infoPrint. 
        hostName infoPrintCR.
        aSocket shutDown
    ].

    "Created: / 15.7.1998 / 16:48:28 / cg"
    "Modified: / 15.7.1998 / 17:52:50 / cg"
!

handleOkClient:aSocket 
    "Called when a good client request arrives;
     Read the socket through cr, for the command, and then doit.
     If the first character of the command is a ?-character, strip it off
     and send the printString of the result back for rdoit to print it."

    | request value msgString returnResult|

    "/claus:
    "/ if command starts with a ?-character, send return value
    "/ back as printString.
    "/
    aSocket readWait.

    "/ use an ascii interface - easier to debug ...
    request := aSocket nextLine.
    request isNil ifTrue:[
        "maybe socket has been closed"
        'MandelServer [warning]: connection with no command' errorPrintNL.
        ^ #Error.
    ].

"/    Logging == true ifTrue:[
        ('MandelServer [info]: request from ' , aSocket getPeerName , ':') infoPrintCR.
        ('MandelServer [info]: --> ' , request) infoPrintCR.
"/    ].

    "/ claus:
    "/  I catch all errors - and send some diagnostics to stderr instead
    "/
    SignalSet anySignal handle:[:ex |
        'MandelServer [warning]: error during rdoit evaluation:' errorPrintNL.
        ('MandelServer [warning]: *** ' , ex errorString) errorPrintNL.
        value := #Error.
        msgString := '-' , ex errorString.
        ex return
    ] do:[
        value := self handleRequest:request.
        msgString := '+' , value storeString.
    ].

"/    Logging == true ifTrue:[
        ('MandelServer [info]: return to ' , aSocket getPeerName , ':') infoPrintCR.
        ('MandelServer [info]: <-- "' , msgString , '"') infoPrintCR.
"/    ].

    aSocket nextPutAll:msgString.
    aSocket cr.
    aSocket flush.

    ^ value

    "Modified: / 11.1.1998 / 15:28:55 / stefan"
    "Created: / 15.7.1998 / 16:53:32 / cg"
    "Modified: / 15.7.1998 / 17:27:04 / cg"
!

handleRequest:requestString 
    "Called when a request from a good client request arrives;
     Execute it and return some value (its printString is sent back)"

    algorithm := self class algorithmClass new.

    ^ Compiler evaluate:('self ' , requestString) receiver:algorithm

    "Modified: / 15.7.1998 / 18:03:34 / cg"
! !

!MandelbrotServer methodsFor:'hosts management'!

confirmNewHost: hostName 
    "A previously unauthorized host is trying to connect.
     Ask the user if we can authorize this new host."

    | answer |

    answer := DialogView confirm: ('Mandelbrot service ok for host ' , 
                                   hostName printString , 
                                   '?') 
                         "initialAnswer: true".
    answer 
        ifTrue: [OkHosts add: hostName]
        ifFalse: [BadHosts add: hostName].
    ^ answer

    "Modified: / 20.5.1998 / 18:35:05 / cg"
    "Created: / 15.7.1998 / 17:09:01 / cg"
! !

!MandelbrotServer methodsFor:'private'!

portNumber
    "Return my port number."
    "Default == 8005 (totally arbitrary)."

    myPortNumber isNil ifTrue: [^ self class defaultPortNumber].
    ^myPortNumber

    "Modified: / 15.7.1998 / 16:36:01 / cg"
    "Created: / 15.7.1998 / 16:46:18 / cg"
! !

!MandelbrotServer methodsFor:'release'!

release
"claus:ORIGINAL
    (socket isKindOf: UnixSocketAccessor) ifTrue: [socket close].
"
    'MandelServer [info]: shutting down.' infoPrintCR.

    socket notNil ifTrue: [socket shutDown. "close"].
    socket := nil.
    super release.

    connectProcess notNil ifTrue:[
        connectProcess terminateGroup.
        connectProcess := nil
    ]

    "Modified: / 20.5.1998 / 18:10:35 / cg"
    "Created: / 15.7.1998 / 16:44:41 / cg"
! !

!MandelbrotServer methodsFor:'startup'!

loopForever
    "Create and listen to my socket. When a connection arrives,
     I fork another subprocess, to handle the request (in #handleClient:).

     Note: Someone else has already forked me, so I run as a subprocess
           and can block."

    |thisSocket|

    thisSocket := Socket newTCPserverAtPort: self portNumber.
    thisSocket isNil ifTrue: [
        'MandelServer [warning]: socket creation failed (port:' errorPrint. 
        self portNumber errorPrint. ')' errorPrintCR.
        ^ nil
    ].

    socket := thisSocket.
    thisSocket listenFor: 5.

    [
        |stayInLoop|

        stayInLoop := true.
        [socket == thisSocket and:[stayInLoop]] whileTrue:[
            "/ don't move newskt out of the block,
            "/ it is local for each thread!!
            |newskt clientProcess|

            newskt := socket accept.
            newskt notNil ifTrue: [
                "/
                "/ 'got a connection ...' printNL.
                "/
                "/ newskt buffered:true.
                newskt buffered:false.
                clientProcess := [
                                    self handleClient: newskt
                                 ] forkAt:self handlePriority. 
                clientProcess name:'mandel execution'.
            ] ifFalse:[
                stayInLoop := false.
                'MandelServer [warning]: socket accept failed' errorPrintCR.
            ].
        ].
    ] valueNowOrOnUnwindDo:[
        thisSocket notNil ifTrue: [thisSocket shutDown "close"].
        self release.
    ].
    ^ nil

    "Modified: / 15.7.1997 / 12:20:04 / stefan"
    "Created: / 15.7.1998 / 16:40:43 / cg"
    "Modified: / 15.7.1998 / 17:17:34 / cg"
!

startConnectProcess
    "start a connect process"

    connectProcess := [
                        self loopForever
                      ] forkAt: self serverPriority.
    connectProcess beGroupLeader.
    connectProcess name:'mandelbrot server (port: ' , self portNumber printString , ')'.

    'MandelServer [info]: started.' infoPrintCR.

    "Modified: / 15.7.1998 / 16:38:54 / cg"
    "Created: / 15.7.1998 / 16:43:25 / cg"
!

startServer
    "This is only run by SERVER instances at startup."

    ObjectMemory addDependent: self.
    self startConnectProcess.
    ^self

    "Modified: / 15.7.1998 / 16:42:47 / cg"
!

startServerAt: aPortNumber 
    "This is only run by SERVER instances at startup."

    myPortNumber := aPortNumber.
    ^ self startServer

    "Created: / 15.7.1998 / 16:47:17 / cg"
!

update:aSymbol 
    "Dependents of ObjectMemory are sent update: 
     #returnFromSnapshot when a snapshot is started."

    aSymbol == #returnFromSnapshot ifTrue: [self startConnectProcess].
    super update: aSymbol.
    ^self

    "Created: / 15.7.1998 / 16:43:57 / cg"
    "Modified: / 15.7.1998 / 16:44:08 / cg"
! !

!MandelbrotServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/MandelbrotServer.st,v 1.1 1998-07-15 19:26:44 cg Exp $'
! !
MandelbrotServer initialize!
