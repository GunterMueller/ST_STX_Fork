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

RPCEndPoint subclass:#RPCClient
	instanceVariableNames:'host programNumber versionNumber replyDataUnpacker'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-SunRPC'
!

!RPCClient class methodsFor:'documentation'!

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
    abstract superclass for RPC client programs.
    See PortMapperClient, MountClient or DemoClient for concrete examples.

    [author:]
        Claus Gittinger
"
!

examples
"
    Abstract - see DemoClient, MountClient, NFSClient and PortMapperClient for examples.
"
! !

!RPCClient class methodsFor:'instance creation'!

toHost:hostname
    ^ self new host:hostname
!

toHost:hostname port:portNr
    "use this port - instead of default"

    ^ self new host:hostname port:portNr
!

toHost:hostname protocol:prot port:portNr
    "use this protocol/port - instead of default"

    ^ self new host:hostname protocol:prot port:portNr
! !

!RPCClient class methodsFor:'queries'!

isRPCClientClass
    ^ true
! !

!RPCClient methodsFor:'calls'!

operation:opName
    "invoke the operation (without arg);
     decode the result and return it"

    ^ self operation:opName arguments:#()

    "Created: / 30.1.2002 / 15:25:28 / cg"
!

operation:opName argument:arg
    "encode arg as-per argType and invoke the operation;
     decode the result and return it"

    ^ self operation:opName arguments:(Array with:arg)

    "Created: / 30.1.2002 / 15:24:49 / cg"
!

operation:opName argument:arg1 argument:arg2
    "encode arg as-per argType and invoke the operation;
     decode the result and return it"

    ^ self operation:opName arguments:(Array with:arg1 with:arg2)

    "Created: / 30.1.2002 / 15:24:58 / cg"
!

operation:opName arguments:argArray
    "encode argArray as-per argType and invoke the operation;
     decode the result and return it.
     Returns the receiver for void types."

    |op data result opType argEncoder|

    op := self operations detect:[:op | op name = opName] ifNone:nil.
    op isNil ifTrue:[
        self error:'no such operation'
    ].

    op arguments size ~~ argArray size ifTrue:[
        self error:'argument mismatch'
    ].

    "/ encode arguments
    argArray size > 0 ifTrue:[
        argEncoder := XDRCoder new.

        op arguments with:argArray do:[:argType :argValue |
            argType encode:argValue on:argEncoder with:nil.
        ].
        data := argEncoder contents.
    ].
    "/ call
    result := self callOperation:opName withData:data.

    "/ decode result
    opType := op type.
    opType isXDRVoid ifTrue:[
        ^ self
    ].
    ^ opType decodeFrom:replyDataUnpacker.

    "Modified: / 30.1.2002 / 15:32:36 / cg"
! !

!RPCClient methodsFor:'calls - basic'!

callOperation:opName withData:encodedData
    "invoke the operation. The encodedData argument must be a byteArray
     containing the encoded XDR-data.
     Returns the replyHeader which contains the XDR encoded reply data"

    |op opNr callHeader packer bytes nWritten replyHeader fragLength 
     addr buffer nReceived atEnd|

    op := self operations detect:[:op | op name = opName] ifNone:nil.
    op isNil ifTrue:[
        self error:'no such operation'.
    ].
    opNr := op number.

    callHeader := RPCDefinitions rpcCallHeader new.
    callHeader
        xid:1234 
        prog:(self programNumber) 
        vers:(self programVersion) 
        proc:opNr 
        cred:nil 
        verf:nil.

    packer := XDRCoder new.
    packer packCallHeader:callHeader.
    bytes := packer contents.
    encodedData size > 0 ifTrue:[
        bytes := bytes , encodedData.
    ].

    connection type == #stream ifTrue:[
        "/ eat old leftover data
        [
            |n|
            n := connection nextAvailableBytes:100 into:(ByteArray new:100) startingAt:1.
            n > 0 ifTrue:[
                Transcript showCR:('eat ' , n printString , ' leftover bytes').
            ].
            n > 0 
        ] whileTrue.

        connection nextPutInt32:(16r80000000 + bytes size) MSB:true.
        nWritten := connection nextPutBytes:bytes size from:bytes startingAt:1.
    ] ifFalse:[
        addr := IPSocketAddress hostName:host port:portNumber.
Transcript showCR:'send to:' , host, ':' , portNumber printString.
RPCServer dumpBytes:bytes.

        nWritten := connection sendTo:addr buffer:bytes.
    ].

    nWritten ~~ bytes size ifTrue:[
        self error:'rpc write error'.
    ].

    "/ wait for reply

    connection type == #stream ifTrue:[
        atEnd := false.
        StreamError handle:[:ex |
            atEnd := true.
        ] do:[
            atEnd := connection atEnd
        ].
        atEnd ifTrue:[
            RPCError raiseErrorString:'rpc connection closed by peer'.
        ].

"/        connection atEnd ifTrue:[
"/            RPCError raiseErrorString:'rpc connection closed by peer'.
"/        ].

        fragLength := connection nextUnsignedInt32MSB:true.
        fragLength isNil ifTrue:[
            RPCError raiseErrorString:'rpc connection closed by peer'.
        ].
        bytes := connection nextBytes:(fragLength bitAnd:16r7FFFFFFF).
        [(fragLength bitAnd:16r80000000) == 0] whileTrue:[
            fragLength := connection nextUnsignedInt32MSB:true.
            bytes := bytes , (connection nextBytes:(fragLength bitAnd:16r7FFFFFFF)).
        ].
    ] ifFalse:[
        OperatingSystem isUNIXlike ifTrue:[
            connection readWait.
        ].
        buffer := ByteArray new:1024 * 32.    
        nReceived := connection receiveFrom:addr buffer:buffer start:1 for:(buffer size).
        nReceived <= 0 ifTrue:[
            RPCError raiseErrorString:'rpc error while receiving result'.
            ^ self
        ].
        bytes := buffer copyTo:nReceived.
Transcript showCR:'received from:' , addr hostName, ':' , addr port printString.
RPCServer dumpBytes:bytes.
    ].

    replyDataUnpacker := XDRCoder from:bytes.
    replyHeader := replyDataUnpacker unpackReplyHeader.
    ^ replyHeader

    "Modified: / 15.2.2002 / 15:31:20 / cg"
!

send:aCall
    |packer|

    packer := XDRCoder new.
    packer packCallHeader:aCall
! !

!RPCClient methodsFor:'operations'!

null
    self callOperation:#null withData:nil.

    "Modified: / 30.1.2002 / 15:30:20 / cg"
! !

!RPCClient methodsFor:'private'!

portNumberFromPortMapperForProgram:programNr version:vsnNr host:host protocol:protocol
    |mapper portNr|

    mapper := PortMapperClient toHost:host protocol:protocol port:nil.
    portNr := mapper getportForProgram:programNr version:vsnNr protocol:protocol.
    mapper close.
    ^ portNr

    "Created: / 30.1.2002 / 15:37:49 / cg"
!

protocolFromPortMapperForProgram:programNr version:vsnNr host:host
    |mapper portNr|

    RPCError handle:[:ex |
        Transcript showCR:'cannot ask portmapper; reason: ' , ex description.
        ^ nil.
    ] do:[
        mapper := PortMapperClient toHost:host.
    ].

    #( tcp udp ) do:[:triedProtocol |
        portNr := mapper getportForProgram:programNr version:vsnNr protocol:triedProtocol.
        (portNr notNil and:[portNr ~~ 0]) ifTrue:[
            mapper close.
            ^ triedProtocol
        ].
    ].
    mapper close.
    ^ nil

    "Created: / 30.1.2002 / 15:37:00 / cg"
    "Modified: / 31.1.2002 / 15:37:55 / cg"
! !

!RPCClient methodsFor:'queries'!

operationNames
    ^ self operations collect:[:op | op name]
!

operations
    ^ self version procedures
!

portNumber
    "return the portnumber to use.
     Can be set explicitly or else its acquired from the portMapper"

    portNumber isNil ifTrue:[
        portNumber := self 
            portNumberFromPortMapperForProgram:(self programNumber) 
            version:(self programVersion)
            host:host
            protocol:(self protocol).
    ].

    ^ portNumber

    "Modified: / 30.1.2002 / 16:15:16 / cg"
!

program
    ^ (self class definitions) detect:[:def | def isProgram] ifNone:nil.
!

programNumber
    programNumber isNil ifTrue:[
        programNumber := self program programNumber
    ].
    ^ programNumber

    "Modified: / 30.1.2002 / 16:24:55 / cg"
!

programVersion
    versionNumber isNil ifTrue:[
        versionNumber := self version versionNumber
    ].
    ^ versionNumber

    "Modified: / 30.1.2002 / 16:25:17 / cg"
!

protocol
    "return the protocol to use.
     Can be set explicitly or else its acquired from the portMapper.
     returns nil, if the remote portmapper cannot be reached"

    protocol isNil ifTrue:[
        protocol := self 
            protocolFromPortMapperForProgram:(self programNumber) 
            version:(self programVersion)
            host:host. 
    ].

    ^ protocol

    "Modified: / 15.2.2002 / 15:31:41 / cg"
!

version
    ^ self program versions first
! !

!RPCClient methodsFor:'setup'!

close
    |conn|

    (conn := connection) notNil ifTrue:[
        connection := nil.
        conn close.
    ]
!

host:hostname
    self host:hostname port:nil
!

host:hostname port:portNr
    self host:hostname protocol:nil port:portNr
!

host:hostname protocol:prot port:portNr
    host := hostname.
    portNumber := portNr.
    protocol := prot.
    self reconnect
!

hostName
    ^ host
!

programNumber:progNrArg
    programNumber := progNrArg.

    "Created: / 30.1.2002 / 16:27:59 / cg"
!

programNumber:progNrArg versionNumber:versNrArg
    programNumber := progNrArg.
    versionNumber := versNrArg.

    "Created: / 30.1.2002 / 16:25:58 / cg"
!

reconnect
    self close.

    protocol isNil ifTrue:[
        protocol := self protocol.
        protocol isNil ifTrue:[
            protocol := #udp
            "/ reasons are:
            "/   - no portmapper running on target host
            "/   - program/version not registered there
"/            RPCError raiseErrorString:'cannot connect (dont know which protocol to use)'
        ]
    ].

    portNumber isNil ifTrue:[
        portNumber := self portNumber.
        portNumber isNil ifTrue:[
            RPCError raiseErrorString:'Cannot figure out port (portMapper ?)'.
        ].
        portNumber == 0 ifTrue:[
            RPCError raiseErrorString:'Program not registered in remote portMapper'.
        ].
    ].

    protocol == #tcp ifTrue:[
        connection := Socket 
                        newTCPclientToHost:host 
                        port:(portNumber ? self portNumber) 
                        withTimeout:1000.

        connection isNil ifTrue:[
            RPCError raiseErrorString:(self class name,' cannot connect to host: ',host)
        ]
    ] ifFalse:[
        connection := Socket newUDP.  "/ anonymous
        connection isNil ifTrue:[
            RPCError raiseErrorString:(self class name,' cannot create socket')
        ]
    ].
    connection binary.

    "Created: / 06-07-2011 / 18:54:08 / cg"
! !

!RPCClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCClient.st,v 1.33 2017-11-18 09:55:47 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SunRPC_RPCClient.st,v 1.33 2017-11-18 09:55:47 cg Exp $'
! !

