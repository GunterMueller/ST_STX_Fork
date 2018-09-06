"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

Object subclass:#SqueakCommentReader
	instanceVariableNames:'myClass'
	classVariableNames:''
	poolDictionaries:''
	category:'Kernel-Support'
!

!SqueakCommentReader class methodsFor:'documentation'!

documentation
"
    a helper class for fileIn of squeak source code with commentStamp chunks.
    This reader reads the next chunk as a string comment

    [author:]
        Claus Gittinger
"
! !

!SqueakCommentReader methodsFor:'private'!

class:aClass stamp:stampString priorVersion:priorVersion
    myClass := aClass.
! !

!SqueakCommentReader methodsFor:'reading'!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly
    "read a single comment chunk"

    |chunk|

    chunk := aStream nextChunk.
    myClass comment:chunk.
!

fileInFrom:aStream notifying:requestor passChunk:passChunk single:oneChunkOnly silent:beSilent
    "read a single comment chunk"

    |chunk|

    chunk := aStream nextChunk.
    myClass comment:chunk.
! !

!SqueakCommentReader class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

