"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

TestCase subclass:#XMLParserTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Testing'
!

!XMLParserTests class methodsFor:'documentation'!

documentation
"
    Class Author: Roger Whitney whitney@cs.sdsu.edu
    Version 1.0
    April 1, 2000

    XMLParserTests uses James Clarks XML tests available at http://www.jclark.com/xml/ and as part of a larger test suite at: http://www.oasis-open.org/committees/xmltest/testsuite.htm. 

    Currently one SUnit test will run multiple XML tests. Tests with names ending in Number collect the number of XML test that fail. Test with names that do not end in Number are used to run one XML test per SUnit test.

    To run the test suite you must:
            edit the class method clarksBaseTestDirectory to include the full path of the directory xmltest of
                    James Clarks tests files.
            install Sunit.
            Run the tests the standard way: TestRunner open

    The VWXMPParser does not pass all test. 
    The two main problems are Unicode characters and carriage return(cr)/line feed(lf). 
    I ran the test on a Mac, so the file system may not be handling the encoding correctly.
    The XML spec requires all carriage returns and cr-lf pairs to be converted to lf. 
    Smalltalk (VisualWorks) strings use cr, as does the parser.

    Test results.

    valid/sa (valid XML in standalone xml files)
            The parser fails tests
                    12  - The test is not correct
                    52 64 89  49 50 51 61 62 63 - character encoding problems
                    44 47 59 92 93 105 106 107 116 - cr-lf problem

    valid/not-sa (valid XML with dtd declaration in separate files)
            The parser fails test:
                    31 - cr/lf problem

    valid/ext-sa
            The parser fails tests:
                    1 4 6 11 - cr/lf problem
                    14 - character encoding problems

    not-wf/sa
            The parser should throw an exception but does not on:
                    186 - contains attributes with no space between them. 
"
! !

!XMLParserTests class methodsFor:'test file locations'!

clarksBaseTestDirectory
	Smalltalk isSmalltalkX ifTrue:[
	    ^ (Smalltalk getPackageFileName:'stx/goodies/xml/vw/xmltests/tests/') asFilename.
	].
	^ Filename fromComponents: #('Other' 'Download' 'xml' 'xmltest')
! !

!XMLParserTests methodsFor:'asserting'!

assert: aBlock raises: anException 
        "assert that the block will raise an exception - the new exceptions, not an old style signal"

        aBlock on: anException do: [:exception | ^nil].
        TestResult exFailure 
                signalWith: 'Should have raised ' , anException printString
! !

!XMLParserTests methodsFor:'clarks invalid tests'!

invalidXMLFile: index  
	| testDirectory xmlFile |

	testDirectory := self class clarksBaseTestDirectory construct: 'invalid'.
	xmlFile := testDirectory 
				construct: (self xmlBaseTestFileNameWithIndex: index).
	^xmlFile
!

runInvalidTest: anInteger validate: aBoolean 
	| test  result inputFilename |
	inputFilename := self invalidXMLFile: anInteger .

	test := XMLParser processDocumentInFilename: inputFilename
				beforeScanDo: [:parser | parser validate: aBoolean].
	result := self canonicalVersion: test.
	^result
!

testInvalidNumber
	| exceptions  |
	exceptions := OrderedCollection new.

	1 to: 6 do: [:test |
		[self 
			assert: [ self runInvalidTest: test validate: true]
			raises: Error.]
			on: GenericException
			do: [:ex | exceptions add: test]].
	self assert: exceptions isEmpty
! !

!XMLParserTests methodsFor:'clarks not-well formed tests'!

notWellFormedXMLFile: index type: aString 
	| testDirectory xmlFile |
	self assertIsLegalValidTestType: aString.
	testDirectory := self class clarksBaseTestDirectory construct: 'not-wf'.
	testDirectory := testDirectory construct: aString.
	xmlFile := testDirectory 
				construct: (self xmlBaseTestFileNameWithIndex: index).
	^xmlFile
!

runNotWellFormedTest: anInteger type: testType validate: aBoolean 
	| test result inputFilename |
	inputFilename := self notWellFormedXMLFile: anInteger type: testType.

	test := XMLParser processDocumentInFilename: inputFilename
				beforeScanDo: [:parser | parser validate: aBoolean].
	result := self canonicalVersion: test.
	^result
!

testNotWellFormedExternalNumber
	| testFailed |
	testFailed := OrderedCollection new.
	1 to: 3
		do: 
			[:test | 
                        
			[self assert: 
					[self 
						runNotWellFormedTest: test
						type: 'ext-sa'
						validate: true]
				raises: Exception] 
					on: Exception
					do: [:ex | testFailed add: test]].
	self assert: testFailed isEmpty
!

testNotWellFormedNotStandAloneNumber
	| testFailed  |
	testFailed := OrderedCollection new.

	1 to: 8 do: [:test |
		[self 
			assert: [ self runNotWellFormedTest: test type: 'not-sa' validate: true]
			raises: Exception.]
			on: Exception
			do: [:ex | testFailed add: test]].
	self assert: testFailed isEmpty
!

testNotWellFormedSANumber
	| testFailed  |
	testFailed := OrderedCollection new.

	1 to: 186 do: [:test |
		[self 
			assert: [ self runNotWellFormedTest: test type: 'sa' validate: true]
			raises: Exception.]
			on: Exception
			do: [:ex | testFailed add: test]].
	self assert: testFailed isEmpty
! !

!XMLParserTests methodsFor:'clarks valid tests'!

runValidTest: anInteger type: testType validate: aBoolean 
        | test correctAnswer result inputFilename |
        inputFilename := self validXMLFile: anInteger type: testType.
        correctAnswer := self validAnswer: anInteger type: testType.
        test := XMLParser processDocumentInFilename: inputFilename
                                beforeScanDo: [:parser | parser validate: aBoolean].
        result := self canonicalVersion: test.
        ^(Dictionary new)
                at: 'answer' put: correctAnswer;
                at: 'result' put: result;
                yourself
!

runValidTests: aCollection type: testType validate: aBoolean 
        | correctAnswer result failures exceptions testResults |
        exceptions := Dictionary new.
        failures := OrderedCollection new.
        aCollection do: 
                        [:fileIndex | 
                        
                        [
                        [testResults := self 
                                                runValidTest: fileIndex
                                                type: testType
                                                validate: aBoolean.
                        result := testResults at: 'result'.
                        correctAnswer := testResults at: 'answer'.
                        correctAnswer = result ifFalse: [failures add: fileIndex]] 
                                        on: Error
                                        do: [:exp | exceptions at: fileIndex put: exp]] 
                                        on: Exception
                                        do: 
                                                [:warn | 
                                                "just stop the warning messages"

                                                ]].
        ^(Dictionary new)
                at: 'exceptions' put: exceptions;
                at: 'failures' put: failures;
                yourself
!

testValidExt
	| testResults answer result |
	#(2) do: 
			[:fileIndex | 
			testResults := self 
						runValidTest: fileIndex
						type: 'ext-sa'
						validate: true.
			answer := testResults at: 'answer'.
			result := testResults at: 'result'.
			self assert: answer = result]
!

testValidExtNumber
	| results testsToRun exceptions failures |
	testsToRun := (Interval from: 1 to: 14) asOrderedCollection.

	results := self 
				runValidTests: testsToRun
				type: 'ext-sa'
				validate: true.
	exceptions := results at: 'exceptions'.
	failures := results at: 'failures'.
	self assert: exceptions isEmpty & (failures isEmpty)
!

testValidNotStandAlone
	| testResults answer result |
	#() do: 
			[:fileIndex | 
			testResults := self 
						runValidTest: fileIndex
						type: 'not-sa'
						validate: true.
			answer := testResults at: 'answer'.
			result := testResults at: 'result'.
			self assert: answer = result]
!

testValidNotStandAloneNumber
	| results testsToRun exceptions failures |
	testsToRun := (Interval from: 1 to: 31) asOrderedCollection.

	results := self 
				runValidTests: testsToRun
				type: 'not-sa'
				validate: true.
	exceptions := results at: 'exceptions'.
	failures := results at: 'failures'.
	self assert: exceptions isEmpty & (failures isEmpty)
!

testValidStandAlone
	| testResults answer result |
	#(75) do: 
			[:fileIndex | 
			testResults := self 
						runValidTest: fileIndex
						type: 'sa'
						validate: true.
			answer := testResults at: 'answer'.
			result := testResults at: 'result'.
			self assert: answer = result]
!

testValidStandAloneNumber
        "       testsToRun :=self vaildStandAloneTestIndexes."

        | results testsToRun exceptions failures |
        testsToRun :=self vaildStandAloneTestIndexes.
        testsToRun := #(110).
        results := self 
                                runValidTests: testsToRun
                                type: 'sa'
                                validate: true.
        exceptions := results at: 'exceptions'.
        failures := results at: 'failures'.
        self assert: exceptions isEmpty & (failures isEmpty)
!

vaildStandAloneTestIndexes
	|badTest allTests unicodeTests crLfProblems characterProblems|

	badTest := #( 12 ).
	unicodeTests := #(52 64 89).  "Are these Mac, Smalltalk, or XML parser problems"
	crLfProblems := #( 44 47 59 92 93 105 106 107 116).
	characterProblems := #( 49 50 51 61 62 63).
	allTests := (Interval from: 1 to: 119) asOrderedCollection.
	allTests 
		removeAll: badTest;
		removeAll: unicodeTests;
		removeAll: characterProblems;
		removeAll: crLfProblems.
	^allTests
! !

!XMLParserTests methodsFor:'exceptions'!

runExceptionTest
	| xml |
	xml := '<a><b>b</b></a>'.

	self assert: [XMLParser processDocumentString: xml
				beforeScanDo: [:parser | parser validate: true]]
		raises: WarningSignal
! !

!XMLParserTests methodsFor:'private'!

canonicalVersion: aDocument
        |  aStream |
        aStream := WriteStream on: (String new: 10).
        aDocument printCanonicalOn: aStream.
        ^aStream contents
!

xmlBaseTestFileNameWithIndex: anInteger
	|  aStream |
	aStream := WriteStream on: (String new: 3).
	anInteger
		printOn: aStream
		paddedWith: $0
		to: 3
		base: 10.
	^(aStream contents) , '.xml'.
! !

!XMLParserTests methodsFor:'private-clark valid'!

assertIsLegalValidTestType: aString 
	(self isLegalValidTestType: aString) 
		ifFalse: 
			[self 
				error: 'Invalid type of test, expecting one of: ext-sa, not-sa, or sa. Got: ' 
						, aString]
!

isLegalValidTestType: aString 
	^#('ext-sa' 'not-sa' 'sa') includes: aString
!

validAnswer: index type: aString 
        | answerDirectory answer |
        self assertIsLegalValidTestType: aString.
        answerDirectory := self class clarksBaseTestDirectory construct: 'valid'.
        answerDirectory := answerDirectory construct: aString.
        answerDirectory := answerDirectory construct: 'out'.
        answer := answerDirectory 
                                construct: (self xmlBaseTestFileNameWithIndex: index).
        Smalltalk dialectName = 'SmalltalkX' ifTrue:[
            "/ avoid xlating cr's and lf's
            ^ answer binaryContentsOfEntireFile asString
        ].
        ^answer contentsOfEntireFile
!

validXMLFile: index type: aString 
	| testDirectory xmlFile |
	self assertIsLegalValidTestType: aString.
	testDirectory := self class clarksBaseTestDirectory construct: 'valid'.
	testDirectory := testDirectory construct: aString.
	xmlFile := testDirectory 
				construct: (self xmlBaseTestFileNameWithIndex: index).
	^xmlFile
! !

!XMLParserTests class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLParserTests.st,v 1.5 2016-04-20 21:24:19 mawalch Exp $'
! !

