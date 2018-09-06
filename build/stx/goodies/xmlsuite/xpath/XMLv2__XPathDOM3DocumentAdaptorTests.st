"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathDocumentAdaptorTests subclass:#XPathDOM3DocumentAdaptorTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Tests'
!


!XPathDOM3DocumentAdaptorTests methodsFor:'initialization & release'!

createDocumentAdaptor

    | document |
    document := XMLv2::Parser forDOM3 processDocumentString:self class bookstore.
    ^documentAdaptor := XPathDOM3DocumentAdaptor new document: document.

    "Created: / 20-11-2006 / 21:57:44 / janfrog"
! !

!XPathDOM3DocumentAdaptorTests class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDOM3DocumentAdaptorTests.st,v 1.2 2006-12-15 11:06:33 vranyj1 Exp $'
! !
