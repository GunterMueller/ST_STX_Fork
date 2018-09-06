"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringTest subclass:#ExtractMethodTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!ExtractMethodTest methodsFor:'failure tests'!

testBadInterval
	self
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (24 to: 30)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					from: #testMethod
					in: RefactoryTestDataApp);
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (80 to: 147)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class)
!

testExtractFailure
	self
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (80 to: 269)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class);
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (53 to: 56)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class);
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (77 to: 222)
							for: (BasicLintRuleTest class 
									sourceCodeAt: #subclassResponsibilityNotDefined))
					from: #subclassResponsibilityNotDefined
					in: BasicLintRuleTest class)
!

testNonExistantSelector
	self shouldFail: (ExtractMethodRefactoring 
				extract: (10 to: 20)
				from: #checkClass1:
				in: BasicLintRuleTest)
! !

!ExtractMethodTest methodsFor:'tests'!

testExtractMethodAtEndOfMethodThatNeedsReturn
	| refactoring class |

	Smalltalk isSmalltalkX ifTrue:[LintRuleTest autoload].

	refactoring := ExtractMethodRefactoring 
				extract: (self convertInterval: (52 to: 182)
						for: (LintRuleTest sourceCodeAt: #openEditor))
				from: #openEditor
				in: LintRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self 
		assert: (class parseTreeFor: #openEditor) = (RBParser 
						parseMethod: 'openEditor
	| rules |
	rules := self failedRules.
	^self foo: rules').
	self 
		assert: (class parseTreeFor: #foo:) = (RBParser 
						parseMethod: 'foo: rules
	rules isEmpty ifTrue: [^self].
	rules size == 1 ifTrue: [^rules first viewResults].
	SmalllintResultEditor openOn: self label: name')
!

testExtractMethodThatMovesTemporaryVariable
	| refactoring class |


	Smalltalk isSmalltalkX ifTrue:[TransformationRuleTest autoload].

	refactoring := ExtractMethodRefactoring 
				extract: (self convertInterval: (22 to: 280)
						for: (TransformationRuleTest sourceCodeAt: #superSends))
				from: #superSends
				in: TransformationRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self 
		assert: (class parseTreeFor: #superSends) = (RBParser 
						parseMethod: 'superSends
	| rule |
	rule := self foo.
	self rewriteUsing: rule').
	self 
		assert: (class parseTreeFor: #foo) = (RBParser 
						parseMethod: 'foo | rule |      rule := ParseTreeRewriter new.
	rule addSearch: ''super `@message: ``@args''
				-> (
					[:aNode | 
					(class withAllSubclasses
						detect: [:each | each includesSelector: aNode selector]
						ifNone: [nil]) isNil]
							-> ''self `@message: ``@args'').
		^rule')
!

testExtractMethodThatNeedsArgument
	| refactoring class |
	refactoring := ExtractMethodRefactoring 
				extract: (self convertInterval: (145 to: 343)
						for: (TransformationRuleTest sourceCodeAt: #checkMethod:))
				from: #checkMethod:
				in: TransformationRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self 
		assert: (class parseTreeFor: #checkMethod:) = (RBParser 
						parseMethod: 'checkMethod: aSmalllintContext 
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[self foo: aSmalllintContext]').
	self 
		assert: (class parseTreeFor: #foo:) = (RBParser 
						parseMethod: 'foo: aSmalllintContext (RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
				ifFalse: 
					[builder compile: rewriteRule tree printString
						in: class
						classified: aSmalllintContext protocols]')
!

testExtractMethodThatNeedsTemporaryVariable
	| refactoring class |
	refactoring := ExtractMethodRefactoring 
				extract: (self convertInterval: (78 to: 197)
						for: (LintRuleTest sourceCodeAt: #displayName))
				from: #displayName
				in: LintRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self 
		assert: (class parseTreeFor: #displayName) = (RBParser 
						parseMethod: 'displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	self foo: nameStream.
	^nameStream contents').
	self 
		assert: (class parseTreeFor: #foo:) = (RBParser 
						parseMethod: 'foo: nameStream   nameStream nextPutAll: self name;
		nextPutAll: '' (''.
	self problemCount printOn: nameStream.
	nameStream nextPut: $).')
!

testModelExtractMethodWithTemporariesSelected
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class compile: 'foo [| temp | temp := 5. temp * temp] value'
		classified: #(#accessing).
	refactoring := ExtractMethodRefactoring 
				model: model
				extract: (6 to: 36)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo) 
				= (RBParser parseMethod: 'foo [self foobar] value').
	self assert: (class parseTreeFor: #foobar) 
				= (RBParser parseMethod: 'foobar |temp | temp := 5. ^temp * temp')
!

testModelExtractMethodWithTemporaryAssigned
	| class refactoring tree1 tree2|
	model := RBNamespace new.
	class := model classNamed: self class name.
			 "         1         2         3         4         5         6         7         8         9         0"                                                                                                                       
	class            "1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890"                                                                                                                       
		compile: 'foo | temp bar | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp * temp'
		classified: #(#accessing).
	refactoring := ExtractMethodRefactoring 
				model: model
				extract: (18 to:83) "/ (26 to: 102)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo) 
				= (RBParser parseMethod: 'foo | temp | temp := self foobar. ^temp * temp').

	tree1 := (RBParser parseMethod: 'foobar | bar temp | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp.').
	tree2 := (RBParser parseMethod: 'foobar | temp bar | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp.').

	self 
		assert: ((class parseTreeFor: #foobar) = tree1
			or:[ (class parseTreeFor: #foobar) = tree2 ])
! !

!ExtractMethodTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/ExtractMethodTest.st,v 1.6 2003-10-06 14:39:33 cg Exp $'
! !
