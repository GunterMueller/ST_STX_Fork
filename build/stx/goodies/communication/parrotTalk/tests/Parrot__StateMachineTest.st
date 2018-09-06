"{ Package: 'stx:goodies/communication/parrotTalk/tests' }"

"{ NameSpace: Parrot }"

TestCase subclass:#StateMachineTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'ParrotTalk-test'
!

StateMachineTest comment:''
!


!StateMachineTest methodsFor:'tests'!

processNotMe: f
!

testStateMap

	| desc state |
	desc := ProtocolStateCompiler initialState: #initial.
	(desc newState: #initial -> (#processInvalidRequest: -> #dead))
		add: #answer -> (nil -> #connected);
		add: #call -> (nil -> #connected).
	(desc newState: #connected -> (nil->nil))
		addInteger: 7 -> (#processBytes: -> #connected);
		addInteger: 16 -> (#processNotMe: -> #dead).
	(desc newState: #dead -> (#processInvalidRequest: -> #dead)).

	state := desc compile.
	self assert: (state isStateNamed: #initial).
	state := state transitionEvent: #call value: nil client: nil.
	self assert: (state isStateNamed: #connected).
	self should: [ state transitionEvent: #NonRegisteredEvent value: nil client: nil ] raise: KeyNotFound.
	self assert: (state isStateNamed: #connected).
	state := state transitionEvent: 16 value: nil client: self.
	self assert: (state isStateNamed: #dead).
! !

!StateMachineTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__StateMachineTest.st,v 1.1 2018-05-14 00:20:00 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/communication/parrotTalk/tests/Parrot__StateMachineTest.st,v 1.1 2018-05-14 00:20:00 cg Exp $'
! !

