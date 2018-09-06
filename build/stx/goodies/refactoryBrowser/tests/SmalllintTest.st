"{ Package: 'stx:goodies/refactoryBrowser/tests' }"

RefactoringBrowserTest subclass:#SmalllintTest
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Refactory-Testing'
!


!SmalllintTest class methodsFor:'others'!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/SmalllintTest.st,v 1.5 2011-08-04 18:39:01 cg Exp $'
! !

!SmalllintTest methodsFor:'set up'!

blockRuleFor: aSelector 
	self blockRuleFor: aSelector plusSelectors: #()
!

blockRuleFor: aSelector plusSelectors: symbolCollection 
        | rule returnedEnvironment testSelector |
        testSelector := aSelector asString copyFrom: 5 to: aSelector size.
        testSelector at: 1 put: testSelector first asLowercase.
        testSelector := testSelector asSymbol.
        (BlockLintRule class includesSelector: testSelector) ifFalse: [^self].
        SmalllintChecker runRule: (rule := BlockLintRule perform: testSelector)
                onEnvironment: self refactoryTestAppEnvironment.
        returnedEnvironment := SelectorEnvironment new.
        RefactoryTestDataApp notNil ifTrue:[
            returnedEnvironment addClass: RefactoryTestDataApp selector: testSelector.
            symbolCollection 
                    do: [:each | returnedEnvironment addClass: RefactoryTestDataApp selector: each].
        ].
        self checkRule: rule isEqualTo: returnedEnvironment
!

checkRule: aLintRule isEqualTo: anEnvironment 
	| returnedEnvironment |
	returnedEnvironment := aLintRule result.
	self compare: returnedEnvironment to: anEnvironment.
	self compare: anEnvironment to: returnedEnvironment
!

compare: subEnvironment to: superEnvironment 
	subEnvironment classesDo: 
			[:each | 
			(subEnvironment selectorsForClass: each) 
				do: [:sel | self assert: (superEnvironment includesSelector: sel in: each)]]
!

currentSelector
	^thisContext sender selector
!

parseTreeRuleFor: aSelector 
	self parseTreeRuleFor: aSelector plusSelectors: #()
!

parseTreeRuleFor: aSelector plusSelectors: symbolCollection 
        | returnedEnvironment testSelector rule |

        "/ so ugly: why not pass the selector as argument; not much of an effort,
        "/ but much clearer (and I could select and find impleementor...)

        "/ strip off the test-prefix, giving us BadMessage, AtIfAbsent etc.
        testSelector := aSelector asString copyFrom: 5 to: aSelector size.
        "/ make it lowercase, gives me the selector to fetch the LintRule
        "/ gives us badMessage, atIfAbsent etc.
        testSelector at: 1 put: testSelector first asLowercase.
        testSelector := testSelector asSymbol.
        rule := ParseTreeLintRule perform: testSelector.
        SmalllintChecker 
                runRule: rule
                onEnvironment: self refactoryTestAppEnvironment.

        returnedEnvironment := SelectorEnvironment new.
        RefactoryTestDataApp notNil ifTrue:[
            returnedEnvironment addClass: RefactoryTestDataApp selector: testSelector.
            symbolCollection do: [:each | 
                returnedEnvironment addClass: RefactoryTestDataApp selector: each
            ].
        ].
        self checkRule: rule isEqualTo: returnedEnvironment

    "Modified (format): / 04-08-2011 / 20:27:18 / cg"
!

refactoryTestAppEnvironment
        | classEnvironment |
        classEnvironment := ClassEnvironment new.
        RefactoryTestDataApp notNil ifTrue:[
            classEnvironment addClass: RefactoryTestDataApp.
        ].
        ^classEnvironment
! !

!SmalllintTest methodsFor:'tests'!

testAsOrderedCollectionNotNeeded
	self parseTreeRuleFor: self currentSelector
!

testAssignmentInBlock
	self parseTreeRuleFor: self currentSelector
!

testAssignmentInIfTrue
	self parseTreeRuleFor: self currentSelector
!

testAtIfAbsent
	self parseTreeRuleFor: self currentSelector
!

testBadMessage
	self blockRuleFor: self currentSelector
!

testBooleanPrecedence
	self parseTreeRuleFor: self currentSelector
!

testCollectSelectNotUsed
	self parseTreeRuleFor: self currentSelector
!

testCollectionMessagesToExternalObject
	self parseTreeRuleFor: self currentSelector
!

testCollectionProtocol
	self parseTreeRuleFor: self currentSelector
!

testConsistencyCheck
	self parseTreeRuleFor: self currentSelector
!

testContains
	self parseTreeRuleFor: self currentSelector
!

testDetectContains
	self parseTreeRuleFor: self currentSelector
!

testEndTrueFalse
	self parseTreeRuleFor: self currentSelector
!

testEqualNotUsed
	self parseTreeRuleFor: self currentSelector
!

testEqualsTrue
	self parseTreeRuleFor: self currentSelector
!

testEquivalentSuperclassMethods
        | returnedEnvironment rule |
        SmalllintChecker 
                runRule: (rule := BlockLintRule equivalentSuperclassMethods)
                onEnvironment: self refactoryTestAppEnvironment.
        returnedEnvironment := SelectorEnvironment new.
        RefactoryTestDataApp notNil ifTrue:[
            returnedEnvironment addClass: RefactoryTestDataApp selector: #isLiteral.
        ].
        self checkRule: rule isEqualTo: returnedEnvironment
!

testExtraBlock
	self parseTreeRuleFor: self currentSelector plusSelectors: #(#testMethod1)
!

testFileBlocks
	self parseTreeRuleFor: self currentSelector
!

testFullBlocks
	"skip this test in squeak"

"       self blockRuleFor: self currentSelector
		plusSelectors: #(#caller1 #fullBlocks #detectContains #fileBlocks #moveDefinition #caller #assignmentInBlock #equalNotUsed #stringConcatenation #noMoveDefinition #referencesConditionFor: #returnInEnsure)"
!

testGuardingClause
	self parseTreeRuleFor: self currentSelector
!

testIfTrueBlocks
	self parseTreeRuleFor: self currentSelector
!

testIfTrueReturns
	self parseTreeRuleFor: self currentSelector
!

testJustSendsSuper
	self blockRuleFor: self currentSelector
!

testLiteralArrayCharacters
	self parseTreeRuleFor: self currentSelector
!

testLongMethods
	self blockRuleFor: self currentSelector
!

testMinMax
	self parseTreeRuleFor: self currentSelector
!

testMissingYourself
	self parseTreeRuleFor: self currentSelector plusSelectors: #(#inlineMethod)
!

testModifiesCollection
	self parseTreeRuleFor: self currentSelector
!

testPrecedence
	self parseTreeRuleFor: self currentSelector
!

testRefersToClass
	self blockRuleFor: self currentSelector
!

testReturnInEnsure
	self parseTreeRuleFor: self currentSelector
!

testReturnsBooleanAndOther
	self blockRuleFor: self currentSelector
!

testReturnsIfTrue
	self parseTreeRuleFor: self currentSelector
!

testSearchingLiteral
	self parseTreeRuleFor: self currentSelector
!

testSendsDifferentSuper
	self blockRuleFor: self currentSelector
!

testSizeCheck
	self parseTreeRuleFor: self currentSelector
!

testStringConcatenation
	self parseTreeRuleFor: self currentSelector
!

testSuperSends
        | rule returnedEnvironment |
        SmalllintChecker runRule: (rule := BlockLintRule superSends)
                onEnvironment: self refactoryTestAppEnvironment.
        returnedEnvironment := SelectorEnvironment new.
        RefactoryTestDataApp notNil ifTrue:[
            returnedEnvironment addClass: RefactoryTestDataApp selector: #release.
        ].
        self checkRule: rule isEqualTo: returnedEnvironment
!

testTempVarOverridesInstVar
	self blockRuleFor: self currentSelector
!

testTempsReadBeforeWritten
	self blockRuleFor: self currentSelector
		plusSelectors: #(#inlineTemporary #noMoveDefinition #tempsReadBeforeWritten #equalNotUsed #fileBlocks #referencesConditionFor:)
!

testThreeElementPoint
	self parseTreeRuleFor: self currentSelector
!

testToDo
	self parseTreeRuleFor: self currentSelector
!

testToDoCollect
	self parseTreeRuleFor: self currentSelector
!

testToDoWithIncrement
	self parseTreeRuleFor: self currentSelector
!

testUsesAdd
	self parseTreeRuleFor: self currentSelector
!

testWhileTrue
	self parseTreeRuleFor: self currentSelector
!

testYourselfNotUsed
	self parseTreeRuleFor: self currentSelector
! !

!SmalllintTest class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/refactoryBrowser/tests/SmalllintTest.st,v 1.5 2011-08-04 18:39:01 cg Exp $'
! !
