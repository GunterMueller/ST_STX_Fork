"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XMLReader subclass:#XPathDOMAdaptorXMLReader
	instanceVariableNames:'namespacePrefixMapping documentAdaptor nsId'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-SAX2-XMLReaders'
!


!XPathDOMAdaptorXMLReader class methodsFor:'accessing'!

concreteClass

    ^self

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
! !

!XPathDOMAdaptorXMLReader class methodsFor:'testing'!

isSpecial

    ^true

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
! !

!XPathDOMAdaptorXMLReader methodsFor:'* As yet uncategorized *'!

visitAttribute: nodeId

    contentHandler
        attribute: (documentAdaptor xpathLocalNameOf: nodeId)
        namespace: ''
        prefix: ''
        value: (documentAdaptor xpathValueOf: nodeId)

    "Created: / 14-11-2007 / 15:12:45 / janfrog"
! !

!XPathDOMAdaptorXMLReader methodsFor:'SAX2 events'!

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

!XPathDOMAdaptorXMLReader methodsFor:'SAX2 interface - Locator'!

getPublicId

    ^nil

    "Created: / 14-02-2007 / 00:07:05 / janfrog"
!

getSystemId

    ^nil

    "Created: / 14-02-2007 / 00:07:11 / janfrog"
! !

!XPathDOMAdaptorXMLReader methodsFor:'initialization'!

initialize

    super initialize.
    namespacePrefixMapping := Dictionary new.
    nsId := 0.

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 10-12-2006 / 20:31:45 / janfrog"
!

setDocumentAdaptor: aDocumentAdaptor

    documentAdaptor := aDocumentAdaptor

    "Created: / 10-12-2006 / 20:04:37 / janfrog"
! !

!XPathDOMAdaptorXMLReader methodsFor:'private'!

extractAttributesFrom: elementNodeId

    | attributes |
    attributes := Attributes new.
    (documentAdaptor xpathAttributeOf: elementNodeId) do:
        [:attrId|
        | ns prefix localName value |

        ns := documentAdaptor xpathNamespaceOf:attrId.
        localName := documentAdaptor xpathLocalNameOf: attrId.
        prefix := namespacePrefixMapping at: ns ifAbsentPut:self generateNs.
        value := documentAdaptor xpathValueOf: attrId.
        attributes add: 
            (Attr 
                named: (NodeName new
                            ns: ns;
                            prefix: prefix;
                            localName: localName)
                value: value)
        ].
    ^attributes

    "Created: / 10-12-2006 / 20:15:43 / janfrog"
    "Modified: / 12-12-2006 / 13:08:54 / janfrog"
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

!XPathDOMAdaptorXMLReader methodsFor:'visiting'!

parseNodeId: id 
    self visit: id.

    "Created: / 10-12-2006 / 13:50:22 / janfrog"
!

visit: nodeId

    "Ugly switch, but no polymorphism could be employed, because
    nodeId could be all of one class (CellPointer for instance)"

    (documentAdaptor xpathIsDocument: nodeId) ifTrue:[^self visitDocument: nodeId].    
    (documentAdaptor xpathIsElement: nodeId) ifTrue:[^self visitElement: nodeId].
    (documentAdaptor xpathIsText: nodeId) ifTrue:[^self visitText: nodeId].
    (documentAdaptor xpathIsDocumentFragment: nodeId) ifTrue:[^self visitDocumentFragment: nodeId].
    (documentAdaptor xpathIsAttribute: nodeId) ifTrue:[^self visitAttribute: nodeId].

    Smalltalk isStandAloneApp ifFalse:
        [contentHandler comment: 'Unknown nodeId: ',nodeId printString]
    "/self shouldNeverBeReached

    "Created: / 10-12-2006 / 20:03:49 / janfrog"
    "Modified: / 14-11-2007 / 15:11:50 / janfrog"
!

visitDocument:nodeId

    namespacePrefixMapping := Dictionary new.
    nsId := 0.
    contentHandler setDocumentLocator: self.
    contentHandler startDocument.
    (documentAdaptor xpathChildOf: nodeId) do:
        [:childId|self visit: childId].
    contentHandler endDocument

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 12-12-2006 / 14:00:58 / janfrog"
!

visitDocumentFragment:nodeId

    namespacePrefixMapping := Dictionary new.
    nsId := 0.
    contentHandler setDocumentLocator: self.
    contentHandler startDocumentFragment.
    (documentAdaptor xpathChildOf: nodeId) do:
        [:childId|self visit: childId].
    contentHandler endDocumentFragment

    "Created: / 10-08-2007 / 09:19:39 / janfrog"
!

visitElement:nodeId 
    |ns localName prefix attrs|

    ns := documentAdaptor xpathNamespaceOf:nodeId.
    localName := documentAdaptor xpathLocalNameOf:nodeId.
    prefix := self prefixForNamespaceURI:ns.
    attrs := self extractAttributesFrom:nodeId.
    contentHandler 
        startElement:localName
        namespace:ns
        prefix:prefix
        attributes:attrs.
    (documentAdaptor xpathChildOf:nodeId) do:[:childId | 
        self visit:childId
    ].
    contentHandler 
        endElement:localName
        namespace:ns
        prefix:prefix

    "Modified: / 30-05-2005 / 16:30:11 / masca"
    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 12-12-2006 / 14:16:37 / janfrog"
!

visitText: nodeId

    | data |
    data := documentAdaptor xpathValueOf: nodeId.
    (data allSatisfy:[:c|c isXMLWhiteSpace]) ifFalse:
        [contentHandler characters: data]

    "Created: / 10-12-2006 / 13:48:28 / janfrog"
    "Modified: / 10-12-2006 / 20:41:46 / janfrog"
! !

!XPathDOMAdaptorXMLReader class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDOMAdaptorXMLReader.st,v 1.5 2007-11-15 18:54:32 vranyj1 Exp $'
! !
