"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#EncodingTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!

!EncodingTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany (janfrog@bruxa)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 15-06-2005 / 13:48:02 / janfrog"
! !

!EncodingTests class methodsFor:'defaults'!

defaultTestDirectory

    ^(Smalltalk getPackageDirectoryForPackage:self package)
        construct:'resources/tests/encoding'

    "Created: / 15-06-2005 / 14:26:36 / janfrog"
    "Modified: / 22-06-2005 / 09:22:56 / masca"
! !

!EncodingTests methodsFor:'accessing'!

letters

    ^'+ěščřžýáíéúů+ĚŠČŘŽÝÁÍÉÚŮ'
        utf8Decoded

    "Created: / 15-06-2005 / 14:44:15 / janfrog"
!

sentence

    ^'Příliš žluťoučký kůň úpěl ďábelské ódy'
        utf8Decoded

    "Modified: / 15-06-2005 / 14:43:28 / janfrog"
! !

!EncodingTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp

    "Created: / 15-06-2005 / 13:48:02 / janfrog"
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown

    "Created: / 15-06-2005 / 13:48:02 / janfrog"
! !

!EncodingTests methodsFor:'tests'!

test_read_iso8859_2

    | doc xmlSentence xmlLetters|
    doc := XMLv2::Parser new
            processDocumentInFilename:
                (self class defaultTestDirectory 
                    construct:'enc-iso8859-2.xml').
    xmlSentence := (doc root anyElementNamed:'sentence') characterData.
    xmlLetters := (doc root anyElementNamed:'letters') characterData.

    self assert:self sentence = xmlSentence.
    self assert:self letters = xmlLetters.

    "Created: / 15-06-2005 / 14:56:14 / janfrog"
!

test_read_utf8

    | doc xmlSentence xmlLetters|
    doc := XMLv2::Parser new
            processDocumentInFilename:
                (self class defaultTestDirectory 
                    construct:'enc-utf8.xml').
    xmlSentence := (doc root anyElementNamed:'sentence') characterData.
    xmlLetters := (doc root anyElementNamed:'letters') characterData.

    self assert:self sentence = xmlSentence.
    self assert:self letters = xmlLetters.

    "
        self sentence 
        xmlSentence
    "

    "Created: / 15-06-2005 / 14:55:41 / janfrog"
!

test_read_utf8_without_encoding_decl

    | doc xmlSentence xmlLetters|
    doc := XMLv2::Parser new
            processDocumentInFilename:
                (self class defaultTestDirectory 
                    construct:'enc-utf8-without-encoding-decl.xml').
    xmlSentence := (doc root anyElementNamed:'sentence') characterData.
    xmlLetters := (doc root anyElementNamed:'letters') characterData.

    self assert:self sentence = xmlSentence.
    self assert:self letters = xmlLetters.

    "
        self sentence 
        xmlSentence
    "

    "Created: / 16-06-2005 / 09:19:28 / janfrog"
!

test_write_iso8859_2

    | doc fileBuffer docBuffer |
    doc := XML::Document new.
    doc addNode:(XML::Element tag:'enc').
    doc root addNode:
        ((XML::Element tag:'sentence')
            addNode:(XML::Text text:self sentence)).
    doc root addNode:
        ((XML::Element tag:'letters')
            addNode:(XML::Text text:self letters)).


    fileBuffer := (self class defaultTestDirectory 
                        construct:'enc-iso8859-2.xml') readStream binary contents.

    docBuffer := (ByteArray new:189) writeStream.
    OldXMLWriter new
        stream:docBuffer;
        formatOutput:false;
        encoding:#'iso-8859-2';
        write:doc.
    docBuffer := docBuffer contents.

    self assert:docBuffer = fileBuffer. 



    "doc := XMLv2::Parser new
            processDocumentInFilename:
                (self class defaultTestDirectory 
                    construct:'enc-utf8.xml').
    xmlSentence := (doc root anyElementNamed:'sentence') characterData.
    xmlLetters := (doc root anyElementNamed:'letters') characterData.

    self assert:self sentence = xmlSentence.
    self assert:self letters = xmlLetters.
    "

    "
        self sentence 
        xmlSentence
    "

    "Created: / 15-06-2005 / 19:29:44 / janfrog"
    "Modified: / 18-10-2005 / 11:31:57 / janfrog"
!

test_write_utf8

    | doc fileBuffer docBuffer |
    doc := XML::Document new.
    doc addNode:(XML::Element tag:'enc').
    doc root addNode:
        ((XML::Element tag:'sentence')
            addNode:(XML::Text text:self sentence)).
    doc root addNode:
        ((XML::Element tag:'letters')
            addNode:(XML::Text text:self letters)).


    fileBuffer := (self class defaultTestDirectory 
                        construct:'enc-utf8.xml') readStream binary contents.

    docBuffer := (ByteArray new:189) writeStream.
    OldXMLWriter write:doc on:docBuffer format:false.
    docBuffer := docBuffer contents.
    
    self assert:docBuffer = fileBuffer.        


    "doc := XMLv2::Parser new
            processDocumentInFilename:
                (self class defaultTestDirectory 
                    construct:'enc-utf8.xml').
    xmlSentence := (doc root anyElementNamed:'sentence') characterData.
    xmlLetters := (doc root anyElementNamed:'letters') characterData.

    self assert:self sentence = xmlSentence.
    self assert:self letters = xmlLetters.
    "

    "
        self sentence 
        xmlSentence
    "

    "Created: / 15-06-2005 / 19:09:33 / janfrog"
    "Modified: / 18-10-2005 / 11:31:53 / janfrog"
! !

!EncodingTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__EncodingTests.st,v 1.1.1.1 2005-11-01 22:05:44 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

