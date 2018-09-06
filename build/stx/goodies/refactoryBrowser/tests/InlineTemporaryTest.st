"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#InlineTemporaryTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!InlineTemporaryTest methodsFor:'tests'!

testInlineTemporary
	| refactoring |
	refactoring := InlineTemporaryRefactoring 
				inline: (self convertInterval: (24 to: 72)
						for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				from: #inlineMethod
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				parseTreeFor: #inlineMethod) = (RBParser 
							parseMethod: 'inlineMethod
										^self
													foo;
													inlineMethod;
													bar')
!

testInlineTemporaryBadInterval
	self shouldFail: (InlineTemporaryRefactoring 
				inline: (self convertInterval: (29 to: 100)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)
!

testInlineTemporaryMutlipleAssignment
	self shouldFail: (InlineTemporaryRefactoring 
				inline: (self convertInterval: (60 to: 83)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)
!

testInlineTemporaryReadBeforeWritten
	self shouldFail: (InlineTemporaryRefactoring 
				inline: (self convertInterval: (48 to: 56)
						for: (RefactoryTestDataApp sourceCodeAt: #inlineTemporary))
				from: #inlineTemporary
				in: RefactoryTestDataApp)
! !

!InlineTemporaryTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/InlineTemporaryTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
