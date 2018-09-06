"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#AddClassTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!AddClassTest methodsFor:'failure tests'!

testExistingName
	self shouldFail: (AddClassRefactoring 
				addClass: #Object
				superclass: self class
				subclasses: #()
				category: #'Refactory-Testing')
!

testInvalidSubclass
	self shouldFail: (AddClassRefactoring 
				addClass: #Foo
				superclass: CompositeLintRuleTest
				subclasses: (Array with: BasicLintRuleTest)
				category: #'Refactory-Tesing')
!

testMetaClassFailure
	self shouldFail: (AddClassRefactoring 
				addClass: #Foo
				superclass: self class class
				subclasses: #()
				category: #'Refactory-Testing')
!

testModelExistingName
	| refactoring |
	refactoring := AddClassRefactoring 
				model: model
				addClass: #Foo
				superclass: Object
				subclasses: #()
				category: #'Refactory-Testing'.
	self shouldFail: refactoring
!

testModelInvalidSubclass
	| refactoring |
	refactoring := AddClassRefactoring 
				model: model
				addClass: #Foo2
				superclass: Object
				subclasses: (Array with: (model classNamed: #Bar))
				category: #'Refactory-Tesing'.
	self shouldFail: refactoring
! !

!AddClassTest methodsFor:'set up'!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')
! !

!AddClassTest methodsFor:'tests'!

testAddClass
	| refactoring newClass superClass classTest |
	refactoring := AddClassRefactoring 
				addClass: #FooTest
				superclass: RefactoringTest
				subclasses: (Array with: self class)
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classNamed: #RefactoringTest.
	classTest := refactoring model classNamed: self class name.
	self assert: newClass superclass = superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass = superClass metaclass.
	self 
		assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: classTest superclass = newClass.
	self assert: (newClass subclasses includes: classTest).
	self assert: classTest metaclass superclass = newClass metaclass.
	self assert: (newClass metaclass subclasses includes: classTest metaclass)
!

testModelAddClass
	| refactoring newClass superClass subclass |
	subclass := model classNamed: #Bar.
	superClass := model classNamed: #Foo.
	refactoring := AddClassRefactoring 
				model: model
				addClass: #FooTest
				superclass: superClass
				subclasses: (Array with: subclass)
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := model classNamed: #FooTest.

	self assert: newClass superclass = superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass = superClass metaclass.
	self 
		assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: subclass superclass = newClass.
	self assert: (newClass subclasses includes: subclass).
	self assert: subclass metaclass superclass = newClass metaclass.
	self assert: (newClass metaclass subclasses includes: subclass metaclass)
! !

!AddClassTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/AddClassTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
