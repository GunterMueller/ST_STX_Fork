"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

SptHTTPError subclass:#SptHTTPServerError
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Exceptions'
!


!SptHTTPServerError methodsFor:'displaying'!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'Server Error %3'
! !

!SptHTTPServerError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPServerError.st,v 1.2 2011-09-23 18:54:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPServerError.st,v 1.2 2011-09-23 18:54:03 cg Exp $'
! !
