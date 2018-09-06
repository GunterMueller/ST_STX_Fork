"
 COPYRIGHT (c) 2006 by eXept Software AG
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

Object subclass:#NameResolver
	instanceVariableNames:'servers cache'
	classVariableNames:'Default'
	poolDictionaries:''
	category:'Net-Communication-DNS'
!

!NameResolver class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2006 by eXept Software AG
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
    no warranty; provided AS-IS
    code ported from squeak
"

    "Created: / 22-11-2006 / 12:48:56 / cg"
!

examples
"
    NameResolver default servers: #( [192 168 23 1] ).
    NameResolver default servers: #( [193 141 12 216] ).
    NameResolver default addressByName: 'imap.exept.de'.
    NameResolver default addressByName: 'google.com'.
    NameResolver default addressByName: 'x2xxxxxxxxxxxxxxxxxxxx.org'
    NameResolver default addressByName: 'ipv6.google.com'
"
! !

!NameResolver class methodsFor:'accessing'!

default
    Default isNil ifTrue:[ Default := self new ].
    ^ Default
! !

!NameResolver class methodsFor:'constants'!

connectionTimeout

    ^ 45
! !

!NameResolver methodsFor:'accessing'!

servers
	^ servers
!

servers: aCollection
        servers := aCollection.
        cache := Dictionary new
! !

!NameResolver methodsFor:'resolving'!

addressByName: hostName
        |answers response answer cname|

        [
            response := self request: (DNSMessage addressByName: hostName).
            answers := response answers.
        ] on:TimeoutError do:[
            ^ HostNameLookupError raiseRequestWith:hostName errorString:' - timeout'.
        ].
        answers isEmptyOrNil ifTrue:[
            ^ HostNameLookupError raiseRequestWith:hostName.
        ].
        answer := answers first.
        answer isCNAMERecord ifTrue:[
           cname := answer cname.
           answer := answers detect:[:eachRecord| eachRecord isARecord and:[eachRecord name = cname]] ifNone:[].
           answer isNil ifTrue:[
               answer := response additional detect:[:eachRecord| eachRecord isARecord and:[eachRecord name = cname]] ifNone:[].
               answer isNil ifTrue:[
                   ^ self addressByName:cname.
               ].
           ].
        ].
        ^ answer address.

"
Example (put the address of a name server):
        NameResolver default servers: #((192 168 0 1))
        NameResolver default servers: #((193 141 12 216))
        NameResolver default addressByName: 'squeak.org'
        NameResolver default addressByName: 'www.web.de'
        NameResolver default addressByName: 'xxx.fasel'
        NameResolver default addressByName: 'x234rtzoifjelfvljjg.de'
"
!

addressesByName: hostName
        |answers response firstAnswer cname|

        [
            response := self request: (DNSMessage addressByName: hostName).
            answers := response answers.
        ] on:TimeoutError do:[
            ^ HostNameLookupError raiseRequestWith:hostName errorString:' - timeout'.
        ].
        answers isEmptyOrNil ifTrue:[
            ^ HostNameLookupError raiseRequestWith:hostName.
        ].
        firstAnswer := answers first.
        firstAnswer isCNAMERecord ifTrue:[
           cname := firstAnswer cname.
           answers := answers select:[:eachRecord| eachRecord isARecord and:[eachRecord name = cname]].
           answers isEmpty ifTrue:[
               answers := response additional select:[:eachRecord| eachRecord isARecord and:[eachRecord name = cname]].
               answers isEmpty ifTrue:[
                   ^ self addressesByName:cname.
               ].
           ].
        ].
        ^ answers collect:[:each| each address].

"
Example (put the address of a name server):
        NameResolver default servers: #((192 168 0 1))
        NameResolver default servers: #((193 141 12 216))
        NameResolver default addressesByName: 'squeak.org'
        NameResolver default addressesByName: 'www.web.de'
        NameResolver default addressesByName: 'google.com'
        NameResolver default addressesByName: 'xxx.fasel'
"
!

mailExchangerFor: domain

    |records|

    records := self mailExchangersFor: domain.
    records isEmpty ifTrue:[^nil].

    ^ records first mx

"
Example (put the address of a name server):
        NameResolver default servers: #((192 168 0 1))
        NameResolver default servers: #((193 141 12 193))
        NameResolver default mailExchangerFor: 'squeak.org'
        NameResolver default mailExchangerFor: 'web.de'
"
!

mailExchangersFor: domain
        ^ (self request: (DNSMessage mailExchangerFor: domain)) answers sort: [:a :b | a priority <= b priority]


"
Example (put the address of a name server):
        NameResolver default servers: #((192 168 0 1))
        NameResolver default servers: #((193 141 12 193))
        NameResolver default mailExchangersFor: 'squeak.org'
        NameResolver default mailExchangersFor: 'web.de'      
        NameResolver default mailExchangersFor: 'exept.de'
        NameResolver default mailExchangersFor: 'xxxx.exept.de'
        NameResolver default mailExchangersFor: 'xxxx.fasel'
"
!

nameServersFor: domain
        ^ (self request: (DNSMessage nameServersFor: domain)) answers collect: [:each | each ns]
"
Example (put the address of a name server):
        NameResolver default servers: #((192 168 0 1))
        NameResolver default servers: #((193 141 12 193))
        NameResolver default nameServersFor: 'squeak.org'
        NameResolver default nameServersFor: 'web.de'
"
!

reverseLookup: address
        ^ self error:  'not yet implemented'
! !

!NameResolver methodsFor:'resolving-private'!

request: aDNSMessage
        | cached |
        cache isNil ifTrue:[
            self error:'setup servers first'.
        ].
        ((cached := cache at: aDNSMessage questions ifAbsent: []) isNil or: [cached timedOut])
                ifTrue: [cached := self sendRequest: aDNSMessage.
                                cache at: aDNSMessage questions put: cached].
        ^ cached

    "Modified: / 22-11-2006 / 12:45:39 / cg"
!

sendRequest: aDNSMessage
        servers allButLast do: [:each |
                [^ self sendRequest: aDNSMessage server: each] on: TimeoutError do: []].
        ^ self sendRequest: aDNSMessage server: servers last
!

sendRequest:request server:server 
    |sock receiveBuf response|

    sock := Socket newUDP.
    [
        sock connectTo:server asByteArray port:53.
        receiveBuf := ByteArray new:512.
        sock nextPutBytes:request asByteArray.
        (sock readWaitWithTimeout:self class connectionTimeout) ifTrue:[
            TimeoutError raise.    
        ].
        sock
            receiveBuffer:receiveBuf
            start:1
            for:512.
        response := DNSMessage readFrom:receiveBuf readStream
    ] ensure:[
        sock
            close;
            shutDown
    ].
    response checkResponseCode.
    ^ response
! !

!NameResolver class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/NameResolver.st,v 1.9 2017-01-23 23:58:01 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/NameResolver.st,v 1.9 2017-01-23 23:58:01 cg Exp $'
! !

