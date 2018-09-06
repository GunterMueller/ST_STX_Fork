"{ Package: 'stx:libdb/nosql/mongoDB' }"

Object subclass:#ReplyOperation
	instanceVariableNames:'stream cursorId startingFrom returnCount responseTo id'
	classVariableNames:''
	poolDictionaries:''
	category:'DataBase-Mongo-Core'
!


!ReplyOperation class methodsFor:'instance creation'!

stream: aStream
	^self new setStream: aStream 
! !

!ReplyOperation methodsFor:'accessing'!

cursorId
	^cursorId
!

returnCount
	^returnCount 
! !

!ReplyOperation methodsFor:'enumerating'!

do: aBlock
	returnCount timesRepeat: [aBlock value: (BSON read: stream)]
! !

!ReplyOperation methodsFor:'private'!

setStream: aStream
	stream := aStream
! !

!ReplyOperation methodsFor:'reading'!

read
	| formatter size opCode responseFlag |
	formatter := LittleEndianStream on: stream.
	size := formatter nextInt32.
	id := formatter nextInt32.
	responseTo := formatter nextInt32.
	opCode := formatter nextInt32.	"should be 1"
	responseFlag := formatter nextInt32.	"should be 0"
	cursorId := formatter nextInt64.
	startingFrom := formatter nextInt32.
	returnCount := formatter nextInt32	"Element count"
! !

!ReplyOperation methodsFor:'testing'!

isFinished
	^cursorId = 0
! !

!ReplyOperation class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/ReplyOperation.st,v 1.1 2013-04-04 21:07:10 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libdb/nosql/mongoDB/ReplyOperation.st,v 1.1 2013-04-04 21:07:10 cg Exp $'
! !

