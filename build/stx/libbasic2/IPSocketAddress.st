"
 COPYRIGHT (c) 1995 by Claus Gittinger
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

SocketAddress variableByteSubclass:#IPSocketAddress
	instanceVariableNames:''
	classVariableNames:'CacheInvalidationTimeInterval AddressCacheSize NameCacheSize'
	poolDictionaries:''
	category:'OS-Sockets'
!

IPSocketAddress class instanceVariableNames:'addrCache nameCache'

"
 No other class instance variables are inherited by this class.
"
!

!IPSocketAddress class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Instances of IPSocketAddress represent tcp/ip-domain socket addresses.
    These consist of an ip address (4 bytes) and a port number.

    Notice that for performance, name and address translations are cached here
    for some time, in order to speed up heavy lookup such as when operating a webserver or similar
    application which does many address-to-hostname translations.

    For systems, when the name translation is fast (unix), you may want to disable it,
    as it prevents new addresses to be detected for some time (for example, if the own address
    changes due to a new dhcp address being acquired).
    You can also change the cacheing-interval time 
    (see caching protocol, flush*Cache, cachingIntervalTime, *CacheSize).

    [author:]
        Claus Gittinger
"
! !

!IPSocketAddress class methodsFor:'instance creation'!

addressString:aString
    "convert an address given in a dot notation like 123.456.78.9.
     handle IPv6SocketAddresses too."

    (self == IPSocketAddress and:[aString includesAny:'[:']) ifTrue:[
        ^ IPv6SocketAddress hostAddress:(IPv6SocketAddress hostAddressFromString:aString).
    ].
    ^ self hostAddress:(self hostAddressFromString:aString).

    "
     IPSocketAddress addressString:'1.2.3.4'
     IPSocketAddress addressString:'2001:4dd0:ffa3::1'
     IPSocketAddress addressString:'[2001:4dd0:ffa3::1]'
    "
!

allForHostName:name serviceName:portNrOrName type:socketTypeSymbol
    "get a collection of new instance given a hostname, port or service and type.
     Multi-homed hosts return more than one entry
     Redefined to cache the result of the name-lookup."

    |addressList|

    portNrOrName isString ifTrue:[
        ^ super allForHostName:name serviceName:portNrOrName type:socketTypeSymbol
    ].

    addressList := self addressCacheAt:name.
    addressList notNil ifTrue:[
        addressList := addressList 
                            collect:[:eachSocketAddress| |sa|
                                sa := eachSocketAddress copy.
                                sa port:(portNrOrName ? 0).
                                sa
                            ].
    ] ifFalse:[
        addressList := super allForHostName:name serviceName:portNrOrName type:socketTypeSymbol.
        addressList notNil ifTrue:[
            self addressCacheAt:name put:(addressList deepCopy).
        ].
    ].
    ^ addressList

    "
     IPSocketAddress allForHostName:nil serviceName:10 type:#stream  
     SocketAddress allForHostName:'localhost' serviceName:10 type:#stream  
     IPSocketAddress allForHostName:'localhost' serviceName:'echo' type:#datagram 
     IPSocketAddress allForHostName:'www.google.com' serviceName:80 type:nil      
     
     IPSocketAddress allForHostName:'localhost' serviceName:'echo' type:#datagram 
     IPv6SocketAddress allForHostName:'localhost' serviceName:'echo' type:#datagram 
    "

    "Modified: / 17-06-2009 / 15:21:00 / sr"
!

localHost
    "get a new instance representing the local-host address as seen internally"

    ^ self hostAddress:self local

    "
     self localHost
     self localHost hostName
    "

    "Modified: / 04-06-2007 / 21:34:22 / cg"
!

localHostAddress
    "NO NO NEVER!!
     Do not use this, because:
     1. It does not work on hosts that get their IP address via dhcp (at least on unix/linux)
     2. Usually OperatingSystem>>#getHostName does not return a fully qualified domain name
     3. This does not work well on multi-homed hosts"

    <resource: #obsolete>

    self obsoleteMethodWarning:'Do not use this method'.
    ^ self hostName:(OperatingSystem getHostName).

    "
      self localHostAddress
    "


    "Modified: / 04-06-2007 / 21:17:25 / cg"
! !

!IPSocketAddress class methodsFor:'addressing'!

anyAddress
    "return the anonymous addresses bytes"

    ^ #[0 0 0 0]
!

anyPort
    "return the anon port number"

    ^ 0
!

broadcastAddress
    "return the broadcast address"

    ^ #[255 255 255 255]
!

firstUnreservedPort
    "return the first unreserved port number"

    ^ 1024
!

local
    "return IN_ADDR_ANY, the address matching any local address"

    ^ #[127 0 0 1]
!

maxPort
    "return the maximum port number"

    ^ 16rffff
!

thisHost
    <resource: #obsolete>
    "return the bytes of IN_ADDR_ANY, the address matching any local address"

    self obsoleteMethodWarning.
    ^ self anyAddress
! !

!IPSocketAddress class methodsFor:'caching'!

addressCacheAt:aHostName
    |addrAndTime addressList time|

    addrCache notNil ifTrue:[
        addrAndTime := addrCache at:aHostName ifAbsent:nil.
        addrAndTime notNil ifTrue:[
            addressList := addrAndTime key.
            time := addrAndTime value.
            ((Timestamp now) secondDeltaFrom:time) > self cacheInvalidationTimeInterval ifFalse:[
                ^ addressList.
            ]
        ].
    ].
    ^ nil

    "Modified: / 26-04-2007 / 11:21:37 / cg"
!

addressCacheAt:aName put:anAddressList
    (addrCache isNil or:[addrCache size > self addressCacheSize]) ifTrue:[
        addrCache := Dictionary new.
    ].
    
    addrCache at:aName put:(anAddressList -> Timestamp now).

    "Modified: / 26-04-2007 / 11:23:26 / cg"
!

addressCacheSize
    ^ AddressCacheSize ? 50

    "Created: / 26-04-2007 / 11:22:40 / cg"
!

addressCacheSize:aNumber
    AddressCacheSize := aNumber

    "Created: / 26-04-2007 / 11:24:05 / cg"
!

cacheInvalidationTimeInterval
    ^ CacheInvalidationTimeInterval ? 30

    "Created: / 26-04-2007 / 11:21:31 / cg"
!

cacheInvalidationTimeInterval:seconds
    CacheInvalidationTimeInterval := seconds

    "Created: / 26-04-2007 / 11:29:28 / cg"
!

flushAddressCache
    addrCache := nil

    "
     self flushAddressCache
    "
!

flushNameCache
    nameCache := Dictionary new.

    "
     self flushNameCache
    "

    "Modified: / 26-04-2007 / 11:25:32 / cg"
!

nameCacheAt:aHostAddress
    |nameAndTime name time|

    nameCache notNil ifTrue:[
        nameAndTime := nameCache at:aHostAddress ifAbsent:nil.
        nameAndTime notNil ifTrue:[
            name := nameAndTime key.
            time := nameAndTime value.
            (Timestamp now secondDeltaFrom:time) > self cacheInvalidationTimeInterval ifFalse:[
                ^ name.
            ]
        ].
    ].
    ^ nil

    "Modified: / 26-04-2007 / 11:25:11 / cg"
!

nameCacheAt:aHostAddress put:aName
    (nameCache isNil or:[nameCache size > self nameCacheSize]) ifTrue:[
        nameCache := Dictionary new.
    ].
    
    nameCache at:aHostAddress put:(aName -> Timestamp now).

    "Modified: / 26-04-2007 / 11:23:35 / cg"
!

nameCacheSize
    ^ NameCacheSize ? 50

    "Created: / 26-04-2007 / 11:22:44 / cg"
!

nameCacheSize:aNumber
    NameCacheSize := aNumber

    "Created: / 26-04-2007 / 11:23:49 / cg"
! !

!IPSocketAddress class methodsFor:'conversion'!

hostAddressFromString:aString
    "convert an address given in a dot notation like 123.456.78.9"

    |components bytes|

    components := aString asCollectionOfSubstringsSeparatedBy:$..
    components size ~~ 4 ifTrue:[
        ^ NameLookupError raiseRequestWith:aString errorString:' - bad address string'.
    ].

    bytes := components collect:[:eachComponent| 
        Integer readFromString:eachComponent onError:[^ NameLookupError raiseRequestWith:aString errorString:' - bad address string'].
    ].

    ^ bytes asByteArray.


    "
        IPSocketAddress hostAddressFromString:'1.2.3.4'
        IPSocketAddress hostAddressFromString:'255.255.255.255'
    "
! !

!IPSocketAddress class methodsFor:'queries'!

domain
    ^ #'AF_INET'
!

hostAddressLen
    "answer the number of bytes of the host address"

    ^ 4
!

obsoleteDomainSymbol
    ^ #inet
!

vwDomainSymbol
    ^ #afInet
! !

!IPSocketAddress methodsFor:'accessing'!

hostAddress
    ^ (ByteArray new:4) replaceFrom:1 to:4 with:self startingAt:5
!

hostAddress:aByteArray
    ^ self replaceFrom:5 to:8 with:aByteArray startingAt:1
!

port
    ^ self unsignedInt16At:3 MSB:true
!

port:aPortNr
    self unsignedInt16At:3 put:aPortNr MSB:true
! !

!IPSocketAddress methodsFor:'comparing'!

sameHostAddress:aSocketAddress
    "answer true, if myself and aSocketAddress have the same host address
     (but possibly different ports)."

    ^ aSocketAddress class == self class 
        and:[self sameContentsFrom:5 to:9 as:aSocketAddress startingAt:5]
! !

!IPSocketAddress methodsFor:'converting'!

asIPv4SocketAddress
    ^ self
!

asIPv6SocketAddress
    "convert a IPv4 address to a mapped IPv6SocketAddress"

    |ipv6|

    ipv6 := IPv6SocketAddress new.
    ipv6
        port:self port;
        at:19 put:16rff;
        at:20 put:16rff.

    ipv6 replaceFrom:21 to:24 with:self startingAt:5.

    ^ ipv6.

    "
        (self localHost port:80) asIPv6SocketAddress
        (self localHost port:80) asIPv6SocketAddress asIPv4SocketAddress
    "
! !

!IPSocketAddress methodsFor:'obsolete'!

address
    <resource: #obsolete>

    ^ self hostAddress
! !

!IPSocketAddress methodsFor:'printing & storing'!

printAddressOn:aStream
    |i1 i2|

    i1 := self adrBytesStart.
    i2 := i1 + self numAdrBytes - 1.
    i1 to:i2 do:[:i | 
        i ~~ i1 ifTrue:[
            aStream nextPut:$.
        ].
        (self at:i) printOn:aStream
    ].

    "
     String streamContents:[:s | (IPSocketAddress hostName:'localhost') printAddressOn:s]
     (IPSocketAddress hostName:'localhost') printString
     (IPSocketAddress hostName:'localhost') hostAddress printString
     (IPSocketAddress hostName:'exeptn') printString
     (IPSocketAddress hostName:'exeptn') printString
    "
! !

!IPSocketAddress methodsFor:'private'!

adrBytesStart
    ^ 5
!

numAdrBytes
    ^ 4
! !

!IPSocketAddress methodsFor:'queries'!

hostName
    |addr name|

    addr := self hostAddress.

    name := self class nameCacheAt:addr.
    name notNil ifTrue:[^ name].

    name := super hostName.
    name notNil ifTrue:[
        self class nameCacheAt:addr put:name.
    ].
    ^ name
!

netmaskSize
    "If this is an address mask: answer the number of mask bits in the address mask"

    |sz bI lowBit lowBitHere hostAddress|

    hostAddress := self hostAddress.

    lowBit := 0.
    bI := 1.
    sz := hostAddress size.
    [
        lowBitHere := (hostAddress basicAt:bI) lowBit.
        lowBitHere ~= 0 ifTrue:[
            lowBit := lowBit + (9 - lowBitHere).
        ].
        bI := bI + 1.
    ] doWhile:[lowBitHere == 1 and:[bI < sz]].

    ^ lowBit

    "
      (IPSocketAddress addressString:'255.255.0.0') netmaskSize
      (IPSocketAddress addressString:'255.255.128.0') netmaskSize
      (IPv6SocketAddress addressString:'FFFF:FFFF:FFFF:FFFF::') netmaskSize
      (IPv6SocketAddress addressString:'FFFF:FFFF:FFFF:FFF0::') netmaskSize
      (IPv6SocketAddress addressString:'F0FF:FFFF:FFFF:FFF0::') netmaskSize
    "
!

networkAddress
    "THINK TWICE before using this!! 
     This is deprecated, it doesn't make sense any longer since CIDR, subnetting and netmasks
     have been introduced.

     Extract and return the network part from the host address."
    <resource: #obsolete>

    |highAddrByte|

    highAddrByte := self at: 5.
    (highAddrByte bitAnd: 16r80) == 0 ifTrue: [^ByteArray with: highAddrByte].
    (highAddrByte bitAnd: 16rC0) == 16r80 ifTrue: [^ByteArray with: highAddrByte with: (self at: 6)].
    (highAddrByte bitAnd: 16rC0) == 16rC0 ifTrue: [^ByteArray with: highAddrByte with: (self at: 6) with: (self at: 7)].
    ^ self error: 'unknown network class'

    "
     (IPSocketAddress hostName:'exept.eu.org') networkAddress     
     (IPSocketAddress hostName:'exept.exept.de') networkAddress    
     (IPSocketAddress hostName:'ibm.com') networkAddress          
     (IPSocketAddress hostName:'cnn.com') networkAddress          
    "
!

networkClass
    "THINK TWICE before using this!! 
     This is deprecated, it doesn't make sense any longer since subnetting and netmasks
     have been introduced.

     Extract and return the network class (as a symbol) from the host address.
     Returns one of #classA #classB #classC."
    <resource: #obsolete>

    |highAddrByte|

    highAddrByte := self at: 5.
    (highAddrByte bitAnd: 16r80) == 0 ifTrue: [^#classA].
    (highAddrByte bitAnd: 16rC0) == 16r80 ifTrue: [^#classB].
    (highAddrByte bitAnd: 16rC0) == 16rC0 ifTrue: [^#classC].
    ^ self error: 'unknown network class'

    "
     (IPSocketAddress hostName:'exept.eu.org') networkClass
    "
!

portOrName
    ^ self port
! !

!IPSocketAddress methodsFor:'testing'!

isBroadcast
    "answer true, if this is a broadcast address"

    ^ (self at:5) == 255
        and:[self sameContentsFrom:6 to:8 as:#[255 255 255] startingAt:1]

    "
        (self hostAddress:self broadcastAddress) isBroadcast
    "
!

isIPSocketAddress
    ^ true
!

isIPv4SocketAddress
    ^ self class == IPSocketAddress
!

isLocal
    "answer true, if this address addresses a peer on the same host"

    ^ (self at:5) == 127

    "
        self localHost isLocal
    "
!

isMulticast
    "answer true, if this address is a multicast address 224.0.0.0/4 or Class D"

    ^ (self at:5) between:224 and:239  
!

isMyAddress
    "answer true, if the address refers to my own host"

    self isLocal ifTrue:[^ true].

    OperatingSystem isLinuxLike ifTrue:[
        "/ make this general later, when getNetworkAddressInfo is implemented in Win32OperatingSystem
        OperatingSystem getNetworkAddressInfo do:[:eachIfAddrInfoSet|
            eachIfAddrInfoSet do:[:eachIfAddrInfo|
                |address|
                address := eachIfAddrInfo at:#address ifAbsent:nil.
                address notNil ifTrue:[
                    (self sameHostAddress:address) ifTrue:[^ true].
                ]
            ].
        ].
        ^ false
    ] ifFalse:[
        "/ For now - works only for ipv4...
        ^ OperatingSystem getNetworkAddresses contains:[:each| 
                self sameHostAddress:each
            ].
    ].

    "
        (IPSocketAddress hostAddress:#[172 23 1 88] port:80) isMyAddress.
        (IPSocketAddress hostAddress:#[192 168 23 29] port:80) isMyAddress.
        (IPv6SocketAddress addressString:'2003:6A:682B:4500:A288:B4FF:FEC6:1514') isMyAddress.
        (IPv6SocketAddress addressString:'2001:6A:682B:4500:A288:B4FF:FEC6:1514') isMyAddress.
    "
! !

!IPSocketAddress class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

