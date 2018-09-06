"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#MongoCursor
	instanceVariableNames:'root query'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!MongoCursor class methodsFor:'instance creation'!

root: aMongo query: aMongoQuery
	^self new
		root: aMongo;
		query: aMongoQuery.
! !

!MongoCursor methodsFor:'accessing'!

query
	^ query
!

query: anObject
	query := anObject
!

root
	^ root
!

root: anObject
	root := anObject
! !

!MongoCursor methodsFor:'executing'!

execute
	| limit reply numberReturned |
	numberReturned := 0.
	limit := query limit.
	limit = 0 
		ifTrue: [limit := Float infinity ].
	limit < query chunkSize 
		ifTrue: [ query chunkSize: limit ].
	[reply isNil
		ifTrue: [ root cursorQuery: query ]
		ifFalse:
			[ root
				getMore: reply cursorId
				collection: query fullCollectionName
				chunkSize: query chunkSize ].
	reply := (ReplyOperation stream: root stream) read.
	reply do: [:each |
		numberReturned < limit ifTrue: [
			query doBlock value: each.
			numberReturned := numberReturned + 1]].
	reply isFinished or: [ numberReturned >= limit] ] whileFalse
! !

!MongoCursor class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoCursor.st,v 1.1 2013-04-04 21:03:24 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/MongoCursor.st,v 1.1 2013-04-04 21:03:24 cg Exp $'
! !

