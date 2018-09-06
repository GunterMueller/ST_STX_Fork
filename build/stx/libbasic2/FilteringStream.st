"
 COPYRIGHT (c) 1996 by Claus Gittinger
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

PeekableStream subclass:#FilteringStream
	instanceVariableNames:'inputStream outputStream filter readAhead'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!FilteringStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by Claus Gittinger
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
    A FilteringStream can be connected to some input
    (from which elements are read via the ReadStream protocol),
    and/or to some output (to which elements are written via
    the WriteStream protocol.

    The FilteringStream itself performs filtering/processing
    on the elements as they arrive, optionally suppressing
    elements.

    A FilteringStream can be operated in pull-mode, by asking
    it for the next element; it will then ask its inputStream for
    and element, process it and return it.

    Or, in pushMode, by having someone else writing elements via
    nextPut:; it will then process the element, and send it to its
    output stream.

    Mixing modes does not make sense, since if pulled, data will not
    be written to the outputStream (unless the puller does it).

    The connected streams need not be real streams; anything which
    responds to the basic Stream protocol can be connected
    (a Transcript, a RandomNumber generator or even a Plug will do as well).

    Similar, but not quite the same as SelectingReadStream / CollectingReadStream.

    [instance variables:]
        inputStream     <Stream>  the stream from which elements are read
        outputStream    <Stream>  the stream to which elements are written
        filter          <Block>   the filter block;
        unbound         <Boolean> if true, the stream is unbound.

    [author:]
        Claus Gittinger

    [See also:]
        ReadStream WriteStream
"
!

examples
"
  pushing the contents of a stream onto another stream
  (here, the Transcript) without a need to read everything into a
  buffer or to reinvent the read-loop:
  (notice, a FilteringLineStream does this with less overhead,
   due to the byte-wise reading done here)
                                                                [exBegin]
    |in pusher|

    in := 'Make.proto' asFilename readStream.
    pusher := FilteringStream readingFrom:in writingTo:Transcript.
    pusher filterUpToEnd
                                                                [exEnd]


  filter random numbers in [0.5 .. 0.6]:
                                                                [exBegin]
    |in filter|

    in := Random new.

    filter := FilteringStream readingFrom:in.
    filter filter:[:num | ((num >= 0.5) and:[num <= 0.6]) ifTrue:[num] ifFalse:[nil]].

    20 timesRepeat:[
        Transcript showCR:(filter next printString).
    ]
                                                                [exEnd]
 compute the values times two
                                                                [exBegin]
    |filter|

    filter := FilteringStream 
                readingFrom:#(1 2 3 4 5 6 7 8 9 10) readStream
                writingTo:#() writeStream.
    filter filter:[:num | num * 2].
    filter contents inspect.
                                                                [exEnd]


  filtering prime numbers (that's just a demo - not really useful, because we will end
  in a recursion error if many filters are stacked):
                                                                [exBegin]
    |num generator primeFilter addFilter|

    num := 1.
    generator := Plug new.
    generator respondTo:#next
                   with:[num := num + 1. num].
    generator respondTo:#atEnd
                   with:[false].

    addFilter := [:prime | |newFilter|
        newFilter := FilteringStream basicNew.
        newFilter filter:[:num | (num \\ prime) == 0 ifTrue:[
                                    nil
                                 ] ifFalse:[
                                    num
                                 ]
                         ].
        newFilter inputStream:primeFilter.
        primeFilter := newFilter
    ].

    addFilter value:2.
    primeFilter inputStream:generator.

    1000 timesRepeat:[
        |nextPrime|

        nextPrime := primeFilter next.
        addFilter value:nextPrime.
        Transcript showCR:nextPrime.
    ]
                                                                [exEnd]
"
! !

!FilteringStream class methodsFor:'instance creation'!

new
    "create and return a new filteringStream.
     The resulting stream must be connected to some other stream,
     before being used"

    ^ self basicNew initialize.

    "Created: 11.1.1997 / 15:31:30 / cg"
    "Modified: 11.1.1997 / 15:33:13 / cg"
!

on:something
    "create and return a new filteringStream, which reads from
     something (which must be convertable to a stream)"

    ^ self readingFrom:something readStream

    "Created: 11.1.1997 / 19:19:34 / cg"
!

readingFrom:aReadStream
    "create and return a new filteringStream, which reads from
     another stream"

    ^ (self basicNew inputStream:aReadStream) initialize.

    "Created: 11.1.1997 / 15:32:15 / cg"
!

readingFrom:aReadStream writingTo:aWriteStream
    "create and return a new filteringStream, which reads from
     aReadStream and writes to aWriteStream."

    |newStream|

    newStream := self basicNew.
    newStream inputStream:aReadStream.
    newStream outputStream:aWriteStream.
    newStream initialize.
    ^ newStream

    "Created: 11.1.1997 / 15:32:28 / cg"
!

writingTo:aWriteStream
    "create and return a new filteringStream, which writes to
     another stream"

    ^ (self basicNew outputStream:aWriteStream) initialize.

    "Created: 11.1.1997 / 15:32:36 / cg"
! !

!FilteringStream methodsFor:'access - pull-reading'!

contents
    self filterUpToEnd.
    ^ outputStream contents
!

filterUpToEnd
    "pull input from inputStream up to the end,
     push it filtered into the outputStream."

    [inputStream atEnd] whileFalse:[
	self nextPut:(inputStream next)
    ].

    "Created: 2.7.1996 / 21:06:42 / cg"
    "Modified: 11.1.1997 / 16:08:35 / cg"
!

next
    "pull input from inputStream and
     push it filtered into the outputStream"

    |input output|

    "/ readAhead input has already been filtered
    "/ (see #atEnd)

    readAhead notNil ifTrue:[
	input := readAhead.
	readAhead := nil.
	^ input
    ].

    [inputStream atEnd] whileFalse:[
	"/ get an element
	input := inputStream next.
	filter isNil ifTrue:[
	    ^ input
	].

	"/ filter it - this may return nil, to eat it
	output := filter value:input.
	output notNil ifTrue:[
	    "/ good - output it
	    ^ output.
	].
    ].
    ^ nil

    "Created: 2.7.1996 / 21:09:58 / cg"
    "Modified: 11.1.1997 / 17:17:27 / cg"
!

peek
    "peek ahead for the next character"

    |input output|

    readAhead notNil ifTrue:[
	^ readAhead
    ].

    [inputStream atEnd] whileFalse:[
	"/ get an element
	input := inputStream peek.
	filter isNil ifTrue:[
	    ^ input
	].

	"/ filter it - this may return nil, to eat it
	inputStream next.
	output := filter value:input.
	output notNil ifTrue:[
	    "/ good - output it
	    readAhead := output.
	    ^ output.
	].
    ].
    ^ self pastEndRead

!

peekOrNil
    "peek ahead for the next character, or return nil"

    |input output|

    readAhead notNil ifTrue:[
	^ readAhead
    ].

    [inputStream atEnd] whileFalse:[
	"/ get an element
	input := inputStream peek.
	filter isNil ifTrue:[
	    ^ input
	].

	"/ filter it - this may return nil, to eat it
	inputStream next.
	output := filter value:input.
	output notNil ifTrue:[
	    "/ good - output it
	    readAhead := output.
	    ^ output.
	].
    ].
    ^ nil
! !

!FilteringStream methodsFor:'access - push-writing'!

nextPut:something
    "push something through the filter"

    |output|

    "/ filter it
    filter isNil ifTrue:[
	outputStream nextPut:something
    ] ifFalse:[
	output := filter value:something.
	output notNil ifTrue:[
	    outputStream nextPut:output
	]
    ]

    "Modified: 11.1.1997 / 16:12:52 / cg"
! !

!FilteringStream methodsFor:'accessing'!

filter
    "return the filter"

    ^ filter

    "Modified: 2.7.1996 / 21:03:36 / cg"
    "Created: 2.7.1996 / 21:06:42 / cg"
!

filter:something
    "set the filter"

    filter := something.

    "Modified: 2.7.1996 / 21:03:40 / cg"
    "Created: 2.7.1996 / 21:06:42 / cg"
!

inputStream
    "return the inputStream"

    ^ inputStream inputStream

    "Modified: 2.7.1996 / 21:03:43 / cg"
    "Created: 2.7.1996 / 21:06:42 / cg"
!

inputStream:something
    "set the inputStream"

    inputStream := something.

    "Modified: 2.7.1996 / 21:03:46 / cg"
    "Created: 2.7.1996 / 21:06:42 / cg"
!

outputStream
    "return the outputStream"

    ^ outputStream

    "Modified: 2.7.1996 / 21:03:49 / cg"
    "Created: 2.7.1996 / 21:06:42 / cg"
!

outputStream:something
    "set the outputStream"

    outputStream := something.

    "Modified: 2.7.1996 / 21:03:52 / cg"
    "Created: 2.7.1996 / 21:06:42 / cg"
! !

!FilteringStream methodsFor:'misc'!

clearEOF
    ^ inputStream clearEOF
!

close
    "when I am closed, close my input - if any"

    inputStream notNil ifTrue:[
	inputStream close
    ]

    "Created: 11.1.1997 / 15:27:17 / cg"
! !

!FilteringStream methodsFor:'queries'!

atEnd
    "return true, if the receiver stream is at the end"

    |nextElement|

    readAhead notNil ifTrue:[^ false].

    filter isNil ifTrue:[
        "/ then, its easy
        ^ inputStream atEnd
    ].

    "/ with a filter, things are more complicated,
    "/ since we cannot tell, without asking the filter...

    [inputStream atEnd] whileFalse:[
        nextElement := inputStream next.
        readAhead := filter value:nextElement.
        readAhead notNil ifTrue:[^ false].
    ].

    ^ true

    "Modified: 11.1.1997 / 17:16:45 / cg"
!

contentsSpecies
    "return the kind of collection I should return when asked
     for multiple elements."

    ^ inputStream contentsSpecies

    "Created: 11.1.1997 / 16:23:22 / cg"
!

isEmpty
    ^ inputStream isEmptyOrNil 
        and:[outputStream isEmptyOrNil and:[readAhead isNil]].

    "Created: / 06-08-2012 / 08:09:01 / cg"
!

isEncodedStream
    ^ inputStream isEncodedStream
!

isReadable
    ^ inputStream notNil and:[inputStream isReadable]
!

isWritable
    "return true, if writing is supported by the receiver."

    ^ outputStream notNil and:[outputStream isWritable]
!

position
    "return the receiver streams position"

    |rawPosition|

    rawPosition := inputStream position.
    readAhead notNil ifTrue:[
	rawPosition := rawPosition - 1
    ].
    ^ rawPosition
!

position0Based
    <resource: #obsolete>
    "return the receiver streams position"

    ^ self position
!

position1Based
    <resource: #obsolete>
    "return the receiver streams position"

    ^ self position + 1
!

readStream
    ^ self

    "Created: / 06-12-2011 / 01:05:26 / cg"
!

size
    "not always correct, but probably better than 0.
     Better use #isEmpty."

    "/ is that better?
    "/ self error:'size of input is unknown (due to filtering)'
    ^ (inputStream ? outputStream) size.

    "Created: / 05-08-2012 / 18:39:00 / cg"
! !

!FilteringStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

