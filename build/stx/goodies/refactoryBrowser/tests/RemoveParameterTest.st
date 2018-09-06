"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RemoveParameterTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RemoveParameterTest methodsFor:'failure tests'!

testNonExistantName
	self
		shouldFail: (RemoveParameterRefactoring 
					removeParameter: 'asdf'
					in: BasicLintRuleTest
					selector: #checkClass:);
		shouldFail: (RemoveParameterRefactoring 
					removeParameter: 'aSmalllintContext'
					in: BasicLintRuleTest
					selector: #checkClass1:)
!

testPrimitiveMethods
	| refactoring |
	(model classNamed: #Object) 
		compile: 'foo123: a <primitive: 100> ^#() primitiveFailed'
		classified: #(#accessing).
	refactoring := RemoveParameterRefactoring 
				model: model
				removeParameter: 'a'
				in: Object
				selector: #foo123:.
	self shouldFail: refactoring
! !

!RemoveParameterTest methodsFor:'tests'!

testRemoveParameter
	| refactoring class |
	refactoring := RemoveParameterRefactoring 
				removeParameter: 'anArg'
				in: RefactoryTestDataApp
				selector: ('rename' , 'ThisMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self assert: (class parseTreeFor: #renameThisMethod) 
				= (RBParser parseMethod: 'renameThisMethod
								^self').
	self assert: (class parseTreeFor: #callMethod) 
				= (RBParser parseMethod: 'callMethod
								^(self renameThisMethod)').
	self 
		deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)
! !

!RemoveParameterTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RemoveParameterTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
