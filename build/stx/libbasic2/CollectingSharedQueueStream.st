SequenceableCollection subclass:#CollectingSharedQueueStream
	instanceVariableNames:'contents readPosition writePosition dataAvailable closed
		finalSizeIfKnown signalChanges'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!CollectingSharedQueueStream class methodsFor:'documentation'!

documentation
"
    This class provides a buffering mechanism between a reader and a writer
    process (i.e. it is much like a sharedQueue), but remembers the data as
    written by the writer internally, providing indexed access to elements.

    The reader side may read from it using #next, and possibly access
    elements via #at:.
    Reading/accessing may start immediately, but will block until enough elements
    have been added by another process, the writer.

    Instances of this class may be useful to start processing on
    big document/data collection immediately, while the data is still being
    read by another thread; 
    A concrete application is the HTMLDocumentReader, which is being changed to
    start processing and displaying the document while the rest is still being read.

    [author:]
        Claus Gittinger

    [see also:]
        Stream OrderedCollection SharedQueue
"
!

examples
"
  two processes synchronized much like with a sharedQueue:
                                                        [exBegin]
    |s reader|

    s := CollectingSharedQueueStream new.
    reader := [
                [s atEnd] whileFalse:[
                    Transcript showCR:s next
                ].
              ] fork.

    1 to:10 do:[:i |
        Delay waitForSeconds:1.
        s nextPut:i
    ].
                                                        [exEnd]

  the writer reads from a (slow) pipe;
  the reader sends it to the transcript.
                                                        [exBegin]
    |pipe s reader|

    s := CollectingSharedQueueStream new.
    reader := [
                [s atEnd] whileFalse:[
                    Transcript showCR:s next
                ].
              ] forkAt:9.

    pipe := PipeStream readingFrom:'ls -lR /usr'.
    pipe notNil ifTrue:[
        [pipe atEnd] whileFalse:[
            pipe readWait.
            s nextPut:(pipe nextLine).
        ].
        pipe close.
    ].
    s close
                                                        [exEnd]


  the writer reads from a (slow) pipe;
  the collection is used in a TextView, which
  will block whenever lines are to be displayed, which have not
  yet been read:
                                                        [exBegin]
    |view pipe buffer reader|

    buffer := CollectingSharedQueueStream new.
    buffer finalSize:100.

    [
        pipe := PipeStream readingFrom:'ls -lR /usr'.
        pipe notNil ifTrue:[
            [pipe atEnd] whileFalse:[
                pipe readWait.
                buffer nextPut:(pipe nextLine).
            ].
            pipe close.
        ].
        buffer changed:#size.
        buffer close.
    ] fork.

    view := ScrollableView for:TextView.
    view model:buffer; listMessage:#value; aspectMessage:#value.
    view open.
                                                        [exEnd]
"

! !

!CollectingSharedQueueStream class methodsFor:'instance creation'!

new
    ^ self basicNew initialize

    "Created: 5.3.1997 / 14:30:36 / cg"
! !

!CollectingSharedQueueStream methodsFor:'accessing'!

at:index
    "synchronized read - possibly wait for elements up to index
     being added (by someone else); then return it."

    writePosition > index ifTrue:[
        ^ contents at:index
    ].

    [writePosition <= index] whileTrue:[
        closed ifTrue:[
            ^ self subscriptBoundsError:index
        ].
        dataAvailable wait.
    ].
    ^ contents at:index

    "Created: 5.3.1997 / 14:44:41 / cg"
!

next
    "return the next value in the queue; if there is none,
     wait 'til something is put into the receiver."

    |value|

    [readPosition >= writePosition] whileTrue:[
        closed ifTrue:[
            ^ nil
        ].
        dataAvailable wait
    ].

    value := contents at:readPosition.
    readPosition := readPosition + 1.
    ^ value

    "Created: 5.3.1997 / 14:28:57 / cg"
    "Modified: 5.3.1997 / 14:45:54 / cg"
!

nextPut:anObject
    "append anObject to the queue; if anyone is waiting, tell him"

    |value|

    contents add:anObject.
    writePosition := writePosition + 1.

    finalSizeIfKnown isNil ifTrue:[
        signalChanges ifTrue:[
            self changed:#size with:nil
        ]
    ].
    dataAvailable signal

    "Created: 5.3.1997 / 14:33:44 / cg"
    "Modified: 5.3.1997 / 15:42:33 / cg"
! !

!CollectingSharedQueueStream methodsFor:'accessing - special'!

close
    "signal the end of input; to be used by the writer"

    closed := true.
    dataAvailable signal

    "Modified: 5.3.1997 / 14:45:11 / cg"
!

finalSize:aNumber
    "can be used by the writer, if the final size is known in
     advance."

    finalSizeIfKnown := aNumber.
    signalChanges ifTrue:[
        self changed:#size
    ].

    "Created: 5.3.1997 / 15:36:07 / cg"
    "Modified: 5.3.1997 / 15:57:24 / cg"
!

signalChanges:aBoolean
    "controls if I should send out size-changeMessages when new elements arrive"

    signalChanges := aBoolean.

    "Created: 5.3.1997 / 15:40:57 / cg"
! !

!CollectingSharedQueueStream methodsFor:'dummy converting'!

asStringCollection
     ^ self

    "Created: 5.3.1997 / 16:02:57 / cg"
! !

!CollectingSharedQueueStream methodsFor:'initialization'!

initialize
    readPosition := writePosition := 1.
    dataAvailable := Semaphore new.
    contents := OrderedCollection new.
    closed := false.

    "Modified: 5.3.1997 / 14:34:55 / cg"
! !

!CollectingSharedQueueStream methodsFor:'queries'!

atEnd
    closed ifFalse:[^ false].
    ^ readPosition >= writePosition

    "Modified: 5.3.1997 / 14:41:04 / cg"
!

currentSize
    ^ contents size

    "Modified: 5.3.1997 / 15:56:36 / cg"
!

size
    closed ifTrue:[^ contents size].
    finalSizeIfKnown notNil ifTrue:[^ finalSizeIfKnown].

    "/ must wait until closed
    [closed] whileFalse:[
        dataAvailable wait
    ].
    closed ifTrue:[^ contents size].

    "Created: 5.3.1997 / 15:35:29 / cg"
    "Modified: 5.3.1997 / 15:57:08 / cg"
! !

!CollectingSharedQueueStream class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libbasic2/CollectingSharedQueueStream.st,v 1.3 1997-03-05 16:26:06 cg Exp $'
! !
