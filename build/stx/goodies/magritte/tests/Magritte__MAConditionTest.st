"{ Package: 'stx:libcompat' }"

"{ NameSpace: Magritte }"

TestCase subclass:#MAConditionTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Magritte-Tests-Utility'
!


!MAConditionTest methodsFor:'testing'!

testConjunctive
	| condition |
	condition := (MACondition selector: #isInteger) & (MACondition selector: #positive).
	self assert: (condition value: 1).
	self deny: (condition value: 1.5).	
	self deny: (condition value: -1).
	self deny: (condition value: -1.5)
!

testDisjunctive
	| condition |
	condition := (MACondition selector: #isInteger) | (MACondition selector: #positive).
	self assert: (condition value: 1).
	self assert: (condition value: 1.5).	
	self assert: (condition value: -1).
	self deny: (condition value: -1.5)
!

testNegation
	| condition |
	condition := (MACondition selector: #isInteger) not.
	self assert: (condition value: 0.6).
	self deny: (condition value: 1)
!

testReceiverSelector
	| condition |
	condition := MACondition receiver: 1 selector: #=.
	self assert: (condition value: 1).
	self deny: (condition value: 0)
!

testSelector
	| condition |
	condition := MACondition selector: #isInteger.
	self assert: (condition value: -1).
	self assert: (condition value: 1).
	self deny: (condition value: 0.5)
	
!

testSelectorArgument
	| condition |
	condition := MACondition selector: #< argument: 5.
	self assert: (condition value: 1).
	self deny: (condition value: 5)
! !

!MAConditionTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/magritte/tests/Magritte__MAConditionTest.st,v 1.1 2009-07-29 15:23:44 cg Exp $'
! !
