"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RemoveClassVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RemoveClassVariableTest methodsFor:'failure tests'!

testNonExistantName
	self 
		shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule1
				class: TransformationRuleTest)
!

testReferencedVariable
	self 
		shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule
				class: TransformationRuleTest)
! !

!RemoveClassVariableTest methodsFor:'tests'!

testRemoveClassVar
	| refactoring class |
	refactoring := RemoveClassVariableRefactoring variable: 'Foo1'
				class: LintRuleTest.
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class definesClassVariable: 'Foo1').
	self executeRefactoring: refactoring.
	self deny: (class definesClassVariable: 'Foo1')
! !

!RemoveClassVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RemoveClassVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
