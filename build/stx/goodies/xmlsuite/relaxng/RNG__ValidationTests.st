"{ Package: 'stx:goodies/xmlsuite/relaxng' }"

"{ NameSpace: RNG }"

TestCase subclass:#ValidationTests
	instanceVariableNames:'testItems'
	classVariableNames:''
	poolDictionaries:''
	category:'Relax NG-Tests'
!

ValidationTests class instanceVariableNames:'testDirectory testDefsModifTS testItems'

"
 The following class instance variables are inherited by this class:

	TestCase - lastTestRunResultOrNil lastTestRunsFailedTests
	Object - 
"
!

XMLv2::ContentHandler subclass:#TestDefsParser
	instanceVariableNames:'testItems currentItem context currentAssertMessage'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ValidationTests
!

Object subclass:#TestItem
	instanceVariableNames:'name schemaFile xmlFile exception errorLine result asserts'
	classVariableNames:''
	poolDictionaries:''
	privateIn:ValidationTests
!

!ValidationTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany (janfrog@john)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 27-04-2005 / 19:14:44 / janfrog"
! !

!ValidationTests class methodsFor:'accessing'!

_allTestSelectors

    self allTestFiles collect:[:f|f baseName asSymbol]

    "Created: / 27-04-2005 / 19:36:10 / janfrog"
!

allTestSelectors

    ^self allTestItems collect:[:e|e name ]

    "Created: / 27-04-2005 / 19:47:52 / janfrog"
    "Modified: / 14-05-2005 / 10:37:30 / janfrog"
!

askForTestDirectory

    | dir |
    
    ^(dir := Dialog requestDirectoryName:'Select directory with tests') isEmpty 
        ifTrue:['.' asFilename]
        ifFalse:[
            dir asFilename exists ifFalse:[
                Dialog warn:'Selected dir does not exist'.
                self askForTestDirectory.
            ] ifTrue:[dir]
        ]

    "Created: / 27-04-2005 / 19:33:48 / janfrog"
!

standardTestDirectory

    ^((Smalltalk getPackageDirectoryForPackage:self package) 
        construct:'/resources/tests') asFilename

    "Created: / 27-04-2005 / 19:30:25 / janfrog"
!

testDirectory

    testDirectory ifNil:[
        (testDirectory := self standardTestDirectory)
            exists ifFalse:[
                testDirectory := self askForTestDirectory
            ]                    
    ].
    ^testDirectory

    "
        testDirectory := nil
    "

    "Created: / 27-04-2005 / 19:27:53 / janfrog"
    "Modified: / 14-05-2005 / 10:19:42 / janfrog"
    "Modified: / 16-05-2005 / 09:38:23 / masca"
!

testFileNamed:aString

    ^(self testDirectory construct:aString) asFilename

    "Created: / 14-05-2005 / 10:41:49 / janfrog"
!

testWithName:aSymbol

    ^self allTestItems detect:[:i|i name = aSymbol]

    "Created: / 14-05-2005 / 10:38:19 / janfrog"
! !

!ValidationTests class methodsFor:'private'!

allTestItems

    | handler |

    (testDefsModifTS isNil 
        or:[self testDefsFile modificationTime > testDefsModifTS]) ifTrue:[
        handler := TestDefsParser new.
        XMLv2::XMLReader new
            setContentHandler:handler;
            parseStream:(self testDefsFile readStream).
        testItems := handler testItems.
        testDefsModifTS := self testDefsFile modificationTime.
    ].
    ^testItems

    "Created: / 14-05-2005 / 10:12:13 / janfrog"
!

testDefsFile

    ^self testFileNamed:'test-defs.xml'

    "Created: / 14-05-2005 / 10:12:54 / janfrog"
! !

!ValidationTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp

    "Created: / 27-04-2005 / 19:14:44 / janfrog"
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown

    "Created: / 27-04-2005 / 19:14:44 / janfrog"
! !

!ValidationTests methodsFor:'private'!

doesNotUnderstand:aMessage

    ('test*' match:aMessage selector ) 
        ifFalse:[^super doesNotUnderstand:aMessage].

    self performTest:(self class testWithName:aMessage selector).

    "Created: / 27-04-2005 / 19:46:38 / janfrog"
    "Modified: / 14-05-2005 / 10:38:39 / janfrog"
!

performTest:aTestItem 
    |xmlFile schema exception line result|

    [
        schema := Schema fromFile:(self class testFileNamed:aTestItem schemaFile).
        xmlFile := self class testFileNamed:aTestItem xmlFile.
        result := self validate:xmlFile usingSchema:schema
    ] on:Error do:[:ex | 
        exception := ex.
        line := ex errorLine.
        (aTestItem exceptionClass == UndefinedObject) ifTrue:[
            ex pass
        ].
    ].
    self assert:exception class == aTestItem exceptionClass.
    self assert:line = aTestItem errorLine.
    aTestItem asserts keysAndValuesDo:[:msg :assertBlock | 
        self 
            assert:(assertBlock value:result)
            message:msg.
    ]

    "Created: / 14-05-2005 / 10:36:47 / janfrog"
    "Modified: / 14-05-2005 / 22:03:14 / janfrog"
!

validate:xmlFile usingSchema:schema 
    ^ schema validateFile:xmlFile

    "Created: / 14-05-2005 / 14:08:11 / janfrog"
! !

!ValidationTests methodsFor:'tests'!

_test_all

    self class allTestFiles do:[:f|
        self performTestIn:f.
    ]

    "Created: / 27-04-2005 / 19:46:50 / janfrog"
! !

!ValidationTests::TestDefsParser methodsFor:'SAX2 events'!

characters:aString

    (context == #addAssert:) ifTrue:[
        currentItem addAssert:(currentAssertMessage->aString)
    ] ifFalse:[

        currentItem perform:context with:aString
    ]

    "Created: / 14-05-2005 / 10:10:26 / janfrog"
    "Modified: / 14-05-2005 / 15:03:34 / janfrog"
!

startDocument

    testItems := OrderedCollection new

    "Created: / 14-05-2005 / 10:01:07 / janfrog"
!

startElement:localName namespace:namespace prefix:prefix attributes:attributes

    localName = 'test-defs' ifTrue:[^self].
    localName = 'test' ifTrue:[
        currentItem := testItems add:ValidationTests::TestItem new.
        currentItem setName:(attributes getValueByURI:namespace localName:'name').
        currentItem setResult:(attributes getValueByURI:namespace localName:'res').
        ^self
    ].
    localName = 'schema' ifTrue:[^context := #setSchemaFile:].
    localName = 'doc' ifTrue:[^context := #setXMLFile:].
    localName = 'exception' ifTrue:[^context := #setExceptionName:].
    localName = 'line' ifTrue:[^context := #setErrorLine:].
    localName = 'assert' ifTrue:[
        currentAssertMessage := (attributes getValueByURI:namespace localName:'msg').
        ^context := #addAssert:
    ].

    self error:'Unexpected element'

    "Modified: / 14-05-2005 / 14:13:21 / janfrog"
! !

!ValidationTests::TestDefsParser methodsFor:'accessing'!

testItems
    ^ testItems

    "Created: / 14-05-2005 / 10:01:46 / janfrog"
! !

!ValidationTests::TestItem methodsFor:'accessing'!

asserts
    ^ asserts ifNil:[asserts := Dictionary new]

    "Created: / 14-05-2005 / 14:08:55 / janfrog"
!

errorLine
    ^ errorLine

    "Created: / 14-05-2005 / 10:35:39 / janfrog"
!

exceptionClass
    ^ exception ? (nil class)

    "Created: / 14-05-2005 / 11:38:25 / janfrog"
!

name
    ^ name

    "Created: / 14-05-2005 / 10:35:39 / janfrog"
!

result
    ^ result

    "Created: / 14-05-2005 / 10:35:39 / janfrog"
!

schemaFile
    ^ schemaFile

    "Created: / 14-05-2005 / 10:35:39 / janfrog"
!

xmlFile
    ^ xmlFile

    "Created: / 14-05-2005 / 10:35:39 / janfrog"
! !

!ValidationTests::TestItem methodsFor:'printing'!

printOn:aStream

    aStream 
        nextPutAll:'RNG test: ',name ; cr;
        nextPutAll:'schema: ',schemaFile ; cr;
        nextPutAll:'xml file:' , xmlFile ; cr.

    result = #fail ifTrue:[
        aStream 
            nextPutAll:'exception class: ',exception name ; cr;
            nextPutAll:'errorLine: ',errorLine printString.

    ]

    "Created: / 14-05-2005 / 10:22:55 / janfrog"
! !

!ValidationTests::TestItem methodsFor:'setting'!

addAssert:assoc

    assoc value:(Compiler evaluate:'[:res| ',assoc value,']').

    self asserts add:assoc.

    "Created: / 14-05-2005 / 14:06:28 / janfrog"
!

setErrorLine:aString

    errorLine := aString asNumber

    "Created: / 14-05-2005 / 10:33:06 / janfrog"
!

setExceptionName:aString

    exception := Smalltalk at:aString asSymbol

    "Created: / 14-05-2005 / 10:32:13 / janfrog"
!

setName:aString

    name := ('test_',aString) asSymbol

    "Created: / 14-05-2005 / 10:31:43 / janfrog"
!

setResult:aString

    result := aString asSymbol

    "Created: / 14-05-2005 / 10:33:47 / janfrog"
!

setSchemaFile:aString

    schemaFile := aString

    "Created: / 14-05-2005 / 10:31:52 / janfrog"
!

setXMLFile:aString

    xmlFile := aString

    "Created: / 14-05-2005 / 10:31:59 / janfrog"
! !

!ValidationTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/relaxng/RNG__ValidationTests.st,v 1.1.1.1 2005-11-01 22:07:16 vranyj1 Exp $'
! !
