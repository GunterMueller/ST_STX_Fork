"{ Package: 'stx:goodies/sunit' }"

Object subclass:#TestSuitesScripter
	instanceVariableNames:'script stream'
	classVariableNames:''
	poolDictionaries:''
	category:'SUnit-Base'
!


!TestSuitesScripter class methodsFor:'example'!

exampleScripting
	^(TestSuitesScripter script: ' "scratch suite 3" ExampleSetTest SUnitTest* ') value

    "Modified: / 21.6.2000 / 10:18:08 / Sames"
! !

!TestSuitesScripter class methodsFor:'initialization & release'!

run: testClassNameString
        ^self new run: testClassNameString
!

script: aString
	^self new setScript: aString
! !

!TestSuitesScripter methodsFor:'printing'!

printOn: aStream
	aStream nextPutAll: (script isNil 
		ifFalse: [script] 
		ifTrue: ['N/A'])

    "Created: / 21.6.2000 / 10:15:29 / Sames"
! !

!TestSuitesScripter methodsFor:'private'!

executeSingleSuiteScript: aString 
        | useHierachy realName testCase |
        aString last = $*
                ifTrue: 
                        [realName := aString copyFrom: 1 to: aString size - 1.
                        useHierachy := true]
                ifFalse: 
                        [realName := aString.
                        useHierachy := false].
        realName isEmpty ifTrue: [^nil].
        testCase := Smalltalk classNamed: realName asSymbol.
        testCase isNil ifTrue: [^nil].
        ^useHierachy
                ifTrue: [self hierachyOfTestSuitesFrom: testCase]
                ifFalse: [testCase suite]

    "Modified: / 21.6.2000 / 10:16:02 / Sames"
!

getNextToken
	[stream atEnd not and: [stream peek first = $"]] whileTrue: [self skipComment].
	^stream atEnd not
		ifTrue: [stream next]
		ifFalse: [nil]

    "Modified: / 21.6.2000 / 10:16:16 / Sames"
!

hierachyOfTestSuitesFrom: aTestCase 
        | subSuite |
        subSuite := TestSuite new.
        subSuite name:aTestCase name.
        subSuite addTest: aTestCase suite.
        aTestCase allSubclasses do: [:each | subSuite addTest:(Smalltalk classNamed:each name asSymbol) suite].
        ^subSuite

    "Modified: / 21.6.2000 / 10:16:29 / Sames"
!

setScript: aString
	script := aString
!

skipComment
	| token inComment |
	token := stream next.
	token size > 1 & (token last = $") ifTrue: [^nil].
	inComment := true.
	[inComment & stream atEnd not]
		whileTrue: 
			[token := stream next.
			token last = $" ifTrue: [inComment := false]]

    "Modified: / 21.6.2000 / 10:16:47 / Sames"
! !

!TestSuitesScripter methodsFor:'scripting'!

run: testClassNameString
        | suite subSuite token |
        suite := TestSuite new.
        suite name:testClassNameString.

        stream := ReadStream on: testClassNameString asArrayOfSubstrings. 
        [stream atEnd] whileFalse: 
                [token := self getNextToken.
                token notNil ifTrue: [
                        subSuite := self executeSingleSuiteScript: token.
                        subSuite notNil ifTrue:[suite addTest: subSuite]]].
        ^suite

    "Modified: / 21.6.2000 / 10:17:11 / Sames"
!

value
	^self run: script
! !

!TestSuitesScripter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/sunit/TestSuitesScripter.st,v 1.11 2011-11-24 11:51:24 cg Exp $'
!

version_SVN
    ^ '§Id: TestSuitesScripter.st,v 1.10 2011/06/29 19:15:49 cg Exp §'
! !
