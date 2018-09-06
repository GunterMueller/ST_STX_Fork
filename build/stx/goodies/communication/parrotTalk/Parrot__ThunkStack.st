"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

OrderedCollection subclass:#ThunkStack
	instanceVariableNames:'properties'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

ThunkStack comment:'I am a complete protocol implemented as a stack of subprotocols.  One end of the stack (the bottom or `tail'') is usually an endpoint communicating with some remote host or process.  The other end (the top or `head'') is either the point of communication for my client (which reads and writes only application-oriented data) or even the client itself.I am created by sending my class the message #on: aSubProtocol.  You can then send me #push: aProtocol as many times as you like, to push aProtocol onto the head of my protocol stack.  When the stack is complete you must send me #install which tells me to finish creating the internal connections between each subprotocol in the stack.  Finally you send me #run which tells the entire protocol stack to start.'
!


!ThunkStack class methodsFor:'instance creation'!

on: layer

	^self new push: layer
! !

!ThunkStack methodsFor:'accessing'!

head
	"Answer the head of the stack."

	^self first
!

pop
	"Remove the head of the stack."
	| layer |
	self isEmpty ifTrue: [^ nil].
	layer := self removeFirst.
	^ layer
!

properties

	properties ifNil: [ properties := IdentityDictionary new ].
	^ properties
!

propertyAt: aKey

	^ self properties at: aKey ifAbsent: []
!

propertyAt: aKey put: aValue

	^ self properties at: aKey put: aValue
!

push: layer
	"Push a new protocol onto the head of the stack."

	layer install.
	self addFirst: layer.
!

tail
	"Answer the tail of the stack."

	^self last
! !

!ThunkStack methodsFor:'protocol'!

downcall: sourceFrame from: sourceGate

	| sourceIndex frame |
	sourceIndex := self indexOf: sourceGate.
	frame := sourceFrame.
	[[ sourceIndex + 1 to: self size by: 1 do: [:i | (self at: i) downcall: frame] ]
		on: BlockCannotReturn do: [:ex | ^ nil ]]
		on: CryptographyError do: [:ex | ^ nil ].
	^ true
!

install

	self do: [:this | this install]
!

issConnected

	^self tail isConnected
!

run

	self do: [:proto | proto run]
!

shutdown

	[self notEmpty] whileTrue: [
		self head close. self pop].
!

stop
	self
		do: [:proto | proto close].
	self shutdown
!

upcall: sourceFrame from: sourceGate

	| sourceIndex frame |
	sourceIndex := self indexOf: sourceGate.
	frame := sourceFrame.
	[[sourceIndex - 1 to: 1 by: -1 do: [:i | (self at: i) upcall: frame ] ]
		on: BlockCannotReturn do: [:ex | ^ nil ]]
		on: CryptographyError do: [:ex | ^ nil ].
	^ true
! !

!ThunkStack class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ThunkStack.st,v 1.1 2018-05-14 00:19:03 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ThunkStack.st,v 1.1 2018-05-14 00:19:03 cg Exp $'
! !

