"{ Package: 'stx:libdb/nosql/mongoDB' }"

MongoOperation subclass:#InsertOperation
	instanceVariableNames:'objects dataBytes'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!InsertOperation class methodsFor:'instance creation'!

collection: aString id: idInteger stream: aStream objects: aCollection
	^(self collection: aString
		id: idInteger
		stream: aStream)
			setObjects: aCollection 
! !

!InsertOperation methodsFor:'private'!

opCode
	^2002
!

setObjects: aCollection
	objects := aCollection
! !

!InsertOperation methodsFor:'writing'!

computeDataBytes
	^ BSON writeAll: objects
!

dataBytes
	^dataBytes ifNil: [dataBytes := self computeDataBytes]
!

fixedHeaderSize
	^ 20
!

messageSize
	^ self dataBytes size + collectionBytes size + 1 + self fixedHeaderSize
!

writeBody
	writer
		nextInt32Put: 0;
		nextEncodedStringPut: collectionBytes;
		nextBytesPut: self dataBytes
! !

!InsertOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/InsertOperation.st,v 1.1 2013-04-04 21:08:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/InsertOperation.st,v 1.1 2013-04-04 21:08:03 cg Exp $'
! !

