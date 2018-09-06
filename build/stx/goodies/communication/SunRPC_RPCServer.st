"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 2002 by eXept Software AG
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: SunRPC }"

RPCEndPoint subclass:#RPCServer
	instanceVariableNames:'connectProcess lastClientProcess lastClientProcessWakeup
		requestHeader requestHost'
	classVariableNames:'Logging ErrorLogging TraceOp Verbose BadHosts OkHosts'
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

RPCServer class instanceVariableNames:'ServersRunning'

"
 The following class instance variables are inherited by this class:

	SunRPC::RPCEndPoint - Definitions
	Object - 
"
!

!RPCServer class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    abstract superclass for RPC server programs.
    See MountServer, NFSServer and DemoServer for concrete examples.

    [author:]
        Claus Gittinger
"
!

examples
"
    Abstract - see DemoServer, MountServer and NFSServer for examples.
"
! !

!RPCServer class methodsFor:'initialization'!

initialize
    "Initialize class variables."

    ServersRunning := nil.
    Definitions := nil.

    BadHosts := Set new.
    OkHosts := Set with:'localhost'.

    Verbose := false.
    Logging := false.
    ErrorLogging := true.

    "
     SunRPC::RPCServer initialize.
    "
!

killAll
    self allInstances do:[:s | s release].
    self allInstances do:[:s | s becomeNil].
!

killAllRPCServers
    self allSubInstances do:[:s | s release].
    self allSubInstances do:[:s | s becomeNil].

    self withAllSubclassesDo:[:eachClass |
	eachClass initialize.
    ].

    "
     self killAllRPCServers
    "
!

serverRunning
    self allInstances do:[:s | ^ true].
    ^ false

    "
     SmalltalkShareServer serverRunning
     RPCServer serverRunning
    "
! !

!RPCServer class methodsFor:'accessing'!

addToServersRunning:aServer
    ServersRunning isNil ifTrue:[
	ServersRunning := IdentitySet new
    ].
    ServersRunning add:aServer.
!

removeFromServersRunning:aServer
    ServersRunning notNil ifTrue:[
	ServersRunning remove:aServer ifAbsent:nil.
	ServersRunning isEmpty ifTrue:[
	    ServersRunning := nil
	]
    ].
!

serversRunning
    ^ ServersRunning
! !

!RPCServer class methodsFor:'debugging'!

debug:aBoolean
    self verbose:aBoolean.
    self logging:aBoolean.
    self traceOp:aBoolean.

    "
     self debug:true
     self debug:false
    "

    "Created: / 31.1.2002 / 14:07:10 / cg"
!

dumpBytes:aByteArray
    |offs lineBuffer1 lineBuffer2|

    offs := 0.

    1 to:aByteArray size do:[:idx |
	|byte|

	offs \\ 16 == 0 ifTrue:[
	    idx ~~ 1 ifTrue:[
		Transcript
		    nextPutAll:(lineBuffer1 contents);
		    nextPutAll:' | ';
		    nextPutAll:(lineBuffer2 contents);
		    nextPutLine:' |'.
	    ].
	    lineBuffer1 := '' writeStream.
	    lineBuffer2 := '' writeStream.
	    lineBuffer1 show:(offs hexPrintString leftPaddedTo:3 with:$0).
	    lineBuffer1 show:':'.
	].
	byte := (aByteArray at:idx).
	lineBuffer1 space.
	lineBuffer1 show:(byte hexPrintString leftPaddedTo:2 with:$0).

	((byte >= 16r20) and:[byte < 16r7F]) ifTrue:[
	    lineBuffer2 nextPut:(Character value:byte)
	] ifFalse:[
	    lineBuffer2 space.
	].
	offs := offs + 1.
    ].

    offs ~~ 0 ifTrue:[
	offs \\ 16 ~~ 0 ifTrue:[
	    (16 - (offs \\ 16)) timesRepeat:[
		lineBuffer1 spaces:3.
		lineBuffer2 space.
	    ].
	].
	Transcript
	    nextPutAll:(lineBuffer1 contents);
	    nextPutAll:' | ';
	    nextPutAll:(lineBuffer2 contents);
	    nextPutLine:' |'.
    ]

    "
     self dumpBytes:#[]
     self dumpBytes:#[ 0 1 2 ]
     self dumpBytes:#[ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 ]
     self dumpBytes:#[ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 ]
     self dumpBytes:#[ 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ]
     self dumpBytes:#[ 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 ]
     self dumpBytes:#[ 40 41 42 43 44 45 46 47 48 49 50 51 52 53 54 55 56 ]
    "
!

logging:aBoolean
    Logging := aBoolean

    "
     self logging:true
     self logging:false
    "

    "Created: / 31.1.2002 / 13:45:58 / cg"
!

traceOp:aBoolean
    TraceOp := aBoolean

    "
     self traceOp:true
     self traceOp:false
    "

    "Created: / 31.1.2002 / 13:46:13 / cg"
!

verbose:aBoolean
    Verbose := aBoolean

    "
     self verbose:true
     self verbose:false
    "

    "Created: / 31.1.2002 / 13:46:25 / cg"
! !

!RPCServer class methodsFor:'queries'!

isRPCServerClass
    ^ true
! !

!RPCServer class methodsFor:'startup'!

isStartableWithMain
    "return true, if this is an application class,
     which can be started via #main / #main:"

    ^ self ~~ RPCServer
!

main
    "Start a server"

    self start
!

start
    "Start a server"

    ^ self new startServer
!

startServerIfNotYetRunningAtPort:portNr protocol:protocol
    self serversRunning size == 0 ifTrue:[
	self new
	    portNumber:portNr;
	    protocol:protocol;
	    startServer
    ].

    "Created: / 1.2.2002 / 13:25:40 / cg"
!

startUDP
    "Start a server"

    ^ (self new protocol:#udp) startServer

    "
     MountServer startUDP
     NFSServer startUDP
    "
! !

!RPCServer methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == ObjectMemory ifTrue:[
	something == #aboutToQuit ifTrue:[
	    "/ system is shutting down - unregister from portMapper
	    RPCError handle:[:ex |
	    ] do:[
		self unregisterInPortMapper.
	    ]
	]
    ]
! !

!RPCServer methodsFor:'handle client'!

checkHost:hostName
    ^ self checkHost:hostName askUser:true
!

checkHost:hostName askUser:askUser
    |ok|

    ok := false.
    (BadHosts includes: hostName) ifFalse:[
	(OkHosts includes: hostName) ifTrue: [
	    ok := true.
	] ifFalse: [
	    askUser ifFalse:[^ false].

	    (self confirmNewHost:hostName) ifTrue: [
		ok := true
	    ]
	]
    ].

    ok ifFalse:[
	ErrorLogging ifTrue:[
	    'RPCServer: Denied rpc attempt from: ' infoPrint .
	    hostName infoPrintCR
	].
    ].
    ^ ok
!

confirmNewHost: hostName
    "A previously unauthorized host is trying to connect.
     Ask the user if we can authorize this new host."

    | answer |

    answer := DialogView confirm: ('RPC (%1) ok from host %2 ?'
				    bindWith:(self class name)
				    with:hostName printString)
			 "initialAnswer: true".
    answer
	ifTrue: [OkHosts add: hostName]
	ifFalse: [BadHosts add: hostName].
    ^ answer
!

executeRequest:bytes
    |requestDataUnpacker replyDataPacker resultPacker resultBytes
     opNr op opName result reply failure acceptStatus|

    requestDataUnpacker := XDRCoder from:bytes.
    requestHeader := requestDataUnpacker unpackCallHeader.

    requestHeader prog ~~ self programNumber ifTrue:[
	"/ NFS has a bug here: even if registered with a different
	"/ portNr in portmapper and /et/fstab, the incoming requests
	"/ will have the 100003 hardwired ...
	Verbose == true ifTrue:[
	    Transcript showCR:'warning: bad program nr: ' , requestHeader prog printString , ' (expected: ' , self programNumber printString , ')'.
	].
"/        self error:'bad program nr'.
"/        "/ TODO: send a NOPROG reply.
    ].
    requestHeader vers ~~ self programVersion ifTrue:[
	Verbose == true ifTrue:[
	    Transcript showCR:'bad version nr'.
	].
"/        self error:'bad version nr'.
"/        "/ TODO: send a NOPROG reply.
    ].

    opNr := requestHeader proc.
    op := self operations detect:[:op | op number == opNr] ifNone:nil.
    op isNil ifTrue:[
	self error:'no such operation'.
	"/ TODO: send a NOPROC reply.
    ].
    opName := op name.

    failure := false.
    RPCOperationError handle:[:ex |
	failure := true.
	acceptStatus := ex status.
    ] do:[
	|opArgs decodedArgs|

	opArgs := op arguments.
	opArgs size > 0 ifTrue:[
	    decodedArgs := OrderedCollection new.
	    opArgs do:[:eachArgType |
		|argValue|

		argValue := eachArgType decodeFrom:requestDataUnpacker.
		decodedArgs add:argValue.
	    ]
	].
	result := self performOperation:opName withArguments:decodedArgs.
    ].

    resultPacker := XDRCoder new.
    failure ifTrue:[
	acceptStatus isInteger ifFalse:[
	    acceptStatus := (OperatingSystem errorNumberFor:acceptStatus)
	].
	result := Dictionary new.
	result at:'status' put:acceptStatus.
    ].

    op type encode:result on:resultPacker with:nil.
    resultBytes := resultPacker contents.

    Verbose == true ifTrue:[
	Transcript showCR:'>>>>> resultBytes: '.
	RPCServer dumpBytes:resultBytes.
    ].

    reply := RPCDefinitions::RPCReplyHeader new.
    reply xid:(requestHeader xid) verf:(requestHeader verf).
    reply replyStatus:#MSG_ACCEPTED.
    reply replyData:resultBytes.
    reply acceptStatus:#SUCCESS.

    replyDataPacker := XDRCoder new.
    replyDataPacker packReplyHeader:reply.

    ^ replyDataPacker contents

    "Modified: / 1.2.2002 / 11:53:01 / cg"
!

handleClient:aSocket
    "This method is invoked when a new connection arrives (tcp),
     or a packet was received (udp).
     It checks the host (allow/deny), possibly asking via a Dialog,
     then calls #handle*Client: to do the real work."

    |hostName peer|

    protocol == #udp ifTrue:[
	AbortOperationRequest handle:[:ex |
	] do:[
	    RPCError handle:[:ex |
		Transcript showCR:ex description.
	    ] do:[
		self handleDatagramClient:aSocket
	    ]
	].
	^ self
    ].

    peer := aSocket getPeer.
    hostName := peer hostAddressString.
    (self checkHost:hostName askUser:false) ifFalse:[
	peer isLocal ifTrue:[
	    hostName := 'localhost'
	] ifFalse:[
	    HostAddressLookupError handle:[:ex |
	    ] do:[
		hostName := peer hostName.
	    ].
	].
	(self checkHost:hostName) ifFalse:[
	    aSocket shutDown.
	    ^ self.
	].
    ].

    requestHost := hostName.
    [
	(AbortOperationRequest, StreamError) handle:[:ex |
	    (ErrorLogging and:[ex creator ~~ EndOfStreamError]) ifTrue:[
		'RPCServer: socket error: ' infoPrint. ex description infoPrintCR.
	    ].
	    aSocket shutDown.
	] do:[
	    aSocket signalAtEnd:true.
	    [
		self handleStreamClient:aSocket.
		aSocket clearEOF.
	    ] loop.
	].
    ] ensure:[
	aSocket close.
    ]

    "Modified: / 1.2.2002 / 16:13:04 / cg"
!

handleDatagramClient:aSocket
    "Called when a request arrives via udp;
     Read the request, check for host being allowed and execute."

    |addr buffer n messageData replyData nWritten|

    OperatingSystem isUNIXlike ifTrue:[
        connection readWait.
    ].

    addr := IPSocketAddress new.
    addr port:portNumber.

    buffer := ByteArray new:1024 * 32.
    n := aSocket receiveFrom:addr buffer:buffer start:1 for:(buffer size).
    n <= 0 ifTrue:[
        self breakPoint:#cg.
        ^ self
    ].
    Verbose == true ifTrue:[
        Transcript show:'request from: '; showCR:addr.
    ].
"/    hostName := addr hostName.
"/    hostName = '127.0.0.1' ifTrue:[
"/        hostName := 'localhost'
"/    ].
"/
"/    requestHost := hostName.
"/    "/ Processor activeProcess name:(self class name , ' (from: ' , hostName , ')').
"/    (self checkHost:hostName) ifFalse:[
"/        self halt.
"/        ^ self.
"/    ].

    messageData := buffer copyTo:n.

    Verbose == true ifTrue:[
        Transcript showCR:'<<<<< received (from ' , addr printString , '): '.
        RPCServer dumpBytes:messageData.
    ].

    Logging == true ifTrue:[
        (self class name , ' [info]: request from ' , addr printString , ':') infoPrintCR.
        (self class name , ' [info]: --> ' , (messageData copyTo:20) printString) infoPrintCR.
    ].

    replyData := self executeRequest:messageData.

    Verbose == true ifTrue:[
        Transcript showCR:'>>>>> send (to ' , addr printString , '): '.
        RPCServer dumpBytes:replyData.
    ].

    nWritten := aSocket sendTo:addr buffer:replyData.
    nWritten ~~ replyData size ifTrue:[
        self halt:'write error'.
    ].

    "Modified: / 1.2.2002 / 12:53:55 / cg"
!

handleStreamClient:aSocket
    "Called when a good client request arrives via tcp;
     Read the request and execute."

    |messageData replyData count nWritten|

    aSocket binary.
    messageData := self readStreamDataFrom:aSocket.

    Logging == true ifTrue:[
        (self class name , ' [info]: request from ' , aSocket getPeerName , ':') infoPrintCR.
        (self class name , ' [info]: --> ' , (messageData copyTo:20) printString) infoPrintCR.
    ].

    replyData := self executeRequest:messageData.

    count := replyData size.
    aSocket nextPutInt32:(16r80000000 bitOr:count) MSB:true.
    nWritten := aSocket nextPutBytes:count from:replyData startingAt:1.
    nWritten ~~ count ifTrue:[
        self halt:'write error'.
    ].

    "Modified: / 1.2.2002 / 14:57:22 / cg"
!

loopForever
    "Create and listen to my socket. When a connection arrives,
     to handle the request (in #handleClient:)."

    |thisSocket|

    Logging == true ifTrue:[
        (self class name , ' [info]: RCPServer started with:') infoPrintCR.
    ].

    portNumber notNil ifTrue:[
        [
            protocol == #udp ifTrue:[
                thisSocket := Socket newUDPserverAtPort:portNumber.
            ] ifFalse:[
                thisSocket := Socket newTCPserverAtPort:portNumber.
            ]
        ] on:OpenError do:[:ex| ].
    ] ifFalse:[
        self portNumbers doWithExit:[:eachPortNumber :exit |
            [
                protocol == #udp ifTrue:[
                    thisSocket := Socket newUDPserverAtPort:eachPortNumber.
                ] ifFalse:[
                    thisSocket := Socket newTCPserverAtPort:eachPortNumber.
                ].
                thisSocket notNil ifTrue:[
                    portNumber := eachPortNumber.
                    exit value:nil
                ]
            ] on:OpenError do:[:ex| ].
        ].
    ].

    thisSocket isNil ifTrue: [
        Transcript show:self class name.
        Transcript show:' [warning]: socket creation failed (ports:'.
        Transcript show:(portNumber ? self portNumbers).
        Transcript showCR:')'.

        (Logging or:[ErrorLogging]) ifTrue:[
            (self class name , ' [warning]: socket creation failed (port:') errorPrint.
            (portNumber ? self portNumbers) errorPrint. ')' errorPrintCR.
            Dialog warn:('socket creation failed (port %1)' bindWith:(portNumber ? self portNumbers)).
        ].
        ^ nil
    ].

    Transcript show:self class name.
    Transcript show:' [info]: started on '.
    Transcript show:protocol.
    Transcript show:' port '.
    Transcript showCR:self portNumber.
    Processor activeProcess name:(self class name , ' server (port: ' , portNumber printString , ')').

    connection := thisSocket.

    protocol ~~ #udp ifTrue:[
        connection listenFor: 5.
    ].

    [
        |stayInLoop|

        self class addToServersRunning:self.
        RPCError handle:[:ex |
            Transcript show:'error caught while registering in portMapper: '.
            Transcript showCR:ex description.
        ] do:[
            self registerInPortMapper.
        ].

        stayInLoop := true.
        [connection == thisSocket and:[stayInLoop]] whileTrue:[
            |newskt|

            protocol == #udp ifTrue:[
                self handleClient:connection.
            ] ifFalse:[
                newskt := connection accept.
                newskt isNil ifTrue:[
                    ErrorLogging ifTrue:[
                        'RPCServer [warning]: socket accept failed' errorPrintCR.
                    ].
                    stayInLoop := false.
                ] ifFalse:[
                    newskt buffered:false.
                    self handleClient:newskt.
                ]
            ].
        ].
    ] ensure:[
        Transcript show:self class name.
        Transcript show:' [info]: finished on '.
        Transcript show:protocol.
        Transcript show:' port '.
        Transcript showCR:self portNumber.

        self class removeFromServersRunning:self.
        RPCError handle:[:ex |
            Transcript show:'error caught while unregistering from portMapper: '.
            Transcript showCR:ex description.
        ] do:[
            self unregisterInPortMapper.
        ].
        thisSocket notNil ifTrue: [thisSocket shutDown "close"].
        self release.
    ].
    ^ nil

    "Modified: / 15.7.1997 / 12:20:04 / stefan"
    "Modified: / 4.2.2002 / 16:55:30 / cg"
!

performOperation:opName withArguments:argVector
    |result|

    TraceOp == true ifTrue:[
	Transcript show:self class name; show:': '; show:(opName allBold).
	Transcript show:' args: '; showCR:argVector.
    ].

    argVector isNil ifTrue:[
	result := self perform:opName asSymbol.
    ] ifFalse:[
	result := self perform:(opName , ':') asSymbol with:argVector.
    ].

    TraceOp == true ifTrue:[
	Transcript show:'ret: '; showCR:result.
    ].

    ^ result.
!

readStreamDataFrom:aSocket
    "Read the request-data from a stream socket."

    |messageData w count fragment nRead|

    messageData := #[].
    [true] whileTrue:[
        OperatingSystem isUNIXlike ifTrue:[
            aSocket readWait.
        ].
"/        aSocket atEnd ifTrue:[^ nil].

        w := aSocket nextUnsignedInt32MSB:true.
        count := w bitAnd:16r7FFFFFFF.
        fragment := ByteArray new:count.
        nRead := aSocket nextBytes:count into:fragment startingAt:1.
        nRead ~~ count ifTrue:[
            self halt:'read error'.
        ].
        messageData := messageData , fragment.
        (w bitAnd:16r80000000) ~~ 0 ifTrue:[
            "/ last fragment
            ^ messageData
        ].
    ]
! !

!RPCServer methodsFor:'initialization'!

initialize
    super initialize.

    protocol := #tcp.
    RPCOperationError autoload.
! !

!RPCServer methodsFor:'operations'!

null
    "ignored - void"
! !

!RPCServer methodsFor:'queries'!

handlePriority
    ^ Processor userSchedulingPriority
!

isRunning
    ^ connectProcess notNil

    "Created: / 12-11-2006 / 19:21:35 / cg"
!

operationNames
    ^ self operations collect:[:op | op name]
!

operations
    ^ self version procedures
!

portNumbers
    self subclassResponsibility
!

program
    ^ (self class definitions) detect:[:def | def isProgram] ifNone:nil.
!

programNumber
    ^ self program programNumber
!

programVersion
    ^ self version versionNumber
!

protocol
    self subclassResponsibility
!

version
    ^ self program versions first
! !

!RPCServer methodsFor:'shutdown'!

release
    (self class name , ' [info]: shutting down.') infoPrintCR.

    connection notNil ifTrue: [connection shutDown. "close"].
    connection := nil.

    super release.

    connectProcess notNil ifTrue:[
	connectProcess isDead ifFalse:[ connectProcess terminateGroup ].
	connectProcess := nil
    ]

    "Modified: / 4.2.2002 / 15:22:35 / cg"
! !

!RPCServer methodsFor:'startup'!

registerInPortMapper
    |mapper ok|

    Transcript showCR:'registerInPortMapper...'.

    RPCError handle:[:ex |
	"/ start a local mapper then
	Transcript showCR:'starting my own portMapper...'.
	SunRPC::PortMapperServer
		    startServerIfNotYetRunningAtPort:111
		    protocol:#tcp.

	mapper := SunRPC::PortMapperClient toHost:'localhost'.
    ] do:[
	mapper := SunRPC::PortMapperClient toHost:'localhost'.
    ].

    ok := mapper
	    setProgram:(self programNumber)
	    version:(self programVersion)
	    protocol:protocol
	    port:portNumber.
    ok ifTrue:[
	ObjectMemory addDependent:self.
    ] ifFalse:[
	Transcript show:self class name ; showCR:' failed to register (or reregistered) in portMapper'.
"/        self error:'failed to register in portMapper' mayProceed:true.
    ].
    mapper close.

    "Modified: / 10-11-2006 / 16:22:23 / cg"
!

restart
    self startConnectProcess.
!

serverPriority
    ^ Processor userSchedulingPriority
!

startConnectProcess
    "Called when snapshot is started, and at instance creation."

    connectProcess := [
			  self loopForever.
			  connectProcess := nil.
		      ] newProcess.
    connectProcess priority:self serverPriority.
    connectProcess beGroupLeader.
    connectProcess name:(self class name , ' server').
    connectProcess resume.
!

startServer
    "This is only run by SERVER instances at startup."

    ObjectMemory addDependent: self.

    self startConnectProcess.
!

unregisterInPortMapper
    |mapper|

    mapper := SunRPC::PortMapperClient toHost:'localhost'.
    (mapper
	unsetProgram:(self programNumber)
	version:(self programVersion)
	protocol:protocol
    ) ifFalse:[
	mapper close.
	RPCError raiseErrorString:'failed to unregister from portMapper'.
    ].
    mapper close.
    ObjectMemory removeDependent:self.

    "Modified: / 1.2.2002 / 13:59:39 / cg"
! !

!RPCServer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCServer.st,v 1.49 2018-01-19 22:53:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCServer.st,v 1.49 2018-01-19 22:53:08 cg Exp $'
! !


RPCServer initialize!
