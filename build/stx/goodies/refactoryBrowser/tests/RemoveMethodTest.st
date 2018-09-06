"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RemoveMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RemoveMethodTest methodsFor:'failure tests'!

testRemoveReferenced
	self shouldFail: (RemoveMethodRefactoring removeMethods: #(#checkClass:)
				from: BasicLintRuleTest)
!

testRemoveSameMethodButSendsSuper
	self shouldWarn: (RemoveMethodRefactoring removeMethods: #(#new)
				from: BasicLintRuleTest class)
! !

!RemoveMethodTest methodsFor:'tests'!

testModelRecursiveMethodThatIsNotReferencedFromOtherMethods
	| class otherClass |
	class := model classNamed: #Object.
	class compile: 'someMethodThatIsNotReferenced ^2' classified: #(#accessing).
	self assert: (class definesMethod: #someMethodThatIsNotReferenced).
	otherClass := model metaclassNamed: self class superclass name.
	otherClass 
		compile: 'someMethodThatIsNotReferenced ^3 someMethodThatIsNotReferenced'
		classified: #(#accessing).
	model removeClassNamed: self class name.
	self executeRefactoring: (RemoveMethodRefactoring 
				model: model
				removeMethods: #(#someMethodThatIsNotReferenced)
				from: class).
	self deny: (class definesMethod: #someMethodThatIsNotReferenced)
!

testRemoveMethod
	| refactoring selectors |
	selectors := Array with: ('selectorNot' , 'Referenced') asSymbol.
	refactoring := RemoveMethodRefactoring removeMethods: selectors
				from: RefactoryTestDataApp.
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				directlyDefinesMethod: selectors first).
	self executeRefactoring: refactoring.
	self deny: ((refactoring model classNamed: #RefactoryTestDataApp) 
				directlyDefinesMethod: selectors first)
! !

!RemoveMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RemoveMethodTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
