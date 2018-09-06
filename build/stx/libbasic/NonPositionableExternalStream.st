"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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

ExternalStream subclass:#NonPositionableExternalStream
	instanceVariableNames:''
	classVariableNames:'StdInStream StdOutStream StdErrorStream'
	poolDictionaries:'TTYConstants'
	category:'Streams-External'
!

!NonPositionableExternalStream primitiveDefinitions!
%{

#ifndef _STDIO_H_INCLUDED_
# include <stdio.h>
# define _STDIO_H_INCLUDED_
#endif

#ifndef REMOVE_LATER
# define __win32_stdout()        stdout
# define __win32_stderr()        stderr
# define __win32_stdin()         stdin
#else
    extern FILE *__win32_stdin();
    extern FILE *__win32_stderr();
    extern FILE *__win32_stdout();
#endif

%}

! !

!NonPositionableExternalStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
 COPYRIGHT (c) 2017 Jan Vrany
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
    This class provides common protocol for all non-positionable,
    external streams. Concrete subclasses are terminal streams, pipe streams,
    PrinterStreams, Sockets etc.

    There are three special instances of this class, representing stdin,
    stdout and stderr of the smalltalk/X process (see Unix manuals, if you
    don't know what those are used for). These special streams are bound to
    to globals Stdin, Stdout and Stderr at early initialization time
    (see Smalltalk>>initializeStandardStreams).

    The name of this class is a historical leftover - it should be called
    'TTYStream' or similar.

    [author:]
        Claus Gittinger
"
! !

!NonPositionableExternalStream class methodsFor:'instance creation'!

forStderr
    "{ Pragma: +optSpace }"

    "return a NonPositionableExternalStream object for writing to
     Unixes standard error output file descriptor"

    StdErrorStream isNil ifTrue:[
	StdErrorStream := self basicNew initializeForStderr
    ].
    ^ StdErrorStream
!

forStdin
    "{ Pragma: +optSpace }"

    "return a NonPositionableExternalStream object for reading from
     Unixes standard input file descriptor"

    StdInStream isNil ifTrue:[
	StdInStream := self basicNew initializeForStdin
    ].
    ^ StdInStream
!

forStdout
    "{ Pragma: +optSpace }"

    "return a NonPositionableExternalStream object for writing to
     Unixes standard output file descriptor"

    StdOutStream isNil ifTrue:[
	StdOutStream := self basicNew initializeForStdout
    ].
    ^ StdOutStream
!

makeBidirectionalPipe
    "return an array with two streams - the first one for reading,
     the second for writing.
     This is the higher level equivalent of OperatingSystem>>makeBidirectionalPipe
     (which returns an array of file-descriptors)."

    |pipe rs ws|

    pipe := OperatingSystem makeBidirectionalPipe.
    pipe isNil ifTrue:[
        "/ ok, maybe someone has forgotten to close a stream; enforce finalization and try again
        'makePipe: enforcing finalization to close any open streams' infoPrintCR.
        ObjectMemory garbageCollect; finalize.
        pipe := OperatingSystem makeBidirectionalPipe.
    ].

    pipe isNil ifTrue:[
        |errorNumber errorHolder|

        errorNumber := OperatingSystem lastErrorNumber.
        errorHolder := errorNumber.
        OpenError newException
            errorCode:errorNumber;
            osErrorHolder:errorHolder;
            raise.
    ].

    rs := NonPositionableExternalStream forFileDescriptor:(pipe at:1) mode:#readWrite buffered:false handleType:#pipeFilePointer.
    ws := NonPositionableExternalStream forFileDescriptor:(pipe at:2) mode:#readWrite buffered:false handleType:#pipeFilePointer.
    ^ Array with:rs with:ws

    "
     |pipe rs ws|

     pipe := NonPositionableExternalStream makeBidirectionalPipe.
     rs := pipe at:1.
     ws := pipe at:2.

     'read ...'.
     [
         1 to:10 do:[:i |
             Transcript showCR:rs nextLine
         ].
         rs close.
     ] forkAt:7.

     'write ...'.
     [
         1 to:10 do:[:i |
             ws nextPutAll:'hello world '; nextPutAll:i printString; cr
         ].
         ws close.
     ] fork.
    "
!

makePTYPair
    "return an array with two streams - the first one is the master,
     the second the slave of a ptym/ptys pair.
     This is much like a bidirectional pipe, but allows signals &
     control chars to be passed through the connection.
     This is needed to execute a shell in a view.
     This is the higher level equivalent of OperatingSystem>>makePTYPair
     (which returns an array of file-descriptors)."

    |ptyPair master slave|

    ptyPair := OperatingSystem makePTYPair.
    ptyPair notNil ifTrue:[
        master := NonPositionableExternalStream forReadWriteToFileDescriptor:(ptyPair at:1).
        master buffered:false.
        slave := NonPositionableExternalStream forReadWriteToFileDescriptor:(ptyPair at:2).
        slave buffered:false.
        ptyPair at:1 put:master.
        ptyPair at:2 put:slave.
        ^ ptyPair
    ].
    ^ nil

    "
     ExternalStream makePTYPair.
    "

    "Modified: 29.2.1996 / 18:28:36 / cg"
!

makePipe
    "return an array with two streams - the first one for reading,
     the second for writing.
     This is the higher level equivalent of OperatingSystem>>makePipe
     (which returns an array of file-descriptors)."

    |pipeArray rs ws|

    pipeArray := OperatingSystem makePipe.
    pipeArray isNil ifTrue:[
        "/ ok, maybe someone has forgotten to close a stream; enforce finalization and try again
        'makePipe: enforcing finalization to close any open streams' infoPrintCR.
        ObjectMemory garbageCollect; finalize.
        pipeArray := OperatingSystem makePipe.
    ].

    pipeArray isNil ifTrue:[
        |errorNumber errorHolder|

        errorNumber := OperatingSystem lastErrorNumber.
        errorHolder := errorNumber.
        OpenError newException
            errorCode:errorNumber;
            osErrorHolder:errorHolder;
            raise.
    ].

    rs := NonPositionableExternalStream forFileDescriptor:(pipeArray at:1) mode:#readonly buffered:false handleType:#pipeFilePointer.
    ws := NonPositionableExternalStream forFileDescriptor:(pipeArray at:2) mode:#writeonly buffered:false handleType:#pipeFilePointer.
    ^ Array with:rs with:ws

    "
     |pipe rs ws|

     pipe := NonPositionableExternalStream makePipe.
     rs := pipe at:1.
     ws := pipe at:2.

     'read ...'.
     [
         1 to:10 do:[:i |
             Transcript showCR:rs nextLine
         ].
         rs close.
     ] forkAt:7.

     'write ...'.
     [
         1 to:10 do:[:i |
             ws nextPutAll:'hello world '; nextPutAll:i printString; cr
         ].
         ws close.
     ] fork.
    "

    "Modified: 29.2.1996 / 18:28:36 / cg"
! !

!NonPositionableExternalStream methodsFor:'accessing'!

buffered:aBoolean
    "do not allow to change to buffered mode - ignore true here"

    aBoolean ifFalse:[
	super buffered:false.
    ].
!

getTTYAttributes
    "Return (UNIX) TTY / PTY attributes for this stream as an instance of
     UnixTerminalAttributes. Throw an error if terminal attributes cannot 
     be retrieved (OS call fails, stream does  not refer to terminal or 
     opration is not supported by this operating system. 

     See tcgetattr()
    "
    ^ OperatingSystem getTTYAttributes: self fileDescriptor

    "
    Stdout ttyAttributes
    "

    "Created: / 30-05-2017 / 20:55:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

setTTYAttributes: aUnixTerminalAttributes
    "Set (UNIX) TTY / PTY attributes for this stream. Throw an error if 
     terminal attributes cannot be set (OS call fails, stream does  not 
     refer to terminal or operation is not supported by this operating 
     system. 

     See tcsetattr()
    "
    ^ OperatingSystem setTTYAttributes: self fileDescriptor to: aUnixTerminalAttributes withActions: TCSANOW

    "
    Stdout ttyAttributes
    "

    "Created: / 30-05-2017 / 20:57:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NonPositionableExternalStream methodsFor:'error handling'!

positionError
    "{ Pragma: +optSpace }"

    "notify that this stream has no concept of a position"

    ^ PositionError raiseRequestWith:self

    "
     Stderr positionError
    "
!

writeError:errorNumber
    "report an error, that some write error occurred.
     Redefined to care for writeErrors on stdout and stderr,
     which happens under linux, if the console is closed while I am running.
     In this case, we ignore the error."

    ((self == Stderr) or:[self == Stdout]) ifTrue:[
        ^ self
    ].
    super writeError:errorNumber
! !

!NonPositionableExternalStream methodsFor:'initialization'!

initialize
    "non-positionable streams do not work well when buffered"

    super initialize.
    position := nil.    "I am not positionable (reading and writing simultaneously)"
    buffered := false.
! !


!NonPositionableExternalStream methodsFor:'non homogenous reading'!

nextBytes:count into:anObject startingAt:start
    "read the next count bytes into an object and return the number of
     bytes read or the number of bytes read, if EOF is encountered before.
     An exception is raised if the connection is broken.

     Redefined here to avoid blocking of ST/X when waiting for io.
     Instead only the calling thread will block"

    |remaining offset nRead|

    count == 0 ifTrue:[
	^ 0.
    ].

    remaining := count.
    offset := start.

    [
	nRead := self nextAvailableBytes:remaining into:anObject startingAt:offset.
	nRead == 0 ifTrue:[
	    "atEnd does a readWait"
	    self atEnd not.
	] ifFalse:[
	    remaining := remaining - nRead.
	    offset := offset + nRead.
	    remaining ~~ 0.
	]
    ] whileTrue.

    ^ count - remaining
!

nextInt16MSB:msbFlag
    "redefined to wait for data on pipes and sockets"

    |bytes nRead|

    bytes := ByteArray uninitializedNew:2.
    nRead := self nextBytes:2 into:bytes startingAt:1.
    nRead ~~ 2 ifTrue:[
        ^ self pastEndRead.
    ].
    ^ bytes signedInt16At:1 MSB:msbFlag.
!

nextInt32MSB:msbFlag
    "redefined to wait for data on pipes and sockets"

    |bytes nRead|

    bytes := ByteArray uninitializedNew:4.
    nRead := self nextBytes:4 into:bytes startingAt:1.
    nRead ~~ 4 ifTrue:[
        ^ self pastEndRead.
    ].
    ^ bytes signedInt32At:1 MSB:msbFlag.
!

nextInt64MSB:msbFlag
    "redefined to wait for data on pipes and sockets"

    |bytes nRead|

    bytes := ByteArray uninitializedNew:8.
    nRead := self nextBytes:8 into:bytes startingAt:1.
    nRead ~~ 8 ifTrue:[
        ^ self pastEndRead.
    ].
    ^ bytes signedInt64At:1 MSB:msbFlag.
!

nextUnsignedInt16MSB:msbFlag
    "redefined to wait for data on pipes and sockets"

    |bytes nRead|

    bytes := ByteArray uninitializedNew:2.
    nRead := self nextBytes:2 into:bytes startingAt:1.
    nRead ~~ 2 ifTrue:[
        ^ self pastEndRead.
    ].
    ^ bytes unsignedInt16At:1 MSB:msbFlag.
!

nextUnsignedInt32MSB:msbFlag
    "redefined to wait for data on pipes and sockets"

    |bytes nRead|

    bytes := ByteArray uninitializedNew:4.
    nRead := self nextBytes:4 into:bytes startingAt:1.
    nRead ~~ 4 ifTrue:[
        ^ self pastEndRead.
    ].
    ^ bytes unsignedInt32At:1 MSB:msbFlag.
!

nextUnsignedInt64MSB:msbFlag
    "redefined to wait for data on pipes and sockets"

    |bytes nRead|

    bytes := ByteArray uninitializedNew:8.
    nRead := self nextBytes:8 into:bytes startingAt:1.
    nRead ~~ 8 ifTrue:[
        ^ self pastEndRead.
    ].
    ^ bytes unsignedInt64At:1 MSB:msbFlag.
! !

!NonPositionableExternalStream methodsFor:'positioning'!

position
    position isNil ifTrue:[
        ^ self positionError.
    ].
    ^ position
!

position:newPosition
    (position isNil or:[newPosition < position]) ifTrue:[
        "there is no turning back"
        ^ self positionError
    ].
    self skip:newPosition - position.
!

skip:numberToSkip
    "skip count bytes/characters, return the receiver.
     Re-redefined since PositionableStream redefined it."

    "don't know how to unread ..."
    numberToSkip < 0 ifTrue:[
        ^ self positionError.
    ].
    numberToSkip timesRepeat:[self next].

    "Modified: / 30.7.1999 / 12:42:12 / cg"
! !

!NonPositionableExternalStream methodsFor:'printing & storing'!

printOn:aStream
    "{ Pragma: +optSpace }"

    "append a user printed representation of the receiver to aStream.
     The format is suitable for a human - not meant to be read back."

    |myName|

    self == Stdin ifTrue:[
	myName := 'Stdin'.
    ] ifFalse:[
	self == Stdout ifTrue:[
	    myName := 'Stdout'.
	] ifFalse:[
	    self == Stderr ifTrue:[
		myName := 'Stderr'.
	    ]
	]
    ].

    myName notNil ifTrue:[
	aStream nextPutAll:myName.
	^ self
    ].
    super printOn:aStream
!

storeOn:aStream
    "{ Pragma: +optSpace }"

    "append a printed representation of the receiver on aStream, from
     which the receiver can be reconstructed."

    ((self == Stdin)
    or:[self == Stdout
    or:[self == Stderr]]) ifTrue:[
	^ self printOn:aStream
    ].
    super storeOn:aStream
! !

!NonPositionableExternalStream protectedMethodsFor:'private'!

closeFile
    |semasToSignal|

    handle notNil ifTrue:[
        "make sure, that no select is performed on closed file descriptors"
        semasToSignal := Processor disableFd:self fileHandle doSignal:false.
        super closeFile.

        "tell the waiters that they must not wait any longer"
        semasToSignal do:[:eachSema|
            eachSema signalForAll.
        ].
    ].
! !

!NonPositionableExternalStream methodsFor:'private'!

handleForStderr
    "{ Pragma: +optSpace }"

    "return a stderr handle"

%{
#ifdef __SCHTEAM__
    return context._RETURN( StandardErrorStream );
#else
# ifdef __win32__
    RETURN ( __MKEXTERNALADDRESS( __win32_stderr() ));
# else
    RETURN ( __MKEXTERNALADDRESS(stderr) );
# endif
#endif
%}
!

handleForStdin
    "{ Pragma: +optSpace }"

    "return a stdin handle"

%{
#ifdef __SCHTEAM__
    return context._RETURN( StandardInputStream );
#else
# ifdef __win32__
    RETURN ( __MKEXTERNALADDRESS( __win32_stdin() ));
# else
    RETURN ( __MKEXTERNALADDRESS(stdin) );
# endif
#endif
%}
!

handleForStdout
    "{ Pragma: +optSpace }"

    "return a stdout handle"

%{
#ifdef __SCHTEAM__
    return context._RETURN( StandardOutputStream );
#else
# ifdef __win32__
    RETURN ( __MKEXTERNALADDRESS( __win32_stdout() ));
# else
    RETURN ( __MKEXTERNALADDRESS(stdout) );
# endif
#endif
%}
!

initializeForStderr
    "{ Pragma: +optSpace }"

    "setup for writing to stderr"

    mode := #writeonly. "since stderr may be redirected to a pipe, reading is forbidden"
    buffered := false.
    position := 0.      "only writing - can keep track of position"
    handle := self handleForStderr.
    handleType := #filePointer.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        eolMode := #crlf
    ]
!

initializeForStdin
    "{ Pragma: +optSpace }"

    "setup for reading stdin"

    mode := #readonly.
    "/ buffered := true.
    buffered := false.
    position := 0.      "only reading - can keep track of position"
    handleType := #filePointer.
    handle := self handleForStdin.
!

initializeForStdout
    "{ Pragma: +optSpace }"

    "setup for writing to stdout"

    mode := #writeonly. "since stdout may be redirected to a pipe, reading is forbidden"
    buffered := false.
    position := 0.      "only writing - can keep track of position"
    handle := self handleForStdout.
    handleType := #filePointer.
    OperatingSystem isMSWINDOWSlike ifTrue:[
        eolMode := #crlf
    ]
!

reOpen
    "{ Pragma: +optSpace }"

    "reopen the stream after an image restart.
     If I am one of the standard streams, reopen is easy"

    (self == StdInStream) ifTrue:[
	^ self initializeForStdin
    ].
    (self == StdOutStream) ifTrue:[
	^ self initializeForStdout
    ].
    (self == StdErrorStream) ifTrue:[
	^ self initializeForStderr
    ].
    ^ super reOpen
! !

!NonPositionableExternalStream methodsFor:'queries'!

atEnd
    "return true, if position is at end.
     Notice: this is a blocking operation, as we do not know in advance,
     if there will be anything to read 
     (i.e. if the partner will send more or close the stream).
     If you want to check for available data, 
     use nextAvailable:, or canReadWithoutBlocking"

    (self == StdInStream) ifTrue:[
        OperatingSystem hasConsole ifFalse:[
            ^ true
        ]
    ].

    handle notNil ifTrue:[
        "first, wait to avoid blocking on the read.
         On end of stream or error, readWait will return"

        self readWaitWithTimeoutMs:nil.
    ].
    handle isNil ifTrue:[
        "we are closed or were closed while waiting - so we are at the end"
        ^ true.
    ].
    ^ super atEnd.
!

collectionSize
    "we do not know our size"

    ^ self positionError
!

isPositionable
    "return true, if the stream supports positioning (this one is not)"

    ^ false
!

remainingSize
    "we do not know our size"

    ^ self positionError
!

size
    "we do not know our size"

    ^ self positionError
! !

!NonPositionableExternalStream methodsFor:'reading'!

next
    "return the next element, if available.
     If nothing is available, this does never raise a read-beyond end signal.
     Instead, nil is returned immediately.

     Redefined, to wait on pipes and sockets"

    self readWaitWithTimeoutMs:nil.
    ^ super next
!

nextByte
    "redefined, to wait on pipes and sockets"

    self readWaitWithTimeoutMs:nil.
    ^ super nextByte
!

nextLine
    "return the characters upTo (but excluding) the next cr (carriage return)
     character (i.e. read a single line of text).
     If the previous-to-last character is a cr, this is also removed,
     so it's possible to read alien (i.e. ms-dos) text as well.
     Redefined to not block forever if no cr is read."

    |answerStream char wasBinary available "{ Class:SmallInteger }"|

    answerStream := WriteStream on:(String uninitializedNew:80).
    [
        "#atEnd waits for new data or EOF"
        self atEnd ifTrue:[
            answerStream size == 0 ifTrue:[
                ^ self pastEndRead.
            ].
            ^ answerStream contents.
        ].
        available := self numAvailableForRead.
        available == 0 ifTrue:[
            "so #atEnd didn't wait above, but no data is present - check for error"
            self peek.
            available := self numAvailableForRead.        
        ].
        
        wasBinary := binary.            "temporarily set to text mode"
        binary := false.
        available timesRepeat:[
            char := super nextOrNil.         "don't wait - we know that there is data"
            char == Character cr ifTrue:[
                (answerStream size ~~ 0 and:[answerStream last == Character return]) ifTrue:[
                    answerStream backStep.
                ].
                binary := wasBinary.
                ^ answerStream contents.
            ].
            char notNil ifTrue:[
                answerStream nextPut:char.
            ].
        ].
        binary := wasBinary.            "restore saved mode"
    ] loop.

    "not reached"
!

nextOrNil
    "like #next, this returns the next element, if available.
     If nothing is available, this does never raise a read-beyond end signal.
     Instead, nil is returned immediately.

     Redefined, to wait on pipes and sockets"

    self readWaitWithTimeoutMs:nil.
    handle isNil ifTrue:[
        "we were closed while waiting - so we are at the end"
        ^ nil.
    ].
    ^ super nextOrNil
!

peek
    "Redefined, to wait on pipes and sockets"

    self readWaitWithTimeoutMs:nil.
    ^ super peek
!

peekOrNil
    "like #peek, this returns the next element, if available.
     If nothing is available, this does never raise a read-beyond end signal.
     Instead, nil is returned immediately.

     Redefined, to wait on pipes and sockets"

    self readWaitWithTimeoutMs:nil.
    handle isNil ifTrue:[
        "we were closed while waiting - so we are at the end"
        ^ nil.
    ].
    ^ self peek
!

upTo:anObject into:aStream
    "read a collection of all objects up-to anObject and append these
     elements to aStream, but excluding anObject.
     The next read operation will return the element after anObject.
     (i.e. anObject is considered a separator, which is skipped)
     Similar to #through:, but the matching object is not included in the returned collection.
     If anObject is not encountered, all elements up to the end are read and returned.
     Compare this with #through: which also reads up to some object
     and also positions behind it, but DOES include it in the returned value."

    |element available "{ Class:SmallInteger }"|

    [
        "#atEnd waits for new data or EOF"
        self atEnd ifTrue:[
            ^ self.
        ].
        available := self numAvailableForRead.
        available == 0 ifTrue:[
            "so #atEnd didn't wait above, but no data is present - check for error"
            self peek.
            available := self numAvailableForRead.        
        ].

        available timesRepeat:[
            element := super next.      "we know that there is data"
            element = anObject ifTrue:[
                ^ self.
            ].
            aStream nextPut:element.
        ].
    ] loop.

    "not reached"
! !

!NonPositionableExternalStream methodsFor:'testing'!

isTTY
    "Return true if receiver refers to TTY / PTY, false otherwise."

    ^ OperatingSystem isTTY: self fileDescriptor

    "Created: / 30-05-2017 / 16:46:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NonPositionableExternalStream methodsFor:'writing'!

nextPutAll:aCollection
    "nextPutBytes handles non-blocking io in receiver"

    self nextPutBytes:aCollection size from:aCollection startingAt:1.
    ^ self.
!

nextPutAll:aCollection startingAt:start to:stop
    "redefined, to wait until stream is writable, to avoid blocking in a write"

    |count|

    count := stop-start+1.
    count ~= (self nextPutBytes:count from:aCollection startingAt:start) ifTrue:[
	"incomplete write"
	self writeError.
    ].
!

nextPutBytes:initialWriteCount from:buffer startingAt:initialOffset
    "redefined, to wait until stream is writable, to avoid blocking in a write"

    |offset remaining wasBlocking|

    offset := initialOffset.
    remaining := initialWriteCount.

    wasBlocking := self blocking:false.
    [remaining ~~ 0] whileTrue:[
	|count|

	count := super nextPutBytes:remaining from:buffer startingAt:offset.

	remaining := remaining - count.
	offset := offset + count.
	remaining ~~ 0 ifTrue:[
	    "Transcript showCR:'writeWait'."
	    self writeWait.
	].
    ].
    wasBlocking ifTrue:[self blocking:true].

    ^ offset - initialOffset.
! !

!NonPositionableExternalStream class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

