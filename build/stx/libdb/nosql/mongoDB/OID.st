"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#OID
	instanceVariableNames:'value'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-BSON'
!


!OID class methodsFor:'instance creation'!

nextOID
	^self value: (UUIDGenerator default makeSeed)
!

value: anInteger 
	^self new setValue: anInteger
! !

!OID methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^7
! !

!OID methodsFor:'Mongo'!

writeBSONOn: aBSON 
	aBSON nextOIDPut: self
! !

!OID methodsFor:'accessing'!

value
	^value
! !

!OID methodsFor:'as yet unclassified'!

printOn: aStream 
	aStream 
		nextPutAll: 'OID';
		nextPut: $(;
		nextPutAll: self value asString;
		nextPut: $)
! !

!OID methodsFor:'comparing'!

= anObject
	^anObject class = self class and: [anObject value = self value]
!

hash
	^value hash
! !

!OID methodsFor:'private'!

setValue: anInteger 
	value := anInteger
! !

!OID class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/OID.st,v 1.1 2013-04-04 21:55:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/OID.st,v 1.1 2013-04-04 21:55:00 cg Exp $'
! !

