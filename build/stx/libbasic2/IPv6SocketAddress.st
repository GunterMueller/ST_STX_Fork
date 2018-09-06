"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

IPSocketAddress variableByteSubclass:#IPv6SocketAddress
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'OS-Sockets'
!

!IPv6SocketAddress class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
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
    Instances of IPv6SocketAddress represent v6 IP socket addresses.
    These consist of a 16byte hostId and a port number.

    Contains
        2 byte domain AF_INET6  
        2 byte port
        4 byte flowInfo
        16 byte address
        4 byte scope

    [author:]
        Claus Gittinger (cg@exept)

    [see also:]

    [instance variables:]

    [class variables:]
"
! !

!IPv6SocketAddress class methodsFor:'addressing'!

anyAddress
    "return the anonymous addresses bytes"

    ^ #[0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 0]
!

broadcastAddress
    "return the addresses bytes of a broadcast address
     (this is the all-nodes link-local address ff02::1.
     Broadcast is not normally used in IPv6"

    ^ #[16rff 16r02 0 0  0 0 0 0  0 0 0 0  0 0 0 16r01]
!

local
    "return the addresses bytes addressing the local host"

    ^ #[0 0 0 0  0 0 0 0  0 0 0 0  0 0 0 1]
! !

!IPv6SocketAddress class methodsFor:'conversion'!

hostAddressFromString:aString 
    "convert an address given in a dot notation like 1:2:3:4:5:6:7:8 or ::1 or even ::"
    
    |components words bytes prevWord bytesToGenerate i|

    components := aString asCollectionOfSubstringsSeparatedBy:$:.
    components size > 8 ifTrue:[
        ^ NameLookupError raiseRequestWith:aString
            errorString:' - bad address string'.
    ].
    "allow addresses formated like: '[2001:4dd0:ffa3::1]'"
    components first first = $[ ifTrue:[
        components at:1 put:(components first copyFrom:2).
        components last last = $] ifTrue:[
            components at:components size put:(components last copyButLast:1).
        ].
    ].
    (components last occurrencesOf:$.) == 3 ifTrue:[
        "IPV4 address embedded"
        bytes := IPSocketAddress hostAddressFromString:components removeLast.
        components add:(((bytes at:1) bitShift:8) bitOr:(bytes at:2)).
        components add:(((bytes at:3) bitShift:8) bitOr:(bytes at:4)) .
    ].
    words := components 
                collect:[:eachComponent | 
                    eachComponent size == 0 ifTrue:[
                        eachComponent isInteger ifTrue:[eachComponent] ifFalse:[nil].
                    ] ifFalse:[
                        Integer 
                            readFromString:eachComponent
                            radix:16
                            onError:[
                                ^ NameLookupError raiseRequestWith:aString
                                    errorString:' - bad address string'
                            ].
                    ].
                ].

    bytes := ByteArray new:16.
    bytesToGenerate := 2 * (8 - words size).
    i := 1.
    words do:[:eachWord|
        eachWord isNil ifTrue:[
            i ~~ 1 ifTrue:[
                i := i + bytesToGenerate.
                bytesToGenerate := 0.
            ].
        ] ifFalse:[
            bytes at:i put:(eachWord digitByteAt:2).
            bytes at:i+1 put:(eachWord digitByteAt:1).
        ].
        i := i + 2.
        prevWord := eachWord.
    ].

    ^ bytes.

    "
        IPv6SocketAddress hostAddressFromString:'::'
        IPv6SocketAddress hostAddressFromString:'::1'
        IPv6SocketAddress hostAddressFromString:':1:2'
        IPv6SocketAddress hostAddressFromString:'1::2'
        IPv6SocketAddress hostAddressFromString:'1:2:3:4:5:6:7:8'
        IPv6SocketAddress hostAddressFromString:'1234:5678:9abc:def1:2345:6789:abcd:ef12'
        IPv6SocketAddress hostAddressFromString:'a:b:c:d:e:f:7:8'
        IPv6SocketAddress hostAddressFromString:'1::2:3:4'
        IPv6SocketAddress hostAddressFromString:'1:2:3::4'
        IPv6SocketAddress hostAddressFromString:'[1:2:3::4]'
        IPv6SocketAddress hostAddressFromString:'::1.2.3.4'
    "
! !

!IPv6SocketAddress class methodsFor:'queries'!

domain
    ^ #'AF_INET6'
!

hostAddressLen
    "answer the number of bytes of the host address"

    ^ 16
!

obsoleteDomainSymbol
    ^ #inet6
!

vwDomainSymbol
    ^ #afInet6
! !

!IPv6SocketAddress methodsFor:'accessing'!

flowInfo
"/    struct sockaddr_in6 {
"/  0           unsigned short int      sin6_family;    /* AF_INET6 */
"/  2           __u16                   sin6_port;      /* Transport layer port # */
"/  4           __u32                   sin6_flowinfo;  /* IPv6 flow information */
"/  8           struct in6_addr         sin6_addr;      /* IPv6 address */
"/ 24            __u32                   sin6_scope_id;  /* scope id (new in RFC2553) */
"/ 28   };
    ^ self unsignedInt32At:4+1 MSB:false.
!

hostAddress
"/    struct sockaddr_in6 {
"/  0           unsigned short int      sin6_family;    /* AF_INET6 */
"/  2           __u16                   sin6_port;      /* Transport layer port # */
"/  4           __u32                   sin6_flowinfo;  /* IPv6 flow information */
"/  8           struct in6_addr         sin6_addr;      /* IPv6 address */
"/ 24            __u32                   sin6_scope_id;  /* scope id (new in RFC2553) */
"/ 28   };
    ^ (ByteArray new:16) replaceFrom:1 to:16 with:self startingAt:9
!

hostAddress:aByteArray
    ^ self replaceFrom:9 to:9+16-1 with:aByteArray startingAt:1
!

scopeId
"/    struct sockaddr_in6 {
"/  0           unsigned short int      sin6_family;    /* AF_INET6 */
"/  2           __u16                   sin6_port;      /* Transport layer port # */
"/  4           __u32                   sin6_flowinfo;  /* IPv6 flow information */
"/  8           struct in6_addr         sin6_addr;      /* IPv6 address */
"/ 24            __u32                   sin6_scope_id;  /* scope id (new in RFC2553) */
"/ 28   };
    ^ self unsignedInt32At:24+1 MSB:false.
! !

!IPv6SocketAddress methodsFor:'comparing'!

sameHostAddress:aSocketAddress
    "answer true, if myself and aSocketAddress have the same host address
     (but possibly different ports)."

"/    struct sockaddr_in6 {
"/  0           unsigned short int      sin6_family;    /* AF_INET6 */
"/  2           __u16                   sin6_port;      /* Transport layer port # */
"/  4           __u32                   sin6_flowinfo;  /* IPv6 flow information */
"/  8           struct in6_addr         sin6_addr;      /* IPv6 address */
"/ 24            __u32                   sin6_scope_id;  /* scope id (new in RFC2553) */
"/ 28   };

    ^ aSocketAddress class == self class 
        and:[self sameContentsFrom:9 to:25 as:aSocketAddress startingAt:9]
! !

!IPv6SocketAddress methodsFor:'converting'!

asIPv4SocketAddress
    "convert a IPv4 addresse mapped to IPv6 into real IPv4 IPSocketAddress"

    self isMappedIPv4 ifFalse:[
        ConversionError raiseErrorString:'Trying to convert a non-mappable IPv6 address'.
    ].

    ^ IPSocketAddress hostAddress:(self copyFrom:21 to:24) port:self port.

    "
        (self addressString:'0:0:0:0:0:ffff::') asIPv4SocketAddress
        (IPSocketAddress localHost port:80) asIPv6SocketAddress asIPv4SocketAddress
    "
!

asIPv4SocketAddressIfPossible
    "try to convert to an IPv4 socket address (works when a IPv6 adreess is a mapped IPv4 address). 
     Answer myself, if the conversion is not possible."

    self isMappedIPv4 ifFalse:[
        ^ self.
    ].

    ^ IPSocketAddress hostAddress:(self copyFrom:21 to:24) port:self port.

    "
        (self addressString:'0:0:0:0:0:ffff::') asIPv4SocketAddressIfPossible
        (IPSocketAddress localHost port:80) asIPv6SocketAddress asIPv4SocketAddressIfPossible
    "
!

asIPv6SocketAddress
    ^ self
! !

!IPv6SocketAddress methodsFor:'printing & storing'!

printAddressOn:aStream
    |i1 i2 colons|

    colons := 0.
    i1 := self adrBytesStart.
    i2 := i1 + self numAdrBytes - 1.
    i1 to:i2 by:2 do:[:i | 
        |word|

        word := self unsignedInt16At:i MSB:true.
        word == 0 ifTrue:[
            (colons <= 1 and:[i ~~ (i2-1)]) ifTrue:[
                colons := colons + 1.
                aStream nextPut:$:
            ]
        ] ifFalse:[
            word printOn:aStream base:16.
            i ~~ (i2-1) ifTrue:[
                aStream nextPut:$:.
                colons >= 2 ifTrue:[
                    colons := -20.       "no more $: may be omitted"
                ] ifFalse:[
                    colons positive ifTrue:[colons := 1].
                ]
            ].
        ].
    ].

    "
       String streamContents:[:s | self localHost printAddressOn:s]
       String streamContents:[:s |(self hostAddress:#[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]) printAddressOn:s]
       String streamContents:[:s |(self hostAddress:#[1 2 3 4 5 6 7 8 0 0 0 0 0 0 0 0]) printAddressOn:s]
       String streamContents:[:s |(self hostAddress:#[0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8]) printAddressOn:s]
       String streamContents:[:s |(self hostAddress:#[0 0 0 0 1 2 3 4 5 6 7 8 0 0 0 0]) printAddressOn:s]
       String streamContents:[:s |(self hostAddress:#[16r1a 16r1b 0 0 0 0 0 0  0 0 0 0 0 0 0 0]) printAddressOn:s]
    "
! !

!IPv6SocketAddress methodsFor:'private'!

adrBytesStart
    ^ 9
!

numAdrBytes
    ^ 16
! !

!IPv6SocketAddress methodsFor:'queries'!

networkAddress
    <resource: #obsolete>
    ^ self shouldNotImplement
!

networkClass
    "IPV6 doesn't know about network classes"
    <resource: #obsolete>

    ^ self shouldNotImplement
! !

!IPv6SocketAddress methodsFor:'testing'!

isBroadcast
    "answer true, if this is a broadcast address:
        all node-local nodes: ff01::1
        all link-local nodes: ff02::1"

    ^ (self at:9) == 16rff 
        and:[((self at:10) bitAnd:16r03) ~~ 0
        and:[self sameContentsFrom:11 to:24 as:#[0 0 0 0 0 0 0 0 0 0 0 0 0 1] startingAt:1]]

    "
        (self addressString:'ff01::1') isBroadcast
        (self addressString:'ff02::1') isBroadcast
        (self addressString:'ff01::55') isBroadcast
    "
!

isGlobalUnicast
    "answer true, if this address is a global unicast address 
     in the range 2000::/3"

    ^ (self at:9) between:16r20 and:16r3f
!

isIPv6SocketAddress
    ^ true
!

isLinkLocalUnicast
    "answer true, if this address is a link local unicast address fe80::/10"

    ^ (self at:9) == 16rfe and:[((self at:10) bitAnd:16rc0) == 16r80]
!

isLocal
    "answer true, if this address addresses a peer on the same host: ::1/128"

    ^ (self at:9) == 0 and:[self hostAddress = self class local]

    "
        self localHost isLocal
    "
!

isMappedIPv4
    "answer true, if this is a mapped IPv4 address"

    ^ (self at:9) == 0 
        and:[self sameContentsFrom:9 to:20 as:#[0 0 0 0 0 0 0 0 0 0 16rff 16rff] startingAt:1]

    "
        (self addressString:'0:0:0:0:0:ffff::') isMappedIPv4
    "
!

isMulticast
    "answer true, if this address is a multicast address ff::/8"

    ^ (self at:9) == 16rff 
!

isUniqueLocalUnicast
    "answer true, if this address is a unique local unicast (e.g. private) address 
     in the range fc::/8 or fd::/8"

    ^ (self at:9) == 16rfc or:[(self at:9) == 16rfd]
! !

!IPv6SocketAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

