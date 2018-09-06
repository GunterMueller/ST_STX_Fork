"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

IdentityDictionary subclass:#ProtocolState
	instanceVariableNames:'stateName default'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

ProtocolState comment:'I am a single state within a cyclic graph of states.  My values are edges leading to another state in the graph.  If the edge has an action associated with it then I perform the method of that name in my client object, passing the object which stepped me as argument, before following the edge.Structure: name		Symbol				-- my state''s name keys		Object				-- the input tokens that cause me to step values		#(Symbol1 Symbol2)	-- an edge: the next state and a client action selector default		#(Symbol1 Symbol2)	-- the edge I follow if no key matches the stepping objectI am intended to be inserted somewhere in the middle of a LayeredProtocol stack.'
!


!ProtocolState class methodsFor:'instance creation'!

basicNew

	^ super basicNew
		initialize;
		yourself
!

name: myName default: aTransition
	^self new
		stateName: myName;
		default: aTransition
! !

!ProtocolState class methodsFor:'accessing'!

created
	^ self new
		stateName: #created;
		yourself
!

submitted
	^ self new
		stateName: #submitted;
		yourself
! !

!ProtocolState class methodsFor:'examples'!

example
	"ProtocolState example"

	^(self name: #initial default: #echo: -> #initial)
		at: 42 put: #echo42: -> #initial;
		yourself
! !

!ProtocolState methodsFor:'accessing'!

add: anAssociation

	^self transitionAt: anAssociation key put: (self transitionFor: anAssociation value)
!

addAll: anAssociation

	^self atAll: anAssociation key put: anAssociation value
!

addAllInteger: anAssociation

	^self atAllInteger: anAssociation key put: anAssociation value
!

addInteger: anAssociation

	^self transitionAt: anAssociation key asInteger put: (self transitionFor: anAssociation value)
!

at: key put: transition

	^self transitionAt: key put: (self transitionFor: transition)
!

at: anObject to: limit put: transition

	| edge |
	edge := self transitionFor: transition.
	anObject to: limit do: [:target | self transitionAt: target put: edge]
!

atAll: collection put: transition
	| edge |
	edge := self transitionFor: transition.
	collection do: [:elt | self transitionAt: elt put: edge]
!

atAllInteger: collection put: transition
	| edge |
	edge := self transitionFor: transition.
	collection do: [:elt | self transitionAt: elt asInteger put: edge]
!

default

	^default
!

default: transition

	self defaultTransition: (self transitionFor: transition)
!

defaultTransition: aTransition

	default := aTransition
!

name
	^ self stateName
!

name: aSymbol

	stateName := aSymbol
!

stateName

	^ stateName
!

stateName: aSymbol

	stateName := aSymbol
!

transitionAt: key

	^super at: key ifAbsent: [default]
!

transitionAt: key put: edge

	^super at: key put: edge
! !

!ProtocolState methodsFor:'actions'!

isStateNamed: aSymbol
	^ stateName == aSymbol
!

transitionEvent: event value: value client: client

	| transition action toState |
	self validateEvent: event.
	transition := self transitionAt: event.
	action := transition key.
	toState := transition value.
	action isNil ifFalse: [client perform: action with: value].
	toState
		ifNil: [(KeyNotFound key: toState) signal]
		ifNotNil: [^toState]
! !

!ProtocolState methodsFor:'comparing'!

= anotherState
	^ self == anotherState
		or: [ 
			self class == anotherState class
				and: [ stateName = anotherState stateName ] ]
!

hash
	^ stateName hash + (self collect: [:e | e key]) hash
! !

!ProtocolState methodsFor:'printing'!

printElementsOn: aStream

	aStream nextPutAll: '(name: ' , stateName printString.
	aStream nextPutAll: ' default: ' , default printString.
	aStream nextPutAll: ' transitions:'.
	self associationsDo: [:transition | aStream space.  transition printOn: aStream.].
	aStream nextPut: $).
!

printOn: aStream
	aStream
		nextPutAll: 'State: ';
		nextPutAll: stateName asString
! !

!ProtocolState methodsFor:'private'!

transitionExistsForEvent: event

	self keysDo: [:key | (key = event) ifTrue: [^ true] ].
	^ false
!

transitionFor: transition

	^transition key -> transition value
!

validateEvent: event

        ^ (self transitionExistsForEvent: event)
                ifTrue: [ true ]
                ifFalse: [ ((KeyNotFound ? KeyNotFoundError) new key: event) signal ]
! !

!ProtocolState class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolState.st,v 1.2 2018-05-14 00:39:14 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolState.st,v 1.2 2018-05-14 00:39:14 cg Exp $'
! !

