"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WDServerObject
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Base-Model'
!

WDServerObject comment:'A server object'
!


!WDServerObject class methodsFor:'instance creation'!

fromDictionary: aDictionary

	^(self basicNew)
		initFromDictionary: aDictionary;
		yourself
! !

!WDServerObject methodsFor:'private - initialization'!

initFromDictionary: aDictionary

	self subclassResponsibility 
! !

!WDServerObject class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerObject.st,v 1.1 2018-06-17 06:37:43 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDServerObject.st,v 1.1 2018-06-17 06:37:43 cg Exp $'
! !

