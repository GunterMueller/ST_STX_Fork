"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RenameClassVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RenameClassVariableTest methodsFor:'failure tests'!

testAlreadyExistingName
	self shouldFail: (RenameClassVariableRefactoring 
				rename: #RecursiveSelfRule
				to: self objectClassVariable
				in: TransformationRuleTest)
!

testMetaClassFailure
	self shouldFail: (RenameClassVariableRefactoring 
				rename: #RecursiveSelfRule
				to: #Foo
				in: TransformationRuleTest class)
!

testNonExistantName
	self shouldFail: (RenameClassVariableRefactoring 
				rename: #foo
				to: #newFoo
				in: BasicLintRuleTest)
! !

!RenameClassVariableTest methodsFor:'tests'!

testRenameClassVar
	| refactoring class |
	refactoring := RenameClassVariableRefactoring 
				rename: #RecursiveSelfRule
				to: #RSR
				in: TransformationRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class directlyDefinesClassVariable: #RSR).
	self deny: (class directlyDefinesClassVariable: #RecursiveSelfRule).
	self 
		assert: (class metaclass parseTreeFor: #initializeAfterLoad1) = (RBParser 
						parseMethod: 'initializeAfterLoad1
								RSR := ParseTreeSearcher new.
								RSR
									addMethodSearches: #(''`@methodName: `@args | `@temps | self `@methodName: `@args'' ''`@methodName: `@args | `@temps | ^self `@methodName: `@args'')
											-> [:aNode :answer | true]').
	self assert: (class metaclass parseTreeFor: #nuke) 
				= (RBParser parseMethod: 'nuke
								RSR := nil').
	self 
		assert: (class parseTreeFor: #checkMethod:) = (RBParser 
						parseMethod: 'checkMethod: aSmalllintContext 
								class := aSmalllintContext selectedClass.
								(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
										[(RSR executeTree: rewriteRule tree initialAnswer: false)
											ifFalse: 
												[builder compile: rewriteRule tree printString
													in: class
													classified: aSmalllintContext protocols]]')
! !

!RenameClassVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RenameClassVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
