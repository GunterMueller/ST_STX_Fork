"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#AddMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!AddMethodTest methodsFor:'failure tests'!

testBadMethod
	self shouldFail: (AddMethodRefactoring 
				addMethod: 'asdf ^super ^printString'
				toClass: BasicLintRuleTest
				inProtocols: #(#accessing))
!

testExistingSelector
	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
	    BasicLintRuleTest autoload
	].
	self shouldFail: (AddMethodRefactoring 
				addMethod: 'printString ^super printString'
				toClass: BasicLintRuleTest
				inProtocols: #(#accessing))
!

testModelExistingSelector
	| refactoring |
	refactoring := AddMethodRefactoring 
				model: model
				addMethod: 'classVarName1 ^super printString'
				toClass: (model classNamed: #Bar)
				inProtocols: #(#accessing).
	self shouldFail: refactoring
!

testModelInheritedSelector
	| refactoring |
	refactoring := AddMethodRefactoring 
				model: model
				addMethod: 'printString ^super printString'
				toClass: (model classNamed: #Bar)
				inProtocols: #(#accessing).
	self shouldFail: refactoring
! !

!AddMethodTest methodsFor:'set up'!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')
! !

!AddMethodTest methodsFor:'tests'!

testAddMethod
	| refactoring |
	refactoring := AddMethodRefactoring 
				addMethod: 'printString1 ^super printString'
				toClass: BasicLintRuleTest
				inProtocols: #(#accessing).
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #BasicLintRuleTest) 
				parseTreeFor: #printString1) 
					= (RBParser parseMethod: 'printString1 ^super printString')
!

testModelAddMethod
	| refactoring class |
	class := model metaclassNamed: #Bar.
	refactoring := AddMethodRefactoring 
				model: model
				addMethod: 'printString1 ^super printString'
				toClass: class
				inProtocols: #(#accessing).
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #printString1) 
				= (RBParser parseMethod: 'printString1 ^super printString')
! !

!AddMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/AddMethodTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
