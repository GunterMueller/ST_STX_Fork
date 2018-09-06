"{ Package: 'stx:goodies/communication/messagePack' }"

"{ NameSpace: Smalltalk }"

Object subclass:#MpExtValue
	instanceVariableNames:'typeCode data'
	classVariableNames:''
	poolDictionaries:''
	category:'MessagePack-Core'
!


!MpExtValue class methodsFor:'instance creation'!

typeCode: anInteger data: data 
	^ self new typeCode: anInteger;
		 data: data
! !

!MpExtValue methodsFor:'accessing'!

data

	^ data
!

data: anObject

	data := anObject
!

size
	^self data size
!

typeCode

	^ typeCode
!

typeCode: anObject

	typeCode := anObject
! !

!MpExtValue methodsFor:'printing'!

printDescriptionOn: aStream
	self typeCode printOn: aStream.
	aStream space.
	aStream nextPutAll: 'data: '.
	self data printOn: aStream
!

printOn: aStream
	aStream nextPutAll: 'Ext: '.
	self printDescriptionOn: aStream
! !

!MpExtValue class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpExtValue.st,v 1.2 2018-05-08 11:02:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/messagePack/MpExtValue.st,v 1.2 2018-05-08 11:02:10 cg Exp $'
! !

