"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

ThunkLayer subclass:#FrameBuffer
	instanceVariableNames:'stack readFrame bufferStream'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

FrameBuffer comment:''
!


!FrameBuffer class methodsFor:'as yet unclassified'!

newOnStack: stack

	^ self basicNew
		initializeOn: stack;
		yourself
! !

!FrameBuffer methodsFor:'initialize'!

initializeOn: aStack

	self initialize.
	stack := aStack.
	bufferStream := ReadWriteStream on: (ByteArray new: 12288).
! !

!FrameBuffer methodsFor:'stack'!

drainBuffer

	| remainingFrameSize frameSpecSize | 
	frameSpecSize := Frame specificationSize.	
	[readFrame notNil or: [bufferStream size >= frameSpecSize]] whileTrue: [
		readFrame ifNil: [readFrame := Frame onFrameSpecification: (bufferStream next: frameSpecSize)].
		remainingFrameSize := readFrame encodedSize.
		(remainingFrameSize < 0) ifTrue: [CryptographyError signal: 'frame messageSize failure'].
		(bufferStream size < remainingFrameSize) ifTrue: [^ self].
		readFrame readRemainderFrom: (bufferStream next: remainingFrameSize) readStream.
		(readFrame frameVersion == 1)
			ifTrue: [[[ stack upcall: readFrame from: self ] 
				on: Halt do: [:halt | halt resumeUnchecked: halt defaultAction ]]
				on: Exception do: [:ex | ex pass]].
		readFrame := nil.
		(bufferStream size = 0) ifTrue: [bufferStream reset]].
	
! !

!FrameBuffer methodsFor:'thunk - accessing'!

doesPop

	^ false
!

headerMakerThunk

	^ [:frame | RawData new ]
!

upThunk

	^ [:frame | | startPos |
		startPos := bufferStream position.
		bufferStream nextPutAll: frame payload.
		bufferStream position: startPos.
		self drainBuffer.
		BlockCannotReturn signal: 'frameBuffer drained' ].
! !

!FrameBuffer class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__FrameBuffer.st,v 1.1 2018-05-14 00:18:27 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__FrameBuffer.st,v 1.1 2018-05-14 00:18:27 cg Exp $'
! !

