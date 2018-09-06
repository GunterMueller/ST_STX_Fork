"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

PeekableStream subclass:#ActorStream
	instanceVariableNames:'nextPutBlock nextPutAllBlock nextPutLineBlock nextBlock
		atEndBlock peekBlock contentsSpecies'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!ActorStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    This class provides a hook for general objects to behave like Stream objects.
    To the outside, actorStreams behave like streams and respond to the
    usual stream messages (i.e. nextPut:, nextPutAll: etc).
    In the inside, for every nextPut-message, the nextPutBlock is evaluated
    passing the argument of nextPut: as block argument.

    These blocks are to be provided by the user of the ActorStream.
    Example use is in the Transcript, which is made Stream-like this way.

    [Instance variables:]
        nextPutBlock    <Block>   the block to evaluate for nextPut:-messages
        nextPutAllBlock <Block>   same for nextPutAll:-messages
        nextBlock       <Block>   the Block to evaluate for the next element

    [author:]
        Claus Gittinger

    [See also:]
        TextCollector

"
! !

!ActorStream class methodsFor:'instance creation'!

new
    "have to re-allow new - it was disabled in Stream"
    ^ self basicNew
! !

!ActorStream methodsFor:'accessing'!

contentsSpecies
    "return a class of which instances will be returned, when
     parts of the collection are asked for. 
     (see upTo-kind of methods in Stream)"

    ^ contentsSpecies ? String
!

contentsSpecies:something
    contentsSpecies := something.
! !

!ActorStream methodsFor:'accessing-read/write'!

next
    "return the next element from the stream by evaluating the nextBlock"

    nextBlock notNil ifTrue:[
        ^ nextBlock value
    ].
    self error:'action for next is undefined'
!

nextPut:something
    "put something onto the stream by evaluating the nextPutBlock with
     something as argument"

    nextPutBlock notNil ifTrue:[  
        ^ nextPutBlock value:something
    ].
    nextPutAllBlock notNil ifTrue:[    
        "/ fallBack to nextPutAll.
        self nextPutAll:(something asString).
        ^ self
    ].
    self error:'action for nextPut:/nextPutAll: are undefined'

    "Modified: / 28.1.2002 / 20:59:32 / micha"
!

nextPutAll:something
    "put all elements of something onto the stream by evaluating
     the nextPutAllBlock with something as argument.
     If there is no nextPutAllBlock, nextPuts will be used (as inherited)"

    nextPutAllBlock notNil ifTrue:[    
        ^ nextPutAllBlock value:something
    ].
    super nextPutAll:something
!

nextPutAll:count from:buffer startingAt:start
    "put some elements of something onto the stream by evaluating
     the nextPutAllBlock with something as argument.
     If there is no nextPutAllBlock, nextPuts will be used (as inherited)"

    nextPutAllBlock notNil ifTrue:[    
        nextPutAllBlock value:(buffer copyFrom:start to:start+count-1).
        ^ count
    ].
    ^ super nextPutAll:count from:buffer startingAt:start
!

nextPutAll:something startingAt:start to:stop
    "put some elements of something onto the stream by evaluating
     the nextPutAllBlock with something as argument.
     If there is no nextPutAllBlock, nextPuts will be used (as inherited)"

    nextPutAllBlock notNil ifTrue:[    
        ^ nextPutAllBlock value:(something copyFrom:start to:stop)
    ].
    super nextPutAll:something startingAt:start to:stop
!

nextPutByte:something
    "put something onto the stream by evaluating the nextPutBlock with
     something as argument"

    self nextPut:(something asCharacter)

    "Created: 6.8.1997 / 00:44:32 / cg"
!

nextPutLine:something
    "put the line onto the stream by evaluating
     the nextPutLineBlock with something as argument.
     If there is no nextPutLineBlock, nextPutAll/nextPut will be used (as inherited)"

    nextPutLineBlock notNil ifTrue:[    
        ^ nextPutLineBlock value:something
    ].
    super nextPutLine:something
!

peek
    "peek ahead for return the next element from the stream by evaluating the peekBlock"

    peekBlock notNil ifTrue:[
        ^ peekBlock value
    ].
    self error:'action for peek is undefined'
! !

!ActorStream methodsFor:'converting'!

readStream
    "return a readStream from the receiver. 
     Since this is (hopefully) already a readStream, return self."

    ^ self
! !

!ActorStream methodsFor:'defining actions'!

atEndBlock:aBlock
    "define the block to be evaluated for every atEnd-message"

    atEndBlock := aBlock
!

nextBlock:aBlock
    "define the block to be evaluated for every next-message"

    nextBlock := aBlock
!

nextPutAllBlock:aBlock
    "define the block to be evaluated for every nextPutAll-message.
     If undefined, nextPuts will be used (as inherited)"

    nextPutAllBlock := aBlock
!

nextPutBlock:aBlock
    "define the block to be evaluated for every nextPut-message"

    nextPutBlock := aBlock
!

nextPutLineBlock:aBlock
    "define the block to be evaluated for every nextPutLineBlock-message.
     If undefined, nextPutAll/nextPut will be used (as inherited)"

    nextPutLineBlock := aBlock
!

peekBlock:aBlock
    "define the block to be evaluated for every peek-message"

    peekBlock := aBlock
! !

!ActorStream methodsFor:'queries'!

atEnd
    "return true, if at the end - actorStreams are never"

    atEndBlock isNil ifTrue:[
        ^ false
    ].
    ^ atEndBlock value
! !

!ActorStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/ActorStream.st,v 1.14 2015-03-13 10:37:49 stefan Exp $'
! !

