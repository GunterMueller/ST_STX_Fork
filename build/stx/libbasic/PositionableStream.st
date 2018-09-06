"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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

PeekableStream subclass:#PositionableStream
	instanceVariableNames:'collection position readLimit writeLimit'
	classVariableNames:'ZeroPosition InvalidPositionErrorSignal'
	poolDictionaries:''
	category:'Streams'
!

!PositionableStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2015 Jan Vrany
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
    Instances of PositionableStream allow positioning the read pointer.
    The PositionableStream class also adds methods for source-chunk reading
    and writing, and for filing-in/out of source code.

    This is an abstract class.

    Compatibility Notice:
        In previous versions of ST/X, streams started with a 1-position (i.e. as in collections),
        while ST-80 has always been using 0-based postions for streams and 1-based positions for collections.

        THIS CERTAINLY IS BAD.

        Although this is confusing ST/X has been changed to now also uses 0-based stream positioning.

    [caveat:]
        Basing capabilities like readability/writability/positionability/peekability on inheritance makes
        the class hierarchy ugly and leads to strange and hard to teach redefinitions (aka. NonPositionableStream
        below PositionableStream or ExternalReadStream under WriteStream)

    [author:]
        Claus Gittinger
"
! !

!PositionableStream class methodsFor:'initialization'!

initialize
    ZeroPosition := 0.        "/ changed with stx rel5.1; 
                              "/ rel6.2: no longer used (i.e. 0 has now ben hardcoded)
                              "/ class variable to be eliminated.

    InvalidPositionErrorSignal isNil ifTrue:[
        InvalidPositionErrorSignal := PositionOutOfBoundsError.
        InvalidPositionErrorSignal notifierString:'position out of bounds: '.
    ]
! !

!PositionableStream class methodsFor:'instance creation'!

on:aCollection
    "return a new PositionableStream streaming on aCollection"

    ^ (self basicNew) on:aCollection
!

on:aCollection from:first to:last
    "return a new PositionableStream streaming on aCollection
     from first to last"

    ^ (self basicNew) on:aCollection from:first to:last
!

with:aCollection
    "return a new PositionableStream streaming on aCollection,
     the stream is positioned to the end of the collection."

    ^ (self basicNew) with:aCollection
! !

!PositionableStream class methodsFor:'Signal constants'!

invalidPositionErrorSignal
    "return the signal raised if positioning is attempted to an
     invalid position (i.e. before the begin of the stream or after
     the end)"

    ^ PositionOutOfBoundsError
! !

!PositionableStream class methodsFor:'constants'!

zeroPosition
    "return the number, which marks the initial position.
     Compatibility Notice:
        In previous versions of ST/X, streams started with a 1-position (i.e. as in collections),
        while ST-80 has always been using 0-based postions for streams and 1-based positions for collections.

     Although this is confusing ST/X has been changed to now also use 0-based stream positioning.
    "

    ^ 0

    "Modified: / 13-07-2006 / 20:36:54 / cg"
! !

!PositionableStream class methodsFor:'testing'!

isAbstract
    ^ self == PositionableStream
! !

!PositionableStream methodsFor:'Compatibility-Dolphin'!

endChunk
    self nextPutChunkSeparator
! !

!PositionableStream methodsFor:'Compatibility-ST/V'!

skipTo:anElement
    "ST/V compatibility:
     skip for the element given by the argument, anElement;
     return nil if not found, self otherwise. 
     On a successful match, the next read will return the element after anElement."

    ^ self skipThrough:anElement

    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipTo:$5.
     s copyFrom:1 to:(s position).    
     s upToEnd      
    "
! !

!PositionableStream methodsFor:'Compatibility-Squeak'!

back
        "Go back one element and return it."

        self position = 0 ifTrue: [self positionError].
        self skip: -1.
        ^ self peek

    "Created: / 03-10-2014 / 03:06:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peekBack
        "Return the element at the previous position, without changing position.  Use indirect messages in case self is a StandardFileStream."

        | element |
        element := self back.
        self skip: 1.
        ^ element

    "Created: / 03-10-2014 / 03:06:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

upToAnyOf: aCollection 
        "Answer a subcollection from the current access position to the 
        occurrence (if any, but not inclusive) of any object in the collection. If 
        no matching object is found, answer the entire rest of the receiver."
        ^self upToAnyOf: aCollection do: [:matchingObject | ]

    "Created: / 21-04-2015 / 17:25:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

upToAnyOf: subcollection do: aBlock
        "Answer a subcollection from the current access position to the occurrence (if any, but not inclusive) of any object in the collection.
        Evaluate aBlock with this occurence as argument.
        If no matching object is found, don't evaluate aBlock and answer the entire rest of the receiver."
        
        ^self collection species new: 1000 streamContents: [ :stream |
                | ch |
                [ self atEnd or: [ (subcollection includes: (ch := self next)) and: [aBlock value: ch. true] ] ] 
                        whileFalse: [ stream nextPut: ch ] ]

    "Created: / 21-04-2015 / 17:26:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PositionableStream methodsFor:'accessing'!

collection
    "return the underlying collection buffer.
     Notice, that this buffer may become invalid after being retrieved,
     if more data is written to the stream (because a bigger buffer might be
     allocated). Therefore, it should be only used in special situations,
     where an already filed buffer needs to be backpatched later
     (eg. before being sent out to some external stream or socket)"
    
    ^ collection
!

contents
    "return the entire contents of the stream"

    ^ collection
!

peekForAll:aCollection
    "return true and advance if the next elements are the same
     as aCollection. 
     otherwise stay and let the position unchanged"

    |oldPos|

    oldPos := self position.
    (self next:(aCollection size)) = aCollection ifTrue:[
	^ true
    ].
    self position:oldPos.
    ^ false

    "Created: 1.3.1997 / 15:11:25 / cg"
!

readLimit
    "return the read-limit; that's the position at which EOF is returned"

    ^ readLimit

    "Created: / 30.10.1998 / 16:47:04 / cg"
!

readLimit:aNumber
    "set the read-limit; that's the position at which EOF is returned"

    readLimit := aNumber
!

setCollection:newCollection
    collection := newCollection
!

writeLimit:aNumber
    "set the writeLimit; that's the position after which writing is prohibited"

    writeLimit := aNumber

    "
     |s|
     s := WriteStream on:String new.
     s nextPutAll:'hello world'.
     s contents.

     |s|
     s := WriteStream on:String new.
     s writeLimit:5.
     s nextPutAll:'hello world'.
     s contents.

    "

    "Modified: / 04-06-2007 / 17:21:55 / cg"
! !

!PositionableStream methodsFor:'misc functions'!

copy:numberOfBytes into:aWriteStream
    "read from the receiver, and write numberOfBytes data to another aWriteStream.
     Return the number of bytes which have been transferred.
     Redefined here to avoid intermediate buffers/garbage."

    |endPosition cnt|

    collection notNil ifTrue:[
        endPosition := (position+numberOfBytes) min:readLimit.
        aWriteStream nextPutAll:collection startingAt:position+1 to:endPosition.
        cnt := endPosition - position.
        position := endPosition.
        ^ cnt.
    ].

    ^ super copy:numberOfBytes into:aWriteStream.


    "
      'hello world' readStream copy:5 into:'/tmp/mist' asFilename writeStream.
      'hello world' readStream 
                        copy:5 into:Transcript;
                        copy:20 into:Transcript.
      'hello world' readStream copy:5 into:'' writeStream inspect.
      #[1 2 3 4 5 6 7] readStream copy:2 into:'/tmp/mist' asFilename writeStream binary.
      #[1 2 3 4 5 6 7] readStream copy:3 into:#[] writeStream.
    "

    "
     |rs ws cnt|

     ws := #() writeStream.
     rs := #( 1 2 3 4 a nil true) readWriteStream.
     rs next.
     cnt := rs copyToEndInto:ws bufferSize:0.
     Transcript show:cnt; show:' '; showCR:ws contents.
    "
!

copy:numberOfBytes into:aWriteStream bufferSize:bufferSize
    "read from the receiver, and write numberOfBytes data to another aWriteStream.
     Return the number of bytes which have been transferred.
     Redefined here to avoid intermediate buffers/garbage.
     bufferSize does not matter here."

    collection notNil ifTrue:[
        ^ self copy:numberOfBytes into:aWriteStream.
    ].
    ^ super copy:numberOfBytes into:aWriteStream bufferSize:bufferSize.
!

copyToEndInto:aWriteStream
    "read from the receiver, and write all data up to the end to another stream.
     Return the number of bytes which have been transferred.
     Redefined here to avoid intermediate buffers/garbage."

    |cnt|

    collection notNil ifTrue:[
        aWriteStream nextPutAll:collection startingAt:position+1 to:readLimit.
        cnt := readLimit - position.
        position := readLimit.
        ^ cnt.
    ].
    ^ super copyToEndInto:aWriteStream.

    "
     |rs ws cnt|

     ws := #() writeStream.
     rs := #( 1 2 3 4 a nil true) readWriteStream.
     rs next.
     cnt := rs copyToEndInto:ws bufferSize:0.
     Transcript show:cnt; show:' '; showCR:ws contents.
    "
!

copyToEndInto:aWriteStream bufferSize:bufferSize
    "read from the receiver, and write all data up to the end to another stream.
     Return the number of bytes which have been transferred.
     Redefined here to avoid intermediate buffers/garbage.
     bufferSize does not matter here."

    collection notNil ifTrue:[
        ^ self copyToEndInto:aWriteStream.
    ].
    ^ super copyToEndInto:aWriteStream bufferSize:bufferSize.

    "
     |rs ws cnt|

     ws := #() writeStream.
     rs := #( 1 2 3 4 a nil true) readWriteStream.
     rs next.
     cnt := rs copyToEndInto:ws bufferSize:0.
     Transcript show:cnt; show:' '; showCR:ws contents.
    "
! !

!PositionableStream methodsFor:'non homogenous reading'!

nextBytes:numBytes into:aCollection startingAt:initialIndex
    "return the next numBytes from the stream. If the end is
     reached before, only that many bytes are copyied into the
     collection.
     Returns the number of bytes that have been actually read.
     The receiver must support reading of binary bytes.

     Notice: this method is provided here for protocol completeness
             with externalStreams - it is normally not used with other
             streams."

    |max|

    (collection isByteCollection
     and:[aCollection isByteCollection]) ifTrue:[
        "do it the fast way"
        max := (readLimit - position) min: numBytes.
        aCollection
            replaceBytesFrom:initialIndex 
            to:(initialIndex + max - 1)
            with:collection 
            startingAt:position+1.
        position := position + max.
        ^ max
    ].
    "do it the hard way"
    ^ super nextBytes:numBytes into:aCollection startingAt:initialIndex

    "
     |s n buffer|

     buffer := ByteArray new:10.

     s := ReadStream on:#[1 2 3 4 5 6 7 8 9].
     s next:3.
     n := s nextBytes:9 into:buffer startingAt:1.
     Transcript showCR:('n = %1; buffer = <%2>' bindWith:n with:buffer)
    "
! !

!PositionableStream methodsFor:'positioning'!

backStep
    "move backward read position by one"

    self position:(self position - 1)
!

match: subCollection
    "Set the access position of the receiver to be past the next occurrence of the subCollection. 
     Answer whether subCollection is found.  
     No wildcards, and case does matter."

    | pattern startMatch |

    pattern := ReadStream on: subCollection.
    startMatch := nil.
    [pattern atEnd] whileFalse: [
        self atEnd ifTrue: [^ false].
        (self next) = (pattern next) 
            ifTrue: [pattern position = 1 ifTrue: [startMatch := self position]]
            ifFalse: [
                pattern position: 0.
                startMatch ifNotNil: [
                    self position: startMatch.
                    startMatch := nil
                ]
            ]
    ].
    ^ true

    "
     'abc def ghi' readStream match:'def'; upToEnd
    "
!

position
    "return the read position (0-based)"

    ^ position
!

position0Based
    <resource: #obsolete>
    "return the read position 0-based"

    ^ self position
!

position0Based:index0Based
    <resource: #obsolete>
    "set the read (or write) position"

    self position:index0Based
!

position1Based
    <resource: #obsolete>
    "return the read position 1-based"

    ^ self position + 1
!

position1Based:index1Based
    <resource: #obsolete>
    "set the read (or write) position"

    self position:(index1Based - 1)

    "
     |s|

     s := '1234567890' readStream.
     s next:5.
     s position:1.
     s next:7.       
    "

    "
     |s|

     s := '' writeStream.
     s nextPutAll:'1234567890'.
     s position:5.
     s nextPutAll:'abcdefg'.
     s contents 
    "

    "
     |s|

     s := '' writeStream.
     s nextPutAll:'1234567890'.
     s position:0.
     s nextPutAll:'abcdefg'.
     s contents 
    "
!

position:index0Based
    "set the read (or write) position"

    ((index0Based > readLimit) or:[index0Based < 0]) ifTrue: [^ self positionError:index0Based].
    position := index0Based
!

reset
    "set the read position to the beginning of the collection"

    position := 0.

    "
     |s|

     s := 'hello world' readStream.
     Transcript showCR:(s next:5).
     s reset.
     Transcript showCR:(s next:10).
    "
!

resetPosition
    <resource: #obsolete>
    "set the read position to the beginning of the collection"

    position := 0

    "
     |s|

     s := 'hello world' readStream.
     Transcript showCR:(s next:5).
     s reset.
     Transcript showCR:(s next:10).
    "
!

setToEnd
    "set the read position to the end of the collection.
     #next will return EOF, #nextPut: will append to the stream.
     (same Behavior as FileStream."

    position := readLimit
!

skip:numberToSkip
    "skip the next numberToSkip elements"

    numberToSkip ~~ 0 ifTrue:[
	self position:(self position + numberToSkip)
    ]
!

skipThroughAll:aCollection
    "skip for and through the sequence given by the argument, aCollection;
     return nil if not found, self otherwise. 
     On a successful match, the next read will return elements after aCollection;
     if no match was found, the receiver will be positioned at the end.
     This is redefined here, to make use of positioning."

    |buffer len first idx|

    self isPositionable ifFalse:[
        "/ for non-positionable subclasses
        ^ super skipThroughAll:aCollection
    ].

    len := aCollection size.
    first := aCollection at:1.
    [self atEnd] whileFalse:[
        buffer := self nextAvailable:len.
        buffer size == len ifTrue:[
            buffer = aCollection ifTrue:[
                ^ self
            ].
            "expect more input"
            idx := buffer indexOf:first startingAt:2.
            idx ~~ 0 ifTrue:[
                self skip:(idx - len - 1)
            ].
        ].
    ].
    ^ nil

    "
     |s|
     s := ReadStream on:'12345678901234567890a'.
     s skipThroughAll:'90ab'.
     s upToEnd  
    "
    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipThroughAll:'1234'.
     s upToEnd  
    "
    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipThroughAll:'999'.
     s atEnd  
    "

    "Created: 26.6.1996 / 09:35:35 / cg"
    "Modified: 11.1.1997 / 19:16:38 / cg"
!

skipToAll:aCollection
    "skip for the sequence given by the argument, aCollection;
     return nil if not found, self otherwise. 
     On a successful match, the next read will return elements of aCollection."

    |oldPos buffer len first idx|

    oldPos := self position.
    len := aCollection size.
    first := aCollection at:1.
    [self atEnd] whileFalse:[
        buffer := self nextAvailable:len.
        buffer = aCollection ifTrue:[
            self position:(self position - len).
            ^ self
        ].
        buffer size == len ifTrue:[
            "more input can be expected"
            idx := buffer indexOf:first startingAt:2.
            idx == 0 ifFalse:[
                self position:(self position - len + idx - 1)
            ].
        ].
    ].
    self position:oldPos.
    ^ nil

    "
     |s|
     s := ReadStream on:'12345678901234567890'.
     s skipToAll:'901'.
     s upToEnd  
    "

    "
     |s|
     s := ReadStream on:'1234567890'.
     s skipToAll:'901'.
     s upToEnd  
    "

    "
     |s|
     s := 'Makefile' asFilename readStream.
     [
         (s skipToAll:'EDIT') notNil ifTrue:[
            s next:100.
         ].
     ] ensure:[
        s close.
     ]
    "

    "Modified: 26.6.1996 / 09:28:27 / cg"
    "Created: 26.6.1996 / 09:35:06 / cg"
! !

!PositionableStream methodsFor:'printing & storing'!

printOn:aStream
    aStream nextPutAll:self className; nextPutAll:'(on:'; nextPutAll:collection classNameWithArticle; nextPut:$)

    "
      '' readStream printString
      '' writeStream printString
    "
! !

!PositionableStream methodsFor:'private'!

contentsSpecies
    "return a class of which instances will be returned, when
     parts of the collection are asked for. 
     (see upTo-kind of methods in Stream)"

    ^ collection species
!

on:aCollection
    "setup for streaming on aCollection"

    collection := aCollection.
    readLimit := aCollection size.
    readLimit == 0 ifTrue:[
        self assert:(aCollection isCollection)
    ].
    position := 0
!

on:aCollection from:first to:last
    "setup for streaming on aCollection from first to last"

    collection := aCollection.
    position := first - 1.
    readLimit := last
!

positionError
    "{ Pragma: +optSpace }"

    "report an error when positioning past the end
     or before the beginning."

    ^ PositionOutOfBoundsError raiseRequestWith:nil

    "Modified: / 26.7.1999 / 10:59:13 / stefan"
!

positionError:badPostition
    "{ Pragma: +optSpace }"

    "report an error when positioning past the end
     or before the beginning."

    ^ PositionOutOfBoundsError raiseRequestWith:badPostition
!

with:aCollection
    "setup for streaming to the end of aCollection"

    collection := aCollection.
    readLimit := aCollection size.
    self setToEnd

    "
      (WriteStream with:#(1 2 3 4 5)) 
            nextPut:6;
            contents
    "
! !

!PositionableStream methodsFor:'queries'!

endsBeforePositionWith:aSequenceableCollection
    "answer true, if the elements in aSequenceableCollection
     are at the current end of the stream up to position."

    |sz pos|

    sz := aSequenceableCollection size.
    pos := self position.
    pos < sz ifTrue:[
        ^ false.
    ].
    self contentsSpecies == collection class ifTrue:[
        ^ collection sameContentsFrom:pos+1-sz to:pos as:aSequenceableCollection startingAt:1.
    ].
    self position:pos-sz.
    ^ (self next:sz) = aSequenceableCollection.

    "
        ('' writeStream nextPutAll:'Hello World') endsBeforePositionWith:'World'
        ('' writeStream nextPutAll:'Hello World') endsBeforePositionWith:'Hello World'
        ('' writeStream nextPutAll:'Hello World') endsBeforePositionWith:'Hello Worldx'
        ('' writeStream nextPutAll:'Hello World') endsBeforePositionWith:'Bla'
        ('' writeStream) endsBeforePositionWith:'Bla'
        ('' writeStream) endsBeforePositionWith:''
        ''  endsWith:''
    "
! !

!PositionableStream methodsFor:'reading'!

nextAvailable:count
    collection notNil ifTrue:[
        |end result|

        end := position + count.
        end >= readLimit ifTrue:[
            end := readLimit.
        ].

        result := collection copyFrom:position+1 to:end.
        position := end.
        ^ result.
    ].

    ^ super nextAvailable:count.

    "
        'abc' readStream nextAvailable:1.
        'abc' readStream nextAvailable:2.
        'abc' readStream nextAvailable:3.
        'abc' readStream nextAvailable:4.

        'abc' readStream nextAvailable:2; nextAvailable:2.
        'abc' readStream nextAvailable:3; nextAvailable:3.
    "
!

nextAvailable:count into:aCollection startingAt:initialIndex
    "return the next count objects from the stream. If the end is
     reached before, only that many objects are copyied into the
     collection.
     Returns the number of objects that have been actually read."

    | max |

    collection notNil ifTrue:[
        max := (readLimit - position) min: count.
        aCollection
            replaceFrom: initialIndex
            to: initialIndex+max-1
            with: collection
            startingAt: position+1.
        position := position + max.
        ^ max.
    ].

    ^ super nextAvailable:count into:aCollection startingAt:initialIndex.

    "
     |s n buffer|

     buffer := ByteArray new:10.

     s := ReadStream on:#[1 2 3 4 5 6 7 8 9].
     s next:3.
     n := s nextBytes:9 into:buffer startingAt:1.
     Transcript showCR:('n = %1; buffer = <%2>' bindWith:n with:buffer)
    "
!

peek
    "look ahead for and return the next element"

    |peekObject|

    peekObject := self next.
    self backStep.
    ^ peekObject
!

upToAll:aCollection
    "read until a subcollection consisisting of the elements in aCollection is encountered.
     Return everything read excluding the elements in aCollection.
     The position is left before the collection; i.e. the next
     read operations will return those elements.
     If no such subcollection is encountered, all elements up to the end 
     are read and returned.
     See also #throughAll: which also reads up to some objects
     but positions behind it and DOES include it in the returned
     collection.
     See also #upToAllExcluding:, which returns the same, but leaves the
     read pointer after the matched subcollection.

     Note: this behavior is inconsistent with the other upTo.. methods,
           which position after the found item. We implement the method
           this way for the sake of ST80-compatibility."

    "/ in the future, this will have the Squeak semantics, which is upToAllExcluding:

    ^ self upToAll_positionBefore:aCollection

    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript show:'<'; show:(s upToAll:'wo'); showCR:'>'. 
     Transcript showCR:s atEnd.
     Transcript show:'<'; show:(s upToEnd); showCR:'>'. 
    "
    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript show:'<'; show:(s upToAll:'wo'); showCR:'>'. 
     Transcript showCR:s atEnd.
     Transcript show:'<'; show:(s upToAll:'wo'); showCR:'>'. 
    "
    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript show:'<'; show:(s upToAll:'xx'); showCR:'>'. 
     Transcript showCR:s atEnd.
     Transcript show:'<'; show:(s upToEnd); showCR:'>'. 
    "

    "Modified: / 12.1.1998 / 22:06:42 / cg"
    "Created: / 12.1.1998 / 22:07:01 / cg"
!

upToAll_positionBefore:aCollection
    "read until a subcollection consisisting of the elements in aCollection is encountered.
     Return everything read excluding the elements in aCollection.
     The position is left before the collection; i.e. the next
     read operations will return those elements.
     If no such subcollection is encountered, all elements up to the end 
     are read and returned.
     See also #throughAll: which also reads up to some objects
     but positions behind it and DOES include it in the returned
     collection."

    |answerStream element last|

    last := aCollection last.
    answerStream := WriteStream on:(self contentsSpecies new:100).
    [(element := self nextOrNil) notNil] whileTrue:[
        answerStream nextPut:element.
        (element = last and:[answerStream endsBeforePositionWith:aCollection]) ifTrue:[
            |backStep|
            backStep := aCollection size negated.
            self skip:backStep.
            answerStream skip:backStep.
            ^ answerStream contents
        ].
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript show:'<'; show:(s upToAll_positionBefore:'wo'); showCR:'>'. 
     Transcript showCR:s atEnd.
     Transcript show:'<'; show:(s upToEnd); showCR:'>'. 
    "
    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript show:'<'; show:(s upToAll_positionBefore:'wo'); showCR:'>'. 
     Transcript showCR:s atEnd.
     Transcript show:'<'; show:(s upToAll_positionBefore:'wo'); showCR:'>'. 
    "
    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript show:'<'; show:(s upToAll_positionBefore:'xx'); showCR:'>'. 
     Transcript showCR:s atEnd.
     Transcript show:'<'; show:(s upToEnd); showCR:'>'. 
    "

    "Modified: / 12.1.1998 / 22:06:42 / cg"
    "Created: / 12.1.1998 / 22:07:01 / cg"
!

upToEnd
    collection notNil ifTrue:[
        |result|

        result := collection copyFrom:position+1 to:readLimit.
        position := readLimit.
        ^ result.
    ].

    ^ super upToEnd.

    "
        'abc' readStream upToEnd.
    "
! !

!PositionableStream methodsFor:'reading-strings'!

nextLine
    "return the characters upTo (but excluding) the next cr (carriage return)
     character (i.e. read a single line of text).
     If the previous-to-last character is a cr, this is also removed,
     so it's possible to read alien (i.e. ms-dos) text as well.
     Added for protocol compatibility with externalStreams."

    |start "{ Class:SmallInteger }" 
     end "{ Class:SmallInteger }"|

    collection isString ifTrue:[
        position == readLimit ifTrue:[
            ^ self pastEndRead
        ].
        start := position+1.
        end := collection indexOf:Character cr startingAt:start.

        (end == 0 or:[end > readLimit]) ifTrue:[
            end := position := readLimit.
        ] ifFalse:[
            position := end.
            end := end - 1.    "skip lf"
        ].
        start > end ifTrue:[
            ^ ''.
        ].
        (collection at:end) == Character return ifTrue:[
            end := end - 1.    "skip return"
        ].
        ^ collection copyFrom:start to:end.
    ].
    ^ super nextLine.

    "
        '12345678' readStream nextLine
        '12345678' allBold readStream nextLine
        '12\34\56\78' withCRs readStream nextLine
        '12\34\56\78' withCRs readStream nextLine; nextLine
        (ReadStream on:('12\34\56\78' withCRs) from:1 to:4) nextLine; nextLine
        ('12\' withCRs, Character return, '34') readStream nextLine; nextLine
        Character cr asString readStream nextLine
        Character return asString readStream nextLine
        (Character return, Character cr) asString readStream nextLine
        Character return asString readStream nextLine; nextLine
    "
! !

!PositionableStream methodsFor:'testing'!

atEnd
    "return true, if the read-position is at the end"

    ^ position >= readLimit
!

isEmpty
    "return true, if the contents of the stream is empty"

    ^ readLimit == 0
!

isInternalByteStream
    "return true, if the stream is an internal stream reading bytes"

    ^ collection class isBytes

    "Created: / 30-05-2007 / 16:16:12 / cg"
!

isPositionable
    "return true, if the stream supports positioning (this one is)"

    ^ true
! !

!PositionableStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


PositionableStream initialize!
