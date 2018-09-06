"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RenameInstanceVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RenameInstanceVariableTest methodsFor:'failure tests'!

testAlreadyExistingName
	self shouldFail: (RenameInstanceVariableRefactoring 
				rename: 'classBlock'
				to: 'name'
				in: BasicLintRuleTest)
!

testNonExistantName
	self shouldFail: (RenameInstanceVariableRefactoring 
				rename: 'foo'
				to: 'newFoo'
				in: BasicLintRuleTest)
! !

!RenameInstanceVariableTest methodsFor:'tests'!

testRenameInstVar
	| refactoring class |
	refactoring := RenameInstanceVariableRefactoring 
				rename: 'classBlock'
				to: 'asdf'
				in: BasicLintRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #BasicLintRuleTest.
	self assert: (class directlyDefinesInstanceVariable: 'asdf').
	self deny: (class directlyDefinesInstanceVariable: 'classBlock').
	self 
		assert: (class parseTreeFor: #checkClass:) = (RBParser 
						parseMethod: 'checkClass: aSmalllintContext 
								^asdf value: aSmalllintContext value: result').
	self 
		assert: (class parseTreeFor: #classBlock:) = (RBParser 
						parseMethod: 'classBlock: aBlock
								asdf := aBlock testMethod1').
	self 
		assert: (class parseTreeFor: #initialize) = (RBParser 
						parseMethod: 'initialize
								super initialize.
								asdf := [:context :aResult | ].
								methodBlock := [:context :aResult | ].
								self resultClass: SelectorEnvironment.')
! !

!RenameInstanceVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RenameInstanceVariableTest.st,v 1.3 2003-10-06 14:39:34 cg Exp $'
! !
