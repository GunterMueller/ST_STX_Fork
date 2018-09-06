"{ Package: 'stx:goodies/smaCC' }"

"{ NameSpace: SmaCC }"

PeekableStream subclass:#SmaCCLineNumberStream
	instanceVariableNames:'sourceStream previousWasCR eolPositions lastPosition'
	classVariableNames:'CR LF'
	poolDictionaries:''
	category:'SmaCC-Runtime'
!


!SmaCCLineNumberStream class methodsFor:'initialization'!

initialize
    CR := Character cr.
    Smalltalk isSmalltalkX ifTrue:[
        CR := Character return.
    ].
    LF := Character nl.

    "
     self initialize
    "
! !

!SmaCCLineNumberStream class methodsFor:'instance creation'!

on: aReadStream 
	^(self basicNew)
		on: aReadStream;
		yourself
! !

!SmaCCLineNumberStream class methodsFor:'accessing'!

zeroPosition

    ^0

    "Created: / 05-04-2006 / 21:27:49 / janfrog"
! !

!SmaCCLineNumberStream methodsFor:'accessing'!

contents
	^sourceStream contents
!

flush
	^sourceStream flush
!

lineNumber
	| index start stop pos |
	pos := sourceStream position.
	pos >= eolPositions last ifTrue: [^eolPositions size].
	start := 1.
	stop := eolPositions size.
	[start + 1 < stop] whileTrue: 
			[index := (start + stop) // 2.
			(eolPositions at: index) <= pos 
				ifTrue: [start := index]
				ifFalse: [stop := index]].
	^start
!

next
        | character |
        character := sourceStream next.
        sourceStream position - 1 == lastPosition 
                ifTrue: 
                        [lastPosition := lastPosition + 1.
                        character == CR 
                                ifTrue: 
                                        [eolPositions add: sourceStream position.
                                        previousWasCR := true]
                                ifFalse: 
                                        [(previousWasCR not and: [character == LF]) 
                                                ifTrue: [eolPositions add: sourceStream position].
                                        previousWasCR := false]].
        ^character
!

nextPut: anObject 
	^sourceStream nextPut: anObject
!

position
	^sourceStream position
!

position: anInteger 
	anInteger > lastPosition 
		ifTrue: 
			[sourceStream position: lastPosition.
			[sourceStream position < anInteger and: [sourceStream atEnd not]] 
				whileTrue: [self next]]
		ifFalse: [sourceStream position: anInteger]
!

skip: anInteger
	^self position: self position + anInteger
! !

!SmaCCLineNumberStream methodsFor:'error handling'!

doesNotUnderstand: aMessage 
	^sourceStream perform: aMessage selector withArguments: aMessage arguments
! !

!SmaCCLineNumberStream methodsFor:'initialize-release'!

on: aReadStream 
	sourceStream := aReadStream.
	eolPositions := OrderedCollection with: aReadStream position.
	lastPosition := aReadStream position.
	previousWasCR := false
! !

!SmaCCLineNumberStream methodsFor:'testing'!

atEnd
	^sourceStream atEnd
!

isReadable
	^sourceStream isReadable
!

isWritable
	^sourceStream isWritable
! !

!SmaCCLineNumberStream class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/smaCC/SmaCC__SmaCCLineNumberStream.st,v 1.2 2006-04-05 20:07:51 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

SmaCCLineNumberStream initialize!
