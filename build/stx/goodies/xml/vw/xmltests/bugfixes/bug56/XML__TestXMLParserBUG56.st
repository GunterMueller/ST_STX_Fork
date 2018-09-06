"{ Package: 'stx:goodies/xml/vw/xmltests/bugfixes' }"

"{ NameSpace: XML }"

TestCase subclass:#TestXMLParserBUG56
	instanceVariableNames:''
	classVariableNames:'StressTestDirectory'
	poolDictionaries:''
	category:'XML-VW-Testing'
!


!TestXMLParserBUG56 class methodsFor:'initialization'!

initialize
    StressTestDirectory := ((Smalltalk projectDirectoryForPackage:package), '/bug56/parserStressTest')asFilename
! !

!TestXMLParserBUG56 class methodsFor:'accessing'!

stressTestDirectory
    ^ StressTestDirectory 
        ifNil:[
            StressTestDirectory := (Dialog requestDirectoryName:'Stress Test Directory') asFilename
        ]
! !

!TestXMLParserBUG56 methodsFor:'helpers'!

parseFileNamed: aString 
        | parser  bomb |
        parser := self parserFor: aString.
        bomb := self class stressTestDirectory 
                                construct: (aString asFilename withoutSuffix asString , '.BOMB').
        WarningSignal handle: [:ex |]
                do: 
                        [ bomb exists 
                                ifTrue: [ self should: [ parser scanDocument ] raise: Error ]
                                ifFalse: [ parser scanDocument ] ]
!

parserFor: aString
"/        XMLParserStX emptyAllCaches.
        ^(XML::XMLParser 
                on: (self class stressTestDirectory construct: aString) readStream)
                validate: true;
                yourself
!

setUp
    "To ensure that we are not using a cached DTD"
    XMLParserStX emptyAllCaches.
! !

!TestXMLParserBUG56 methodsFor:'tests'!

testBodyText
        self parseFileNamed: 'bodytext.xml'.
!

testGjError
        self parseFileNamed: 'gj-error.xml'.
!

testGjExplicitPrefixes
        self parseFileNamed: 'gj-explicit-prefix.xml'.
!

testGjMix
        self parseFileNamed: 'gj-mix.xml'.
!

testHeaderText
        self parseFileNamed: 'headertext.xml'.
!

testHtmlText
        self parseFileNamed: 'htmltext.xml'.
!

testMissingRoot
        self parseFileNamed: 'missing-root.xml'.
!

testSimple
        self parseFileNamed: 'simple.xml'.
!

testSimpleWithMath
        self parseFileNamed: 'simple-with-math.xml'.
!

testWorkingAsIs
        self parseFileNamed: 'working-asis.xml'.
!

testWrongRoot
        self parseFileNamed: 'wrong-root.xml'.
!

testXmlLang
        self parseFileNamed: 'xmllang.xml'.
!

testXmlNS
        self parseFileNamed: 'xmlns.xml'.
! !

!TestXMLParserBUG56 class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/xmltests/bugfixes/bug56/XML__TestXMLParserBUG56.st,v 1.3 2004-04-26 10:25:25 james Exp $'
! !

TestXMLParserBUG56 initialize!
