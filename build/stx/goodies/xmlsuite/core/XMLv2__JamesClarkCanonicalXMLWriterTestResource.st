"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestResource subclass:#JamesClarkCanonicalXMLWriterTestResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests'
!


!JamesClarkCanonicalXMLWriterTestResource methodsFor:'accessing'!

canonicalFilesDirectory

    ^self testFilesDirectory construct:'canonical'

    "Created: / 20-05-2006 / 13:03:08 / janfrog"
!

testFiles

    ^self testFilesDirectory directoryContents 
        select:[:filename|filename matches:'*.xml']

    "Created: / 20-05-2006 / 13:05:58 / janfrog"
!

testFilesDirectory

    ^(Smalltalk packageDirectoryForPackageId:(self class package))
        construct:'resources/tests/canonical-form-test-suite'

    "Created: / 20-05-2006 / 13:01:47 / janfrog"
! !

!JamesClarkCanonicalXMLWriterTestResource methodsFor:'testing'!

isAvailable

    ^self testFilesDirectory exists
        and:[self canonicalFilesDirectory exists]

    "Created: / 20-05-2006 / 13:03:57 / janfrog"
! !

!JamesClarkCanonicalXMLWriterTestResource class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__JamesClarkCanonicalXMLWriterTestResource.st,v 1.1 2006-05-21 08:16:23 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

