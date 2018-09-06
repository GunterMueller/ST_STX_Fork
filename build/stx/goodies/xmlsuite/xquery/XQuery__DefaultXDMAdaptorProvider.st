"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAdaptorProvider subclass:#DefaultXDMAdaptorProvider
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-XDM'
!


!DefaultXDMAdaptorProvider methodsFor:'accessing'!

documentAdaptorsFor: aStringOrURI

    | uri documentAdaptor |
    uri := aStringOrURI asURI.
    uri exists ifFalse:[^XQuery::DocumentNotFoundError raiseErrorString:'A document ',uri asString,' is not found'].
    uri readStreamDo:
        [:stream :attrs|
        documentAdaptor := XQuery::XDMAdaptorFactory
            documentAdaptorFor:(XMLv2::Parser forDOM3 processDocumentInStream:stream
            beforeScanDo:[:parser | parser validate:false ])].

    ^Array with:documentAdaptor

    "Created: / 20-09-2007 / 10:32:41 / janfrog"
    "Modified: / 06-04-2010 / 11:55:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DefaultXDMAdaptorProvider class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
