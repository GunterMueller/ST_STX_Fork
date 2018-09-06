"{ Package: 'stx:libdb/nosql/mongoDB' }"

MongoOperation subclass:#GetMoreOperation
	instanceVariableNames:'cursorId returnCount'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!GetMoreOperation class methodsFor:'instance creation'!

collection: aString id: idInteger stream: aStream cursorId: cursorInteger returnCount: countInteger
	^(self collection: aString
		id: idInteger
		stream: aStream)
			setCursorId: cursorInteger
			returnCount: countInteger 
! !

!GetMoreOperation methodsFor:'private'!

opCode
	^2005
!

setCursorId: cursorInteger returnCount: countInteger
	cursorId := cursorInteger.
	returnCount := countInteger 
! !

!GetMoreOperation methodsFor:'writing'!

fixedHeaderSize
	^ 32
!

messageSize
	^ collectionBytes size + 1 + self fixedHeaderSize
!

writeBody
	writer
		nextInt32Put: 0;
		nextEncodedStringPut: collectionBytes;
		nextInt32Put: returnCount;
		nextInt64Put: cursorId
! !

!GetMoreOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/GetMoreOperation.st,v 1.1 2013-04-04 21:09:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/GetMoreOperation.st,v 1.1 2013-04-04 21:09:45 cg Exp $'
! !

