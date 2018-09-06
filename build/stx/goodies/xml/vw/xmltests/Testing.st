<?xml version="1.0"?>

<st-source>
<time-stamp>From VisualWorks¬Æ NonCommercial, Release 5i.1 of January 24, 2000 on March 14, 2000 at 10:55:31 am</time-stamp>


<class>
<name>TestXMLParser</name>
<environment>XML</environment>
<super>TestCase</super>
<private>false</private>
<indexed-type>none</indexed-type>
<inst-vars></inst-vars>
<class-inst-vars></class-inst-vars>
<imports></imports>
<category>Testing</category>
</class>

<methods>
<class-id>XML.TestXMLParser</class-id> <category>FileLocations</category>

<body>baseTestDirectory
	^'other:download:xml:xmltests:'</body>

<body><B>baseValidStandAloneDirectory
	</B>^self baseTestDirectory , 'valid:sa:'</body>
</methods>

<methods>
<class-id>XML.TestXMLParser</class-id> <category>private</category>

<body><B>canonicalVersion: aDocument
	</B>|  aStream |
	aStream := WriteStream on: (String new: 10).
	<B>aDocument</B>
		<B>printCanonicalOn:</B> aStream.

	^aStream contents</body>

<body><B>parseFile: aString validate: aBoolean
	</B>| stream p |
	stream := (<B>aString</B> asFilename withEncoding: #UTF_8) readStream.
	stream lineEndTransparent.
	p := XMLParser on: stream.
	p validate: aBoolean.
	^p scanDocument</body>

<body><B>vaildStandAloneTestIndexes
	</B>|badTest allTests unicodeTests crLfProblems characterProblems|

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
	^allTests</body>

<body><B>validStandAloneAnswer: index
	</B>| testDirectory answerFilename |
	testDirectory := self <B>baseValidStandAloneDirectory</B>.
	answerFilename := testDirectory , 'out:' , (self xmlBaseTestFileNameWithIndex: <B>index</B>).
	^answerFilename asFilename <B>contentsOfEntireFile</B>.</body>

<body><B>xmlBaseTestFileNameWithIndex: anInteger
	</B>|  aStream |
	aStream := WriteStream on: (String new: 3).
	<B>anInteger</B>
		printOn: aStream
		paddedWith: $0
		to: 3
		base: 10.
	^(aStream contents) <B>, </B>'.xml'.</body>

<body><B>xmlTestFileWithIndex: anInteger
	</B>^self <B>baseValidStandAloneDirectory </B>, (self xmlBaseTestFileNameWithIndex: <B>anInteger</B>)</body>
</methods>

<methods>
<class-id>XML.TestXMLParser</class-id> <category>W3CTests</category>

<body><B>testValidStandAlone
	"tests stops on first failure"

	</B>| test  answer result |

	#(44) do: 
		[:fileIndex | 
		| inputFilename |
		inputFilename := self xmlTestFileWithIndex: fileIndex.
		answer := self <B>validStandAloneAnswer:</B> fileIndex.
		test := self parseFile:  inputFilename validate: true.
		result := self canonicalVersion: test.
		self assert: (answer = result)
		]</body>

<body><B>testValidStandAloneNumber
	" Perform all tests and recorded the results"

	</B>| test answer result exceptions failures |
	exceptions := OrderedCollection new.
	failures := OrderedCollection new.

	(self <B>vaildStandAloneTestIndexes</B>) do: 
		[:fileIndex | 
		| inputFilename  |
		inputFilename := self xmlTestFileWithIndex: fileIndex.
		answer := self <B>validStandAloneAnswer:</B> fileIndex.
		[[test := self parseFile:  inputFilename validate: false.
		result := self canonicalVersion: test.
		(answer = result) ifFalse: [ failures add: fileIndex ]]
			on: Error
			do: [:exp | exceptions add: fileIndex ]]
			on: Exception
			do:[:warn | "just stop the warning messages" ]
		].

	self assert: (exceptions size = 0 ) &amp; (failures size = 0)</body>
</methods>



</st-source>
