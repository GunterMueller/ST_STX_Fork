"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

TestResource subclass:#W3XMLTestSuiteResource
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Tests W3C'
!


!W3XMLTestSuiteResource class methodsFor:'acessing'!

fileNamed:aString

    self current ifNil:
        [self error:'Resource is not initialized'].

    ^self current fileNamed:aString

    "Created: / 25-10-2005 / 15:58:17 / janfrog"
! !

!W3XMLTestSuiteResource methodsFor:'accessing'!

fileNamed:aString

    ^(self filesDirectory construct:aString)

    "Created: / 25-10-2005 / 15:57:36 / janfrog"
!

filesDirectory

    ^((Smalltalk getPackageDirectoryForPackage:self class package)   
        construct: '/resources/tests/xmltestsuite') asFilename

    "Created: / 25-10-2005 / 12:52:23 / janfrog"
    "Modified: / 25-10-2005 / 13:56:41 / janfrog"
! !

!W3XMLTestSuiteResource methodsFor:'testing'!

isAvailable

    ^self filesDirectory exists

    "Created: / 25-10-2005 / 12:39:01 / janfrog"
! !

!W3XMLTestSuiteResource class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__W3XMLTestSuiteResource.st,v 1.1.1.1 2005-11-01 22:07:10 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !

