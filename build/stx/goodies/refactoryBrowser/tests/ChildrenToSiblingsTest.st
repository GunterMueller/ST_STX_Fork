"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#ChildrenToSiblingsTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!ChildrenToSiblingsTest methodsFor:'failure tests'!

testBadName
	self shouldFail: (ChildrenToSiblingsRefactoring 
				name: #'Obje ct'
				class: LintRuleTest
				subclasses: (Array with: BasicLintRuleTest with: CompositeLintRuleTest))
!

testExistingName
	self
		shouldFail: (ChildrenToSiblingsRefactoring 
					name: #Object
					class: LintRuleTest
					subclasses: (Array with: BasicLintRuleTest with: CompositeLintRuleTest));
		shouldFail: (ChildrenToSiblingsRefactoring 
					name: #Processor
					class: LintRuleTest
					subclasses: (Array with: BasicLintRuleTest with: CompositeLintRuleTest))
!

testInvalidSubclass
	self shouldFail: (ChildrenToSiblingsRefactoring 
				name: #Foo
				class: LintRuleTest
				subclasses: (Array with: BasicLintRule with: CompositeLintRule))
!

testMetaClassFailure
	self shouldFail: (ChildrenToSiblingsRefactoring 
				name: #Foo
				class: LintRuleTest class
				subclasses: (Array with: BasicLintRuleTest class
						with: CompositeLintRuleTest class))
! !

!ChildrenToSiblingsTest methodsFor:'set up'!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'ChildrenToSiblingTest.st')
! !

!ChildrenToSiblingsTest methodsFor:'tests'!

testModelChildrenToSibling
	| refactoring class subclass superclass |
	class := model classNamed: #ConcreteSuperclass.
	subclass := model classNamed: #ConcreteSubclass.
	refactoring := ChildrenToSiblingsRefactoring 
				model: model
				name: #AbstractSuperclass
				class: class
				subclasses: (Array with: subclass).
	self executeRefactoring: refactoring.
	superclass := refactoring model classNamed: #AbstractSuperclass.
	self assert: class superclass = superclass.
	self assert: class metaclass superclass = superclass metaclass.
	self assert: subclass superclass = superclass.
	self assert: subclass metaclass superclass = superclass metaclass.
	self 
		assert: (superclass parseTreeFor: #same) = (RBParser 
						parseMethod: 'same ^self initialize isKindOf: AbstractSuperclass').
	self assert: (superclass parseTreeFor: #different) 
				= (RBParser parseMethod: 'different self subclassResponsibility').
	self 
		assert: (superclass parseTreeFor: #initialize) = (RBParser 
						parseMethod: 'initialize
							instVarName1 := instVarName2 := ClassVarName1 := ClassVarName2 := 0').
	self assert: (superclass directlyDefinesInstanceVariable: 'instVarName1').
	self assert: (superclass directlyDefinesInstanceVariable: 'instVarName2').
	self assert: (superclass directlyDefinesClassVariable: 'ClassVarName1').
	self assert: (superclass directlyDefinesClassVariable: 'ClassVarName2').
	self assert: (superclass metaclass 
				directlyDefinesInstanceVariable: 'classInstVarName1').
	self 
		assert: (superclass metaclass parseTreeFor: #foo) = (RBParser 
						parseMethod: 'foo
							^classInstVarName1 + ClassVarName1 + ClassVarName2').
	self assert: (superclass metaclass parseTreeFor: #new) 
				= (RBParser parseMethod: 'new
							^super new initialize').
	self assert: (superclass metaclass parseTreeFor: #bar) 
				= (RBParser parseMethod: 'bar
							self subclassResponsibility').
	self deny: (class directlyDefinesInstanceVariable: 'instVarName1').
	self deny: (class directlyDefinesInstanceVariable: 'instVarName2').
	self deny: (class directlyDefinesClassVariable: 'ClassVarName1').
	self deny: (class directlyDefinesClassVariable: 'ClassVarName2').
	self 
		deny: (class metaclass directlyDefinesInstanceVariable: 'classInstVarName1').
	self deny: (class directlyDefinesMethod: #same).
	self deny: (class directlyDefinesMethod: #initialize).
	self deny: (class metaclass directlyDefinesMethod: #new).
	self assert: (class parseTreeFor: #different) 
				= (RBParser parseMethod: 'different
							^instVarName1 + instVarName2').
	self assert: (class metaclass parseTreeFor: #bar) 
				= (RBParser parseMethod: 'bar
							^self printString')
! !

!ChildrenToSiblingsTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ChildrenToSiblingsTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
