"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#PushUpMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!PushUpMethodTest methodsFor:'failure tests'!

testPushUpClassMethod
	| class |
	class := model classNamed: #Object.
	class addClassVariable: #Foo.
	class metaclass compile: 'foo ^Foo' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#foo)
				from: class metaclass)
!

testPushUpReferencesInstVar
	self shouldFail: (PushUpMethodRefactoring pushUp: #(#checkClass:)
				from: BasicLintRuleTest)
!

testPushUpWithInvalidSuperSend
	| class |
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	(model classNamed: #Foo2) compile: 'yourself ^super yourself + 1'
		classified: #(#accessing).
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#yourself)
				from: class)
!

testPushUpWithMethodThatCannotBePushedDown
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''' category: #''Refactory-Test data'''.
	(model classNamed: #SomeClass) compile: 'yourself ^54'
		classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#yourself)
				from: (model classNamed: #SomeClass))
!

testPushUpWithSuperSendThatCannotBeCopiedDown
	| class |
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''' category: #''Refactory-Test data'''.
	(model classNamed: #Object) compile: 'foo ^3' classified: #(#accessing).
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	(model classNamed: #Subclass) compile: 'foo ^super foo'
		classified: #(#accessing).
	model 
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	(class := model classNamed: #Foo2) compile: 'foo ^1'
		classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#foo)
				from: class)
! !

!PushUpMethodTest methodsFor:'tests'!

testPushUpAndCopyDown
	| class |
	model 
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	model 
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''.
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self executeRefactoring: (PushUpMethodRefactoring 
				model: model
				pushUp: #(#yourself)
				from: class).
	self assert: (class superclass parseTreeFor: #yourself) 
				= (RBParser parseMethod: 'yourself ^1').
	self deny: (class directlyDefinesMethod: #yourself).
	class := model classNamed: #Foo2.
	self assert: (class directlyDefinesMethod: #yourself).
	self assert: (class parseTreeFor: #yourself) 
				= ((model classNamed: #Object) parseTreeFor: #yourself)
!

testPushUpMethodWithCopyOverriddenMethodsDown
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := PushUpMethodRefactoring pushUp: #(#isComposite)
						from: CompositeLintRuleTest.
			self executeRefactoring: refactoring].
	self 
		assert: ((refactoring model classNamed: #BasicLintRuleTest) 
				parseTreeFor: #isComposite) = (RBParser parseMethod: 'isComposite ^false').
	self 
		assert: ((refactoring model classNamed: ('Foo' , 'LintRuleTest') asSymbol) 
				parseTreeFor: #isComposite) = (RBParser parseMethod: 'isComposite ^false').
	self 
		assert: ((refactoring model classNamed: #LintRuleTest) 
				parseTreeFor: #isComposite) = (RBParser parseMethod: 'isComposite ^true').
	self deny: ((refactoring model classNamed: #CompositeLintRuleTest) 
				directlyDefinesMethod: #isComposite)
! !

!PushUpMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/PushUpMethodTest.st,v 1.3 2003-10-06 14:39:33 cg Exp $'
! !
