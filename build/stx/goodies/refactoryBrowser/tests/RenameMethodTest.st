"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RenameMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RenameMethodTest methodsFor:'failure tests'!

testExistingSelector
	self shouldFail: (RenameMethodRefactoring 
				renameMethod: #checkClass:
				in: BasicLintRuleTest
				to: #runOnEnvironment:
				permuation: (1 to: 1))
!

testMultipleSelectors
	self shouldWarn: (RenameMethodRefactoring 
				renameMethod: #checkClass:
				in: BasicLintRuleTest
				to: #foo:
				permuation: (1 to: 1))
! !

!RenameMethodTest methodsFor:'tests'!

testRenamePermuteArgs
	| refactoring class |
	refactoring := RenameMethodRefactoring 
				renameMethod: ('rename:' , 'two:') asSymbol
				in: RefactoryTestDataApp
				to: ('rename:' , 'two:') asSymbol
				permuation: #(2 1).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self 
		assert: (class parseTreeFor: ('rename:' , 'two:') asSymbol) = (RBParser 
						parseMethod: 'rename: argumentMethod two: this ^self printString, this, argumentMethod').
	self assert: (class parseTreeFor: #exampleCall) 
				= (RBParser parseMethod: 'exampleCall ^self rename: 2 two: 1')
!

testRenamePrimitive
	| refactoring count |
	count := 0.
	model allReferencesTo: #basicAt:put: do: [:method | count := count + 1].
	refactoring := RenameMethodRefactoring 
				model: model
				renameMethod: #basicAt:put:
				in: Object
				to: ('at:' , 'bar:') asSymbol
				permuation: (1 to: 2).
	self proceedThroughWarning: [self executeRefactoring: refactoring].
	model allReferencesTo: #basicAt:put:
		do: 
			[:method | 
			count := count - 1.
			self assert: method source isNil].
	model allReferencesTo: ('at:' , 'bar:') asSymbol
		do: [:method | count := count - 1].
	self assert: count = 0
!

testRenameTestMethod
	| refactoring class |
	refactoring := RenameMethodRefactoring 
				renameMethod: ('rename' , 'ThisMethod:') asSymbol
				in: RefactoryTestDataApp
				to: #renameThisMethod2:
				permuation: (1 to: 1).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self assert: (class parseTreeFor: #renameThisMethod2:) 
				= (RBParser parseMethod: 'renameThisMethod2: anArg
	^self').
	self assert: (class parseTreeFor: #callMethod) 
				= (RBParser parseMethod: 'callMethod
	^(self renameThisMethod2: 5)').
	self 
		assert: (class parseTreeFor: #symbolReference) = (RBParser 
						parseMethod: 'symbolReference
		^ #(#renameThisMethod2: #(4 #renameThisMethod2:))').
	self 
		deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)
!

testRenameTestMethod1
	| refactoring class |
	refactoring := RenameMethodRefactoring 
				renameMethod: ('test' , 'Method1') asSymbol
				in: RefactoryTestDataApp
				to: #testMethod2
				permuation: (1 to: 0).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self 
		assert: (class parseTreeFor: #testMethod2) = (RBParser 
						parseMethod: 'testMethod2
	^self testMethod2 , ([:each | each testMethod2] value: #(#(#testMethod2) 2 #testMethod2))').
	self 
		assert: ((refactoring model classNamed: #BasicLintRuleTest) 
				parseTreeFor: #classBlock:) = (RBParser 
							parseMethod: 'classBlock: aBlock
	classBlock := aBlock testMethod2').
	self deny: (class directlyDefinesMethod: ('test' , 'Method1') asSymbol)
! !

!RenameMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RenameMethodTest.st,v 1.3 2003-10-06 14:39:34 cg Exp $'
! !
