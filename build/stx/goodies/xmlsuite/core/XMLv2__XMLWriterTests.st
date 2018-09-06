"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestCase subclass:#XMLWriterTests
	instanceVariableNames:'writer outputStream'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!

!XMLWriterTests class methodsFor:'documentation'!

documentation
"
    documentation to be added.

    [author:]
        Jan Vrany (janfrog@janfrog)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

history
    "Created: / 11-10-2005 / 11:06:52 / janfrog"
! !

!XMLWriterTests methodsFor:'accessing'!

output

    ^outputStream contents

    "Created: / 18-10-2005 / 12:56:27 / janfrog"
!

writer

    ^writer

    "Created: / 18-10-2005 / 12:56:36 / janfrog"
! !

!XMLWriterTests methodsFor:'initialize / release'!

setUp
    "common setup - invoked before testing."

    super setUp.
    writer := XMLWriter on:(outputStream := UnicodeString new writeStream)

    "Created: / 11-10-2005 / 14:39:13 / janfrog"
    "Modified: / 18-10-2005 / 12:55:57 / janfrog"
!

tearDown
    "common cleanup - invoked after testing."

    super tearDown

    "Created: / 11-10-2005 / 14:39:13 / janfrog"
! !

!XMLWriterTests methodsFor:'tests'!

test_01

    self writer
        startDocument;
        startElement:'x' namespace:'' prefix:'' attributes:Attributes new;
        endElement:'x' namespace:'' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x></x>'

    "Created: / 18-10-2005 / 15:26:48 / janfrog"
    "Modified: / 29-05-2006 / 10:58:11 / janfrog"
!

test_02

    self writer
        startDocument;
        startPrefix:'' mappingTo:'uri';
        startElement:'x' namespace:'' prefix:'' attributes:Attributes new;
        endElement:'x' namespace:'' prefix:'';
        endPrefixMapping:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x xmlns="uri"></x>'

    "Created: / 18-10-2005 / 15:26:52 / janfrog"
    "Modified: / 29-05-2006 / 10:58:22 / janfrog"
!

test_03

    self writer
        startDocument;
        startPrefix:'ns' mappingTo:'uri';
        startElement:'x' namespace:'' prefix:'' attributes:Attributes new;
        endElement:'x' namespace:'' prefix:'';
        endPrefixMapping:'ns';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x xmlns:ns="uri"></x>'

    "Created: / 18-10-2005 / 15:26:55 / janfrog"
    "Modified: / 29-05-2006 / 10:58:48 / janfrog"
!

test_04

    self writer
        startDocument;
        startPrefix:'ns' mappingTo:'uri';
        startElement:'x' namespace:'uri' prefix:'ns' attributes:Attributes new;
        endElement:'x' namespace:'uri' prefix:'ns';
        endPrefixMapping:'ns';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><ns:x xmlns:ns="uri"></ns:x>'

    "Created: / 18-10-2005 / 15:26:59 / janfrog"
    "Modified: / 29-05-2006 / 10:58:50 / janfrog"
!

test_05

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:Attributes new;
        startElement:'y' namespace:'uri' prefix:'' attributes:Attributes new;
        endElement:'y' namespace:'uri' prefix:'';
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x><y></y></x>'

    "Created: / 18-10-2005 / 15:27:03 / janfrog"
    "Modified: / 29-05-2006 / 10:58:53 / janfrog"
!

test_06

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' 
            attributes:(Attributes with:
                (Attr new
                    localName:'attr';
                    value:'val')
            );
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x attr="val"></x>'

    "Created: / 18-10-2005 / 15:27:06 / janfrog"
    "Modified: / 29-05-2006 / 10:58:57 / janfrog"
!

test_07

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

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x attr="val" abc="xyz"></x>'

    "Created: / 18-10-2005 / 15:27:11 / janfrog"
    "Modified: / 29-05-2006 / 10:59:01 / janfrog"
!

test_08

    self writer
        startDocument;
        startPrefix:'ns' mappingTo:'uri';
        startElement:'x' namespace:'uri' prefix:'' 
            attributes:(Attributes with:
                (Attr new
                    localName:'attr';
                    value:'val')
            );
        endElement:'x' namespace:'uri' prefix:'';
        endPrefixMapping:'ns';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x attr="val" xmlns:ns="uri"></x>'

    "Created: / 18-10-2005 / 15:27:17 / janfrog"
    "Modified: / 29-05-2006 / 10:59:05 / janfrog"
!

test_09

    self writer
        startDocument;
        startPrefix:'ns' mappingTo:'uri';
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        startElement:'y' namespace:'uri' prefix:'' attributes:(Attributes new);
        endElement:'y' namespace:'uri' prefix:'';
        endElement:'x' namespace:'uri' prefix:'';
        endPrefixMapping:'ns';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x xmlns:ns="uri"><y></y></x>'

    "Created: / 18-10-2005 / 15:27:20 / janfrog"
    "Modified: / 29-05-2006 / 10:59:08 / janfrog"
!

test_10

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        characters:'characters';
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x>characters</x>'

    "Created: / 18-10-2005 / 15:26:40 / janfrog"
    "Modified: / 29-05-2006 / 10:59:11 / janfrog"
!

test_11

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        processingInstruction:'pi' data:'data';
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x><?pi data?></x>'

    "Created: / 18-10-2005 / 15:30:53 / janfrog"
    "Modified: / 29-05-2006 / 10:59:14 / janfrog"
!

test_12

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        comment:'comment';
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x><!!--comment--></x>'

    "Created: / 18-10-2005 / 15:33:18 / janfrog"
    "Modified: / 29-05-2006 / 10:59:17 / janfrog"
!

test_13

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' attributes:(Attributes new);
        characters:'<>&"';
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x>&lt;&gt;&amp;&quot;</x>'

    "Created: / 21-10-2005 / 14:59:20 / janfrog"
    "Modified: / 29-05-2006 / 10:59:19 / janfrog"
!

test_14

    self writer
        startDocument;
        startElement:'x' namespace:'uri' prefix:'' 
            attributes:(Attributes with:
                (Attr new
                    localName:'attr';
                    value:'val & another val')
            );
        endElement:'x' namespace:'uri' prefix:'';
        endDocument.

    self assert: self output = '<?xml version="1.0" encoding="utf-8"?><x attr="val &amp; another val"></x>'

    "Created: / 21-10-2005 / 15:39:40 / janfrog"
    "Modified: / 29-05-2006 / 10:59:22 / janfrog"
! !

!XMLWriterTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__XMLWriterTests.st,v 1.2 2006-05-29 15:06:52 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

