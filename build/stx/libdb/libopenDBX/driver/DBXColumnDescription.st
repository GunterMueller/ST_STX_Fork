"{ Package: 'stx:libdb/libopenDBX/driver' }"

Object subclass:#DBXColumnDescription
	instanceVariableNames:'type dbxType name size'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-OpenDBXDriver-Description'
!


!DBXColumnDescription class methodsFor:'instance creation'!

name: aString dbxType: aNumber type: aType
"this instantiates a new DBXColumnDescription with a type size of zero"
	^self name: aString dbxType: aNumber type: aType size: 0 
!

name: aNameString dbxType: aNumber type: aTypeSymbol size: aTypeSizeNumber
"this instantiates a new DBXColumnDescription, whitch will hold the name, data type and size of the data type the rows from the database have"
	^(super new)
		name: aNameString;
		type: aTypeSymbol;
		size: aTypeSizeNumber;
		yourself.
!

new
	self error: 'Use caption:type:'
! !

!DBXColumnDescription methodsFor:'accessing'!

addTo: aDBXResultSetDescription
	aDBXResultSetDescription addDescription: self.
	type isBehavior ifFalse:[
		aDBXResultSetDescription addNotSupportedDescription: self.
	].
!

dbxType
"this is the data type of this column, according to its data type from the database"
	^ dbxType
!

dbxType: anObject
	dbxType := anObject
!

name
"this is the name of this column, according to its database name, "
	^name
!

name: aString
	name := aString
!

size
"size of the data type"
	^size
!

size: aNumber
	size := aNumber
!

type
"type of the data that a column description holds"
	^ type
!

type: anObject
	type := anObject
! !

!DBXColumnDescription methodsFor:'printing'!

printOn: aStream
	aStream nextPut: $(.
	self name printOn: aStream.
	aStream nextPut: $:.
	self type printOn: aStream.
	aStream nextPut: $).
! !

!DBXColumnDescription methodsFor:'testing'!

isLarge
"see DBXBackend isLarge"
	^DBXBackend isLarge: self dbxType
! !

!DBXColumnDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXColumnDescription.st,v 1.2 2013-04-15 13:11:30 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/libopenDBX/driver/DBXColumnDescription.st,v 1.2 2013-04-15 13:11:30 cg Exp $'
! !

