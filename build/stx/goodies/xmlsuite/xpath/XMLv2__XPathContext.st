"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathContext
	instanceVariableNames:'node position contextSize documentAdaptor'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathContext methodsFor:'accessing'!

contextSize
    ^ contextSize
!

contextSize:something
    contextSize := something.
!

documentAdaptor
    ^ documentAdaptor

    "Created: / 13-10-2006 / 17:30:38 / janfrog"
!

documentAdaptor: anXPathDocumentAdaptor
    documentAdaptor := anXPathDocumentAdaptor.

    "Created: / 13-10-2006 / 17:31:04 / janfrog"
!

newNodeSet

    ^XPathNodeSet new documentAdaptor:self documentAdaptor.

    "Created: / 13-10-2006 / 20:39:40 / janfrog"
!

newNodeSetWith: anObject

    ^self newNodeSet
        add: anObject;
        yourself

    "Created: / 13-10-2006 / 20:41:14 / janfrog"
!

newNodeSetWithAll: aCollection

    ^self newNodeSet
        addAll: aCollection;
        yourself

    "Created: / 13-10-2006 / 20:43:23 / janfrog"
!

node
    ^ node
!

node:something
    node := something.
!

position
    ^ position
!

position:something
    position := something.
! !

!XPathContext class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathContext.st,v 1.2 2006-10-14 05:42:04 vranyj1 Exp $'
! !
