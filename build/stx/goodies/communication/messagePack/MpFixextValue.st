"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

MpExtValue subclass:#MpFixextValue
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpFixextValue methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: 'FixExt('.
	aStream nextPutAll: self size printString. 
	aStream nextPutAll: '): '.
	self printDescriptionOn: aStream
! !

!MpFixextValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpFixextValue.st,v 1.2 2018-05-08 11:01:40 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpFixextValue.st,v 1.2 2018-05-08 11:01:40 cg Exp $'
! !

