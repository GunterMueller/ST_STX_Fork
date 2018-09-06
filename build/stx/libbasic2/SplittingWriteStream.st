"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#SplittingWriteStream
	instanceVariableNames:'outStream1 outStream2'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!SplittingWriteStream class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1999 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice. This software may not
 be provided or otherwise made available to, or used by, any
 other person. No title to or ownership of the software is
 hereby transferred.

"
!

documentation
"
    A stream duplicator - everything written onto a splittingWriteStream
    is written to two real streams.
    Useful, if you have to send something to two files/destinations
    simultaneously, and do not want to (or cannot) buffer it.
    Especially useful, to generate a checksum, 
    while sending something to a file 
    (if one of the output streams is a checksummer).

    [author:]
        Claus Gittinger (cg@exept)

    [see also:]
        WriteStream

    [instance variables:]
        outStream1      <Stream>       actual output streams
        outStream2      <Stream>

    [class variables:]
"
!

examples
"
    examples to be added.
                                                                [exBegin]
    |s1 s2 splitter|

    s1 := '/tmp/foo1' asFilename writeStream.
    s2 := '/tmp/foo2' asFilename writeStream.
    splitter := SplittingWriteStream on:s1 and:s2.
    splitter nextPutAll:'hello world'.
    splitter close.
                                                                [exEnd]
"
! !

!SplittingWriteStream class methodsFor:'instance creation'!

on:stream1 and:stream2
    ^ self basicNew setOutStream1:stream1 outStream2:stream2
! !

!SplittingWriteStream methodsFor:'accessing'!

outStream1
    "return the value of the instance variable 'outStream1' (automatically generated)"

    ^ outStream1
!

outStream1:something
    "set the value of the instance variable 'outStream1' (automatically generated)"

    outStream1 := something.
!

outStream2
    "return the value of the instance variable 'outStream2' (automatically generated)"

    ^ outStream2
!

outStream2:something
    "set the value of the instance variable 'outStream2' (automatically generated)"

    outStream2 := something.
! !

!SplittingWriteStream methodsFor:'private access'!

setOutStream1:stream1 outStream2:stream2
    outStream1 := stream1.
    outStream2 := stream2.

! !

!SplittingWriteStream methodsFor:'redirect messages'!

doesNotUnderstand:aMessage
    "if my superclass implements the message, it can be forwarded to both streams."

    (outStream2 class canUnderstand:aMessage selector) ifTrue:[
        aMessage sendTo:outStream1.
        ^ aMessage sendTo:outStream2.
    ].
    ^ super doesNotUnderstand:aMessage.

    "
        |sp s1 s2|

        s1 := TextStream on:''.
        s2 := TextStream on:''.

        sp := SplittingWriteStream on:s1 and:s2.

        sp nextPutAllText:('ABC' allBold); closeRun.
        s2 contents inspect.
    "
! !

!SplittingWriteStream methodsFor:'writing'!

clear
    outStream1 isStream ifFalse:[ outStream1 clear ]. 
    outStream2 isStream ifFalse:[ outStream2 clear ].
!

close
    outStream1 close.
    outStream2 close.

!

contents
    ^ outStream1 contents 
!

endEntry
    outStream1 endEntry.
    outStream2 endEntry.

!

flush
    outStream1 flush.
    outStream2 flush.

!

nextPut:something
    outStream1 nextPut:something.
    outStream2 nextPut:something.

!

nextPutAll:something
    outStream1 nextPutAll:something.
    outStream2 nextPutAll:something.

!

nextPutAll:aCollection startingAt:start to:stop
    outStream1 nextPutAll:aCollection startingAt:start to:stop.
    outStream2 nextPutAll:aCollection startingAt:start to:stop.
! !

!SplittingWriteStream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

