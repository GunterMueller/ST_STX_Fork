"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#PushUpInstanceVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!PushUpInstanceVariableTest methodsFor:'failure tests'!

testPullUpVariableNotDefined
	self shouldFail: (PullUpInstanceVariableRefactoring 
				variable: 'notDefinedVariable'
				class: LintRuleTest)
! !

!PushUpInstanceVariableTest methodsFor:'tests'!

testPullUpInstVar
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := PullUpInstanceVariableRefactoring variable: 'result'
						class: LintRuleTest.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: #LintRuleTest) 
				directlyDefinesInstanceVariable: 'result').
	self deny: ((refactoring model classNamed: #BasicLintRuleTest) 
				directlyDefinesInstanceVariable: 'result')
! !

!PushUpInstanceVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/PushUpInstanceVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
