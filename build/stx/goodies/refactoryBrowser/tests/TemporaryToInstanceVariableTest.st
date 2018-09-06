"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#TemporaryToInstanceVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!TemporaryToInstanceVariableTest methodsFor:'failure tests'!

testNonExistantName
	self
		shouldFail: (TemporaryToInstanceVariableRefactoring 
					class: BasicLintRuleTest
					selector: #checkClass:
					variable: 'asdf');
		shouldFail: (TemporaryToInstanceVariableRefactoring 
					class: BasicLintRuleTest
					selector: #checkClass1:
					variable: 'aSmalllintContext')
!

testRedefinedTemporary
	| class |
	class := model classNamed: #Foo.
	class 
		compile: 'someMethod | instVarName1 | instVarName1 := 4. ^instVarName1'
		classified: #(#accessing).
	self shouldFail: (TemporaryToInstanceVariableRefactoring 
				class: class
				selector: #someMethod
				variable: 'instVarName1')
! !

!TemporaryToInstanceVariableTest methodsFor:'set up'!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')
! !

!TemporaryToInstanceVariableTest methodsFor:'tests'!

testTemporaryToInstanceVariable
	| refactoring class |
	refactoring := TemporaryToInstanceVariableRefactoring 
				class: LintRuleTest
				selector: #displayName
				variable: 'nameStream'.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self 
		assert: (class parseTreeFor: #displayName) = (RBParser 
						parseMethod: 'displayName
								nameStream := WriteStream on: (String new: 64).
								nameStream
									nextPutAll: self name;
									nextPutAll: '' (''.
								self problemCount printOn: nameStream.
								nameStream nextPut: $).
								^nameStream contents').
	self assert: (class directlyDefinesInstanceVariable: 'nameStream')
! !

!TemporaryToInstanceVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/TemporaryToInstanceVariableTest.st,v 1.3 2003-10-06 14:39:34 cg Exp $'
! !
