"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Error subclass:#MpError
	instanceVariableNames:'type'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpError class methodsFor:'instance creation'!

decode
	^self new type: #decode
!

encode
	^self new type: #encode
! !

!MpError methodsFor:'accessing'!

type
	"Answer the value of type"

	^ type
!

type: anObject
	"Set the value of type"

	type := anObject
! !

!MpError class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpError.st,v 1.2 2018-05-08 11:02:11 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpError.st,v 1.2 2018-05-08 11:02:11 cg Exp $'
! !

