"{ Package: 'stx:libbasic2' }"

PeekableStream subclass:#CollectingReadStream
	instanceVariableNames:'collectBlock inStream'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams-Misc'
!

!CollectingReadStream class methodsFor:'documentation'!

documentation
"
    A stream which evaluates collectBlock for every element
    read from an underlying stream, providing the result from
    the evaluation as read-elements.
    Useful to process a readStream, for tracing or diverting to another
    processing stage.

    [Author:]
        Claus Gittinger
"
!

examples
"
                                                            [exBegin]
    |s|

    s := CollectingReadStream 
            on:#(1 2 3 4 5 6 7 8) readStream
            collecting:[:each | each squared].
    s upToEnd  
                                                            [exEnd]

                                                            [exBegin]
    |s|

    s := (#(1 2 3 4 5 6 7 8) readStream 
            selecting:[:n | n odd])
                collecting:[:n | n squared].
    s upToEnd    
                                                            [exEnd]
"
! !

!CollectingReadStream class methodsFor:'instance creation'!

diverting:aStream to:anotherStream
    ^ self on:aStream collecting:[:el | anotherStream nextPut:el. el].

    "
     |s|

     s := CollectingReadStream 
            diverting:#(1 2 3 4 5 6 7 8) readStream
            to:Transcript.
     s upToEnd  
    "
!

on:aStream collecting:aBlock
    ^ self basicNew on:aStream collecting:aBlock

    "
     |s|

     s := CollectingReadStream 
            on:#(1 2 3 4 5 6 7 8) readStream
            collecting:[:each | each squared].
     s upToEnd  
    "
! !

!CollectingReadStream methodsFor:'instance creation'!

on:aStream collecting:aBlock
    inStream := aStream.
    collectBlock := aBlock.
! !

!CollectingReadStream methodsFor:'queries'!

atEnd
    ^ inStream atEnd
!

contentsSpecies
    "return a class of which instances will be returned, when
     parts of the collection are asked for. 
     (see upTo-kind of methods in Stream)"

    ^ inStream contentsSpecies.
! !

!CollectingReadStream methodsFor:'stream protocol'!

next
    inStream atEnd ifTrue:[
        ^ self pastEndRead
    ].
    ^ collectBlock value:(inStream next)
!

nextOrNil
    |ch|

    ch := inStream nextOrNil.
    ch notNil ifTrue:[
        collectBlock value:ch
    ].
    ^ ch

    "Created: / 26-10-2011 / 17:29:01 / cg"
!

nextPeek
    self next.
    ^ self peek

    "Created: / 26-10-2011 / 17:25:16 / cg"
!

peek
    ^ inStream peek

    "Created: / 26-10-2011 / 17:24:59 / cg"
!

peekOrNil
    ^ inStream peekOrNil

    "Created: / 26-10-2011 / 17:25:32 / cg"
!

position
    ^ inStream position

    "Created: / 26-10-2011 / 17:25:08 / cg"
!

position0Based
    <resource: #obsolete>
    ^ inStream position

    "Created: / 26-10-2011 / 17:23:56 / cg"
!

position1Based
    <resource: #obsolete>
    ^ inStream position + 1

    "Created: / 26-10-2011 / 17:22:42 / cg"
!

readStream
    ^ self

    "Created: / 26-10-2011 / 17:25:43 / cg"
! !

!CollectingReadStream class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libbasic2/CollectingReadStream.st,v 1.6 2014-04-30 18:19:37 cg Exp $'
! !

