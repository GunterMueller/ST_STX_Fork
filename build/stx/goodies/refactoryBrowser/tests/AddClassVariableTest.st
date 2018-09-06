"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#AddClassVariableTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!AddClassVariableTest methodsFor:'failure tests'!

testAlreadyExistingName
	self
		shouldFail: (AddClassVariableRefactoring variable: #RecursiveSelfRule
					class: TransformationRuleTest);
		shouldFail: (AddClassVariableRefactoring variable: self objectClassVariable
					class: TransformationRuleTest)
!

testMetaClassFailure
	self shouldFail: (AddClassVariableRefactoring variable: #VariableName
				class: TransformationRuleTest class)
!

testMetaclass
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: #ClassVarName3
				class: (model classNamed: #Object) metaclass.
	refactoring model: model.
	self shouldFail: refactoring
!

testModelAlreadyExistingName
	| refactoring |
	refactoring := AddClassVariableRefactoring 
				model: model
				variable: #ClassVarName2
				class: (model classNamed: #Bar).
	self shouldFail: refactoring
!

testModelMetaclass
	| refactoring |
	refactoring := AddClassVariableRefactoring 
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar) metaclass.
	self shouldFail: refactoring
! !

!AddClassVariableTest methodsFor:'set up'!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')
! !

!AddClassVariableTest methodsFor:'tests'!

testAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring variable: 'Asdf'
				class: TransformationRuleTest.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #TransformationRuleTest) 
				directlyDefinesClassVariable: #Asdf)
!

testModelAddClassVariable
	| refactoring |
	refactoring := AddClassVariableRefactoring 
				model: model
				variable: #ClassVarName3
				class: (model classNamed: #Bar).
	self executeRefactoring: refactoring.
	self assert: ((model classNamed: #Bar) 
				directlyDefinesClassVariable: #ClassVarName3)
! !

!AddClassVariableTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/AddClassVariableTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
