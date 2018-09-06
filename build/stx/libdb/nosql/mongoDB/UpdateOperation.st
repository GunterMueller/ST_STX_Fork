"{ Package: 'stx:libdb/nosql/mongoDB' }"

MongoOperation subclass:#UpdateOperation
	instanceVariableNames:'originalObject newObject dataBytes'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!UpdateOperation class methodsFor:'instance creation'!

collection: aString id: idInteger stream: aStream originalObject: origDictionary newObject: newDictionary
	^(self collection: aString
		id: idInteger
		stream: aStream)
			originalObject: origDictionary;
			newObject: newDictionary
! !

!UpdateOperation methodsFor:'accessing'!

newObject: anObject 
	newObject := anObject
!

originalObject: anObject 
	originalObject := anObject
! !

!UpdateOperation methodsFor:'private'!

opCode
	^2001
! !

!UpdateOperation methodsFor:'writing'!

computeDataBytes
	^ BSON writeAll: (Array 
		with: originalObject
		with: newObject)
!

dataBytes
	^dataBytes ifNil: [dataBytes := self computeDataBytes]
!

fixedHeaderSize
	^ 24
!

messageSize
	^ self dataBytes size + collectionBytes size + 1 + self fixedHeaderSize
!

writeBody
	writer
		nextInt32Put: 0;
		nextEncodedStringPut: collectionBytes;
		nextInt32Put: 0;
		nextBytesPut: self dataBytes
! !

!UpdateOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/UpdateOperation.st,v 1.1 2013-04-04 21:00:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/UpdateOperation.st,v 1.1 2013-04-04 21:00:44 cg Exp $'
! !

