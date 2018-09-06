"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#DOMImplementation
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3-Implementation'
!

DOMImplementation class instanceVariableNames:'defaultInstance'

"
 No other class instance variables are inherited by this class.
"
!


!DOMImplementation class methodsFor:'DOM3 interface'!

createDocument

    "Just forward to singleton object"

    ^self default createDocument

    "Created: / 04-08-2005 / 13:23:47 / janfrog"
!

createDocumentFragment

    "Just forward to singleton object"

    ^self default createDocumentFragment

    "Created: / 10-12-2006 / 20:37:30 / janfrog"
!

createDocumentType

    "Just forward to singleton object"

    ^self default createDocumentType

    "Created: / 04-08-2005 / 13:23:54 / janfrog"
! !

!DOMImplementation class methodsFor:'accessing'!

default

    ^defaultInstance ifNil:[defaultInstance := self new]

    "Created: / 19-06-2005 / 15:33:20 / janfrog"
!

flushDefault

    ^defaultInstance := nil

    "Created: / 19-06-2005 / 15:33:32 / janfrog"
! !

!DOMImplementation methodsFor:'DOM3 interface'!

createDocumentNS:ns qualifiedName:qName doctype:documentType

    ^self subclassResponsibility

    "Created: / 11-08-2005 / 22:32:09 / janfrog"
!

createDocumentType:type publicId:pubID systemId:sysID

    self subclassResponsibility

    "Created: / 24-12-2005 / 10:41:07 / janfrog"
!

getFeature:feature version:version

    ^self subclassResponsibility

    "Created: / 19-06-2005 / 15:31:26 / janfrog"
!

hasFeature:feature version:version

    self featureArray pairsDo:[:f :v|
        ((f sameAs: feature) 
            and:[version isNil or:[version = v]])
                ifTrue:[^true]].
    ^false

    "Created: / 19-06-2005 / 15:29:24 / janfrog"
! !

!DOMImplementation methodsFor:'accessing'!

featureArray

    ^self subclassResponsibility

    "Created: / 19-06-2005 / 15:29:46 / janfrog"
!

saxContentHandler

    ^self saxContentHandlerClass new
            domImplementation: self.

    "Created: / 04-08-2005 / 12:53:26 / janfrog"
    "Modified: / 07-04-2007 / 14:59:55 / janfrog"
!

saxContentHandlerClass

    "Answers SAX2 ContentHandler class that builds DOM tree"

    ^self subclassResponsibility

    "Created: / 04-08-2005 / 12:53:15 / janfrog"
! !

!DOMImplementation methodsFor:'instance creation'!

createDocument

    ^self subclassResponsibility

    "Created: / 11-08-2005 / 22:32:10 / janfrog"
!

createDocumentFragment

    ^self subclassResponsibility

    "Created: / 10-12-2006 / 20:35:20 / janfrog"
! !

!DOMImplementation methodsFor:'utilities'!

hasFeatures:anArray

    anArray do:[:fp|
        (self featureArray includes:fp) ifFalse:[^false]
    ].
    ^true

    "
        XMLSuiteDOM3Implementation default hasFeatures:#(('XML' '3.0')) 
        XMLSuiteDOM3Implementation default hasFeatures:#(('+XML' '3.0')) 
        XMLSuiteDOM3Implementation default hasFeatures:#(('XPath' '3.0'))     
    "

    "Created: / 04-08-2005 / 12:25:43 / janfrog"
! !

!DOMImplementation class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DOMImplementation.st,v 1.5 2007-04-10 08:33:12 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
