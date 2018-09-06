"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathDocumentProvider
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'XML Suite-XPath-Adaptors'
!


!XPathDocumentProvider class methodsFor:'instance creation'!

default

    "
        XMLv2::XPathDocumentProvider reset
        XMLv2::XPathDocumentProvider default 
    "

    Default ifNil:[Default := XPathSimpleDocumentProvider new].
    ^Default.

    "Created: / 05-12-2006 / 14:59:49 / janfrog"
! !

!XPathDocumentProvider class methodsFor:'initialization & release'!

reset

    "
        XMLv2::XPathDocumentProvider reset
    "

    Default := nil
! !

!XPathDocumentProvider methodsFor:'accessing'!

documentAdaptorsFor: aStringOrURI

    "
        Returns a document adaptor for document at given URI.
        @param aStringOrURI 
    "

    ^ self subclassResponsibility

    "Created: / 20-09-2007 / 10:32:28 / janfrog"
! !

!XPathDocumentProvider class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDocumentProvider.st,v 1.6 2007-09-21 11:06:48 vranyj1 Exp $'
! !
