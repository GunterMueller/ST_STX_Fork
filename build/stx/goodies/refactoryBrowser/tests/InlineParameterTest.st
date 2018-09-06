"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#InlineParameterTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!InlineParameterTest methodsFor:'failure tests'!

testInlineBlockFailure
	self shouldFail: (InlineParameterRefactoring 
				inlineParameter: 'aBlock'
				in: RefactoryTestDataApp
				selector: ('inline' , 'Foo:') asSymbol)
! !

!InlineParameterTest methodsFor:'tests'!

testInlineLiteralArray
	| refactoring class |
	refactoring := InlineParameterRefactoring 
				inlineParameter: 'aSymbol'
				in: RefactoryTestDataApp
				selector: ('inline' , 'ParameterMethod:') asSymbol.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self 
		assert: (class parseTreeFor: #inlineParameterMethod) = (RBParser 
						parseMethod: 'inlineParameterMethod | aSymbol | aSymbol := #(asdf). ^aSymbol isSymbol').
	self 
		assert: (class parseTreeFor: #sendInlineParameterMethod) = (RBParser 
						parseMethod: 'sendInlineParameterMethod ^self inlineParameterMethod').
	self deny: (class 
				directlyDefinesMethod: ('inline' , 'ParameterMethod:') asSymbol)
! !

!InlineParameterTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/InlineParameterTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
