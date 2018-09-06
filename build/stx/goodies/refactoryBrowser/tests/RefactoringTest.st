"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringBrowserTest subclass:#RefactoringTest
	instanceVariableNames:'manager changeSet model'
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!RefactoringTest methodsFor:'private'!

shouldFail: aRefactoring 
	self proceedThroughWarning: 
			[self should: [self executeRefactoring: aRefactoring]
				raise: RefactoringError]
!

shouldWarn: aRefactoring 
	self should: [self executeRefactoring: aRefactoring]
		raise: RefactoringWarning
! !

!RefactoringTest methodsFor:'set up'!

readFile: aString 
	"^ aString asFilename contentsOfEntireFile"
	| file |
	file _ FileStream readOnlyFileNamed: aString.
	file isNil ifTrue:[
	    ((Smalltalk respondsTo:#isSmalltalkX) and:[Smalltalk isSmalltalkX]) ifTrue:[
		file _ FileStream readOnlyFileNamed: ('../../goodies/refactoryBrowser/testData/' , aString ).
	    ]
	].
	^ [file contentsOfEntireFile]
		ensure: [file close]
!

setUp
	| assoc |
	super setUp.
	assoc := RefactoringManager classPool associationAt: #Instance
				ifAbsent: [RefactoringManager classPool associationAt: 'Instance'].
	manager := assoc value.
	assoc value: nil.
	model := RBNamespace new
!

setupImplementorToInlineFor: aRefactoring toReturn: anObject 
	| options |
	options := aRefactoring options copy.
	options at: #implementorToInline put: [:ref :imps | anObject].
	aRefactoring options: options
!

setupInlineExpressionFor: aRefactoring toReturn: aBoolean 
	| options |
	options := aRefactoring options copy.
	options at: #inlineExpression put: [:ref :string | aBoolean].
	aRefactoring options: options
!

setupMethodNameFor: aRefactoring toReturn: aSelector 
	| options |
	options := aRefactoring options copy.
	options at: #methodName
		put: 
			[:ref :aMethodName | 
			aMethodName
				selector: aSelector;
				yourself].
	aRefactoring options: options
!

setupMethodNameFor: aRefactoring toReturn: aSelector withArguments: stringCollection 
	| options |
	options := aRefactoring options copy.
	options at: #methodName
		put: 
			[:ref :aMethodName | 
			aMethodName
				selector: aSelector;
				arguments: stringCollection;
				yourself].
	aRefactoring options: options
!

setupSelfArgumentNameFor: aRefactoring toReturn: aString 
	| options |
	options := aRefactoring options copy.
	options at: #selfArgumentName put: [:ref | aString].
	aRefactoring options: options
!

setupVariableToMoveToFor: aRefactoring toReturn: aString 
	| options |
	options := aRefactoring options copy.
	options at: #selectVariableToMoveTo put: [:ref :class :selector | aString].
	aRefactoring options: options
!

setupVariableTypesFor: aRefactoring toReturn: anObject 
	| options |
	options := aRefactoring options copy.
	options at: #variableTypes put: [:ref :ignore1 :ignore2 | anObject].
	aRefactoring options: options
!

tearDown
	super tearDown.
	RefactoringManager instance release.
	(RefactoringManager classPool associationAt: #Instance
		ifAbsent: [RefactoringManager classPool associationAt: 'Instance']) 
			value: manager
! !

!RefactoringTest methodsFor:'tests'!

testConditions
	| condition newCondition |
	condition := RBCondition new 
				type: #false
				block: [false]
				errorString: 'false'.
	condition errorMacro: '<1?true:false>'.
	self deny: condition check.
	self assert: condition errorString = 'false'.
	self assert: condition not check.
	self assert: condition printString = 'false'.
	self assert: condition not printString = 'NOT false'.
	self deny: (condition not & condition) check.
	self 
		assert: (condition not & condition) printString = 'NOT false & false'.
	self assert: (condition & condition) not check.
	self assert: (condition | condition not) check.
	self deny: (newCondition := condition | condition) check.
	self assert: newCondition errorString = 'false AND false'.
	self assert: (condition not | condition not) check.
	self deny: (newCondition := condition & condition) check.
	self assert: newCondition errorString = 'false'.
	self assert: (condition not & condition not) check.
	self assert: (condition & condition) errorString = 'false OR false'
!

testPrintRefactoringManager
	Transcript
		show: RefactoringManager instance printString;
		cr;
		flush
! !

!RefactoringTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/RefactoringTest.st,v 1.4 2003-10-06 14:39:33 cg Exp $'
! !
