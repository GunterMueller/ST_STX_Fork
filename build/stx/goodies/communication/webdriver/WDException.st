"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

Error subclass:#WDException
	instanceVariableNames:'errorCode'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Exceptions'
!

WDException comment:'A webdriver exception'
!


!WDException methodsFor:'accessing'!

errorCode: anInteger 
	errorCode := anInteger
! !

!WDException class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDException.st,v 1.1 2018-06-17 06:51:29 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDException.st,v 1.1 2018-06-17 06:51:29 cg Exp $'
! !

