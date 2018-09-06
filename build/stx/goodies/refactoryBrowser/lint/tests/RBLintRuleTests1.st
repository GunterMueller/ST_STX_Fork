"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/refactoryBrowser/lint' }"

"{ NameSpace: Smalltalk }"

TestCase subclass:#RBLintRuleTests1
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Lint-Tests'
!

TestCase subclass:#LintTestClass
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	privateIn:RBLintRuleTests1
!

Object subclass:#TestClass
	instanceVariableNames:'temporaryVariable'
	classVariableNames:''
	poolDictionaries:''
	privateIn:RBLintRuleTests1
!

Object subclass:#TestClassA
	instanceVariableNames:''
	classVariableNames:'Foo'
	poolDictionaries:''
	privateIn:RBLintRuleTests1
!

RBLintRuleTests1::TestClassA subclass:#TestClassB
	instanceVariableNames:''
	classVariableNames:'Bar'
	poolDictionaries:''
	privateIn:RBLintRuleTests1
!

!RBLintRuleTests1 class methodsFor:'documentation'!

documentation
"
    Original SmallLint tests

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!RBLintRuleTests1 class methodsFor:'accessing'!

packageNamesUnderTest
	^ #('Refactoring-Critics')
! !

!RBLintRuleTests1 methodsFor:'private'!

assertEnvironment: env1 isEqualTo: env2
    self compare: env1 to: env2.
    self compare: env2 to: env1

    "Created: / 04-09-2012 / 17:11:00 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

compare:subEnvironment to:superEnvironment 
    subEnvironment 
        classesDo:[:class | 
            (subEnvironment selectorsForClass:class) do:[:selector | 
                self assert:(superEnvironment includesSelector:selector in:class)
            ]
        ]

    "Modified (format): / 23-07-2012 / 12:38:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

currentSelector
	^ testSelector
!

ruleFor: aSelector 
	self ruleFor: aSelector plusSelectors: #()
!

ruleFor: aSelector plusSelectors: symbolCollection 

    self ruleFor: aSelector plusSelectors: symbolCollection thenCheck: nil

    "Modified: / 04-09-2012 / 17:12:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ruleFor: aSelector plusSelectors: symbolCollection thenCheck: aBlock 
        | expectedEnvironment rule class selector className |

        (aSelector startsWith:'test') ifFalse:[self error].
        selector := aSelector asString copyFrom: 5 to: aSelector size.
        className := 'RB' , selector , 'Rule'.
        class := Smalltalk classNamed: className.
        class isNil ifTrue: [ self error: className , ' class not found' ].
        selector at: 1 put: selector first asLowercase.
        selector := selector asSymbol.

        SmalllintChecker 
                runRule: (rule := class new)
                onEnvironment: self smalllintTestEnvironment.
        expectedEnvironment := SelectorEnvironment new.
        expectedEnvironment addClass: TestClass selector: selector.
        symbolCollection do: [ :each | 
                expectedEnvironment addClass: TestClass selector: each 
        ].

        self 
                assert: (rule name isString and: [ rule name notEmpty ])
                description: 'Missing rule name'.
        self 
                assert: (rule group isString and: [ rule group notEmpty ])
                description: 'Missing group name'.
        self 
                assert: (rule rationale isString and: [ rule rationale notEmpty ])
                description: 'Missing rationale'.
        self
                assert: (#(error warning information) includes: rule severity)
                description: 'Invalid severity'.
        self 
                assert:(expectedEnvironment numberSelectors = rule result numberSelectors)
                description:('Expected %1 matching methods; got %2' bindWith:expectedEnvironment numberSelectors with:rule result numberSelectors).

        self
                assertEnvironment: rule result
                isEqualTo: expectedEnvironment.

        aBlock notNil ifTrue:[
            aBlock valueWithOptionalArgument: rule result
        ]

    "Created: / 04-09-2012 / 17:12:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

ruleFor: aSelector thenCheck: aBlockOrNil 
        self ruleFor: aSelector plusSelectors: #() thenCheck: aBlockOrNil

    "Created: / 04-09-2012 / 17:13:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

smalllintTestEnvironment
        | classEnvironment |
        classEnvironment := ClassEnvironment new.
        classEnvironment addClass: TestClass.
        ^ classEnvironment

    "Modified: / 23-07-2012 / 13:29:01 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!RBLintRuleTests1 methodsFor:'tests'!

testAsOrderedCollectionNotNeeded
	self ruleFor: self currentSelector
!

testAssignmentInBlock
	self ruleFor: self currentSelector
!

testAssignmentInIfTrue
	self ruleFor: self currentSelector
!

testAssignmentWithoutEffect
	self ruleFor: self currentSelector
!

testAtIfAbsent
	self ruleFor: self currentSelector
!

testBadMessage
	self ruleFor: self currentSelector plusSelectors: #(codeCruftLeftInMethods)
!

testBooleanPrecedence
	self ruleFor: self currentSelector
!

testCodeCruftLeftInMethods
	self ruleFor: self currentSelector
!

testCollectSelectNotUsed
	self ruleFor: self currentSelector
!

testCollectionMessagesToExternalObject
	self ruleFor: self currentSelector
!

testCollectionProtocol
	self ruleFor: self currentSelector
!

testConsistencyCheck
        self 
                ruleFor: self currentSelector
                plusSelectors: #(#noIsNil: )
!

testConsistencyCheck2
        self 
                ruleFor: self currentSelector
                plusSelectors: #(#noIsNil: )
!

testContains
    self skip:'replaced by cotainsToIncludes'.

    self ruleFor: self currentSelector

    "Modified: / 16-11-2016 / 23:23:48 / cg"
!

testContainsToIncludes
        self ruleFor: self currentSelector

    "Created: / 16-11-2016 / 23:20:24 / cg"
!

testCopyElimination
        self ruleFor: self currentSelector.

    "Created: / 16-11-2016 / 17:43:34 / cg"
!

testDetectContains
	self ruleFor: self currentSelector
!

testEmptyExceptionHandler
	self ruleFor: self currentSelector
!

testEndTrueFalse
	self ruleFor: self currentSelector
!

testEqualNotUsed
	self ruleFor: self currentSelector
!

testEqualsTrue
	self ruleFor: self currentSelector
!

testEquivalentSuperclassMethods
        | expectedEnvironment rule |
        SmalllintChecker 
                runRule: (rule := RBEquivalentSuperclassMethodsRule new)
                onEnvironment: self smalllintTestEnvironment.
        expectedEnvironment := SelectorEnvironment new.
        expectedEnvironment 
                addClass: TestClass
                selector: #isLiteral.
        self 
                assertEnvironment: rule result
                isEqualTo: expectedEnvironment

    "Modified: / 04-09-2012 / 17:10:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testExtraBlock
	self 
		ruleFor: self currentSelector
		plusSelectors: #(#testMethod1 )
!

testFileBlocks
	self ruleFor: self currentSelector
!

testFloatEqualityComparison
	self ruleFor: self currentSelector
!

testFullBlocks
	"skip this test in squeak"

"	self blockRuleFor: self currentSelector
		plusSelectors: #(#caller1 #fullBlocks #detectContains #fileBlocks #moveDefinition #caller #assignmentInBlock #equalNotUsed #stringConcatenation #noMoveDefinition #referencesConditionFor: #returnInEnsure)"
!

testGuardingClause
	self ruleFor: self currentSelector
!

testIfTrueBlocks
	self ruleFor: self currentSelector
!

testIfTrueReturns
	self ruleFor: self currentSelector
!

testInvalidArgumentIdentifier
        self ruleFor: self currentSelector plusSelectors: #(invalidArgumentIdentifier1 invalidArgumentIdentifier2:)

    "Created: / 29-05-2014 / 15:10:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testInvalidLocalIdentifier
        self ruleFor: self currentSelector plusSelectors: #(invalidLocalIdentifier1 invalidLocalIdentifier2)

    "Created: / 29-05-2014 / 14:52:37 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testJustSendsSuper
	self ruleFor: self currentSelector
!

testLiteralArrayCharacters
	self ruleFor: self currentSelector
!

testLiteralArrayContainsComma
	self ruleFor: self currentSelector
!

testLongMethods
	self ruleFor: self currentSelector
!

testMinMax
	self ruleFor: self currentSelector
!

testMissingYourself
        self 
                ruleFor: self currentSelector
                "/ plusSelectors: #(#inlineMethod )

    "Modified: / 16-11-2016 / 22:06:00 / cg"
!

testModifiesCollection
	self ruleFor: self currentSelector
!

testOnlyReadOrWrittenTemporary
        self ruleFor: self currentSelector thenCheck:[:result|
            | intervals |

            intervals := OrderedCollection new.
            result selectionIntervalsForSource: (TestClass >> #onlyReadOrWrittenTemporary) source do:[:interval|intervals add: interval].
            self assert: intervals size == 2.

        ]

    "Modified: / 04-09-2012 / 17:16:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testPrecedence
	self ruleFor: self currentSelector
!

testRefersToClass
	self ruleFor: self currentSelector
!

testReturnInEnsure
	self ruleFor: self currentSelector
!

testReturnsBooleanAndOther
	self ruleFor: self currentSelector
!

testReturnsIfTrue
	self ruleFor: self currentSelector
!

testSearchingLiteral
	self ruleFor: self currentSelector
!

testSendsDifferentSuper
	self ruleFor: self currentSelector
!

testSizeCheck
	self ruleFor: self currentSelector
!

testStringConcatenation
	self ruleFor: self currentSelector
!

testTempVarOverridesInstVar
	self ruleFor: self currentSelector
!

testTemporaryVariableCapitalization
	self ruleFor: self currentSelector
!

testTempsReadBeforeWritten
    self ruleFor:self currentSelector
        plusSelectors:#( #inlineTemporary #noMoveDefinition #tempsReadBeforeWritten #equalNotUsed #fileBlocks #referencesConditionFor: )

    "Modified (format): / 23-07-2012 / 12:38:14 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

testThreeElementPoint
	self ruleFor: self currentSelector
!

testToDo
	self ruleFor: self currentSelector
!

testToDoCollect
	self ruleFor: self currentSelector
!

testToDoWithIncrement
	self ruleFor: self currentSelector
!

testUnclassifiedMethods
	self ruleFor: self currentSelector
!

testUncommonMessageSend
        self 
            ruleFor: self currentSelector
            plusSelectors:#( uncommonMessageSend_2 uncommonMessageSend_3 uncommonMessageSend_4) 
!

testUnneededIfNilAfterNilAssignment
        self 
                ruleFor: self currentSelector
!

testUnoptimizedAndOr
	self ruleFor: self currentSelector
!

testUsesAdd
	self ruleFor: self currentSelector
!

testUsesTrue
	self ruleFor: self currentSelector
!

testWhileTrue
	self ruleFor: self currentSelector
!

testYourselfNotUsed
	self ruleFor: self currentSelector
! !

!RBLintRuleTests1::LintTestClass class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        cg

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!RBLintRuleTests1::LintTestClass methodsFor:'tests'!

shouldBeFound_copyEliminationRule
    |k|

    "/ the following lines should be marked with a notifiier in the browser
    (k copyFrom:1 to:3) = 'MAC'.
    (k foo copyFrom:1 to:3) = 'MAC'.

    "Created: / 16-11-2016 / 16:58:25 / cg"
    "Modified (format): / 16-11-2016 / 23:44:06 / cg"
!

shouldBeFound_copyEliminationRule2
    |k|

    "/ the following lines should be marked with a notifiier in the browser
    (k copyTo:3) = 'MAC'.
    (k foo copyTo:3) = 'MAC'.

    "Created: / 16-11-2016 / 23:32:43 / cg"
!

shouldBeFound_copyEliminationRule3
    |k|

    "/ the following line should be marked with a notifiier in the browser
    (k copyLast:3) = 'MAC'.

    "Created: / 16-11-2016 / 23:37:54 / cg"
! !

!RBLintRuleTests1::TestClass methodsFor:'as yet unclassified'!

unclassifiedMethods
	"intentionally unclassified method"
! !

!RBLintRuleTests1::TestClass methodsFor:'methods'!

asOrderedCollectionNotNeeded
	self foo addAll: (1 to: 10) asOrderedCollection
!

assignmentInBlock
	[^self printString] ensure: [self close]
!

assignmentInIfTrue
	| variable |
	self isVariable 
		ifTrue: [variable := self]
		ifFalse: [variable := self printString].
	^variable
!

assignmentWithoutEffect
	| a |
	a := 1.
	a := a
!

atIfAbsent
	^ Smalltalk at: #MyTest
		ifAbsent: 
			[| collection |
			collection := #().
			Smalltalk at: #MyTest put: collection]
!

badMessage
	self become: String new
!

booleanPrecedence
	^true & 4 = 45
!

codeCruftLeftInMethods
	self halt
!

collectSelectNotUsed
	(1 to: 10) select: [:each | each = 4]
!

collectionMessagesToExternalObject
	self someObject collection remove: 10
!

collectionProtocol
	| newCollection |
	newCollection := OrderedCollection new.
	(1 to: 10) asOrderedCollection do: 
			[:each | 
			| new |
			new := each * 2.
			newCollection add: new].
	^newCollection
!

consistencyCheck
    |foo|

    foo := #().
    ^ foo size == 0
!

consistencyCheck2
        ^(1 to: 10) at: 1
!

contains
	^((1 to: 10) detect: [:each | each > 2] ifNone: [nil]) isNil
!

containsToIncludes
        ^((1 to: 10) detect: [:each | each > 2] ifNone: [nil]) isNil

    "Created: / 16-11-2016 / 23:20:02 / cg"
!

copyElimination
    |k|

    (k copyFrom:1 to:3) = 'MAC'.
    (k foo copyFrom:1 to:3) = 'MAC'.

    "Created: / 16-11-2016 / 17:44:36 / cg"
!

detectContains
	^(1 to: 10) do: [:each | each > 2 ifTrue: [^each]]
!

emptyExceptionHandler
	[ ] on: Error do: [ :err | ]
!

endTrueFalse
	self isVariable 
		ifTrue: 
			[self printString.
			self isVariable printString]
		ifFalse: 
			[self printString.
			^4]
!

equalNotUsed
	| string |
	string = '' yourself.
	(1 to: 10) do: [:i | string := i printString].
	^string
!

equalsTrue
	^true == self
!

extraBlock
	^[:arg | arg + 43] value: 45
!

fileBlocks
	| file |
	^
	[file := 'asdf' asFilename readStream.
	file contents] ensure: [file close]
!

floatEqualityComparison
	^ 1.0 = 1
!

fullBlocks
	^[thisContext]
!

guardingClause
	self isSymbol 
		ifFalse: 
			[self printString.
			self isSymbol printString]
!

ifTrueBlocks
    ^true ifFalse: self foo

    "Created: / 16-11-2016 / 22:14:29 / cg"
!

ifTrueReturns
	self isSymbol ifFalse: [^true].
	^false
!

invalidArgumentIdentifier
    "that is only a problem for Squeak"

    ^ '123' select:[:_e | _e == $1 ]

    "Created: / 29-05-2014 / 15:18:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidArgumentIdentifier1
    "that is only a problem for Squeak"

    ^ '123' select:[:e | e printString contains:[:_each | _each = '1'] ]

    "Created: / 29-05-2014 / 15:18:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidArgumentIdentifier2: _aeg
    "that is only a problem for Squeak"


    "Created: / 29-05-2014 / 15:18:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidLocalIdentifier
    "that is only a problem for Squeak"

    | _invalid1 |

    ^ _invalid1

    "Created: / 29-05-2014 / 14:50:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidLocalIdentifier1
    "that is only a problem for Squeak"

    ^ 'aaa' select:[:e | | _each | _each == $a ]

    "Created: / 29-05-2014 / 14:51:51 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

invalidLocalIdentifier2
    "that is only a problem for Squeak"

    ^ 'aaa' select:[:e | [ [ | _each | _each == $a ] value ] value ]

    "Created: / 29-05-2014 / 15:10:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isLiteral
	^false
!

justSendsSuper
	super justSendsSuper
!

literalArrayCharacters
	^#($a $b $c) includes: $a
!

literalArrayContainsComma
        ^ #(a , b)
        "/ ^ #(#,)

    "Modified: / 16-11-2016 / 21:58:34 / cg"
!

longMethods
        self printString.
        self printString.
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
        self isVariable ifTrue: [self printString].
!

minMax
	"Bug in 3<5 ifTrue: [3]  ifFalse: [5]"

^3<5 ifTrue: [3]  ifFalse: [5]
"	| var |
	var := 4.
	var < 5 ifTrue: [var := 5].
	^var"
!

missingYourself
	^(OrderedCollection new)
		add: 1;
		add: 2;
		removeFirst
!

modifiesCollection
	| collection |
	collection := (1 to: 10) asOrderedCollection.
	collection do: [:each | each > 5 ifTrue: [collection remove: each]].
	^collection
!

noIsNil: arg
	^arg = nil or: [ arg ~= nil ]
!

onlyReadOrWrittenTemporary
	| a |
	a := 1
!

precedence
	^self isArray ifFalse: [self block + 5 * 34] ifTrue: [self printString = 10]
!

refersToClass
    Smalltalk isSmalltalkX ifTrue:[
        "/ must include the namespace for this to be detected
        ^ RBLintRuleTests1::TestClass
    ].
    ^ TestClass

    "Modified: / 23-07-2012 / 13:28:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

release
	self printString
!

returnInEnsure
	[self error: 'asdf'] ensure: [^4]
!

returnsBooleanAndOther
	self isVariable ifTrue: [^false].
	self printString
!

returnsIfTrue
	^self isNil ifTrue: [4]
!

searchingLiteral
	^self printString = #a or: [#() = self printString | ( #() == self printString)]
!

sendsDifferentSuper
	super printString
!

sizeCheck
	self isEmpty
		ifFalse: [self do: 
					[:each | 
					]]
!

stringConcatenation
	| string |
	string := '' yourself.
	(1 to: 10) do: [:i | string := string , i printString].
	^string
!

tempVarOverridesInstVar
	| temporaryVariable |
	temporaryVariable := 4.
	^temporaryVariable
!

temporaryVariableCapitalization
	| Capital |
	Capital := 'Bern'.
	^ Capital
!

tempsReadBeforeWritten
	| temp |
	self isVariable ifTrue: [temp := 4].
	^temp
!

threeElementPoint
	^5 @ 5 + 6 @ 6
!

toDo
    "/ this is wrong, because the rule should check, if the receiver implement #do:
    "/ and only complains, if it DOES. TestClass does not.

    "/    1 to: self size do: [:i | (self at: i) printString]

    "/ therefore let it check something which it cannot verify...
    1 to: temporaryVariable size do: [:i | (temporaryVariable at: i) printString]
!

toDoCollect
	| array |
	array := Array new: 10.
	1 to: 10 do: [:i | array at: i put: i * i].
	^array
!

toDoWithIncrement
	| counter |
	counter := 0.
	1 to: 10
		by: 2
		do: [:i | counter := counter + 2].
	^counter
!

uncommonMessageSend
	true false
!

uncommonMessageSend_2
        true true
!

uncommonMessageSend_3
        true self
!

uncommonMessageSend_4
        true thisContext
!

unneededIfNilAfterNilAssignment
    "/ the following code (in the smallLint UI) inspired this lint rule:

    |dialog rule environment|

    dialog accepted ifTrue:[
        rule := dialog selectionAsRule
    ] ifFalse:[
        rule := nil.
    ].
    rule notNil ifTrue:[
        self smalllintRunRule:rule copy onEnvironment:environment.
    ].

    "Modified: / 16-11-2016 / 20:40:12 / cg"
!

unoptimizedAndOr
	^ (true and: [ false ]) and: [ true ]
!

usesAdd
	^(1 to: 10) asOrderedCollection addAll: (11 to: 20)
!

usesTrue
	^ True
!

variableAssignedLiteral
	temporaryVariable := #() 
!

whileTrue
	| i |
	i := 1.
	[i < self size] whileTrue: 
			[(self at: i) printString.
			i := i + 1]
!

yourselfNotUsed
	self
		printString;
		printString;
		yourself
! !

!RBLintRuleTests1::TestClassA class methodsFor:'initialization'!

initialize
    "bug should be found by RBDoubleClassInitializationRule"

    Foo := Object new.
! !

!RBLintRuleTests1::TestClassB class methodsFor:'initialization'!

initialize
    "bug should be found by RBDoubleClassInitializationRule"

    super initialize.
    Bar := Object new.
! !

!RBLintRuleTests1 class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


RBLintRuleTests1::TestClassA initialize!
RBLintRuleTests1::TestClassB initialize!
