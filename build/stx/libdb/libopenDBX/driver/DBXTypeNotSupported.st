"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXTypeNotSupported
	instanceVariableNames:'code type'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-API'
!


!DBXTypeNotSupported class methodsFor:'instance creation'!

code: aNumber
	^self new
		code: aNumber;
		yourself
!

type: aSymbol
	^self new
		type: aSymbol;
		yourself
! !

!DBXTypeNotSupported class methodsFor:'*OpenDBXDriver'!

fromDbxString: aString
	self error: 'Type not supported'
! !

!DBXTypeNotSupported methodsFor:'accessing'!

code
	^ code
!

code: anObject
	code := anObject
!

type
	^ type
!

type: anObject
	type := anObject
! !

!DBXTypeNotSupported methodsFor:'dbx'!

fromDbxString: aString
	self type 
		ifNotNil: [ OpenDBXDriverError signal: ('Unsupported data type: {1}, trying to parse: {2}' format: {self type. aString}) ]
		ifNil: [ OpenDBXDriverError signal: ('Unknown data type: {1}, trying to parse: {2}' format: {self code. aString}) ]
		
	
! !

!DBXTypeNotSupported class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXTypeNotSupported.st,v 1.2 2013-04-15 13:10:08 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXTypeNotSupported.st,v 1.2 2013-04-15 13:10:08 cg Exp $'
! !

