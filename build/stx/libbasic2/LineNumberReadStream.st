"
 COPYRIGHT (c) 1996 by eXept Software AG
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

FilteringStream subclass:#LineNumberReadStream
	instanceVariableNames:'lineNumber lineStartPosition'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!LineNumberReadStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996 by eXept Software AG
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
    This filter keeps track of the current line, and optionally
    the current line's start position (if the input stream is positionable).
    while passing text from its inputStream to its outputStream.

    Can be placed in-between text processing and the text's
    input stream, and let it keep track of the lineNumber.

    [see also:]
        ReadStream WriteStream ExternalStream FileStream
        FilteringStream FilteringLineStream

    [author:]
        Claus Gittinger
"
!

examples
"
  count lines in a Makefile:
									[exBegin]
    |in filter|

    in := 'Makefile' asFilename readStream.

    filter := LineNumberReadStream readingFrom:in.

    filter upToEnd.
    filter close.

    Transcript showCR:('Makefile has %1 lines' bindWith:(filter lineNumber - 1)).
									[exEnd]



  find a specific string and output its lineNr:
									[exBegin]
    |in filter|

    in := 'Makefile' asFilename readStream.

    filter := LineNumberReadStream readingFrom:in.

    filter skipThroughAll:'start of'.
    filter close.

    Transcript showCR:('found in line %1' bindWith:(filter lineNumber)).
									[exEnd]
"


! !

!LineNumberReadStream methodsFor:'accessing'!

lineNumber
    "return the current lineNumber"

    ^ lineNumber

    "Created: 11.1.1997 / 16:57:10 / cg"
    "Modified: 11.1.1997 / 16:57:19 / cg"
!

lineNumber:something
    "set the current lineNumber"

    lineNumber := something.

    "Created: 11.1.1997 / 16:57:10 / cg"
    "Modified: 11.1.1997 / 16:57:22 / cg"
!

lineStartPosition
    "return the current lines start position"

    ^ lineStartPosition
! !

!LineNumberReadStream methodsFor:'converting'!

asLineNumberReadStream
    ^ self
! !

!LineNumberReadStream methodsFor:'initialization'!

initialize
    super initialize.

    lineNumber := 1.
    (inputStream isPositionable) ifTrue:[
        lineStartPosition := inputStream position.
    ].
    filter := [:char |
                char == Character cr ifTrue:[
                    lineNumber := lineNumber + 1.
                    lineStartPosition notNil ifTrue:[
                        lineStartPosition := inputStream position.
                    ].
                ].
                char
              ].

    "Modified: 11.1.1997 / 16:58:42 / cg"
! !

!LineNumberReadStream methodsFor:'positioning'!

position:aPosition
    "this method fails if inputStream is not positionable"

    readAhead := nil.
    inputStream position:aPosition.
    (lineStartPosition notNil and:[aPosition < lineStartPosition]) ifTrue:[
        "we detect backPosition over a single line, but not over multiple lines and 
         no forward positioning!!"
        lineNumber := lineNumber - 1.
        lineStartPosition := aPosition.
    ].
!

skip:numberToSkip
    "this method fails if inputStream is not positionable"

    readAhead := nil.
    inputStream skip:numberToSkip.
    (lineStartPosition notNil and:[numberToSkip < lineStartPosition negated]) ifTrue:[
        "we detect backPosition over a single line, but not over multiple lines and 
         no forward positioning!!"
        lineNumber := lineNumber - 1.
        lineStartPosition := lineStartPosition + numberToSkip.
    ].
! !

!LineNumberReadStream methodsFor:'queries'!

atEnd
    "return true, if the receiver stream is at the end"

    readAhead notNil ifTrue:[^ false].
    ^ inputStream atEnd
!

isLineNumberReadStream
    ^ true
! !

!LineNumberReadStream methodsFor:'reading'!

contents
    ^ inputStream contents
!

contentsAsString
    ^ inputStream contentsAsString
!

upToAll_positionBefore:aCollection
    "read until a subcollection consisting of the elements in aCollection is encountered.
     Return everything read excluding the elements in aCollection.
     The position is left before the collection; i.e. the next
     read operations will return those elements.
     If no such subcollection is encountered, all elements up to the end 
     are read and returned.
     See also #throughAll: which also reads up to some objects
     but positions behind it and DOES include it in the returned
     collection.

     This is a copy from PositionableStream>>#upToAll_positionBefore:.
     It fails if inputStream is not positionable"

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
! !

!LineNumberReadStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

