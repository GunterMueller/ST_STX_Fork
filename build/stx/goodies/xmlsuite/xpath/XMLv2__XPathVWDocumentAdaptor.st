"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathDocumentAdaptor subclass:#XPathVWDocumentAdaptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Adaptors'
!


!XPathVWDocumentAdaptor class methodsFor:'accessing'!

documentClass


    ^XML::Document

    "Created: / 13-10-2006 / 21:05:53 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'checking'!

ensureIsValidNodeId: anObject

    "
        Ensures whether given object is valid node ID for myself
    "

    (anObject isKindOf: XML::Node)
        ifFalse:[XPathInvalidNodeIdError raiseErrorString:'Invalid Node ID']

    "Created: / 14-12-2006 / 23:44:34 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'resource management'!

primReleaseResources

    "Created: / 12-12-2006 / 10:46:37 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'xpath axes'!

primXpathAttributeOf: anObject

    ^(self xpathIsElement: anObject)
        ifTrue:[anObject attributes]
        ifFalse:[#()]

    "Created: / 14-12-2006 / 23:23:14 / janfrog"
!

primXpathChildOf: anObject

    ((self xpathIsElement:anObject) or:[self xpathIsDocument: anObject]) ifFalse:[^#()].

    ^anObject elements

    "Created: / 14-12-2006 / 23:23:21 / janfrog"
!

primXpathParentOf: anObject

    ^anObject parent

    "Created: / 14-12-2006 / 23:23:29 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'xpath primitives'!

primXpathIsDocumentFragment:arg 
    "Superclass says that I am responsible to implement this method"

    ^arg isDocumentFragment

    "Created: / 10-08-2007 / 09:16:21 / janfrog"
!

primXpathIsText:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 10-08-2007 / 09:16:21 / janfrog"
!

primXpathNameOf:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 10-08-2007 / 09:16:21 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'xpath testing'!

primXpathIsAttribute: anObject

    ^anObject isAttribute

    "Created: / 14-12-2006 / 23:24:18 / janfrog"
!

primXpathIsDocument: anObject

    ^anObject isDocument

    "Created: / 14-12-2006 / 23:24:27 / janfrog"
!

primXpathIsElement: anObject

    ^anObject isElement

    "Created: / 14-12-2006 / 23:24:32 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'xpath values'!

primXpathAttributeValueOf: anObject

    ^anObject value

    "Created: / 14-12-2006 / 23:24:47 / janfrog"
!

primXpathLocalNameOf: anObject

    ^anObject tag type

    "Created: / 14-12-2006 / 23:24:52 / janfrog"
!

primXpathNamespaceOf: anObject

    ^anObject tag namespace

    "Created: / 14-12-2006 / 23:25:02 / janfrog"
! !

!XPathVWDocumentAdaptor methodsFor:'xpath values - private'!

primXpathElementValueOf: anObject

    ^anObject tag type

    "Created: / 14-12-2006 / 23:25:11 / janfrog"
!

primXpathTextValueOf: anObject

    ^anObject text

    "Created: / 14-12-2006 / 23:25:16 / janfrog"
! !

!XPathVWDocumentAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathVWDocumentAdaptor.st,v 1.7 2007-08-10 07:34:30 vranyj1 Exp $'
! !
