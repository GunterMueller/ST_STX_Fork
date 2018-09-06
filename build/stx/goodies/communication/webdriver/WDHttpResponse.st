"{ Package: 'stx:goodies/communication/webdriver' }"

"{ NameSpace: Smalltalk }"

Object subclass:#WDHttpResponse
	instanceVariableNames:'httpStatus headers contents'
	classVariableNames:''
	poolDictionaries:''
	category:'WebDriver-Core-Utilities'
!

WDHttpResponse comment:'An HTTP response'
!


!WDHttpResponse methodsFor:'accessing'!

contents
	^ contents
!

contents: anObject
	contents := anObject
!

headers
	^ headers
!

headers: anObject
	headers := anObject
!

httpStatus
	^ httpStatus
!

httpStatus: anObject
	httpStatus := anObject
! !

!WDHttpResponse methodsFor:'printing'!

printOn: aStream 

	super printOn: aStream.
	aStream 
		nextPut: $(;
		nextPutAll: self httpStatus asString;
		nextPut: $)
		
! !

!WDHttpResponse methodsFor:'testing'!

isSuccess
	^ #(200 201 202 204) includes: self httpStatus
! !

!WDHttpResponse class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDHttpResponse.st,v 1.1 2018-06-17 06:52:52 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/webdriver/WDHttpResponse.st,v 1.1 2018-06-17 06:52:52 cg Exp $'
! !

