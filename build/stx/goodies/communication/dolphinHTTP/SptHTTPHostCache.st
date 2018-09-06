"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPHostCache
	instanceVariableNames:'cache ipFactory'
	classVariableNames:'Current'
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPHostCache comment:'SptHTTPHostCache

I am an optimization class; I cache the ip address of host to avoid a DNS lookup

Instance Variables
	cache		<SharedLookupTable>
	ipFactory		<SptHTTPHostCache>'
!


!SptHTTPHostCache class methodsFor:'instance creation'!

new
	^super new initialize
! !

!SptHTTPHostCache class methodsFor:'accessing'!

current
	Current isNil ifTrue: [Current := self new].
	^Current
! !

!SptHTTPHostCache class methodsFor:'initializing'!

uninitialize
	Current := nil
! !

!SptHTTPHostCache methodsFor:'accessing'!

cache
	^cache
!

cache: anObject
	cache := anObject
!

ipFactory
	^ipFactory
!

ipFactory: anObject
	ipFactory := anObject
! !

!SptHTTPHostCache methodsFor:'caching'!

hasExpired: entry
	^Delay millisecondClockValue - entry first > self freshMilliseconds
!

ipAddressFor: aString
	| entry |
	entry := cache at: aString ifAbsent: [].
	(entry isNil or: [self hasExpired: entry]) 
		ifTrue: [cache at: aString put: (entry := self newEntryFor: aString)].
	^entry second
! !

!SptHTTPHostCache methodsFor:'constants'!

freshMilliseconds
        ^ 120000 "/ ##(1000 * 60 * 2)

    "Created: / 23-09-2011 / 12:48:25 / cg"
! !

!SptHTTPHostCache methodsFor:'entries'!

newEntryFor: aString
	^self newEntryForIP: (ipFactory ipAddressFromString: aString)
!

newEntryForIP: anIPAddress
	^Array with: Delay millisecondClockValue with: anIPAddress
! !

!SptHTTPHostCache methodsFor:'helpers'!

ipAddressFromString: aString
    ^ IPSocketAddress hostName:aString
    "/     ^(InternetAddress fromString: aString) ipAddress

    "Modified: / 23-09-2011 / 22:47:50 / cg"
! !

!SptHTTPHostCache methodsFor:'initializing'!

initialize
        super initialize.
        cache := Dolphin::SharedLookupTable new.
        ipFactory := self

    "Modified: / 23-09-2011 / 22:25:06 / cg"
! !

!SptHTTPHostCache class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPHostCache.st,v 1.4 2011-09-23 20:55:12 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPHostCache.st,v 1.4 2011-09-23 20:55:12 cg Exp $'
! !
