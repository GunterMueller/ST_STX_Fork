"{ Package: 'stx:libbasic2' }"

Stream subclass:#LoggingStream
	instanceVariableNames:'loggedStream logger'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!LoggingStream class methodsFor:'documentation'!

documentation
"
    Useful for debugging - stream operations are logged in human readable form
    on a separate logger stream, while stream operations are forwarded to the underlying
    loggedStream.

    Unfinished - may need more protocol to be intercepted.

    sample use, logging operations on a socket stream:
        sock := ... Socket connectTo: ...
        s := LoggingStream new loggedStream: sock.
        ...
        use s instead of sock
        ...

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!LoggingStream class methodsFor:'instance creation'!

on:aStream
    "Create & return a new instance for aStream, logging to the Transcript."

    ^ self on:aStream logger:Transcript
!

on:aStream logger:aLoggerStream
    "Create & return a new instance for aStream, logging to aLoggerStream."

    ^ self basicNew initializeOn:aStream logger:aLoggerStream
! !

!LoggingStream methodsFor:'accessing'!

loggedStream
    ^ loggedStream
!

loggedStream:something
    loggedStream := something.
!

logger
    ^ logger
!

logger:something
    logger := something.
! !

!LoggingStream methodsFor:'initialization'!

initializeOn:aStream logger:aLogger
    loggedStream := aStream.
    logger := aLogger.
! !

!LoggingStream methodsFor:'logging'!

log:messageString
    logger nextPutLine:messageString.
! !

!LoggingStream methodsFor:'stream protocol'!

atEnd
    ^ loggedStream atEnd.
!

flush
    loggedStream flush.
!

next
    |el|

    el := loggedStream next.
    self log:( '<<< ' , el storeString ).
    ^ el
!

next:n
    |els|

    els := loggedStream next:n.
    self log:( '<<< ' , els storeString ).
    ^ els
!

nextBytes:n
    |els|

    els := loggedStream nextBytes:n.
    self log:( '<<< ' , els storeString ).
    ^ els
!

nextPut:something
    self log:( '>>> ' , something storeString).
    loggedStream nextPut:something.
!

nextPutAll:aCollection
    self log:( '>>> ' , aCollection storeString).
    loggedStream nextPutAll:aCollection.
!

peek
    ^ loggedStream peek
!

peekOrNil
    ^ loggedStream peekOrNil
!

readWait
    ^ loggedStream readWait.
!

skipSeparators
    |ch|

    [
        (ch := loggedStream peekOrNil) notNil
        and:[ch isSeparator]
    ] whileTrue:[
        self next.
    ].
    ^ ch
!

upToEnd
    |els|

    els := loggedStream upToEnd.
    self log:( '<<< ' , els storeString).
    ^ els
! !

!LoggingStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/LoggingStream.st,v 1.7 2014-05-29 10:59:23 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/LoggingStream.st,v 1.7 2014-05-29 10:59:23 cg Exp $'
! !

