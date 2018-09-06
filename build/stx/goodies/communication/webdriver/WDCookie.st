"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDServerObject subclass:#WDCookie
	instanceVariableNames:'name value path domain secure httpOnly expiry'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDCookie comment:'A  object describing a Cookie.See https://code.google.com/p/selenium/wiki/JsonWireProtocol#Cookie_JSON_Object'
!


!WDCookie methodsFor:'accessing'!

domain
	^ domain
!

domain: anObject
	domain := anObject
!

expiry
	^ expiry
!

expiry: anObject
	expiry := anObject
!

httpOnly
	^ httpOnly
!

httpOnly: anObject
	httpOnly := anObject
!

name
	^ name
!

name: anObject
	name := anObject
!

path
	^ path
!

path: anObject
	path := anObject
!

secure
	^ secure
!

secure: anObject
	secure := anObject
!

value1
	^ value
!

value: anObject
	value := anObject
! !

!WDCookie methodsFor:'printing'!

printOn: aStream

	aStream nextPutAll: self name asString
! !

!WDCookie methodsFor:'private - initialization'!

initFromDictionary: aDictionary
	aDictionary at: 'name' ifPresent: [:v | self name: v ].
	aDictionary at: 'value' ifPresent: [:r | self value: r ].
	aDictionary at: 'path' ifPresent: [:t | self path: t ].
	aDictionary at: 'domain' ifPresent: [:t | self domain: t ].	
	aDictionary at: 'secure' ifPresent: [:t | self secure: t ].		
	aDictionary at: 'httpOnly' ifPresent: [:t | self httpOnly: t ].			
	aDictionary at: 'expiry' ifPresent: [:t | self expiry: t ].					
! !

!WDCookie class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDCookie.st,v 1.1 2018-06-17 06:36:50 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDCookie.st,v 1.1 2018-06-17 06:36:50 cg Exp $'
! !

