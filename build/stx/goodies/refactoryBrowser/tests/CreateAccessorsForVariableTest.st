"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#CreateAccessorsForVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!CreateAccessorsForVariableTest methodsFor:'failure tests'!

testNonExistantName
	self
		shouldFail: (CreateAccessorsForVariableRefactoring 
					variable: #Foo
					class: BasicLintRuleTest
					classVariable: true);
		shouldFail: (CreateAccessorsForVariableRefactoring 
					variable: 'foo'
					class: BasicLintRuleTest
					classVariable: true)
! !

!CreateAccessorsForVariableTest methodsFor:'set up'!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')
! !

!CreateAccessorsForVariableTest methodsFor:'tests'!

testExistingInstanceVariableAccessors
	| ref |
	ref := CreateAccessorsForVariableRefactoring 
				variable: 'name'
				class: LintRuleTest
				classVariable: false.
	self executeRefactoring: ref.
	self assert: ref changes changes isEmpty.
	self assert: ref setterMethod == #name:.
	self assert: ref getterMethod == #name
!

testNewClassVariableAccessors
	| ref class |
	ref := CreateAccessorsForVariableRefactoring 
				variable: 'Foo1'
				class: LintRuleTest
				classVariable: true.
	self executeRefactoring: ref.
	class := ref model metaclassNamed: #LintRuleTest.
	self deny: ref changes changes isEmpty.
	self assert: ref setterMethod == #foo1:.
	self assert: ref getterMethod == #foo1.
	self 
		assert: (class parseTreeFor: #foo1) = (RBParser parseMethod: 'foo1 ^Foo1').
	self assert: (class parseTreeFor: #foo1:) 
				= (RBParser parseMethod: 'foo1: anObject Foo1 := anObject')
!

testNewInstanceVariableAccessors
	| ref class |
	ref := CreateAccessorsForVariableRefactoring 
				variable: 'foo1'
				class: LintRuleTest
				classVariable: false.
	self executeRefactoring: ref.
	class := ref model classNamed: #LintRuleTest.
	self deny: ref changes changes isEmpty.
	self assert: ref setterMethod == #foo1:.
	self assert: ref getterMethod == #foo1.
	self 
		assert: (class parseTreeFor: #foo1) = (RBParser parseMethod: 'foo1 ^foo1').
	self assert: (class parseTreeFor: #foo1:) 
				= (RBParser parseMethod: 'foo1: anObject foo1 := anObject')
! !

!CreateAccessorsForVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/CreateAccessorsForVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
