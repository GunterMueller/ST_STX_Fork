"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/ssdp' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SSDPService
	instanceVariableNames:'serviceType uniqueServiceName location serverInfo discoveryTime
		maxAge'
	classVariableNames:'Verbose'
	poolDictionaries:''
	category:'Net-Communication-SSDP-Core'
!

SSDPService comment:''
!


!SSDPService class methodsFor:'instance creation'!

ofType: aServiceType atLocation: aServiceLocation
	"Used by server to initialize the service it offers"

	^ self new initializeWithType: aServiceType at: aServiceLocation
! !

!SSDPService class methodsFor:'debugging'!

verbose
    ^ Verbose ? false

    "
     Verbose := true.
     Verbose := false.
    "
! !

!SSDPService methodsFor:'accessing'!

location
	^location
!

serverInfo
	"Some identifier of the server on which service is running.
	uPnP 1.1 suggests:
	'OS/version Protocol/version Product/version"
	^serverInfo
!

serverInfo: someInfoString
	^serverInfo := someInfoString
!

serviceType
	"The maximum amount of time since time of discovery this entry should be cached/relied upon"
	^serviceType
!

uniqueServiceName
	"The maximum amount of time since time of discovery this entry should be cached/relied upon"
	^uniqueServiceName
! !

!SSDPService methodsFor:'accessing - cache validity'!

cacheExpiry
	^self discoveryTime + self maxAge
!

discoveryTime
	^discoveryTime
!

maxAge
	"The maximum amount of time since time of discovery this entry should be cached/relied upon"
	^maxAge
!

validDuration

	^self cacheExpiry - DateAndTime now.
! !

!SSDPService methodsFor:'comparing'!

= anotherObject
	^self species = anotherObject species and: [ self uniqueServiceName = anotherObject uniqueServiceName ]

!

hash
	^self uniqueServiceName hash
! !

!SSDPService methodsFor:'initialize - release'!

initializeWithType: aServiceType at: aServiceLocation
        | locationHash locationHex |
        serviceType := aServiceType.
        location := aServiceLocation asUrl.     "For current purposes, identify services uniquely by the hash of their location.
        Saves us a lot of trouble wrt. maintaining identity of services after restarts etc.
        (But of course means, if our services location changes, it is registed as a wholly new service)"
        Smalltalk isSmalltalkX ifTrue:[
            locationHex := (SHA256Stream hashValueOf:aServiceLocation) hexPrintString readStream.
        ] ifFalse:[
            locationHash := SHA256 new hashStream: aServiceLocation readStream.
            locationHex := locationHash hex readStream.
        ].
        uniqueServiceName := String
                streamContents: [ :stream |
                        stream
                                nextPutAll: 'uuid:';
                                nextPutAll: (locationHex next: 8);
                                nextPut: $-;
                                nextPutAll: (locationHex next: 4);
                                nextPut: $-;
                                nextPutAll: (locationHex next: 4);
                                nextPut: $-;
                                nextPutAll: (locationHex next: 4);
                                nextPut: $-;
                                nextPutAll: (locationHex next: 12);
                                nextPutAll: '::';
                                nextPutAll: NetNameResolver localHostName;
                                nextPutAll: '::';
                                nextPutAll: aServiceType ].
        maxAge := 180 seconds
! !

!SSDPService methodsFor:'printing'!

printOn: aStream
	uniqueServiceName printOn: aStream
! !

!SSDPService methodsFor:'private -printing'!

remoteAddressString: aHostInfo
        |addr|
        addr := aHostInfo host.
        Smalltalk isSmalltalkX ifTrue:[
            addr size = 4 ifTrue:[
                "/ ( #[1 2 3 4] collect: #asString as:OrderedCollection) asStringWith:'.'
                ^(addr collect: #asString as:OrderedCollection) asStringWith:'.'
            ].
            addr size = 6 ifTrue:[
                "/ ( #[1 2 3 4 5 6] collect: #hexPrintString as:OrderedCollection) asStringWith:':'
                ^ (addr collect: #hexPrintString as:OrderedCollection) asStringWith:':'
            ].
            self halt.
        ] ifFalse:[
            ^addr size = 4
                    ifTrue: [ "IPv4"
                              (addr collect: #asString as: OrderedCollection) joinUsing: '.'  ]
                    ifFalse: [ "IPv6"
                             ((addr collect: [:e | e printStringBase: 16]) as: OrderedCollection) joinUsing: ':' ]
        ]
! !

!SSDPService methodsFor:'server messages'!

aliveResponseFor: aHostInfo
	"The ping we send periodically to notify clients we are still here"
	"TODO: Rewrite to take multicastInfo as parameter "

	^('NOTIFY * HTTP/1.1
Host: ', (self remoteAddressString: aHostInfo) , ':' , aHostInfo port asString, '
NT: ', serviceType ,'
NTS: ssdp:alive
USN: ', uniqueServiceName ,'
Location: ', location asString , '
Cache-Control: max-age=', maxAge asSeconds printString,'

') withInternetLineEndings
!

byebyeResponseFor: multicastInfo
	"The ping we send when shutting down to notify clients we can no longer provide services"
		"TODO: Rewrite to take multicastInfo as parameter "
	^('NOTIFY * HTTP/1.1
Host: ', (self remoteAddressString: multicastInfo), ':' , multicastInfo port asString, '
NT: ', serviceType ,'
NTS: ssdp:byebye
USN: ', uniqueServiceName, '

') withInternetLineEndings
!

discoveryResponse
	^('HTTP/1.1 200 OK
ST: ', serviceType ,'
USN: ',  uniqueServiceName,'
Location: ', location asString, '
Server: ', self serverInfo, '
Cache-Control: max-age=', maxAge asSeconds printString,'

') withInternetLineEndings

! !

!SSDPService methodsFor:'testing'!

matchesType: aNotification
	^ serviceType = 'ssdp:all'
		or: [ serviceType = aNotification serviceType ]
! !

!SSDPService methodsFor:'updating'!

merge: aNotification
	|info loc|

	uniqueServiceName
		ifNotNil:
			[
			uniqueServiceName = aNotification uniqueServiceName
				ifFalse: [ ^ self error: 'Cannot merge data from notification with different identity!!' ] ].
	"Obligatory notification data"
	serviceType := aNotification serviceType.
	uniqueServiceName := aNotification uniqueServiceName.
	discoveryTime := aNotification discoveryTime.
	maxAge := aNotification maxAge.
	(info := aNotification serverInfo) ifNotNil: [serverInfo := info ].
	"Common SSDP fields"
	(loc := aNotification location) ifNotNil: [location := loc ]
! !

!SSDPService class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPService.st,v 1.7 2018-05-14 20:32:55 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/ssdp/SSDPService.st,v 1.7 2018-05-14 20:32:55 cg Exp $'
! !

