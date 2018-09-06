"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010
"
"{ Package: 'stx:libjava/examples' }"

"{ NameSpace: Smalltalk }"

Object subclass:#JavaExamples
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Languages-Java-Examples'
!

!JavaExamples class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1996-2015 by Claus Gittinger

 New code and modifications done at SWING Research Group [1]:

 COPYRIGHT (c) 2010-2015 by Jan Vrany, Jan Kurs and Marcel Hlopko
                            SWING Research Group, Czech Technical University in Prague

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.

 [1] Code written at SWING Research Group contains a signature
     of one of the above copright owners. For exact set of such code,
     see the differences between this version and version stx:libjava
     as of 1.9.2010

"
! !

!JavaExamples class methodsFor:'examples'!

example_1
    "A CD .xml parsing example. The handler prints each CD it parses
     from given XML file. Demonstrates:
      - proxy creation
      - exception handling

    cd.xml may look like:

    <?xml version='1.0' encoding='ISO-8859-1'?>
    <catalog>
        <cd>
            <title>Empire Burlesque</title>
            <artist>Bob Dylan</artist>
            <country>USA</country>
            <company>Columbia</company>
            <price>10.90</price>
            <year>1985</year>
        </cd>
    </catalog>



    "

    | file factory parser |

    file := (Smalltalk packageDirectoryForPackageId: self package) asFilename
                / 'data' / 'cd.xml'.

    factory := JAVA javax xml parsers SAXParserFactory newInstance.
    parser := factory newSAXParser getXMLReader.
    parser setContentHandler: JavaExamples::CDDatabaseHandler1 new.
    [
        parser parse: file pathName
    ] on: JAVA java io IOException do:[:ioe|
        Transcript showCR: 'I/O error: ', ioe getMessage.
        ioe printStackTrace
    ] on: UserNotification do:[:un|
        Transcript showCR: un messageText.
        un proceed.
    ]

    "Created: / 13-05-2012 / 18:27:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

example_2
    "A CD .xml parsing example. The parser raises a UserNotification
     whenever it parses a CD. The notification is then handled and printed. 
     Demonstrates:
      - proxy creation
      - exception handling

    cd.xml may look like:

    <?xml version='1.0' encoding='ISO-8859-1'?>
    <catalog>
        <cd>
            <title>Empire Burlesque</title>
            <artist>Bob Dylan</artist>
            <country>USA</country>
            <company>Columbia</company>
            <price>10.90</price>
            <year>1985</year>
        </cd>
    </catalog>



    "

    | file factory parser |

    file := (Smalltalk packageDirectoryForPackageId: self package) asFilename
                / 'data' / 'cd.xml'.

    factory := JAVA javax xml parsers SAXParserFactory newInstance.
    parser := factory newSAXParser getXMLReader.
    parser setContentHandler: JavaExamples::CDDatabaseHandler2 new.
    [
        parser parse: file pathName
    ] on: JAVA java io IOException do:[:ioe|
        Transcript showCR: 'I/O error: ', ioe getMessage.
        ioe printStackTrace
    ] on: UserNotification do:[:un|
        Transcript showCR: un messageText.
        un proceed.
    ]

    "Created: / 20-08-2012 / 17:28:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!JavaExamples class methodsFor:'documentation'!

version_CVS
    ^ '$Header: /cvs/stx/stx/libjava/examples/JavaExamples.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
!

version_HG

    ^ '$Changeset: <not expanded> $'
!

version_SVN
    ^ '$Id: JavaExamples.st,v 1.5 2015-03-20 12:08:02 vrany Exp $'
! !

