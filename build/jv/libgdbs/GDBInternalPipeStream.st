"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
"{ Package: 'jv:libgdbs' }"

"{ NameSpace: Smalltalk }"

Stream subclass:#GDBInternalPipeStream
	instanceVariableNames:'buffer first last accessLock dataAvailable spaceAvailable closed'
	classVariableNames:'DefaultBufferSize'
	poolDictionaries:''
	category:'GDB-Support'
!

!GDBInternalPipeStream class methodsFor:'documentation'!

copyright
"
jv:libgdbs - GNU Debugger Interface Library
Copyright (C) 2015-now Jan Vrany

This library is free software; you can redistribute it and/or
modify it under the terms of the GNU Lesser General Public
License as published by the Free Software Foundation; either
version 2.1 of the License. 

This library is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public
License along with this library; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
"
!

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

    terminal translateNLToCRNL:true.
    terminal inputTranslateCRToNL:true.
    terminal localEcho:true.

    elizasOutput nextPutLine:'Hi, I am Eliza'.
    elizasOutput nextPutLine:'What is your problem ?'.
    elizasOutput nextPutLine:''.
    elizasOutput nextPutAll:'>'.

    [top realized] whileTrue:[
        |line answer matchingRule|

        line := userInput nextLine.
        (#('quit' 'exit' 'end' 'bye') includes:line) ifTrue:[
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

!GDBInternalPipeStream class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)

    DefaultBufferSize := 1024.

    "Modified: / 07-06-2014 / 00:49:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream class methodsFor:'instance creation'!

new
    ^ self newWithBufferSize: DefaultBufferSize

    "Modified: / 10-06-2014 / 00:26:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWithBufferSize: bufferSize
    ^ self basicNew initializeWithBufferSize: bufferSize

    "Created: / 07-06-2014 / 00:48:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'accessing'!

atEnd
    ^ closed and:[ last == 0 ]

    "Modified: / 07-06-2014 / 01:06:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

close
    closed := true.
    dataAvailable signalForAll.

    "Modified: / 26-08-2014 / 09:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

readStream
    ^ self

    "Created: / 03-07-2014 / 20:57:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

size
    last == 0 ifTrue:[ ^ 0 ].
    last >= first ifTrue:[ 
        ^ last - first + 1 
    ] ifFalse:[ 
        ^ buffer size - first + 1 + last
    ].

    "Modified: / 07-06-2014 / 01:08:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'initialization'!

initializeWithBufferSize: bufferSize
    buffer := String new: bufferSize.
    first := 1.
    last := 0.

    accessLock := Semaphore forMutualExclusion." Plug new respondTo: #critical: with: [ :block | block value ]; yourself."
    dataAvailable := Semaphore new.
    spaceAvailable := Semaphore new.

    closed := false

    "Created: / 07-06-2014 / 00:49:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 11-06-2014 / 23:12:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'non homogenous reading'!

nextAvailableBytes:max into:out startingAt:offset
    | count |

    accessLock critical:[
        last == 0 ifTrue:[ 
            count := 0
        ] ifFalse:[
            last >= first ifTrue:[         
                count := max min: (last - first + 1).    
                out replaceFrom:offset to: offset + count - 1 with: buffer startingAt: first.
                first := first + count.
                first > last ifTrue:[ 
                    first := 1. 
                    last := 0.
                ].
                spaceAvailable signalForAll.
            ] ifFalse:[ 
                "/ Wrap around
                count := max.
                first + count <= buffer size ifTrue:[ 
                    out replaceFrom:offset to: offset + count - 1 with: buffer startingAt: first.
                    first := (first + count) \\ buffer size.
                    spaceAvailable signalForAll.
                ] ifFalse:[ 
                    | rem |

                    count := max min: (buffer size - first) + last.
                    rem := buffer size - first.
                    out replaceFrom: offset to: offset + (buffer size - first) with: buffer startingAt: first.

                    out replaceFrom: offset + (buffer size - first + 1) to:  offset + count with: buffer startingAt: 1.
                    rem == last ifTrue:[ 
                        first := 1.
                        last := 0.
                    ] ifFalse:[
                        first := rem + 1.
                    ].
                ].
            ].
        ].
    ].
    ^ count

    "Modified: / 11-06-2014 / 21:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'non homogenous writing'!

nextPutBytes:count from:bytes startingAt:start
    "Write count bytes from an object starting at index start.
     Return the number of bytes written.
     The object must have non-pointer indexed instvars 
     (i.e. be a ByteArray, String, Float- or DoubleArray).     
     Use with care - non object oriented i/o.
     This is provided for compatibility with externalStream;
     to support binary storage"

    | written write remaining offset space |

    closed ifTrue:[ 
        self class writeErrorSignal signal:'Pipe stream closed'.
    ].
    written := 0.
    remaining := count.
    offset := start.

    space := true.
    [ space and:[remaining > 0] ] whileTrue:[
        accessLock critical:[
            space := ("self hasSpace"last == 0 or:[ ( (last \\ buffer size) + 1) ~~ first]).
            space ifTrue:[
                last == 0 ifTrue:[ 
                    "/ Special case - empty buffer
                    write := remaining min: buffer size.
                    buffer replaceFrom:1 to: write with: bytes startingAt: offset.
                    last := write.
                ] ifFalse:[
                    | lastPlusOne |

                    lastPlusOne := (last \\ buffer size) + 1.

                    first < lastPlusOne ifTrue:[ 
                        write := remaining min: (buffer size - last).
                    ] ifFalse:[
                        write := (first - lastPlusOne + 1) min: remaining.
                    ].
                    buffer replaceFrom: lastPlusOne to: lastPlusOne + write - 1 with: bytes startingAt: offset.
                    last := (last \\ buffer size) + write.
                ].
                remaining := remaining - write.
                written := written + write.
                offset := offset + write.  
                dataAvailable signalForAll.    
            ].
        ].
    ].
    ^ written.

    "Created: / 09-06-2014 / 22:04:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2014 / 08:15:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'private'!

contentsSpecies
    ^ buffer class

    "Created: / 09-06-2014 / 21:50:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'private-queries'!

hasData
    ^ last ~~ 0

    "Created: / 11-06-2014 / 21:19:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

hasSpace
    ^ last == 0 or:[ ( (last \\ buffer size) + 1) ~~ first]

    "Created: / 11-06-2014 / 21:18:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'reading'!

next
    "return the next element from the stream (might block until something is written)"

    | c |

    [
        accessLock critical:[
            ("self hasData"last ~~ 0) ifTrue:[ 
                c := buffer at: first.
                first == last ifTrue:[ 
                    first := 1.
                    last := 0.
                ] ifFalse:[
                   first := (first \\ buffer size) + 1
                ].
                spaceAvailable signalForAll.
                ^ c
            ] ifFalse:[ 
                closed ifTrue:[ ^ nil ]
            ].
        ].
        dataAvailable wait.
    ] loop.

    "Modified: / 11-06-2014 / 21:38:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

peek
    "return the next element from the stream but do not advance position (might block until something is written)"

    | c |

    [
        accessLock critical:[
            ("self hasData"last ~~ 0) ifTrue:[ 
                c := buffer at: first.
                ^ c
            ] ifFalse:[ 
                closed ifTrue:[ ^ nil ]
            ].
        ].
        dataAvailable wait.
    ] loop.

    "Created: / 08-03-2015 / 05:54:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'synchronization'!

readWait
    last == 0 ifTrue:[ 
        dataAvailable wait.
    ].

    "Modified: / 07-06-2014 / 01:09:29 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

writeWait    
    | hasSpace |

    accessLock critical:[ hasSpace := self hasSpace ].
    hasSpace ifFalse:[ 
        spaceAvailable wait.
    ].

    "Created: / 11-06-2014 / 22:04:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 07-09-2014 / 08:17:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream methodsFor:'writing'!

nextPut:aCharacter
    | done |

    closed ifTrue:[ 
        self class writeErrorSignal signal:'Pipe stream closed'.
        ^ self.
    ].

    done := false.
    [ done ] whileFalse:[
        accessLock critical:[
            ("self hasSpace"last == 0 or:[ ( (last \\ buffer size) + 1) ~~ first]) ifTrue:[
                last := (last \\ buffer size) + 1.
                buffer at: last put: aCharacter.
                done := true.
            ].
        ].
        done ifFalse:[ 
            spaceAvailable wait.
        ].
    ].
    dataAvailable signalForAll.

    "Modified: / 11-06-2014 / 21:49:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextPutAll:aCollection
    "Put all elements of the argument, aCollection onto the receiver."

    ^ self nextPutAll: aCollection startingAt: 1 to: aCollection size

    "Created: / 09-06-2014 / 21:58:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

nextPutAll:aCollection startingAt:firstIndex to: lastIndex
    "Append the elements with index from firstIndex to lastIndex
     of the argument, aCollection,  onto the receiver."

    closed ifTrue:[ 
        self class writeErrorSignal signal:'Pipe stream closed'.
    ].

    (aCollection class == self contentsSpecies) ifTrue:[
        | remaining offset written |

        remaining := lastIndex - firstIndex + 1.
        offset := firstIndex.
        [ remaining > 0 ] whileTrue:[
            written := self nextPutBytes: remaining from: aCollection startingAt: offset.
            remaining := remaining - written.
            offset := offset + written.
            remaining > 0 ifTrue:[ 
                self writeWait.
            ].
        ].

    ] ifFalse:[ 
        super nextPutAll:aCollection startingAt:firstIndex to: lastIndex
    ].

    "Created: / 09-06-2014 / 21:57:15 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 06-09-2014 / 16:35:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GDBInternalPipeStream class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !


GDBInternalPipeStream initialize!
