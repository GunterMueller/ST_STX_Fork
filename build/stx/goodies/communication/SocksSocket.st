"{ Package: 'stx:goodies/communication' }"

"{ NameSpace: Smalltalk }"

Socket subclass:#SocksSocket
	instanceVariableNames:'vers method socksIP socksPort dstPort dstIP dstName'
	classVariableNames:'DefaultSocksVersion'
	poolDictionaries:''
	category:'Net-Communication-SOCKS'
!


!SocksSocket class methodsFor:'instance creation'!

new
    ^ super new 
        domain:#inet type:#stream; 
        socks5

    "Created: / 27-12-2011 / 14:47:10 / cg"
! !

!SocksSocket class methodsFor:'accessing'!

defaultSocksHostAddress
    ^ UserPreferences current socksProxyHost.
"/        ^NetNameResolver addressForName: HTTPSocket httpProxyServer

    "
     UserPreferences current socksProxyHost:'71.105.237.142'
     UserPreferences current socksProxyPort:35867.
    "

    "Modified (comment): / 27-12-2011 / 14:43:33 / cg"
!

defaultSocksPort
    ^ UserPreferences current socksProxyPort
"/         ^HTTPSocket httpProxyPort

    "Modified: / 27-12-2011 / 14:39:45 / cg"
!

defaultSocksVersion
    "nil means no socks"

    ^DefaultSocksVersion
!

defaultSocksVersion: anIntegerOrNIl
    "nil means no socks"
    
    DefaultSocksVersion := anIntegerOrNIl
! !

!SocksSocket class methodsFor:'methods'!

noAutorizationMethod
	^0
! !

!SocksSocket methodsFor:'connection open/close'!

connectTo: hostAddress port: port
        "/ self initializeNetwork.
        self shouldUseSocks
                ifFalse: [^super connectTo: hostAddress port: port].
        super connectTo: socksIP port: socksPort.
        self readWaitWithTimeout:Socket standardDeadline.
        "/ self waitForConnectionUntil: Socket standardDeadline.
        dstIP := hostAddress.
        dstPort := port.
        vers == 4
                ifTrue: [self connectSocks4]
                ifFalse: [self connectSocks5]

    "Modified: / 27-12-2011 / 14:54:44 / cg"
!

connectToHostNamed: hostName port: port
        super connectTo: socksIP port: socksPort.
        self readWaitWithTimeout:Socket standardDeadline.
        "/ self waitForConnectionUntil: Socket standardDeadline.
        dstName := hostName.
        dstPort := port.
        vers == 4
                ifTrue: [self connectSocks4]
                ifFalse: [self connectSocks5]

    "Modified: / 27-12-2011 / 14:49:47 / cg"
! !

!SocksSocket methodsFor:'initialize'!

socks4
    vers := 4.
    method := nil.
    socksIP := self class defaultSocksHostAddress.
    socksPort := self class defaultSocksPort

    "Modified (format): / 27-12-2011 / 14:38:38 / cg"
!

socks5
    vers := 5.
    method := self class noAutorizationMethod.
    socksIP := self class defaultSocksHostAddress.
    socksPort := self class defaultSocksPort

    "Modified (format): / 27-12-2011 / 14:38:45 / cg"
! !

!SocksSocket methodsFor:'private'!

connectCommandCode
	^1
!

defaultTimeOutDuration
	^20000
!

dstIP
	^dstIP
!

dstPort
	^dstPort
!

requestGrantedCode
	^90
!

shouldUseSocks
	^vers notNil
!

socksError: errorString
	self close; destroy.
	self error: errorString
!

waitForConnectionUntil:aMillisecondClockValue
    self readWaitWithTimeout:aMillisecondClockValue.

    "Created: / 27-12-2011 / 14:49:00 / cg"
!

waitForReply: replySize for: timeOutDuration
    | startTime response delay bytesRead |

    startTime := Time millisecondClockValue.
    response := ByteArray new: replySize.
    bytesRead := 0.
    delay := Delay forMilliseconds: 500.
    [
        bytesRead < replySize
        and: [(Time millisecondClockValue - startTime) < timeOutDuration]
    ] whileTrue: [
        bytesRead := bytesRead + (self nextAvailableBytes:(replySize-bytesRead) into:response startingAt:bytesRead "receiveDataInto: response").
        delay wait.
        Transcript show: '.'
    ].
    bytesRead < replySize ifTrue: [
        self close; destroy.
        ^ (ConnectionRefused host: self dstIP port: self dstPort) signal
    ].
    ^ response

    "Modified: / 27-12-2011 / 14:52:35 / cg"
! !

!SocksSocket methodsFor:'socks4'!

connectSocks4
	self
		sendSocks4ConnectionRequestUserId: '';
		waitForSocks4ConnectionReply.
!

sendSocks4ConnectionRequestUserId: userId
    "The client connects to the SOCKS server and sends a CONNECT request when
     it wants to establish a connection to an application server. The client
     includes in the request packet the IP address and the port number of the
     destination host, and userid, in the following format.

        +----+----+----+----+----+----+----+----+----+----+....+----+
        | VN | CD | DSTPORT |      DSTIP        | USERID       |NULL|
        +----+----+----+----+----+----+----+----+----+----+....+----+
           1    1      2              4           variable       1
    "

    | requestString |

    requestString := 
        ByteArray streamContents:[:s |
            dstIP isNil ifTrue: [
                dstIP := NetNameResolver addressForName: dstName
            ].
            s
                nextPut: 4;
                nextPut: self connectCommandCode;
                nextPutShort:dstPort MSB:true;
                nextPutAll: self dstIP;
                nextPutAll: userId asByteArray;
                nextPut: 0.
        ].        
    self sendData: requestString
!

waitForSocks4ConnectionReply
    | response |

    response := self waitForReply: 8 for: self defaultTimeOutDuration.
    (response at: 2) = self requestGrantedCode ifFalse: [
        ^ self socksError: ('Connection failed: %1' bindWith:(response at: 2))
    ].
! !

!SocksSocket methodsFor:'socks5'!

connectSocks5
	self
		socks5MethodSelection;
		sendSocks5ConnectionRequest;
		socks5RequestReply
!

hostIP6Code
	^4
!

hostIPCode
	^1
!

qualifiedHostNameCode
	^3
!

sendSocks5ConnectionRequest
    "Once the method-dependent subnegotiation has completed, the client
     sends the request details."

    | requestString |
    
    requestString := 
        ByteArray streamContents:[:s |
            s
                nextPut: 5;
                nextPut: self connectCommandCode;
                nextPut: 0. "Reserved slot"

            dstName isNil ifTrue: [
                s
                    nextPutAll: self hostIPCode;
                    nextPutAll: dstIP
            ] ifFalse: [
                s
                    nextPut: self qualifiedHostNameCode;
                    nextPut: dstName size;
                    nextPutAll: dstName asByteArray
            ].
            s nextPutShort:dstPort MSB:true.
        ].    
        
    self sendData: requestString
!

skipQualifiedHostName
    | startTime response bytesRead |

    startTime := Time millisecondClockValue.
    response := ByteArray new: 1.

    [
        (bytesRead := self receiveDataInto: response) < 1
        and: [ (Time millisecondClockValue - startTime) < self defaultTimeOutDuration]
    ] whileTrue.

    bytesRead < 1 ifTrue: [
        self socksError: 'Time out reading data'
    ].

    self waitForReply: (response at: 1) + 2 for: self defaultTimeOutDuration
!

socks5MethodSelection
    "The client connects to the server, and sends a version
     identifier/method selection message.
     The server selects from one of the methods given in METHODS, and
     sends a METHOD selection message."

    | requestString response |

"/        requestString := WriteStream on: ByteArray new.
"/        requestString
"/                nextPut: 5;
"/                nextPut: 1;
"/                nextPut: 0.
"/        self sendData: requestString contents.
    self sendData: #[5 1 0].

    response := self waitForReply: 2 for: self defaultTimeOutDuration.
    (response at: 2) == 16rFF ifTrue: [
        self socksError: 'No acceptable methods.'
    ] ifFalse: [
        method := response at: 2
    ]

    "Modified: / 27-12-2011 / 14:54:09 / cg"
!

socks5RequestReply
    | response responseCode|

    response := self waitForReply: 4 for: self defaultTimeOutDuration.
    "Skip rest for now."
    responseCode := (response at: 4).
    
    responseCode = self hostIPCode ifTrue: [
        self waitForReply: 6 for: self defaultTimeOutDuration
    ].
    responseCode = self qualifiedHostNameCode ifTrue: [
        self skipQualifiedHostName
    ].
    responseCode = self hostIP6Code ifTrue: [
        self waitForReply: 18 for: self defaultTimeOutDuration
    ].
    
    (response at: 2) ~= 0 ifTrue: [
        ^ self socksError:('Connection failed: %1' bindWith: (response at: 2))
    ].
! !

!SocksSocket class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/SocksSocket.st,v 1.2 2017-01-24 13:01:56 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/SocksSocket.st,v 1.2 2017-01-24 13:01:56 cg Exp $'
! !

