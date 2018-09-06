"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPError subclass:#SptHTTPClientError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Exceptions'
!


!SptHTTPClientError methodsFor:'displaying'!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'Client Error %3'
! !

!SptHTTPClientError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPClientError.st,v 1.2 2011-09-23 18:53:51 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPClientError.st,v 1.2 2011-09-23 18:53:51 cg Exp $'
! !
