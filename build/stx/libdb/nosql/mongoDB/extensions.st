"{ Package: 'stx:libdb/nosql/mongoDB' }"!

!Array methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextArrayPut: self
! !

!Association methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextAssociationPut: self
! !

!Boolean methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^8
! !

!Boolean methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextBooleanPut: self
! !

!ByteArray methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^5
! !

!ByteArray methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextByteArrayPut: self
! !

!Date methodsFor:'*Mongo-BSON'!

bsonTypeCode 
	^9
! !

!Date methodsFor:'*Mongo-BSON'!

duration 
	^Duration seconds: self asSeconds  nanoSeconds: 0
! !

!Date methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextDatePut: self
! !

!Dictionary methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^3
! !

!Dictionary methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextDictionaryPut: self
! !

!Integer methodsFor:'*Mongo-BSON'!

bsonTypeCode
	(BSON new isInt32: self) ifTrue: [^16].
	(BSON new isInt64: self) ifTrue: [^18].
	self error: 'Integer too large: ' , self printString
! !

!Integer methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON
	aBSON nextIntegerPut: self
! !

!SequenceableCollection methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^4
! !

!SequenceableCollection methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	self asArray writeBSONOn: aBSON
! !

!String methodsFor:'*Mongo-BSON'!

asBSONRegex
	^BSONRegex value: self
! !

!String methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^2
! !

!String methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextSizedStringPut: self
! !

!Symbol methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^14
! !

!Symbol methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextSymbolPut: self
! !

!TwoByteString methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON
	aBSON nextWideStringPut: self
! !

!UUID methodsFor:'*mongo-bson'!

bsonTypeCode 
	^ 5
! !

!UUID methodsFor:'*mongo-bson'!

writeBSONOn: aBSON
	aBSON nextUUIDPut: self
! !

!UndefinedObject methodsFor:'*Mongo-BSON'!

bsonTypeCode
	^10
! !

!UndefinedObject methodsFor:'*Mongo-BSON'!

writeBSONOn: aBSON 
	aBSON nextNilPut
! !

!stx_libdb_nosql_mongoDB class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/extensions.st,v 1.2 2013-04-04 22:40:04 cg Exp $'
! !
