"
 COPYRIGHT (c) 1994 by Claus Gittinger
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

Stream subclass:#PeekableStream
	instanceVariableNames:''
	classVariableNames:'ErrorDuringFileInSignal CurrentFileInDirectoryQuerySignal
		CurrentSourceContainerQuery'
	poolDictionaries:''
	category:'Streams'
!

!PeekableStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    abstract superclass for all Stream which support read-ahead
    (i.e. peeking) of one element.
    Concrete subclasses must implement a peek method.

    [caveat:]
        Basing capabilities like readability/writability/positionability/peekability on inheritance makes
        the class hierarchy ugly and leads to strange and hard to teach redefinitions (aka. NonPositionableStream
        below PositionableStream or ExternalReadStream under WriteStream)

    [author:]
        Claus Gittinger
"
! !

!PeekableStream class methodsFor:'initialization'!

initialize
    "setup the signal used to handle errors during fileIn"

    ErrorDuringFileInSignal isNil ifTrue:[
        ErrorDuringFileInSignal := Error newSignalMayProceed:true.
        ErrorDuringFileInSignal nameClass:self message:#errorDuringFileInSignal.
        ErrorDuringFileInSignal notifierString:'error during fileIn'.
    ]

    "
     self initialize
    "

    "Modified: / 23-10-2006 / 16:34:41 / cg"
! !

!PeekableStream class methodsFor:'Signal constants'!

currentFileInDirectoryQuerySignal
    "return the querySignal, which can be used to ask for the current directory
     during a fileIn (that is the directory where the filed-in file resides),
     and in a fileBrowsers doIt.
     Using this, allows for the loaded code or doIts to ask for the fileBrowsers
     current directory, by asking this querySignal (which is nice sometimes)."

    CurrentFileInDirectoryQuerySignal isNil ifTrue:[
        CurrentFileInDirectoryQuerySignal := QuerySignal new.
        CurrentFileInDirectoryQuerySignal nameClass:self message:#currentFileInDirectoryQuerySignal.
        CurrentFileInDirectoryQuerySignal notifierString:'query for current directory when filing in'.
        CurrentFileInDirectoryQuerySignal handlerBlock:[:ex | ex proceedWith:Filename currentDirectory].
    ].
    ^ CurrentFileInDirectoryQuerySignal

    "Modified: / 23-10-2006 / 16:34:37 / cg"
!

currentSourceContainerQuery
    "return the querySignal, which can be used to ask for the current source container filename
     during a fileIn 
     Using this, allows for the loaded code to remember the classes file name."

    CurrentSourceContainerQuery isNil ifTrue:[
        CurrentSourceContainerQuery := QuerySignal new.
        CurrentSourceContainerQuery nameClass:self message:#currentClassFilenameQuery.
        CurrentSourceContainerQuery notifierString:'query for current sorce container name when filing in'.
        CurrentSourceContainerQuery handlerBlock:[:ex | ex proceedWith:nil].
    ].
    ^ CurrentSourceContainerQuery

    "Modified: / 23-10-2006 / 16:32:49 / cg"
! !

!PeekableStream class methodsFor:'queries'!

currentFileInDirectory
    "during a fileIn (if a script), the script can ask for the current directory"

    ^ self currentFileInDirectoryQuerySignal query

    "Modified: / 23-10-2006 / 16:34:47 / cg"
!

currentSourceContainer
    "during a fileIn (if a script), the script can ask for the current filename"

    ^ self currentSourceContainerQuery query

    "Modified: / 23-10-2006 / 16:33:40 / cg"
! !

!PeekableStream class methodsFor:'testing'!

isAbstract
    ^ self == PeekableStream
! !

!PeekableStream methodsFor:'chunk input/output'!

nextChunk
    "return the next chunk, i.e. all characters up to the next
     exclamation mark. Within the chunk, exclamation marks have to be doubled,
     they are undoubled here.
     Except for primitive code, in which doubling is not needed (allowed).
     This exception was added to make it easier to edit primitive code with 
     external editors. However, this means, that other Smalltalks cannot always 
     read chunks containing primitive code 
     - but that doesn't really matter, since C-primitives are an ST/X feature anyway."

    |buffer theString chunkSeparator newString done thisChar nextChar 
     atBeginOfLine inPrimitive  hasCR hasLF
     index    "{ Class:SmallInteger }"
     currSize "{ Class:SmallInteger }" |

    chunkSeparator := ChunkSeparator.
    buffer := CharacterWriteStream on:(String new:100).
    self skipSeparators.
    thisChar := self nextOrNil.
    done := false.
    atBeginOfLine := true.
    inPrimitive := false.
    hasCR := hasLF := false.

    [done not and:[thisChar notNil]] whileTrue:[
        "match primitive only at beginning of line 
         (ExternalStream>>#nextChunk did this, although stc allows primitive to start anywhere)"

        (atBeginOfLine and:[thisChar == $%]) ifTrue:[
            nextChar := self peekOrNil.
            (nextChar == ${ ) ifTrue:[
                inPrimitive := true.
                buffer nextPut:thisChar.
                thisChar := self next
            ] ifFalse:[
                (nextChar == $} ) ifTrue:[
                    inPrimitive := false.
                    buffer nextPut:thisChar.
                    thisChar := self next
                ]
            ]
        ] ifFalse:[
            "chunk can not end in primitive code"
            (inPrimitive not and:[thisChar == chunkSeparator]) ifTrue:[
                (self peekOrNil == chunkSeparator) ifTrue:[
                    "double chunkSeparator, make single"
                    self next.
                ] ifFalse:[
                    "single chunkSeparator: end of chunk"
                    done := true.
                ].
            ].
        ].
        done ifFalse:[
            "now map CR LF to LF (ExternalStream>>#nextChunk did this)"
            atBeginOfLine := false.
            thisChar == Character return ifTrue:[
                self peekOrNil == Character lf ifTrue:[
                    self next.
                    thisChar := Character lf.
                    hasLF := true.
                ] ifFalse:[
                    "CR without LF"
                    hasCR := true.
                ].
                atBeginOfLine := true.
            ] ifFalse:[thisChar == Character lf ifTrue:[
                hasLF := true.
                atBeginOfLine := true.
            ]].
                
            buffer nextPut:thisChar.
            thisChar := self nextOrNil.
        ].
    ].

    theString := buffer contents.
    (hasCR and:[hasLF not]) ifTrue:[
        "map all CR in a CR only file to NL (ExternalStream>>#nextChunk did this)"
        theString replaceAll:Character return with:Character nl.
    ].

    ^ theString
! !

!PeekableStream methodsFor:'fileIn'!

fileIn
    "file in from the receiver, i.e. read chunks and evaluate them -
     return the value of the last chunk."

    |notifiedLoader lastValue|

    SourceFileLoader notNil ifTrue:[
        notifiedLoader := SourceFileLoader on:self.
    ].

    Class nameSpaceQuerySignal handle:[:ex |
        ex proceedWith:Smalltalk
    ] do:[
        lastValue := self fileInNotifying:notifiedLoader passChunk:true.
    ].
    ^ lastValue.
!

fileInBinary
    "file in from the receiver, i.e. read binary stored classes and/or objects.
     Return the last object."

    |bos obj|

    bos := BinaryObjectStorage onOld:self.
    Class nameSpaceQuerySignal 
	answer:Smalltalk
	do:[
	    [self atEnd] whileFalse:[
		obj := bos next.
	    ]
	].
    bos close.
    ^ obj

    "Created: / 13.11.2001 / 10:12:30 / cg"
    "Modified: / 13.11.2001 / 10:14:04 / cg"
! !

!PeekableStream methodsFor:'positioning'!

skipAny:skipCollection
    "skip all characters included in the argument-set.
     returns the next peeked element or nil, if the end-of-stream was reached."

    |nextOne|

    nextOne := self peekOrNil.
    [nextOne notNil and:[skipCollection includes:nextOne]] whileTrue:[
        self next.
        nextOne := self peekOrNil
    ].
    ^ nextOne

    "
     |s skipChars|

     s := ReadStream on:'some numbers1234with\in other99 stuff' withCRs.
     skipChars := 'abcdefghijklmnopqrstuvwxyz\ ' withCRs.
     s skipAny:skipChars.
     Transcript showCR:(Integer readFrom:s).
     s skipAny:skipChars.
     Transcript showCR:(Integer readFrom:s).
    "
!

skipSeparators
    "skip all whitespace; 
     return the next peeked element or nil, if the end-of-stream was reached.
     The stream's elements should be characters.
     Notice: compare this method to skipSpaces"

    |nextOne|

    nextOne := self peekOrNil.
    [nextOne notNil and:[nextOne isSeparator]] whileTrue:[
        self next.
        nextOne := self peekOrNil
    ].
    ^ nextOne

    "
     |s|

     s := ReadStream on:'one      two\three' withCRs.
     s skipSeparators.
     Transcript showCR:(s nextWord).
     s skipSeparators.
     Transcript showCR:(s nextWord).
     s skipSeparators.
     Transcript showCR:(s next displayString).
    "
!

skipSeparatorsExceptCR
    "skip all whitespace except carriage return; returns the 
     next peeked element or nil, if the end-of-stream was reached.
     The streams elements should be characters.
     Notice: compare this method to skipSpaces and skipSeparators"

    |nextOne|

    nextOne := self peekOrNil.
    [nextOne notNil 
     and:[nextOne isSeparator
     and:[nextOne ~~ Character cr]]] whileTrue:[
        self next.
        nextOne := self peekOrNil
    ].
    ^ nextOne
!

skipSpaces
    "skip all spaces; returns the next peeked element or
     nil, if the end-of-stream was reached.
     The streams elements should be characters.
     Notice: this one skips only spaces (i.e. no cr, tabs etc)
             usually, skipSeparators is what you want."

    |nextOne|

    nextOne := self peekOrNil.
    [nextOne notNil and:[nextOne == Character space]] whileTrue:[
        self next.
        nextOne := self peekOrNil
    ].
    ^ nextOne

    "
     |s|

     s := ReadStream on:'one      two\three' withCRs.
     s skipSpaces.
     Transcript showCR:(s nextWord).
     s skipSpaces.
     Transcript showCR:(s nextWord).
     s skipSpaces.
     Transcript showCR:(s next displayString).
    "
! !

!PeekableStream methodsFor:'private fileIn'!

basicFileInNotifying:someone passChunk:passChunk
    "central method to file in from the receiver, i.e. read chunks and evaluate them -
     return the value of the last chunk.
     Someone (which is usually some codeView) is notified of errors."

     ^(EncodedStream decodedStreamFor:self) basicFileInNotifying:someone passChunk:passChunk

    "Modified: / 10-09-1999 / 16:54:01 / stefan"
    "Modified: / 16-11-2001 / 16:21:28 / cg"
    "Modified: / 25-03-2013 / 22:57:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fileInNextChunkNotifying:someone
    "read next chunk, evaluate it and return the result;
     someone (which is usually some codeView) is notified of errors.
     Filein is done as follows:
	read a chunk
	if it started with an excla, evaluate it, and let the resulting object
	fileIn more chunks.
	This is a nice trick, since the methodsFor: expression evaluates to
	a ClassCategoryReader which reads and compiles chunks for its class.
	However, other than methodsFor expressions are possible - you can
	(in theory) create readers for any syntax.
    "

    ^ self fileInNextChunkNotifying:someone passChunk:false
!

fileInNextChunkNotifying:someone passChunk:passChunk
    "read next chunk, evaluate it and return the result;
     someone (which is usually some codeView) is notified of errors.
     Filein is done as follows:
	read a chunk
	if it started with an excla, evaluate it, and let the resulting object
	fileIn more chunks.
	This is a nice trick, since the methodsFor: expression evaluates to
	a ClassCategoryReader which reads and compiles chunks for its class.
	However, other than methodsFor expressions are possible - you can
	(in theory) create readers for any syntax.
    "

    ^ self fileInNextChunkNotifying:someone passChunk:passChunk silent:nil
!

fileInNextChunkNotifying:someone passChunk:passChunk silent:beSilent
    "read next chunk, evaluate it and return the result;
     someone (which is usually some codeView) is notified of errors.
     Filein is done as follows:
        read a chunk
        if it started with an excla, evaluate it, and let the resulting object
        fileIn more chunks.
        This is a nice trick, since the methodsFor: expression evaluates to
        a ClassCategoryReader which reads and compiles chunks for its class.
        However, other than methodsFor expressions are possible - you can
        (in theory) create readers for any syntax.
    "

    |aString sawExcla rslt done compiler lastClass|

    self skipSeparators.
    self atEnd ifFalse:[
        sawExcla := self peekFor:(self class chunkSeparator).
        aString := self nextChunk.
        "/
        "/ handle empty chunks;
        "/ this allows for Squeak code to be filedIn
        "/
        [aString size == 0 and:[self atEnd not]] whileTrue:[
            aString := self nextChunk.
        ].
        aString size ~~ 0 ifTrue:[
            passChunk ifTrue:[
                someone notNil ifTrue:[someone source:aString]
            ].
            someone perform:#reader: with:(SourceFileLoader::SourceFileReader new) ifNotUnderstood:[].
            compiler := (Smalltalk at:#Compiler) new.
            compiler allowUndeclaredVariables:false.

            sawExcla ifFalse:[
                "/ class definition chunks, etc., which are simply evaluated
                rslt := compiler evaluate:aString receiver:someone notifying:someone compile:false.
                rslt isBehavior ifTrue:[ 
                    lastClass := rslt 
                ] ifFalse:[
                    lastClass := nil 
                ].
            ] ifTrue:[
                "/ methodsFor chunks, etc., which generate a reader
                (Smalltalk at:#Compiler) emptySourceNotificationSignal handle:[:ex |
                    ^ nil
                ] do:[
                    rslt := compiler 
                                evaluate:aString 
                                notifying:someone 
                                compile:false.
                ].

                "
                 usually, the above chunk consists of some methodsFor:-expression
                 in this case, the returned value is a ClassCategoryReader,
                 which is used to load & compile the methods ...
                "
                (rslt isNil or:[rslt == #Error]) ifTrue:[
                    "
                     however, if that was nil (i.e. some error), we skip chunks
                     up to the next empty chunk.
                    "
                    Transcript showCR:'skipping chunks ...'.
                    done := false.
                    [done] whileFalse:[
                        aString := self nextChunk.
                        done := (aString size == 0).
                    ]
                ] ifFalse:[
                    Class packageQuerySignal handle:[:ex |
                        lastClass notNil ifTrue:[
                            ex proceedWith:lastClass package
                        ] ifFalse:[
                            ex reject
                        ].    
                    ] do:[    
                        rslt := rslt 
                                fileInFrom:self 
                                notifying:someone 
                                passChunk:passChunk
                                single:false
                                silent:beSilent
                    ].            
                ]
            ]
        ]
    ].
    ^ rslt

    "Modified: / 05-02-2011 / 10:06:57 / cg"
!

fileInNotifying:notifiedLoader passChunk:passChunk
    "central method to file in from the receiver, i.e. read chunks and evaluate them -
     return the value of the last chunk.
     Someone (which is usually some codeView) is notified of errors."

    ^ self basicFileInNotifying:notifiedLoader passChunk:passChunk.
!

fileInXMLNotifying:someone passChunk:passChunk
    "filein an XML source file (format as in campSmalltalk DTD)"

    | builder parser|

    (XML isNil or:[XML::SourceNodeBuilder isNil or:[XML::XMLParser isNil]]) ifTrue:[
	Smalltalk loadPackage:'stx:goodies/xml/vw'.
	(XML isNil or:[XML::SourceNodeBuilder isNil or:[XML::XMLParser isNil]]) ifTrue:[
	    self error:'Could not load XML package(s) from ''stx:goodies/xml/vw'''.
	]
    ].

    builder := XML::SourceNodeBuilder new.
    parser := XML::XMLParser on:self.
    parser builder:builder.
    parser validate:false.
    parser scanDocument.
    "/ self halt.
! !

!PeekableStream methodsFor:'reading'!

nextDelimited:terminator
    "return the contents of the receiver, up to the next terminator element. 
     Doubled terminators indicate an embedded terminator element.  
     For example: 'this '' was a quote'. 
     Start positioned before the initial terminator."

    | out element |

    self atEnd ifTrue: [^ ''].
    self next == terminator ifFalse: [self skip: -1].       "absorb initial terminator"
    out := WriteStream on:(self contentsSpecies new).
    [(element := self nextOrNil) isNil and:[self atEnd]] whileFalse:[
        element == terminator ifTrue: [
            self peek == terminator ifFalse: [
                ^ out contents  "terminator is not doubled; we're done!!"
            ].
            self next.  "skip doubled terminator"
        ].
        out nextPut:element.
    ].
    ^ out contents

    "
     ('*foo bar baz* more foo' readStream nextDelimited:$*) 
     ('*foo bar **baz***' readStream nextDelimited:$*)   
    "
!

nextPeek
    "advance to next element and return the peeked element"

    self next.
    ^ self peek
!

nextPeekOrNil
    "advance to next element and return the peeked element"

    self nextOrNil.
    ^ self peekOrNil
!

nextUpTo:anObject
    "read a collection of all objects up-to anObject and return these
     elements, but excluding anObject. 
     The next read operation will return anObject.
     If anObject is not encountered, all elements up to the end are read
     and returned, and the stream is positioned at the end.
     Compare this with #upTo: which positions behind anObject"

    |answerStream element|

    answerStream := WriteStream on:(self contentsSpecies new).
    [self atEnd] whileFalse:[
	element := self peek.
	(element = anObject) ifTrue: [
	    ^ answerStream contents
	].
	answerStream nextPut:element.
	self next.
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s nextUpTo:4).  
     Transcript showCR:s next

     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s upTo:4).  
     Transcript showCR:s next

     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s nextUpTo:9).  
     Transcript showCR:s next

     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s upTo:9).  
     Transcript showCR:s next
    "

    "Created: 24.1.1997 / 14:08:35 / cg"
    "Modified: 24.1.1997 / 14:09:49 / cg"
!

peek 
    "return the next element of the stream without advancing (i.e.
     the following send of next will return this element again.)
     - we do not know here how to do it, it must be redefined in subclass"

    ^ self subclassResponsibility
!

peekFor:anObject 
    "if the next-to-be-read object is equal to the argument, anObject, read it
     and return true. Otherwise, leave the receiver unaffected and return false."

    self peek = anObject ifTrue:[
        self nextOrNil.
        ^ true
    ].
    ^ false

    "
      #() readStream peekFor:nil
      #() readStream signalAtEnd:true; peekFor:nil
      #(nil) readStream peekFor:nil
      'abc' readStream next; peekFor:$b.
      'abc' readStream next; peekFor:$c.
    "
!

peekOrNil
    "like #peek, this returns the next readAhead element, if available.
     However, unlike #peek, this does not raise an atEnd-query signal - even
     if handled. Instead, nil is returned immediately."

    self atEnd ifTrue:[^ nil].
    ^ self peek

    "Created: / 5.3.1998 / 02:56:49 / cg"
    "Modified: / 5.3.1998 / 13:45:07 / cg"
!

skipUntil:aBlock
    "skip all elements for which aBlock returns false.
     Return true if more elements can be read, false if eof has been reached."

    [self atEnd] whileFalse:[
        (aBlock value: self peek) ifTrue:[^ true].
        self next
    ].
    ^ false

    "
     #(1 2 3 4 5 6 7 8 9 10) readStream
        skipUntil:[:el | el >= 5];
        next
    "
!

skipWhile:aBlock
    "skip all elements for which aBlock returns true. Return true if more elements can be read,
     false if eof has been reached."

    [self atEnd] whileFalse:[
	(aBlock value: self peek) ifFalse:[^ true].
	self next
    ].
    ^ false

    "
     #(1 2 3 4 5 6 7 8 9 10) readStream
	skipWhile:[:el | el <= 5];
	next
    "

    "Created: / 23-09-2011 / 13:32:40 / cg"
!

throughAnyForWhich:checkBlock
    "read & return a collection of all objects up-to and including 
     the elements for which checkBlock returns true.
     (i.e. read until checkBlock returns false on an element)
     If no such element is encountered, all elements up to the end are read
     and returned."

    |answerStream element|

    answerStream := WriteStream on:(self contentsSpecies new).
    [self atEnd] whileFalse:[
        element := self peek.
        (checkBlock value:element) ifFalse:[
            ^ answerStream contents
        ].
        answerStream nextPut:element.
        self next.
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:#(1 2 3 4 5 6 7 8).
     Transcript showCR:(s throughAny:#(3 4 5)).  
     Transcript showCR:s next

     |s|
     s := ReadStream on:'hello world, this is some text'.
     Transcript showCR:(s throughAnyForWhich:[:ch | ch isSeparator not]).  
     Transcript showCR:(s throughAnyForWhich:[:ch | ch isSeparator not]).  
     Transcript showCR:s upToEnd.
    "

    "Modified: / 11.1.1998 / 15:28:04 / cg"
!

upToAny:aCollectionOfObjects
    "read a collection of all objects up-to a element which is contained in
     aCollectionOfObjects and return these elements, but excluding the matching one.
     The next read operation will return the element AFTER anObject.
     If no such element is encountered, all elements up to the end are read
     and returned.
     Compare this with #throughAll: which also reads up to some object
     and also positions behind it, but DOES include it in the returned
     value."

    |result|

    result := self upToBeforeAny:aCollectionOfObjects.
    self atEnd ifFalse:[
        self next.
    ].
    ^ result

    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript showCR:(s upToAny:(Array with:Character space)).
     Transcript showCR:(s upToEnd)

     'Makefile' asFilename readStream upToAny:($A to:$Z)
    "

    "Created: / 30.8.1997 / 03:02:05 / cg"
    "Modified: / 11.1.1998 / 15:19:18 / cg"
!

upToBeforeAny:aCollectionOfObjects
    "read a collection of all objects up-to a element which is contained in
     aCollectionOfObjects and return these elements, but excluding the matching one.
     The next read operation will return the matching element.
     If no such element is encountered, all elements up to the end are read
     and returned.
     This returns the exact same as upToAny: would, but leaves the stream's position so that
     the next read returns the matching delimiter instead of skipping it.
     Caveat: this is the one which should have been called upTo: in the first place;
     however, it seems now too late for a change."

    |answerStream element|

    answerStream := WriteStream on:(self contentsSpecies new).
    [self atEnd] whileFalse:[
        element := self peek.
        (aCollectionOfObjects includes:element) ifTrue: [
            ^ answerStream contents
        ].
        answerStream nextPut:element.
        self next.
    ].
    ^ answerStream contents

    "
     |s|
     s := ReadStream on:'hello world'.
     Transcript showCR:(s upToBeforeAny:(Array with:Character space)).
     Transcript showCR:(s upToEnd)

     'Make.proto' asFilename readStream upToBeforeAny:($A to:$Z)
    "

    "Created: / 30.8.1997 / 03:02:05 / cg"
    "Modified: / 11.1.1998 / 15:19:18 / cg"
!

upToElementForWhich:aBlock
    "read elements until aBlock returns true for an element.
     Return the collected elements excluding that element.
     Leave the stream positioned for the next read to return that element.
     If no element matches, all elements up to the end are returned"

    |answerStream next|

    answerStream := WriteStream on:(self contentsSpecies new).

    [
        self atEnd
        or:[ (aBlock value: (next := self peek)) ]
    ] whileFalse:[
        answerStream nextPut:next.
        self next.
    ].
    ^ answerStream contents

    "
     #(1 2 3 4 5 6 7 8 9 10) readStream
        upToElementForWhich:[:el | el > 5]
    "
! !

!PeekableStream methodsFor:'reading-numbers'!

nextDecimalInteger
    "read the next integer in radix 10. 
     Does NOT skip initial whitespace.
     The streams elements should be characters.

     Be careful - this method returns 0 if not positioned on a digit intitially
     or if the end of the stream is encountered."

    |nextOne value|

    nextOne := self peekOrNil.
    value := 0.
    [nextOne notNil and:[nextOne isDigitRadix:10]] whileTrue:[
        value := (value * 10) + nextOne digitValue.
        self next.
        nextOne := self peekOrNil
    ].
    ^ value

    "
     |s|

     s := '1234 5678' readStream.
     s nextDecimalInteger. 
    "

    "
     |s|

     s := '1234 5678' readStream.
     s nextDecimalInteger.
     s skipSpaces.
     s nextDecimalInteger. 
    "
! !

!PeekableStream methodsFor:'reading-strings'!

nextAlphaNumericWord
    "read the next word (i.e. up to non letter-or-digit).
     Return a string containing those characters.
     Any leading non-alphaNumeric chars are skipped.

     National letters or digits in unicode are not treated as letters."

    |s c|

    "first: skip white space and other garbage, leave first character in c"
    [
        c := self nextOrNil.
        c isNil ifTrue:[
            "end of stream"
            ^ nil.
        ].
        c isLetterOrDigit
    ] whileFalse.

    "second: get the alphanumeric word"
    s := WriteStream on:(self contentsSpecies new:100).

    [
        s nextPut:c.
        c := self peekOrNil.
        (c notNil and:[c isLetterOrDigit]) ifTrue:[
            self next.
            true.
        ] ifFalse:[
            false.
        ]
    ] whileTrue.

    ^ s contents.

    "Use UnicodeString in the examples, to avoid the optimization in ReadStream for Strings"

    "
     |s|

     s := 'hello world 1234 foo1 foo2' asUnicodeString readStream.
     [s atEnd] whileFalse:[
        Transcript showCR:(s nextAlphaNumericWord).
     ].
    "

    "
     |s|

     s := 'hello +++ #world ###123###abc### 1234 foo1 foo2++++' asUnicodeString readStream.
     [s atEnd] whileFalse:[
        Transcript showCR:(s nextAlphaNumericWord).
     ].
    "

    "Modified: 15.5.1996 / 17:51:42 / cg"
!

nextMatching:matchBlock1 thenMatching:matchBlock2
    "read the next word. The first character must match matchBlock1,
     remaining characters must match matchBlock2.
     Return a string containing those characters.
     Useful to read identifiers, where the first char is from a different
     set than the remaining (letter vs. letterOrDigit)"

    |s c|

    self atEnd ifTrue:[^ nil].
    (matchBlock1 value:self peek) ifFalse:[^ nil].

    s := self next asString.

    [self atEnd not
     and:[matchBlock2 value:(c := self peek)]] whileTrue:[ 
        s := s copyWith:c. 
        self next 
    ].

    s size == 0 ifTrue:[^ nil].
    ^ s.

    "
     |s|

     s := 'hello_world_1234 foo1 foo2' readStream.
     s nextMatching:[:c | c isLetter] 
       thenMatching:[:c | c isLetterOrDigit or:[c == $_]].
    "
!

nextSymbol
    "read the next selector-symbol (i.e. up to non letter-or-digit).
     Return a string containing those characters.
     Any leading non-alphaNumeric chars are skipped."

    |symbol c symbolStream|

    [self atEnd
     or:[(c := self peek) isLetterOrDigit]] whileFalse:[
        self next 
    ].

    self atEnd ifTrue:[^ nil].

    symbolStream := '' writeStream.

    [self atEnd not
     and:[(c := self peek) isLetterOrDigit or:[c == $:]]] whileTrue:[
        symbolStream nextPut:c.
        self next 
    ].

    symbol := symbolStream contents.
    symbol size == 0 ifTrue:[^ nil].
    ^ symbol.

    "
     |s|

     s := 'hello: world 1234 foo1 foo2:' readStream.
     [s atEnd] whileFalse:[
        Transcript showCR:(s nextSymbol).
     ].
    "

    "
     |s|

     s := 'hello +++ #world ###123###abc### 1234 foo1 foo2' readStream.
     [s atEnd] whileFalse:[
        Transcript showCR:(s nextAlphaNumericWord).
     ].
    "

    "Modified: 15.5.1996 / 17:51:42 / cg"
! !

!PeekableStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


PeekableStream initialize!
