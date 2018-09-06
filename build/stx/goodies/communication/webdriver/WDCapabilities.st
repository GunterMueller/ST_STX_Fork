"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDServerObject subclass:#WDCapabilities
	instanceVariableNames:'mapping'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDCapabilities comment:'Not all server implementations will support every WebDriver feature. Therefore, the client and server should use JSON objects with properties when describing which features a user requests that a session support.If a session cannot support a capability that is requested in the desired capabilities, no error is thrown; a read-only capabilities object is returned that indicates the capabilities the session actually supports.'
!


!WDCapabilities class methodsFor:'instance creation'!

new
    "return an initialized instance"

    ^ self basicNew initialize.
! !

!WDCapabilities methodsFor:'accessing'!

getCapability: aString 
	^mapping at: aString asSymbol ifAbsent: [ nil ]
! !

!WDCapabilities methodsFor:'conversion'!

asDictionary
	^mapping
! !

!WDCapabilities methodsFor:'initialization'!

initialize
	super initialize.
	mapping := Dictionary new
! !

!WDCapabilities methodsFor:'private - accessing'!

mapping: aMapping

	mapping := aMapping
! !

!WDCapabilities methodsFor:'private - initialization'!

initFromDictionary: aDictionary

	self mapping: aDictionary 
! !

!WDCapabilities class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDCapabilities.st,v 1.1 2018-06-17 06:36:35 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDCapabilities.st,v 1.1 2018-06-17 06:36:35 cg Exp $'
! !

