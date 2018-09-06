"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WDSmalltalkPlatform
	instanceVariableNames:''
	classVariableNames:'Current'
	poolDictionaries:''
	category:'WebDriver-Core-Platforms'
!

WDSmalltalkPlatform comment:'A Smalltalk platform'
!


!WDSmalltalkPlatform class methodsFor:'class initialization'!

initialize
	self ~~ WDSmalltalkPlatform ifTrue: [ WDSmalltalkPlatform current: self new ]
! !

!WDSmalltalkPlatform class methodsFor:'facade'!

current
	^ Current ifNil: [ self error: 'No current WDPlatform is set, send #initialize to the appropriate subclass first.' ]
!

current: aPlatform
	Current := aPlatform
! !

!WDSmalltalkPlatform methodsFor:'facade'!

signalException: exception
	"ANSI behaviour. Some dialects like VisualWork have non-standard behaviour, which can be overwritten in subclasses."

	^exception signal
! !

!WDSmalltalkPlatform methodsFor:'facade - http'!

handleRequest: aBlock

	self subclassResponsibility 
!

httpClient

	^self subclassResponsibility
!

httpDelete: url

	^self subclassResponsibility 
!

httpGet: url

	^self subclassResponsibility 
!

httpPost: url data: data timeout: seconds

	^self subclassResponsibility 
!

httpPost: url timeout: seconds

	^self subclassResponsibility 
! !

!WDSmalltalkPlatform methodsFor:'facade - json'!

jsonRead: aString 
	^self subclassResponsibility 
!

jsonWrite: anObject

	^self subclassResponsibility 
! !

!WDSmalltalkPlatform class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDSmalltalkPlatform.st,v 1.1 2018-06-17 06:53:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDSmalltalkPlatform.st,v 1.1 2018-06-17 06:53:11 cg Exp $'
! !


WDSmalltalkPlatform initialize!
