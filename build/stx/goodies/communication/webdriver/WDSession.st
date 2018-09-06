"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

WDServerObject subclass:#WDSession
	instanceVariableNames:'sessionId capabilities'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDSession comment:'A session'
!


!WDSession methodsFor:'accessing'!

capabilities

	^capabilities
!

sessionId

	^sessionId
! !

!WDSession methodsFor:'comparing'!

= anotherSession
	^ self species = anotherSession species and: [ self sessionId = anotherSession sessionId ]
! !

!WDSession methodsFor:'printing'!

printOn: aStream
	super printOn: aStream.
	aStream 
		nextPut: $(;
		nextPutAll: self sessionId asString;
		nextPut: $)
! !

!WDSession methodsFor:'private - accessing'!

capabilities: someCapabilities

	capabilities := someCapabilities 
!

sessionId: anId

	sessionId := anId
! !

!WDSession methodsFor:'private initialization'!

initFromDictionary: aDictionary

	aDictionary at: 'sessionId' ifPresent: [:id | self sessionId: id ].
	aDictionary at: 'value' ifPresent: [:value | self capabilities: (WDCapabilities fromDictionary: value)].
 
	aDictionary at: 'id' ifPresent: [:id | self sessionId: id ].
	aDictionary at: 'capabilities' ifPresent: [:value | self capabilities: (WDCapabilities fromDictionary: value)].
	
! !

!WDSession class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDSession.st,v 1.1 2018-06-17 06:39:59 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDSession.st,v 1.1 2018-06-17 06:39:59 cg Exp $'
! !

