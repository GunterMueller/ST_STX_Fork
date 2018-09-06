"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

PeekableStream subclass:#MultiReadStream
	instanceVariableNames:'streamStack'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!MultiReadStream class methodsFor:'documentation'!

documentation
"
    Stacked streams. At any time, another stream can be stacked onto
    a stream stack. Making this stream's contents to be returned before the
    rest. To the stream reader, this looks like a single stream delivering the
    embedded stream contents sequentially.

    Useful when reading files which include each other, or to handle
    define-macro expansion in a c-parser.

    [Author:]
        Claus Gittinger

    [instance variables:]
"

    "Created: / 21-05-2010 / 14:34:48 / cg"
!

examples
"
    |s|

    s := MultiReadStream on:('abcd' readStream).
    self assert:(s peek == $a).
    self assert:(s next == $a).
    s pushInputStream:('1234' readStream).
    self assert:(s next == $1).
    self assert:(s next == $2).
    s pushInputStream:('aa' readStream).
    self assert:(s next == $a).
    self assert:(s next == $a).
    self assert:(s atEnd not).
    self assert:(s next == $3).
    self assert:(s next == $4).
    self assert:(s next == $b).
    self assert:(s next == $c).
    self assert:(s next == $d).
    self assert:(s atEnd).
    self assert:(s peek == nil).
    self assert:(s next == nil).
"

    "Created: / 21-05-2010 / 14:27:53 / cg"
! !

!MultiReadStream class methodsFor:'instance creation'!

on:aReadStream
    ^ self basicNew pushInputStream:aReadStream

    "Created: / 21-05-2010 / 14:26:03 / cg"
! !

!MultiReadStream methodsFor:'private'!

checkCurrentStreamAtEnd
    [streamStack size > 1 and:[streamStack last atEnd]] whileTrue:[
        "keep the last stream, so that the #position kludge will work"
        self popInputStream
    ].

    "Created: / 21-05-2010 / 14:30:20 / cg"
! !

!MultiReadStream methodsFor:'stream protocol'!

atEnd
    self checkCurrentStreamAtEnd.
    ^ streamStack isEmptyOrNil or:[streamStack last atEnd]

    "Created: / 21-05-2010 / 14:31:48 / cg"
!

contentsSpecies 
    "return a class of which instances will be returned, when
     parts of the collection are asked for. 
     (see upTo-kind of methods in Stream)"

    streamStack isEmptyOrNil ifTrue:[^ super contentsSpecies].
    ^ streamStack first contentsSpecies

    "Created: / 21-05-2010 / 14:44:26 / cg"
!

next
    self checkCurrentStreamAtEnd.
    streamStack isEmptyOrNil ifTrue:[^ self pastEndRead].
    ^ streamStack last next

    "Created: / 21-05-2010 / 14:31:23 / cg"
!

peek
    self checkCurrentStreamAtEnd.
    streamStack isEmptyOrNil ifTrue:[^ self pastEndRead].
    ^ streamStack last peek

    "Created: / 21-05-2010 / 14:29:06 / cg"
!

position
    "/ that's debatable !!
    "/ the code below only makes sense, if we see the multiStream as some kind of
    "/ macro-expanding c-define stream

    streamStack isEmptyOrNil ifTrue:[
        "we assume we are at the beginning"
        ^ 0
    ].
    ^ streamStack first position

    "Created: / 21-05-2010 / 14:52:40 / cg"
!

position0Based
    <resource: #obsolete>
    ^ self position

    "Created: / 21-05-2010 / 14:52:40 / cg"
!

position1Based
    <resource: #obsolete>
    ^ self position + 1

    "Created: / 21-05-2010 / 14:52:40 / cg"
!

readStream
    ^ self

    "Created: / 21-05-2010 / 14:51:05 / cg"
! !

!MultiReadStream methodsFor:'stream stacking'!

popInputStream
    streamStack removeLast

    "Created: / 21-05-2010 / 14:25:30 / cg"
!

pushInputStream:aReadStream
    streamStack isNil ifTrue:[
        streamStack := OrderedCollection new.
    ].
    streamStack add:aReadStream

    "Created: / 21-05-2010 / 14:25:17 / cg"
! !

!MultiReadStream class methodsFor:'documentation'!

version_CVS
    ^ '$Header$'
! !

