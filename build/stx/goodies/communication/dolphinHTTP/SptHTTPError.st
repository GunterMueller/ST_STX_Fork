"{ Package: 'stx:goodies/communication/dolphinHTTP' }"

Error subclass:#SptHTTPError
	instanceVariableNames:'httpStatus'
	classVariableNames:''
	poolDictionaries:''
	category:'Dolphin-Spt-HTTP-Exceptions'
!


!SptHTTPError methodsFor:'accessing'!

httpStatus
	^httpStatus
!

httpStatus: aSptHTTPStatus
        httpStatus := aSptHTTPStatus.
        messageText := httpStatus asString "displayString"

    "Modified: / 23-09-2011 / 22:16:24 / cg"
!

statusCode
	"Answer the status code of the response"

	^self httpStatus statusCode
!

statusText
	"Answer the Status text of the response"

	^self httpStatus statusText
! !

!SptHTTPError methodsFor:'displaying'!

_descriptionArguments
        "Answer the set of arguments to be substitued into the receiver's descriptionFormat
        String."

        ^super _descriptionArguments , (Array with: httpStatus asString "displayString")

    "Modified: / 23-09-2011 / 22:16:08 / cg"
!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'HTTP Error %3'
! !

!SptHTTPError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPError.st,v 1.3 2011-09-23 20:22:17 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/dolphinHTTP/SptHTTPError.st,v 1.3 2011-09-23 20:22:17 cg Exp $'
! !
