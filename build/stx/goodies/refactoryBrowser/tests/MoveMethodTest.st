"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#MoveMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!MoveMethodTest methodsFor:'failure tests'!

testMovePrimitiveMethod
	| refactoring |
	(model classNamed: #Object) 
		compile: 'foo <primitive: 100> ^#() primitiveFailed'
		classified: #(#accessing).
	refactoring := MoveMethodRefactoring 
				model: model
				selector: #foo
				class: Object
				variable: 'OrderedCollection'.
	self shouldFail: refactoring
! !

!MoveMethodTest methodsFor:'tests'!

testMoveMethodIntoArgument
	| refactoring class |
	self proceedThroughWarning: 
			[refactoring := MoveMethodRefactoring 
						selector: #checkMethod:
						class: TransformationRuleTest
						variable: 'aSmalllintContext'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring
				toReturn: (Array with: (refactoring model classNamed: #SmalllintContext)).
			self setupMethodNameFor: refactoring toReturn: #foo:.
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #TransformationRuleTest.
	self 
		assert: (class parseTreeFor: #checkMethod:) = (RBParser 
						parseMethod: 'checkMethod: aSmalllintContext aSmalllintContext foo: self').
	self 
		assert: ((refactoring model classNamed: #SmalllintContext) 
				parseTreeFor: #foo:) = (RBParser 
							parseMethod: 'foo: transformationRule
	transformationRule class: self selectedClass.
	(transformationRule rewriteRule executeTree: self parseTree) ifTrue: 
			[(transformationRule class recursiveSelfRule executeTree: transformationRule rewriteRule tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: transformationRule rewriteRule tree printString
						in: transformationRule class1
						classified: self protocols]]').
	self assert: (class parseTreeFor: #class1) 
				= (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:) 
				= (RBParser parseMethod: 'class: anObject class := anObject').
	self 
		assert: (class metaclass parseTreeFor: #recursiveSelfRule:) = (RBParser 
						parseMethod: 'recursiveSelfRule: anObject RecursiveSelfRule := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule) 
				= (RBParser parseMethod: 'recursiveSelfRule ^RecursiveSelfRule').
	self assert: (class parseTreeFor: #builder) 
				= (RBParser parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:) 
				= (RBParser parseMethod: 'builder: anObject builder := anObject').
	self assert: (class parseTreeFor: #rewriteRule) 
				= (RBParser parseMethod: 'rewriteRule ^rewriteRule').
	self assert: (class parseTreeFor: #rewriteRule:) 
				= (RBParser parseMethod: 'rewriteRule: anObject rewriteRule := anObject')
!

testMoveMethodIntoClassVariable
	| refactoring class |
	self proceedThroughWarning: 
			[refactoring := MoveMethodRefactoring 
						selector: #checkMethod:
						class: TransformationRuleTest
						variable: 'RecursiveSelfRule'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring
				toReturn: (Array with: (refactoring model classNamed: #ParseTreeSearcher)).
			self 
				setupMethodNameFor: refactoring
				toReturn: #foo:foo:
				withArguments: #('transformationRule' 'aSmalllintContext').
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #TransformationRuleTest.
	self 
		assert: (class parseTreeFor: #checkMethod:) = (RBParser 
						parseMethod: 'checkMethod: aSmalllintContext RecursiveSelfRule foo: self foo: aSmalllintContext').
	self 
		assert: ((refactoring model classNamed: #ParseTreeSearcher) 
				parseTreeFor: #foo:foo:) = (RBParser 
							parseMethod: 'foo: transformationRule foo: aSmalllintContext
	transformationRule class: aSmalllintContext selectedClass.
	(transformationRule rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[(self executeTree: transformationRule rewriteRule tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: transformationRule rewriteRule tree printString
						in: transformationRule class1
						classified: aSmalllintContext protocols]]').
	self assert: (class parseTreeFor: #class1) 
				= (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:) 
				= (RBParser parseMethod: 'class: anObject class := anObject').
	self assert: (class parseTreeFor: #builder) 
				= (RBParser parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:) 
				= (RBParser parseMethod: 'builder: anObject builder := anObject').
	self assert: (class parseTreeFor: #rewriteRule) 
				= (RBParser parseMethod: 'rewriteRule ^rewriteRule').
	self assert: (class parseTreeFor: #rewriteRule:) 
				= (RBParser parseMethod: 'rewriteRule: anObject rewriteRule := anObject')
!

testMoveMethodIntoInstanceVariable
	| refactoring class |
	self proceedThroughWarning: 
			[refactoring := MoveMethodRefactoring 
						selector: #checkMethod:
						class: TransformationRuleTest
						variable: 'rewriteRule'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring
				toReturn: (Array with: (refactoring model classNamed: #ParseTreeRewriter)).
			self 
				setupMethodNameFor: refactoring
				toReturn: #foo:foo:
				withArguments: #('transformationRule' 'aSmalllintContext').
			self executeRefactoring: refactoring].
	class := refactoring model classNamed: #TransformationRuleTest.
	self 
		assert: (class parseTreeFor: #checkMethod:) = (RBParser 
						parseMethod: 'checkMethod: aSmalllintContext rewriteRule foo: self foo: aSmalllintContext').
	self 
		assert: ((refactoring model classNamed: #ParseTreeRewriter) 
				parseTreeFor: #foo:foo:) = (RBParser 
							parseMethod: 'foo: transformationRule foo: aSmalllintContext
	transformationRule class: aSmalllintContext selectedClass.
	(self executeTree: aSmalllintContext parseTree) ifTrue: 
			[(transformationRule class recursiveSelfRule executeTree: self tree initialAnswer: false)
				ifFalse: 
					[transformationRule builder compile: self tree printString
						in: transformationRule class1
						classified: aSmalllintContext protocols]]').
	self assert: (class parseTreeFor: #class1) 
				= (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:) 
				= (RBParser parseMethod: 'class: anObject class := anObject').
	self 
		assert: (class metaclass parseTreeFor: #recursiveSelfRule:) = (RBParser 
						parseMethod: 'recursiveSelfRule: anObject RecursiveSelfRule := anObject').
	self assert: (class metaclass parseTreeFor: #recursiveSelfRule) 
				= (RBParser parseMethod: 'recursiveSelfRule ^RecursiveSelfRule').
	self assert: (class parseTreeFor: #builder) 
				= (RBParser parseMethod: 'builder ^builder').
	self assert: (class parseTreeFor: #builder:) 
				= (RBParser parseMethod: 'builder: anObject builder := anObject')
!

testMoveMethodThatReferencesPoolDictionary
	| refactoring class |
	self
		proceedThroughWarning: 
			[refactoring _ MoveMethodRefactoring
						selector: #junk
						class: LintRuleTest
						variable: 'RefactoryTestDataApp'.
			self setupSelfArgumentNameFor: refactoring toReturn: 'transformationRule'.
			self setupVariableTypesFor: refactoring toReturn: (Array with: (refactoring model classNamed: 'RefactoryTestDataApp class' asSymbol)).
			self setupMethodNameFor: refactoring toReturn: #junk1.
			self executeRefactoring: refactoring].
	class _ refactoring model classNamed: #LintRuleTest.
	self assert: (class parseTreeFor: #junk)
			= (RBParser parseMethod: 'junk ^RefactoryTestDataApp junk1').
	self assert: ((refactoring model metaclassNamed: #RefactoryTestDataApp)
			parseTreeFor: #junk1)
			= (RBParser parseMethod: 'junk1
	^self printString copyFrom: 1 to: CR').
	((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifFalse:[
	    self assert: (class directlyDefinesPoolDictionary: 'TextConstants' asSymbol)
	].
! !

!MoveMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/MoveMethodTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
