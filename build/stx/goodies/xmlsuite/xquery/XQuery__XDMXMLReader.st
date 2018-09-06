"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XMLv2::XMLReader subclass:#XDMXMLReader
	instanceVariableNames:'namespacePrefixMapping documentAdaptor nsId'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-XDM'
!


!XDMXMLReader class methodsFor:'accessing'!

concreteClass

    ^self

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
! !

!XDMXMLReader class methodsFor:'testing'!

isSpecial

    ^true

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
! !

!XDMXMLReader methodsFor:'SAX2 events'!

getColumnNumber

    ^nil

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
!

getLineNumber

    ^nil

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
!

parseFragmentStream:aStream

    "I read DOM3 tree, not stream"

    self shouldNotImplement

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
!

parseStream:aStream 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
! !

!XDMXMLReader methodsFor:'SAX2 interface - Locator'!

getPublicId

    ^nil

    "Created: / 14-02-2007 / 00:07:05 / janfrog"
!

getSystemId

    ^nil

    "Created: / 14-02-2007 / 00:07:11 / janfrog"
! !

!XDMXMLReader methodsFor:'initialization'!

initialize

    super initialize.
    namespacePrefixMapping := Dictionary new.
    nsId := 0.

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 10-12-2006 / 20:31:45 / janfrog"
!

setDocumentAdaptor: aDocumentAdaptor
    <resource: #obsolete>
    self error: 'documentAdaptor should not be used any more'.

"/    documentAdaptor := aDocumentAdaptor

    "Created: / 10-12-2006 / 20:04:37 / janfrog"
    "Modified: / 07-06-2009 / 21:21:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 23-04-2010 / 10:56:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XDMXMLReader methodsFor:'private'!

extractAttributesFrom: elementNodeId

    | attributes |
    attributes := XMLv2::Attributes new.
    (elementNodeId xpathAttribute) do:
        [:attrId|
        | ns prefix localName value |

        ns := attrId xpathNamespace.
        localName := attrId xpathLocalName.
        prefix := namespacePrefixMapping at: ns ifAbsentPut:self generateNs.
        value := attrId dmStringValue.
        attributes add: 
            (XMLv2::Attr 
                named: (XMLv2::NodeName new
                            ns: ns;
                            prefix: prefix;
                            localName: localName)
                value: value)
        ].
    ^attributes

    "Created: / 10-12-2006 / 20:15:43 / janfrog"
    "Modified: / 12-12-2006 / 13:08:54 / janfrog"
    "Modified: / 06-10-2009 / 12:48:51 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2010 / 15:21:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

generateNs

    ^'ns' , (nsId := nsId + 1) printString

    "Created: / 10-12-2006 / 20:12:57 / janfrog"
!

prefixForNamespaceURI:ns 
    ^namespacePrefixMapping isEmpty
        ifTrue:[namespacePrefixMapping at:ns put:'']
        ifFalse:[namespacePrefixMapping at:ns ifAbsentPut:self generateNs]

    "Created: / 12-12-2006 / 14:16:37 / janfrog"
! !

!XDMXMLReader methodsFor:'visiting'!

parseNodeId: id 
    self visit: id.

    "Created: / 10-12-2006 / 13:50:22 / janfrog"
!

visit: node

    "Ugly switch, but no polymorphism could be employed, because
    nodeId could be all of one class (CellPointer for instance)"
    "nodeId is atomicValue"
    (node isAtomicValue) ifTrue: [^ self visitAtomic: node].

    (node isSubtypeOf: 'document') ifTrue:[^self visitDocument: node].    
    (node isElementNode) ifTrue:[^self visitElement: node].
    (node isTextNode) ifTrue:[^self visitText: node].
    (node isAttributeNode) ifTrue:[^self visitAttribute: node].
    (node isDocumentFragmentNode) ifTrue:[^self visitDocumentFragment: node].

    Smalltalk isStandAloneApp ifFalse:
        [contentHandler comment: 'Unknown node: ',node printString]
    "/self shouldNeverBeReached

    "Created: / 10-12-2006 / 20:03:49 / janfrog"
    "Modified: / 14-11-2007 / 15:11:50 / janfrog"
    "Modified: / 05-10-2009 / 14:36:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAtomic: item
    | data |
    data := item stringValue.
    (data allSatisfy:[:c|c isXMLWhiteSpace]) ifFalse:
        [contentHandler characters: data]

    "Modified: / 05-10-2009 / 14:37:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitAttribute: nodeId

    contentHandler
        attribute: (nodeId xpathLocalName)
        namespace: ''
        prefix: ''
        value: (nodeId xpathValue)

    "Created: / 14-11-2007 / 15:12:45 / janfrog"
    "Modified: / 07-06-2009 / 21:21:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitDocument:node

    namespacePrefixMapping := Dictionary new.
    nsId := 0.
    contentHandler setDocumentLocator: self.
    contentHandler startDocument.
    (node xpathChild) do:
        [:childId|self visit: childId].
    contentHandler endDocument

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 12-12-2006 / 14:00:58 / janfrog"
    "Modified: / 07-06-2009 / 21:16:39 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitDocumentFragment:node

    namespacePrefixMapping := Dictionary new.
    nsId := 0.
    contentHandler setDocumentLocator: self.
    contentHandler startDocumentFragment.
    (node xpathChild) do:
        [:childId|self visit: childId].
    contentHandler endDocumentFragment

    "Created: / 10-08-2007 / 09:19:39 / janfrog"
    "Modified: / 07-06-2009 / 21:16:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitElement:node 
    |ns localName prefix attrs|

    ns := node xpathNamespace.
    localName := node xpathLocalName.
    prefix := self prefixForNamespaceURI:ns.
    attrs := self extractAttributesFrom:node.
    contentHandler 
        startElement:localName
        namespace:ns
        prefix:prefix
        attributes:attrs.
    (node xpathChild) do:[:childId | 
        self visit:childId
    ].
    contentHandler 
        endElement:localName
        namespace:ns
        prefix:prefix

    "Modified: / 30-05-2005 / 16:30:11 / masca"
    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 12-12-2006 / 14:16:37 / janfrog"
    "Modified: / 07-06-2009 / 21:15:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

visitText: node

    | data |
    data := node xpathValue.
    (data allSatisfy:[:c|c isXMLWhiteSpace]) ifFalse:
        [contentHandler characters: data]

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 10-12-2006 / 20:41:46 / janfrog"
    "Modified: / 07-06-2009 / 21:15:58 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMXMLReader class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDOMAdaptorXMLReader.st,v 1.5 2007-11-15 18:54:32 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
