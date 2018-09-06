"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathDocumentProvider subclass:#XPathSimpleDocumentProvider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Adaptors'
!


!XPathSimpleDocumentProvider methodsFor:'accessing'!

documentAdaptorsFor: aStringOrURI

    | uri documentAdaptor |
    uri := aStringOrURI asURI.
    uri exists ifFalse:[^XPathDocumentNotFoundError raiseErrorString:'A document ',uri asString,' is not found'].
    uri readStreamDo:
        [:stream :attrs|
        documentAdaptor := XMLv2::XPathDocumentAdaptorFactory
            documentAdaptorFor:(XMLv2::Parser forDOM3 processDocumentInStream:stream
            beforeScanDo:[:parser | parser validate:false ])].

    ^Array with:documentAdaptor

    "Created: / 20-09-2007 / 10:32:41 / janfrog"
! !

!XPathSimpleDocumentProvider class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathSimpleDocumentProvider.st,v 1.3 2007-09-21 11:06:52 vranyj1 Exp $'
! !
