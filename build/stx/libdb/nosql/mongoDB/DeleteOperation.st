"{ Package: 'stx:libdb/nosql/mongoDB' }"

MongoOperation subclass:#DeleteOperation
	instanceVariableNames:'query dataBytes'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!DeleteOperation class methodsFor:'instance creation'!

collection: aString id: idInteger stream: aStream query: aDictionary
	^(self
		collection: aString 
		id: idInteger 
		stream: aStream)
			setQuery: aDictionary
! !

!DeleteOperation methodsFor:'private'!

opCode
	^2006
!

setQuery: aDictionary
	query := aDictionary 
! !

!DeleteOperation methodsFor:'writing'!

computeDataBytes
	^ BSON write: query
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

!DeleteOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/DeleteOperation.st,v 1.1 2013-04-04 21:01:34 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/DeleteOperation.st,v 1.1 2013-04-04 21:01:34 cg Exp $'
! !

