"{ Package: 'stx:goodies/communication/thrift' }"

Object subclass:#TClient
	instanceVariableNames:'iprot oprot seqid remoteSeqid'
	classVariableNames:''
	poolDictionaries:''
	category:'Net-Communication-Thrift-Misc'
!

!TClient class methodsFor:'documentation'!

documentation
"
    original from pharo/squeak.

    heavily fixed (framedTransport) and adjusted for ST/X.
    left original code in 'isSmalltalkX not' code fragments for reference,
    but it is not guaranteed to be backward compatible with squeak.
"
! !

!TClient class methodsFor:'instance creation'!

binaryOnHost: hostString port: portInteger
    "connect to host:port and return a client which uses the binary protocol on a framed transport"

    ^ self
        onHost: hostString port: portInteger
        protocol: TBinaryProtocol
        transport: TFramedTransport
!

compactBinaryOnHost: hostString port: portInteger
    "connect to host:port and return a client which uses the compact binary protocol on a framed transport"

    ^ self
        onHost: hostString port: portInteger
        protocol: TCompactProtocol
        transport: TFramedTransport
!

onHost: hostString port: portInteger protocol:protocolClass transport:transportClass
    "connect to host:port and return a client which uses the given protocol and transport"

    | sock transport |

    Smalltalk isSmalltalkX ifTrue:[
        sock := Socket newTCPclientToHost:hostString port:portInteger withTimeout:180*1000.
        sock isNil ifTrue:[
            TTransportError signal: 'Could not connect to ', hostString
        ].
        sock binary.
        " 
          sock buffered:true. 
          sock := LoggingStream on:sock logger:Transcript.
        "
    ] ifFalse:[
        "Squeak"
        sock := (self socketStream openConnectionToHost:
                    (NetNameResolver addressForName: hostString) port: portInteger)
                        timeout: 180;
                        binary;
                        yourself
    ].

    transport := transportClass new socket:sock.
    ^ self new
            inProtocol: (protocolClass new transport: transport);
            yourself
! !

!TClient class methodsFor:'class factories'!

socketStream
    "for squeak only"

    ^ Smalltalk at: #FastSocketStream ifAbsent: [SocketStream] 
! !

!TClient methodsFor:'initialization & release'!

close
    iprot close.
    iprot := oprot := nil.
!

inProtocol: aProtocol
	iprot := aProtocol.
	oprot ifNil: [oprot := aProtocol]
!

outProtocol: aProtocol
	oprot := aProtocol
! !

!TClient methodsFor:'misc'!

nextSeqid
	^ seqid
		ifNil: [seqid := 0]
		ifNotNil: [seqid := seqid + 1]
!

validateRemoteMessage: aMsg
	remoteSeqid
		ifNil: [remoteSeqid := aMsg seqid]
		ifNotNil:
			[(remoteSeqid + 1) = aMsg seqid ifFalse:
				[TProtocolError signal: 'Bad seqid: ', aMsg seqid asString,
							'; wanted: ', remoteSeqid asString].
			remoteSeqid := aMsg seqid]
! !

!TClient class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TClient.st,v 1.4 2013-03-25 01:08:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/thrift/TClient.st,v 1.4 2013-03-25 01:08:52 cg Exp $'
! !

