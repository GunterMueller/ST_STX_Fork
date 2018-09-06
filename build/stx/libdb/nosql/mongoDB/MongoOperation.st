"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#MongoOperation
	instanceVariableNames:'id writer collectionBytes'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!MongoOperation class methodsFor:'private-instance creation'!

collection: aString id: idInteger stream: aStream
	^ self new
		setCollection: aString
		id: idInteger
		stream: aStream
! !

!MongoOperation methodsFor:'private'!

setCollection: aString id: idInteger stream: aStream
	id := idInteger.
	writer := LittleEndianStream on: aStream.
	collectionBytes := writer encode: aString
	
! !

!MongoOperation methodsFor:'writing'!

flush
	writer flush
!

write
	self writeHeader.
	self writeBody.
	self flush
!

writeHeader
	writer
		nextInt32Put: self messageSize;
		nextInt32Put: id;
		nextInt32Put: 0;
		nextInt32Put: self opCode
! !

!MongoOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoOperation.st,v 1.1 2013-04-04 20:56:18 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoOperation.st,v 1.1 2013-04-04 20:56:18 cg Exp $'
! !

