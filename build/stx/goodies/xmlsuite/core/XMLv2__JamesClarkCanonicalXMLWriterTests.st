"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#JamesClarkCanonicalXMLWriterTests
	instanceVariableNames:'writer outputStream'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!JamesClarkCanonicalXMLWriterTests class methodsFor:'accessing'!

resources

    ^Array with:
        JamesClarkCanonicalXMLWriterTestResource

    "Created: / 20-05-2006 / 13:08:54 / janfrog"
! !

!JamesClarkCanonicalXMLWriterTests methodsFor:'accessing'!

output

    ^outputStream contents

    "Created: / 21-10-2005 / 15:25:44 / janfrog"
!

writer

    ^writer

    "Created: / 21-10-2005 / 15:25:44 / janfrog"
! !

!JamesClarkCanonicalXMLWriterTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp.
    writer := JamesClarkCanonicalXMLWriter on:(outputStream := UnicodeString new writeStream)

    "Created: / 21-10-2005 / 15:16:16 / janfrog"
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown

    "Created: / 21-10-2005 / 15:16:16 / janfrog"
! !

!JamesClarkCanonicalXMLWriterTests methodsFor:'tests'!

test_01

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        characters:(UnicodeString with:Character tab);
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<x>&#9;</x>'

    "Created: / 21-10-2005 / 15:25:39 / janfrog"
!

test_02

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        characters:(UnicodeString with:Character linefeed);
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<x>&#A;</x>'

    "Created: / 21-10-2005 / 15:28:10 / janfrog"
!

test_03

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        characters:(UnicodeString with:Character return);
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<x>&#D;</x>'

    "Created: / 21-10-2005 / 15:28:22 / janfrog"
!

test_04

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' 
            attributes:(Attributes
                with: (Attr new
                    localName:'attr';
                    value:'val')
                with: (Attr new
                    localName:'abc';
                    value:'xyz')
            );
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<x abc="xyz" attr="val"></x>'

    "Created: / 21-10-2005 / 15:34:02 / janfrog"
!

test_files


    JamesClarkCanonicalXMLWriterTestResource current testFiles do:[:filename|
        | source 
          canonical 
          parser 
          output |
        writer stream reset.
        source := (JamesClarkCanonicalXMLWriterTestResource current testFilesDirectory construct:filename)
                    readStream contents asString.
        canonical := (JamesClarkCanonicalXMLWriterTestResource current canonicalFilesDirectory construct:filename)
                    readStream contents asString.
        parser := XMLReader new setContentHandler: writer.
        parser parseInputSource:(InputSource onString:source).
        output := self output.


        self assert: output = canonical.

        Transcript showCR:filename asString  , '...OK'.
    ]

    "Created: / 20-05-2006 / 13:08:36 / janfrog"
    "Modified: / 29-09-2006 / 08:00:37 / janfrog"
! !

!JamesClarkCanonicalXMLWriterTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__JamesClarkCanonicalXMLWriterTests.st,v 1.3 2006-10-02 14:55:02 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

