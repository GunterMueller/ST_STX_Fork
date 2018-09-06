"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#BSONRegex
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-BSON'
!


!BSONRegex class methodsFor:'instance creation'!

value: aString
	^self basicNew 
		initialize: aString;
		yourself
! !

!BSONRegex methodsFor:'accessing'!

bsonTypeCode 
	^11
!

value 
	^value
! !

!BSONRegex methodsFor:'initialization'!

initialize: aString 
	value := aString.
	self initialize
! !

!BSONRegex methodsFor:'printing'!

printOn: aStream 
	aStream 
		nextPut: $/;
		nextPutAll: self value;
		nextPut: $/;
		nextPut: $i
! !

!BSONRegex methodsFor:'writing'!

writeBSONOn: aBSON 
	aBSON nextRegexPut: self
! !

!BSONRegex class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/BSONRegex.st,v 1.1 2013-04-04 21:53:22 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/BSONRegex.st,v 1.1 2013-04-04 21:53:22 cg Exp $'
! !

