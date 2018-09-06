"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RemoveInstanceVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RemoveInstanceVariableTest methodsFor:'failure tests'!

testNonExistantName
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name1'
				class: LintRuleTest)
!

testReferencedVariable
	self shouldFail: (RemoveInstanceVariableRefactoring variable: 'name'
				class: LintRuleTest)
! !

!RemoveInstanceVariableTest methodsFor:'tests'!

testModelRemoveInstanceVariable
	| class |
	model 
		defineClass: 'nil subclass: #Object instanceVariableNames: ''foo1'' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	class := model classNamed: #Object.
	self assert: (class definesInstanceVariable: 'foo1').
	self executeRefactoring: (RemoveInstanceVariableRefactoring 
				model: model
				variable: 'foo1'
				class: class).
	self deny: (class definesInstanceVariable: 'foo1')
!

testRemoveInstVar
	| refactoring class |
	refactoring := RemoveInstanceVariableRefactoring variable: 'foo1'
				class: LintRuleTest.
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class definesInstanceVariable: 'foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesInstanceVariable: 'foo1')
! !

!RemoveInstanceVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RemoveInstanceVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
