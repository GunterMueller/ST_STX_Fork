"{ Package: 'stx:goodies/xmlsuite/xsl-fo' }"

"{ NameSpace: FO }"

XMLv2::XMLSuiteDOM3Implementation subclass:#FOImplementation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'FO-DOM3 Implemementation'
!


!FOImplementation methodsFor:'accessing'!

featureArray 
    "
        
        XMLv2::DOMImplementationRegistry getDOMImplementation:'+XML 3.0 +XSLT-FO 1.0'   
    "



    ^super featureArray , #(('XSLT-FO' '1.0') ('+XSLT-FO' '1.0'))

    "Created: / 07-04-2007 / 14:45:48 / janfrog"
! !

!FOImplementation methodsFor:'instance creation'!

createDocument

    ^FO::Document new

    "Created: / 07-04-2007 / 14:56:04 / janfrog"
! !

!FOImplementation class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xsl-fo/FO__FOImplementation.st,v 1.1 2007-04-13 15:41:44 vranyj1 Exp $'
! !
