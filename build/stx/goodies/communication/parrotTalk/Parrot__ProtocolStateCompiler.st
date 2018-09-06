"{ Package: 'stx:goodies/communication/parrotTalk' }"

"{ NameSpace: Parrot }"

IdentityDictionary subclass:#ProtocolStateCompiler
	instanceVariableNames:'initialState'
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-base'
!

ProtocolStateCompiler comment:'I am a collection of ProtocolStates constituting a transition graph for a StatefulProtocol.  See my class side for some examples of how I construct state machine descriptions for you.Note that before I can be used to drive a StatefulProtocol you *must* send me #compile.  I will answer the initial ProtocolState in the compiled transition graph.  (I will also complain if your protocol is broken. ;-)  You subsequently pass this ProtocolState as the argument to StatefulProtocol class>>initialState: in order to instantiate a new StatefulProtocol.Structure: initialState		Symbol	-- the name of the initial (root) node in my transition graph'
!


!ProtocolStateCompiler class methodsFor:'instance creation'!

initialState: stateName

	^self new initialState: stateName
! !

!ProtocolStateCompiler class methodsFor:'examples'!

example
	"A state machine that recognises occurrences of 'x' 'xy' and 'xy[digits...]z' in a stream of characters.  Note: this is used by StateMachineTester, so don't modify it.  See StateMachineTester class>>test for an example of use."
	"ProtocolStateCompiler example"

	| desc |
	desc := self new.
	(desc newState: #initial -> (#echo: -> #initial)) add: $x -> (nil -> #statex).
	(desc newState: #statex -> (#echox: -> #initial)) add: $y -> (#initPrefix: -> #statexy).
	(desc newState: #statexy -> (#echoxy: -> #initial))
		add: $z -> (#echoxyz: -> #initial);
		addAll: '0123456789' -> (#addPrefix: -> nil).
	desc initialState: #initial.
	^desc
!

example2
	"ProtocolStateCompiler example2 explore"

	^self example compile
!

example3		"Note: this example should pop up an error notifier during compilation"

	"ProtocolStateCompiler example3 compile"

	| desc |
	desc := self new.
	(desc newState: #initial -> (#echo: -> #initial)) add: $x -> (nil -> #statex).
	(desc newState: #statex -> (#echox: -> #initial)) add: $y -> (nil -> #statexy).
	(desc newState: #statexy -> (#echoxy: -> #initial)) add: $z -> (#echoxy: -> #statexyz).
	(desc newState: #statexyz -> (#echoxy: -> #initial)) add: $z -> (#echoxyz: -> #statexyz).
	desc initialState: #initial.
	^desc
!

example4		"Note: this example should pop up an error notifier during compilation"

	"ProtocolStateCompiler example4 compile"

	| desc |
	desc := self new.
	(desc newState: 0 -> (#echo: -> 0)) add: $x -> (nil -> 1).
	(desc newState: 1 -> (#echox: -> 0)) add: $y -> (nil -> 2).
	(desc newState: 2 -> (#echoxy: -> 0)) add: $z -> (#echoxy: -> 3).
	(desc newState: 3 -> (#echoxy: -> 0)) add: $z -> (#echoxyz: ->3).
	desc initialState: 0.
	^desc
! !

!ProtocolStateCompiler methodsFor:'compiling'!

compile
	"Compile my symbolic representation into a cyclic DAG and answer the root node"

	| edge |
	self valuesDo: [:state |
		state defaultTransition: (self resolve: state default).
		state keysDo: [:key |
			edge := state at: key.
			state transitionAt: key put: (self resolve: edge)]].
	
	^self at: initialState
!

resolve: edge

	| action target |
	action := edge key.
	target := edge value.
	target := (self includesKey: target)
		ifTrue: [self at: target]
		ifFalse: [target isNil
					ifTrue: [nil]
					ifFalse: [self error: 'unknown target state ' , edge printString]].
	^ action -> target
! !

!ProtocolStateCompiler methodsFor:'initialize-release'!

initialState: stateName

	initialState := stateName
!

newState: rule

	^self newState: rule key default: rule value
!

newState: stateName default: transition

	^self at: stateName put: (ProtocolState name: stateName default: transition)
! !

!ProtocolStateCompiler methodsFor:'printing'!

printElementsOn: aStream

	aStream nextPutAll: '(initial: ' , initialState printString , ' states:'.
	self keysDo: [:key | aStream space.  key printOn: aStream].
	aStream nextPut: $)
! !

!ProtocolStateCompiler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolStateCompiler.st,v 1.1 2018-05-14 00:18:39 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/Parrot__ProtocolStateCompiler.st,v 1.1 2018-05-14 00:18:39 cg Exp $'
! !

