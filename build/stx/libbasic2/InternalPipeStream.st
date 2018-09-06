"{ Package: 'stx:libbasic2' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#InternalPipeStream
	instanceVariableNames:'queue closed contentsSpecies'
	classVariableNames:''
	poolDictionaries:''
	category:'Streams'
!

!InternalPipeStream class methodsFor:'documentation'!

documentation
"
    not useful on its own, but can be used to talk to a vt100
    terminal view ...
    
    See example.
"
!

examples
"
                                                                [exBegin]
    |p|

    p := InternalPipeStream new.
    [
        10 timesRepeat:[
            p nextPutLine:'hello'
        ].
    ] fork.

    [
        10 timesRepeat:[
            Transcript showCR:p nextLine
        ].
    ] fork.
                                                                [exEnd]

                                                                [exBegin]
    |userInput elizasOutput top terminal|

    userInput    := InternalPipeStream new.
    elizasOutput := InternalPipeStream new.

    top := StandardSystemView new.
    terminal := VT100TerminalView openOnInput: userInput output:elizasOutput in:top.

    top extent:(terminal preferredExtent).
    top label:'The doctor is in'.
    top iconLabel:'doctor'.
    top open.
    top waitUntilVisible.
    top onChangeEvaluate:[:what :aParameter :changedObject | what == #destroyed ifTrue:[userInput close]].

    terminal translateNLToCRNL:true.
    terminal inputTranslateCRToNL:true.
    terminal localEcho:true.

    elizasOutput nextPutLine:'Hi, I am Eliza'.
    elizasOutput nextPutLine:'What is your problem (type end to finish conversation) ?'.
    elizasOutput nextPutLine:''.
    elizasOutput nextPutAll:'>'.

    [top realized] whileTrue:[
        |line answer matchingRule|

        line := userInput nextLine.
        ((line isEmptyOrNil and:[userInput atEnd]) or:[ #('quit' 'exit' 'end' 'bye') includes:line ]) ifTrue:[
            top destroy.
            ^ self
        ].

        answer := 'Tell me more.'.
        elizasOutput nextPutLine:answer.
        elizasOutput nextPutAll:'>'.
    ].
                                                                [exEnd]
"
! !

!InternalPipeStream class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!InternalPipeStream methodsFor:'accessing'!

atEnd
    ^ closed and:[queue isEmpty]
!

close
    "if there is any partner waiting at either side of the queue,
     tell it that the pipe is no longer active.
     (readers will read an EOF condition, writers will get a write error).
     Either side may close the internal pipe."
     
    closed := true.
    queue readSemaphore signalForAll
!

isOpen
    ^ closed not
!

next
    "return the next element from the stream (might block until something is written)"

    (closed and:[queue isEmpty]) ifTrue:[^ self pastEndRead].
    ^ queue next
!

nextAvailableBytes:nMax into:aBuffer startingAt:startIndex
    |n idx ch|

    (closed and:[queue isEmpty and:[self pastEndRead isNil]]) ifTrue:[^ 0].

    n := 0.
    idx := startIndex.
    [n <= nMax] whileTrue:[
        ch := queue nextIfEmpty:[^ n ].
        aBuffer at:idx put:ch.
        idx := idx + 1.
        n := n + 1
    ].
    ^ n
!

nextPut:anObject
    "write an element (might wakeup readers)"

    closed ifTrue:[ self errorNotOpen].
    queue nextPut:anObject

    "
     |s|
     s := InternalPipeStream new.
     s nextPut:$a.
     s nextPut:$b.
     s nextPut:$c.
    "
!

size
    ^ queue size
! !

!InternalPipeStream methodsFor:'initialization'!

contentsSpecies:aClass
    "by default, I will return a String of elements, if reading multiple elements.
     However, you may change this to eg. an array, if desired"

    contentsSpecies := aClass.
!

initialize
    queue := SharedQueue new.
    closed := false.
! !

!InternalPipeStream methodsFor:'queries'!

contentsSpecies
    ^ contentsSpecies ? String
! !

!InternalPipeStream methodsFor:'synchronization'!

readWait
    queue readSemaphore wait
!

writeWaitWithTimeoutMs:timeout
    queue writeSemaphore waitWithTimeoutMs:timeout
! !

!InternalPipeStream class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

