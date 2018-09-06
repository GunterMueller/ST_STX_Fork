"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#PullUpClassVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!PullUpClassVariableTest methodsFor:'failure tests'!

testMetaClassFailure
	self 
		shouldFail: (PullUpClassVariableRefactoring variable: #RecursiveSelfRule
				class: LintRuleTest class)
!

testNonExistantName
	self shouldFail: (PullUpClassVariableRefactoring variable: #Foo
				class: LintRuleTest)
! !

!PullUpClassVariableTest methodsFor:'tests'!

testPullUpClassVariable
	| refactoring |
	refactoring := PullUpClassVariableRefactoring variable: #RecursiveSelfRule
				class: LintRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #LintRuleTest) 
				directlyDefinesClassVariable: #RecursiveSelfRule).
	self deny: ((refactoring model classNamed: #TransformationRuleTest) 
				directlyDefinesClassVariable: #RecursiveSelfRule)
! !

!PullUpClassVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/PullUpClassVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
