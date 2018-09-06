"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#RenameClassTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RenameClassTest methodsFor:'failure tests'!

testBadName
	self
		shouldFail: (RenameClassRefactoring rename: LintRuleTest
					to: self objectClassVariable);
		shouldFail: (RenameClassRefactoring rename: LintRuleTest to: #'Ob ject')
!

testExistingName
	self shouldFail: (RenameClassRefactoring rename: self class to: #Object)
!

testMetaClassFailure
	self 
		shouldFail: (RenameClassRefactoring rename: self class class to: #Foo)
! !

!RenameClassTest methodsFor:'tests'!

testModelRenameClass
	| refactoring class |
	model 
		defineClass: 'Object subclass: #Foo instanceVariableNames: ''a'' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	class := model classNamed: #Foo.
	class
		compile: 'foo   ^Object' classified: #(#accessing);
		compile: 'objectName ^#(Object)' classified: #(#accessing).
	refactoring := RenameClassRefactoring 
				model: model
				rename: Object
				to: #Thing.
	self executeRefactoring: refactoring.
	self assert: (model includesClassNamed: #Thing).
	self deny: (model includesClassNamed: #Object).
	self 
		assert: (class parseTreeFor: #foo) = (RBParser parseMethod: 'foo ^Thing').
	self assert: (class parseTreeFor: #objectName) 
				= (RBParser parseMethod: 'objectName ^#(Thing)').
	self assert: class superclass name = #Thing
!

testRenameClass
        | refactoring class |
        refactoring := RenameClassRefactoring 
                                rename: (Smalltalk at: ('Class' , 'ToRename') asSymbol)
                                to: ('New' , 'ClassName' asSymbol).
        self executeRefactoring: refactoring.
        self 
                assert: ((refactoring model classNamed: ('New' , 'ClassName') asSymbol) 
                                parseTreeFor: #method1) = (RBParser parseMethod: 'method1
        ^self method2').
        self deny: (refactoring model 
                                includesClassNamed: ('Class' , 'ToRename') asSymbol).
        class := refactoring model 
                                classNamed: ('Subclass' , 'OfClassToRename') asSymbol.
        self assert: class superclass 
                                = (refactoring model classNamed: ('New' , 'ClassName') asSymbol).
        self assert: (class parseTreeFor: #symbolReference) 
                                = (RBParser parseMethod: 'symbolReference
                                                                ^#NewClassName').
        self assert: (class parseTreeFor: #reference) 
                                = (RBParser parseMethod: 'reference
                                                                ^NewClassName new')
! !

!RenameClassTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RenameClassTest.st,v 1.4 2003-10-06 15:50:55 cg Exp $'
! !
