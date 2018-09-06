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

FilteringStream subclass:#FilteringLineStream
	instanceVariableNames:'lineBuffer lineFilter'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!FilteringLineStream class methodsFor:'documentation'!

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
    A FilteringLineStream is much like a FilteringStream, but
    processes its input line-wise.

    A FilteringLineStream can be connected to some input
    (from which characters are read via the ReadStream protocol),
    and/or to some output (to which characters are written via
    the WriteStream protocol.

    The FilteringLineStream itself performs some filtering/processing
    on the elements as they arrive, optionally suppressing filtering
    (i.e. removing) some elements.


    [author:]
	Claus Gittinger

    [See also:]
	FilteringStream ReadStream WriteStream
"


!

examples
"
  pushing the contents of a stream onto another stream
  (here, the Transcript) without a need to read everyting into a
  buffer or to reinvent the read-loop:
                                                                [exBegin]
    |in pusher|

    in := 'Makefile' asFilename readStream.
    pusher := FilteringLineStream readingFrom:in writingTo:Transcript.
    pusher filterUpToEnd
                                                                [exEnd]


  collect a command's stdout and stderr, colorizing error output in red and normal output in green:
                                                                [exBegin]
    |in out stdoutColorizer errColorizer|

    out := Transcript.
    in := OperatingSystem 
            executeCommand:'bc'
            inputFrom:
'4+5
bla bla foo
4+5
bar
' readStream
            outputTo:((FilteringLineStream writingTo:out) filter:[:line | line colorizeAllWith:Color green darkened])
            errorTo:((FilteringLineStream writingTo:out) filter:[:line | line colorizeAllWith:Color red]).
                                                                [exEnd]


  filter through an ActorStream:
                                                                [exBegin]
    |lineNr in pusher actorPerLine|

    lineNr := 0.

    actorPerLine := ActorStream new.
    actorPerLine nextPutLineBlock:[:line | lineNr := lineNr + 1. Transcript show:lineNr; showCR:line].

    in := 'Makefile' asFilename readStream.
    pusher := FilteringLineStream readingFrom:in writingTo:actorPerLine.
    pusher filterUpToEnd
                                                                [exEnd]


  filter all comments (starting with '#') from a Makefile:
                                                                [exBegin]
    |in filter|

    in := 'Makefile' asFilename readStream.

    filter := FilteringLineStream readingFrom:in.
    filter filter:[:line | (line startsWith:'#') ifTrue:[line] ifFalse:[nil]].

    filter outputStream:Transcript.

    filter filterUpToEnd
                                                                [exEnd]


  the inverse - remove all comments from the Makefile:
                                                                [exBegin]
    |in filter|

    in := 'Makefile' asFilename readStream.

    filter := FilteringLineStream readingFrom:in.
    filter filter:[:line | (line startsWith:'#') ifTrue:[nil] ifFalse:[line]].

    filter outputStream:Transcript.

    filter filterUpToEnd
                                                                [exEnd]


  feed a second filter from the first filters output;
  (the remains are all lines starting with '#' and ending with '-'):
                                                                [exBegin]
    |in filter1 filter2|

    in := 'Makefile' asFilename readStream.

    filter1 := FilteringLineStream readingFrom:in.
    filter1 filter:[:line | (line startsWith:'#') ifTrue:[line] ifFalse:[nil]].

    filter2 := FilteringLineStream readingFrom:filter1.
    filter2 filter:[:line | (line endsWith:'-') ifTrue:[line] ifFalse:[nil]].

    filter2 outputStream:Transcript.

    filter2 filterUpToEnd
                                                                [exEnd]
"
! !

!FilteringLineStream methodsFor:'access - pull-reading'!

filterUpToEnd
    "pull input from inputStream up to the end,
     push it filtered into the outputStream."

    [inputStream atEnd] whileFalse:[
	self nextPutLine:(inputStream nextLine)
    ].

    "Created: 11.1.1997 / 16:09:05 / cg"
! !

!FilteringLineStream methodsFor:'access - push-writing'!

cr
    "finish a line, push it filtered into the outputStream"

    |output|

    lineFilter isNil ifTrue:[
	outputStream nextPutLine:(lineBuffer ? '')
    ] ifFalse:[
	lineBuffer isNil ifTrue:[lineBuffer := ''].

	output := lineFilter value:lineBuffer.
	output notNil ifTrue:[
	    outputStream nextPutLine:output.
	]
    ].
    lineBuffer := ''.

    "Modified: 11.1.1997 / 16:32:40 / cg"
!

nextPut:something
    "collect a line and push it when a cr arrives"

    something == Character cr ifTrue:[
	self cr
    ] ifFalse:[
	lineBuffer isNil ifTrue:[lineBuffer := ''].
	lineBuffer := lineBuffer copyWith:something.
    ]

    "Created: 2.7.1996 / 20:54:38 / cg"
    "Modified: 2.7.1996 / 21:03:26 / cg"
!

nextPutAll:something
    "collect a line and push it when a cr arrives"

    lineBuffer isNil ifTrue:[
	lineBuffer := something
    ] ifFalse:[
	lineBuffer := lineBuffer , something.
    ]

    "Modified: 11.1.1997 / 16:31:28 / cg"
! !

!FilteringLineStream methodsFor:'accessing'!

filter
    "return the filter"

    ^ lineFilter

    "Created: 11.1.1997 / 16:13:15 / cg"
!

filter:aBlock
    "set the filter"

    lineFilter := aBlock

    "Created: 11.1.1997 / 16:13:25 / cg"
!

isBinary
    ^ (inputStream ? outputStream) isBinary
!

size
    "mhmh - please use isEmpty; anything else is unknown"

    self error:'size of input is unknown (due to filtering)'

    "Created: / 06-08-2012 / 08:21:12 / cg"
! !

!FilteringLineStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/FilteringLineStream.st,v 1.9 2014-11-08 10:20:41 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/FilteringLineStream.st,v 1.9 2014-11-08 10:20:41 cg Exp $'
! !

