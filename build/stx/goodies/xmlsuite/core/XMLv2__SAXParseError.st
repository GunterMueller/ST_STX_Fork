"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

SAXError subclass:#SAXParseError
	instanceVariableNames:'col line locator systemId pubId'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-Exceptions'
!


!SAXParseError methodsFor:'SAX2 interface'!

getColumnNumber
    ^col

    "Created: / 17-04-2005 / 09:47:53 / janfrog"
!

getLineNumber
    ^line

    "Created: / 17-04-2005 / 09:47:59 / janfrog"
!

getPublicId
    ^pubId

    "Created: / 17-04-2005 / 09:48:11 / janfrog"
!

getSystemId
    ^systemId

    "Created: / 17-04-2005 / 09:48:25 / janfrog"
! !

!SAXParseError methodsFor:'accessing'!

col:something
    col := something.

    "Created: / 17-04-2005 / 09:47:38 / janfrog"
!

line:something
    line := something.

    "Created: / 17-04-2005 / 09:47:38 / janfrog"
!

locator:something
    locator := something.

    "Created: / 17-04-2005 / 09:47:38 / janfrog"
!

pubId:something
    pubId := something.

    "Created: / 17-04-2005 / 09:47:38 / janfrog"
!

systemId:something
    systemId := something.

    "Created: / 17-04-2005 / 09:47:38 / janfrog"
! !

!SAXParseError class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__SAXParseError.st,v 1.2 2006-12-07 08:17:04 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
