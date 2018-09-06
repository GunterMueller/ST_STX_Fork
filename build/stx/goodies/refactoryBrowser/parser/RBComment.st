"{ Package: 'stx:goodies/refactoryBrowser/parser' }"

Object subclass:#RBComment
	instanceVariableNames:'start stop commentType characters startColumn lineNumber'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Parser'
!


!RBComment class methodsFor:'instance creation'!

start:newStart stop:newStop
    ^ self new start:newStart stop:newStop

    "Created: / 6.2.2000 / 14:24:13 / cg"
! !

!RBComment methodsFor:'accessing'!

beEOLComment
    commentType := #eol
!

beTokenComment
    commentType := #token
!

characters
    "return the value of the instance variable 'characters' (automatically generated)"

    ^ characters
!

characters:something
    "set the value of the instance variable 'characters' (automatically generated)"

    characters := something.
!

commentType
    "return the value of the instance variable 'commentType' (automatically generated)"

    ^ commentType

    "Created: / 6.2.2000 / 14:22:09 / cg"
!

commentType:something
    "set the value of the instance variable 'commentType' (automatically generated)"

    commentType := something.

    "Created: / 6.2.2000 / 14:22:09 / cg"
!

first
    ^ start

    "Created: / 6.2.2000 / 14:26:58 / cg"
!

isEOLComment
    ^ commentType == #eol
!

isTokenComment
    ^ commentType == #token
!

last
    ^ stop

    "Created: / 6.2.2000 / 14:27:05 / cg"
!

lineNumber
    lineNumber isNil ifTrue:[self halt:'lineNumber should always be non-nil'].
    ^ lineNumber
!

lineNumber:something
    lineNumber := something.
!

sourceInterval
    "sigh - duplicate code"

    start > stop ifTrue:[^ 1 to: 0].
    ^ start to: stop
!

start
    ^ start

    "Created: / 6.2.2000 / 14:26:58 / cg"
!

start:newStart stop:newStop
    start := newStart.
    stop := newStop.

    "Created: / 6.2.2000 / 14:23:48 / cg"
!

startColumn
    ^ startColumn 
!

startColumn:anInteger
    startColumn := anInteger
! !

!RBComment methodsFor:'displaying'!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ ST/X (and some old ST80's) mean: draw-yourself on a GC.
    (aGCOrStream isStream) ifFalse:[
        ^ super displayOn:aGCOrStream
    ].

    ^ aGCOrStream nextPutAll:characters
! !

!RBComment class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/parser/RBComment.st,v 1.13 2014-07-18 14:51:40 cg Exp $'
! !

