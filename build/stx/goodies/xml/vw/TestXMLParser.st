"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

TestCase subclass:#TestXMLParser
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Testing'
!

!TestXMLParser class methodsFor:'documentation'!

examples
"
    Transcript showCR:self runAllUnitTests

    self new testValidStandAlone

    self testValidStandAloneNumber
"
! !

!TestXMLParser methodsFor:'FileLocations'!

baseTestDirectory
	Smalltalk isSmalltalkX ifTrue:[
	    ^ Smalltalk getPackageFileName:'stx/goodies/xml/vw/xmltests/tests/'.
	].
	^'other:download:xml:xmltests:'
!

baseValidStandAloneDirectory
	Smalltalk isSmalltalkX ifTrue:[
	    ^(self baseTestDirectory asFilename construct:'valid')
		construct:'sa/'
	].
	^self baseTestDirectory , 'valid:sa:'
! !

!TestXMLParser methodsFor:'W3CTests'!

testValidStandAlone
        "tests stops on first failure"

        | test  answer result |

        #(44) do: 
                [:fileIndex | 
                | inputFilename |
                inputFilename := self xmlTestFileWithIndex: fileIndex.
                answer := self validStandAloneAnswer: fileIndex.
                (Smalltalk dialectName = 'SmalltalkX') ifTrue:[
                    answer := answer withoutTrailingSeparators
                ].
                test := self parseFile:  inputFilename validate: true.
                result := self canonicalVersion: test.
                (Smalltalk dialectName = 'SmalltalkX') ifTrue:[
                    result := result withoutTrailingSeparators
                ].
                self assert: (answer = result)
                ]
!

testValidStandAloneNumber
        " Perform all tests and recorded the results"

        | test answer result exceptions failures backTraces testContext failureInfos|
        exceptions := OrderedCollection new.
        failures := OrderedCollection new.
        backTraces := Dictionary new.
        failureInfos := Dictionary new.
        testContext := thisContext.

        (self vaildStandAloneTestIndexes) do: 
                [:fileIndex | 
                    | inputFilename  |
                    inputFilename := self xmlTestFileWithIndex: fileIndex.
                    answer := self validStandAloneAnswer: fileIndex.
                    (Smalltalk dialectName = 'SmalltalkX') ifTrue:[
                        answer := answer withoutTrailingSeparators     
                    ].

                    [
                        [
                            test := self parseFile:  inputFilename validate: false.
                            result := self canonicalVersion: test.
                            (Smalltalk dialectName = 'SmalltalkX') ifTrue:[
                                result := result withoutTrailingSeparators     
                            ].
                            (answer = result) ifFalse: [
                                failureInfos at:fileIndex put:(Dictionary new
                                                                at:#expected put:answer;
                                                                at:#result put:result;
                                                                yourself).
                                failures add: fileIndex 
                            ]
                        ]
                        on: Error
                        do: [:exp | 
                                    Transcript showCR:'error (' , exp errorString , ') in ' , inputFilename.
                                    exceptions add: fileIndex.
                                    backTraces at:fileIndex put:(self backtraceFrom:exp suspendedContext upTo:testContext).
                            ]
                    ]
                    on: Exception
                    do:[:warn | (HaltSignal accepts:warn signal) ifTrue:[
                                    warn reject.
                                ].
                                Transcript showCR:'exception (' , warn errorString , ') in ' , inputFilename.
                                        "just stop the warning messages" ]
                ].

        self assert: (exceptions size = 0 ) & (failures size = 0).
        failureInfos notEmpty ifTrue:[failureInfos inspect].
! !

!TestXMLParser methodsFor:'private'!

backtraceFrom:aContext upTo:lastContext
    |stack con|

    stack := OrderedCollection new.
    con := aContext.
    [con ~~ lastContext] whileTrue:[
	stack addLast:con copy.
	con := con sender.
    ].
    stack addLast:con copy.
    ^ stack
!

canonicalVersion: aDocument
        |  aStream |
        aStream := WriteStream on: (String new: 10).
        aDocument printCanonicalOn: aStream.
        ^aStream contents
!

parseFile: aString validate: aBoolean
	| stream p |

	Smalltalk isSmalltalkX ifTrue:[
	    stream := (aString asFilename) readStream.
	] ifFalse:[
	    stream := (aString asFilename withEncoding: #UTF_8) readStream.
	].
	stream isNil ifTrue:[self halt].
	stream lineEndTransparent.
	p := XMLParser on: stream.
	p validate: aBoolean.
	^p scanDocument
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
!

validStandAloneAnswer: index
	| testDirectory answerFilename |
	testDirectory := self baseValidStandAloneDirectory.
	((Smalltalk respondsTo:#isSmalltalkX)
	and:[Smalltalk isSmalltalkX]) ifTrue:[
	    answerFilename := (testDirectory construct:'out')
				construct:(self xmlBaseTestFileNameWithIndex: index).
	] ifFalse:[
	    answerFilename := testDirectory , 'out:' , (self xmlBaseTestFileNameWithIndex: index).
	].
	^answerFilename asFilename contentsOfEntireFile.
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
!

xmlTestFileWithIndex: anInteger
        ^self baseValidStandAloneDirectory construct: (self xmlBaseTestFileNameWithIndex: anInteger)
! !

!TestXMLParser class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/TestXMLParser.st,v 1.13 2015-01-29 11:07:48 cg Exp $'
! !

