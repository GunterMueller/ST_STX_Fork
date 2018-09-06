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
"{ Package: 'stx:libbasic' }"

"{ NameSpace: Smalltalk }"

WriteStream subclass:#ReadWriteStream
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!ReadWriteStream class methodsFor:'documentation'!

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
    ReadWriteStreams allow both read- and write-access to some collection.
    To allow this, they reenable some methods blocked in WriteStream.
    (being one of the seldom places, where multiple inheritance could be
     of good use in smalltalk).

    [caveat:]
        Basing capabilities like readability/writability/positionability/peekability on inheritance makes
        the class hierarchy ugly and leads to strange and hard to teach redefinitions (aka. NonPositionableStream
        below PositionableStream or ExternalReadStream under WriteStream)

    Claus:
        I personally find the ReadStream - WriteStream - ReadWriteStream
        organization brain-damaged. It would be better to have an attribute
        (such as readOnly / writeOnly / readWrite) in an InternalStream subclass 
        of Stream ...

    [author:]
        Claus Gittinger
"
!

examples
"
    |s|

    s := ReadWriteStream with:'abcd'.
    s reset.
    s nextPut:$A.
    s contents       
"
! !

!ReadWriteStream methodsFor:'access-reading'!

next
    "return the next element; advance read position.
     If there are no more elements, nil is returned."

    |element|

    (position >= readLimit) ifTrue:[^ self pastEndRead].
    element := collection at:(position+1).
    position := position + 1.
    ^ element

    "Modified: 5.2.1996 / 21:57:40 / stefan"
!

next:count
    "return the next count elements of the stream as aCollection,
     which depends on the streams type - (see #contentsSpecies)."

    |answer|

    self contentsSpecies == collection class ifTrue:[
        ((position + count) > readLimit) ifFalse:[
            answer := collection copyFrom:position+1 to:position+count.
            position := position+count.
            ^ answer
        ].
    ].
    ^ super next:count
! !

!ReadWriteStream methodsFor:'accessing'!

clear
    "re-initialize the stream to write to the beginning and
     to not read any data."

    position := readLimit := 0.
!

contents
    "return the contents as written so far;
     redefined to prevent confusion resulting due to 
     my superclasses optimization. (see WriteStream contents).
     ST80 users of ReadWriteStream may expect the contents array to remain
     unchanged, which we do not guarantee."

    readLimit := (readLimit ? 0) max:position.
    ^ collection copyFrom:1 to:readLimit

    "Created: / 30.10.1997 / 16:25:22 / cg"
    "Modified: / 30.10.1997 / 18:37:09 / cg"
!

reset
    "set the read position to the beginning of the collection.
     Because I am a read/write stream, the readLimit is set to the current write position.
     Thus, the just written data can be read back."

    readLimit := position max:readLimit.
    position := 0.
!

resetPosition
    <resource: #obsolete>
    "set the read position to the beginning of the collection.
     Because I am a read/write stream, the readLimit is set to the current write position.
     Thus, the just written data can be read back."

    readLimit := position max:readLimit.
    position := 0.
! !

!ReadWriteStream methodsFor:'converting'!

readStream
    "return the receiver as a readStream - that's myself"

    ^ self

    "Created: 29.11.1995 / 22:04:23 / stefan"
!

readStreamOrNil
    "return a readStream from the receiver. Since this is already
     a readStream, return self.

     This method has been defined for protocol copmatibility with Filename"

    ^ self
! !

!ReadWriteStream methodsFor:'initialization'!

with:initialCollection
    "redefined from WriteStream, to position to the beginning of the stream"

    super with:initialCollection.
    position := 0.
! !

!ReadWriteStream methodsFor:'queries'!

isReadable 
    "return true if the receiver supports reading - that's true"

    ^ true
!

size
    "return the number of elements in the streamed collection."

    ^ (readLimit ? 0) max:(position ? 0).
! !

!ReadWriteStream methodsFor:'reading'!

peek
    "return the element to be read next without advancing read position.
     If there are no more elements, nil is returned."

    (position >= readLimit) ifTrue:[^ self pastEndRead].
    ^ collection at:(position+1)

    "Modified: 5.2.1996 / 21:57:47 / stefan"
! !

!ReadWriteStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

