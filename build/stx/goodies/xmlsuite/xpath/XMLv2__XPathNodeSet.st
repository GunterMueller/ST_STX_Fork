"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

IdentitySet subclass:#XPathNodeSet
	instanceVariableNames:'documentAdaptor'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath'
!


!XPathNodeSet methodsFor:'accessing'!

documentAdaptor
    ^ documentAdaptor

    "Created: / 13-10-2006 / 20:49:51 / janfrog"
!

documentAdaptor:anXPathDocumentAdaptor
    documentAdaptor := anXPathDocumentAdaptor.

    "Created: / 13-10-2006 / 20:20:19 / janfrog"
!

nodes

    <resource: #obsolete>
    self obsoleteFeatureWarning .
    ^ self

    "Modified: / 13-10-2006 / 18:05:00 / janfrog"
!

nodesInDocumentOrder

    ^self asSortedCollection:documentAdaptor xpathNodePositionComparator

    "Created: / 13-10-2006 / 20:28:04 / janfrog"
! !

!XPathNodeSet methodsFor:'adding'!

addNode:aNode

    <resource: #obsolete>
    self obsoleteFeatureWarning .
    self add:aNode.

    "Modified: / 13-10-2006 / 18:04:40 / janfrog"
!

addNodeSet:aNodeSet

    <resource: #obsolete>
    self obsoleteFeatureWarning .
    self addAll: aNodeSet

    "Modified: / 13-10-2006 / 18:05:32 / janfrog"
! !

!XPathNodeSet methodsFor:'enumeration'!

inDocumentOrderDo: aBlock

    self nodesInDocumentOrder do: aBlock

    "Created: / 13-10-2006 / 20:29:41 / janfrog"
! !

!XPathNodeSet methodsFor:'hacks'!

new

    ^self class new
        documentAdaptor: documentAdaptor;
        yourself

    "Created: / 13-10-2006 / 20:48:01 / janfrog"
!

species

    ^self

    "Created: / 13-10-2006 / 20:47:38 / janfrog"
! !

!XPathNodeSet methodsFor:'printing'!

asString
    |position string|

    string := ''.
    position := 1.
    self inDocumentOrderDo:[:node | 
        (documentAdaptor xpathIsElement: node) ifTrue:[
            string := string , (documentAdaptor xpathValueOf:node) , (position printString) , ' '.
        ].
        (documentAdaptor xpathIsAttribute: node) ifTrue:[
            string := string , (documentAdaptor xpathValueOf:node).
        ].
        (documentAdaptor xpathIsText: node)  ifTrue:[
            (((documentAdaptor xpathValueOf:node)) withoutSeparators = '') ifFalse:[
                position := position + 1
            ]
        ] ifFalse:[
            position := position + 1
        ].
    ].
    ^ string.

    "Created: / 13-10-2006 / 20:30:54 / janfrog"
    "Modified: / 24-10-2006 / 13:36:18 / janfrog"
! !

!XPathNodeSet methodsFor:'queries'!

includesNode:aNode

    <resource: #obsolete>
    self obsoleteFeatureWarning .
    ^self includes: aNode

    "Modified: / 13-10-2006 / 18:05:50 / janfrog"
! !

!XPathNodeSet class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathNodeSet.st,v 1.3 2006-10-27 06:06:32 vranyj1 Exp $'
! !
