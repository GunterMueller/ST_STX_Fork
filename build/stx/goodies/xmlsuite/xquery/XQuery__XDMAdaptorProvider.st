"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XDMAdaptorProvider
	instanceVariableNames:''
	classVariableNames:'Default'
	poolDictionaries:''
	category:'XQuery-XDM'
!


!XDMAdaptorProvider class methodsFor:'instance creation'!

default

    "
        XMLv2::DefaultXDMAdaptorProvider reset 
        XMLv2::DefaultXDMAdaptorProvider default  
    "

    Default ifNil:[Default := XQuery::DefaultXDMAdaptorProvider new].
    ^Default.

    "Created: / 05-12-2006 / 14:59:49 / janfrog"
    "Modified: / 28-01-2010 / 11:32:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XDMAdaptorProvider class methodsFor:'initialization & release'!

reset

    "
        XMLv2::XPathDocumentProvider reset
    "

    Default := nil
! !

!XDMAdaptorProvider methodsFor:'accessing'!

documentAdaptorsFor: aStringOrURI

    "
        Returns a document adaptor for document at given URI.
        @param aStringOrURI 
    "

    ^ self subclassResponsibility

    "Created: / 20-09-2007 / 10:32:28 / janfrog"
! !

!XDMAdaptorProvider class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
