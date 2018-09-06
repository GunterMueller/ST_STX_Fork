"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Object subclass:#SptHTTPProgressAbstract
	instanceVariableNames:'request'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP'
!

SptHTTPProgressAbstract comment:'

Instance Variables
	request 	<SptHTTPRequest>'
!


!SptHTTPProgressAbstract class methodsFor:'instance creation'!

new
	^super new initialize
! !

!SptHTTPProgressAbstract methodsFor:'accessing'!

request
	^request
!

request: anObject
	request := anObject
!

response
	^request lastResponse
! !

!SptHTTPProgressAbstract class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPProgressAbstract.st,v 1.2 2011-09-23 18:54:53 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPProgressAbstract.st,v 1.2 2011-09-23 18:54:53 cg Exp $'
! !
