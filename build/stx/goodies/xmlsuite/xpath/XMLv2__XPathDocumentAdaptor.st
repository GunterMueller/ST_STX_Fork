"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

Object subclass:#XPathDocumentAdaptor
	instanceVariableNames:'document released documentURI'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Adaptors'
!


!XPathDocumentAdaptor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 24-10-2006 / 11:15:06 / janfrog"
! !

!XPathDocumentAdaptor class methodsFor:'accessing'!

documentClass

    ^self subclassResponsibility

    "Created: / 13-10-2006 / 21:05:26 / janfrog"
! !

!XPathDocumentAdaptor class methodsFor:'testing'!

isAbstract

    ^self == XPathDocumentAdaptor

    "Created: / 13-10-2006 / 21:05:14 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'accessing'!

document
        ^document.
!

document: aDocument

    document := aDocument.
    document ifNotNil:[released := false].

    "Modified: / 24-10-2006 / 11:14:54 / janfrog"
!

documentURI: uri

    documentURI := uri.

    "Created: / 20-09-2007 / 12:49:21 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'checking'!

ensureIsValidAttributeId: nodeId 

    (self xpathIsAttribute: nodeId)
        ifFalse:[self invalidNodeIdError: 'Not an attribute']

    "Created: / 31-10-2007 / 10:21:04 / janfrog"
!

ensureIsValidElementId: nodeId 

    (self xpathIsElement: nodeId)
        ifFalse:[self invalidNodeIdError: 'Not an element']

    "Created: / 31-10-2007 / 10:18:19 / janfrog"
!

ensureIsValidElementOrAttributeId: nodeId 

    ((self xpathIsAttribute: nodeId) or:[self xpathIsElement: nodeId])
        ifFalse:[self invalidNodeIdError: 'Not an attribute']

    "Created: / 31-10-2007 / 10:22:12 / janfrog"
!

ensureIsValidElementOrDocumentId: nodeId 


    ((self xpathIsElement: nodeId) or:[self xpathIsDocument: nodeId])
        ifFalse:[self invalidNodeIdError: 'Not an element or document']

    "Created: / 31-10-2007 / 10:18:19 / janfrog"
!

ensureIsValidNodeId:arg 
    "raise an error: must be redefined in concrete subclass(es)"

    ^ self subclassResponsibility

    "Created: / 14-12-2006 / 23:44:44 / janfrog"
!

ensureIsValidNodeIds: aCollection "of node-ids"

    aCollection do:[:nodeId| self ensureIsValidNodeId: nodeId]

    "Created: / 14-11-2007 / 16:11:18 / janfrog"
!

ensureNotReleased

    released ifTrue:[XPathDocumentAdaptorReleasedError raiseErrorString:'Document adaptor released']

    "Created: / 24-10-2006 / 11:16:30 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'error reporting'!

invalidNodeIdError: aString

    XMLv2::XPathInvalidNodeIdError raiseErrorString: aString

    "Created: / 31-10-2007 / 10:18:59 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'initialization & release'!

initialize

    "/super initialize.
    released := false

    "Created: / 24-10-2006 / 11:15:06 / janfrog"
    "Modified: / 15-12-2006 / 00:33:39 / janfrog"
!

primReleaseResources

    ^self subclassResponsibility

    "Created: / 12-12-2006 / 10:48:19 / janfrog"
!

releaseResources

    "
        Release all associated resources such as
        database connections, in-memory tree nodes,
        indexes and so on.
        After sending #releaseResources to myself,
        all subsequent sends of any of #xpath* messages
        will cause XPathDocumentAdaptorReleasedError
        exception.

    "

    
    self primReleaseResources.
    document := nil.
    released := true.

    "Created: / 18-10-2006 / 14:58:59 / janfrog"
    "Modified: / 12-12-2006 / 10:47:49 / janfrog"
!

releaseResourcesIfNotAlready

    self isReleased ifFalse:[self releaseResources]

    "Created: / 12-12-2006 / 10:48:46 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'node importing'!

importForeignNode:foreignNodeId adaptor:foreignXPathDocumentAdaptor 
    |builder|

    builder := self importingBuilder.
    (XQuery::XQueryResultXMLReader new)
        setDocumentAdaptor:foreignXPathDocumentAdaptor;
        setContentHandler:builder;
        visit:foreignNodeId.
    ^ builder document

    "Created: / 05-12-2007 / 14:26:29 / janfrog"
!

importingBuilder

    ^self importingBuilderClass new

    "Created: / 14-11-2007 / 14:29:21 / janfrog"
!

importingBuilderClass

    ^self subclassResponsibility

    "Created: / 14-11-2007 / 14:29:09 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'printing'!

printOn: aStream

    super printOn:aStream.
    aStream nextPutAll:' on '.
    documentURI printOn: aStream

    "Created: / 20-09-2007 / 12:50:11 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'testing'!

isReleased

    ^released

    "Created: / 12-12-2006 / 10:45:18 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'update primitives'!

updDelete: nodeId

    self ensureNotReleased ; ensureIsValidNodeId: nodeId.

    (self xpathIsAttribute: nodeId)
        ifTrue:[self primUpdDeleteAttribute: nodeId]
        ifFalse:[self primUpdDeleteNode: nodeId]

    "Created: / 24-10-2007 / 16:09:53 / janfrog"
    "Modified: / 31-10-2007 / 10:17:25 / janfrog"
!

updInsert:sourceNodeId after:targetNodeId 
    "String"
    
    self
        ensureNotReleased;
        ensureIsValidElementOrAttributeId:sourceNodeId;
        ensureIsValidElementOrDocumentId:targetNodeId.
    self 
        primUpdInsert:sourceNodeId
        into:(self xpathParentOf: targetNodeId)
        after:targetNodeId.

    "Modified: / 21-11-2007 / 13:58:38 / janfrog"
!

updInsert:insertedNodeId asFirstInto:parentNodeId 
    |childNodes|

    self
        ensureNotReleased;
        ensureIsValidNodeId:insertedNodeId;
        ensureIsValidElementOrDocumentId:parentNodeId.
    self 
        primUpdInsert:insertedNodeId
        into: parentNodeId
        before:((childNodes := self xpathChildOf:parentNodeId) isEmpty 
                ifTrue:[ nil ]
                ifFalse:[ childNodes anyOne ])

    "Modified: / 21-11-2007 / 14:20:28 / janfrog"
!

updInsert:insertedNodeId asLastInto:parentNodeId 
    "String"
    
    self
        ensureNotReleased;
        ensureIsValidElementOrAttributeId:insertedNodeId;
        ensureIsValidElementOrDocumentId:parentNodeId.
    self 
        primUpdInsert:insertedNodeId
        into:parentNodeId
        after:(self xpathChildOf:parentNodeId) last

    "Modified: / 21-11-2007 / 13:59:02 / janfrog"
!

updInsert:insertedNodeId before:referenceNodeId 
    "String"
    
    self
        ensureNotReleased;
        ensureIsValidElementOrAttributeId:insertedNodeId;
        ensureIsValidElementOrDocumentId:referenceNodeId.
    self 
        primUpdInsert:insertedNodeId
        into:(self xpathParentOf: referenceNodeId)
        before:referenceNodeId.

    "Created: / 21-11-2007 / 11:31:22 / janfrog"
    "Modified: / 21-11-2007 / 14:19:11 / janfrog"
!

updInsert:insertedNodeId into:parentNodeId 

    ^self updInsert: insertedNodeId asFirstInto: parentNodeId

    "Modified: / 21-11-2007 / 12:15:08 / janfrog"
!

updInsertAttribute:anAttr into:targetNodeId 
    self
        ensureNotReleased;
        ensureIsValidElementId:targetNodeId;
        ensureIsValidAttributeId:anAttr.
    self primUpdInsertAttribute:anAttr into:targetNodeId

    "Modified: / 31-10-2007 / 10:22:31 / janfrog"
!

updRename: nodeId to: newName "String"

    self ensureNotReleased ; ensureIsValidElementOrAttributeId: nodeId.
    self primUpdRename: nodeId to: newName.

    "Modified: / 31-10-2007 / 10:22:31 / janfrog"
!

updReplaceNode:nodeId with:replacementNodeIds 
    |realReplacementNodeIds|

    self
        ensureNotReleased;
        ensureIsValidNodeId:nodeId;
        ensureIsValidNodeIds:replacementNodeIds.
    realReplacementNodeIds := OrderedCollection new:replacementNodeIds size.
    replacementNodeIds do:[:replacementNodeId | 
        (self xpathIsDocumentOrDocumentFragment:replacementNodeId) ifTrue:[
            realReplacementNodeIds addAll:(self xpathChildOf:replacementNodeId)
        ] ifFalse:[
            realReplacementNodeIds add:replacementNodeId
        ]
    ].
    (self xpathIsElement:nodeId) ifTrue:[
        realReplacementNodeIds do:[:node | 
            self 
                primUpdInsert:node
                into: (self xpathParentOf: nodeId)
                after:nodeId
        ].
        self primUpdDeleteNode:nodeId
    ] ifFalse:[
        realReplacementNodeIds do:[:node | 
            self primUpdInsertAttribute:node into:(self xpathParentOf:nodeId)
        ].
        self primUpdDeleteAttribute:nodeId
    ]

    "Created: / 14-11-2007 / 14:17:16 / janfrog"
    "Modified: / 21-11-2007 / 13:59:39 / janfrog"
!

updReplaceValueOf:nodeId with:newValue 
    self
        ensureNotReleased;
        ensureIsValidNodeId:nodeId.

    (self xpathIsElement:nodeId) 
        ifTrue:
            ["delete all child nodes"            
            (self xpathChildOf: nodeId) do:[:node|self updDelete: node].
            "insert new node"
            self updInsert: newValue into: nodeId]
        ifFalse:
            [self primUpdReplaceValueOf:nodeId with:newValue]

    "Modified: / 21-11-2007 / 12:48:36 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'update primitives - primitives'!

primUpdDeleteAttribute: nodeId

    ^self subclassResponsibility

    "Created: / 31-10-2007 / 09:53:38 / janfrog"
!

primUpdDeleteNode: nodeId

    self subclassResponsibility

    "Created: / 31-10-2007 / 09:53:52 / janfrog"
!

primUpdInsert:insertedNodeId into:nodeId after: referenceNodeId
    ^ self subclassResponsibility

    "Created: / 21-11-2007 / 13:55:03 / janfrog"
!

primUpdInsert:insertedNodeId into: nodeId before:referenceNodeId 
    ^ self subclassResponsibility

    "Created: / 21-11-2007 / 13:55:38 / janfrog"
!

primUpdInsertAttribute:anAttr into: targetNodeId 

    ^self subclassResponsibility

    "Created: / 31-10-2007 / 09:53:38 / janfrog"
!

primUpdRename: nodeId to: newName

    self subclassResponsibility

    "Created: / 31-10-2007 / 09:54:39 / janfrog"
!

primUpdReplaceValueOf:nodeId with:newValue 
    self subclassResponsibility

    "Created: / 14-11-2007 / 15:17:24 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath accessing'!

xpathDocument

    "
        Returns a Document node ID
    "

    self ensureNotReleased.
    ^document

    "Created: / 18-10-2006 / 15:25:31 / janfrog"
    "Modified: / 24-10-2006 / 12:01:32 / janfrog"
!

xpathDocumentURI

    "
        Returns a Document URI
    "

    self ensureNotReleased.
    ^documentURI

    "Created: / 20-09-2007 / 12:48:48 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath axes'!

xpathAncestorOf: anObject

    "
        Returns all ancestors including Document node
        in REVERSE DOCUMENT ORDER
    "

    | currentNode ancestors |

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    currentNode := anObject.
    ancestors := OrderedCollection new.
    [ self xpathIsDocument: currentNode ] whileFalse:[
        currentNode := self xpathParentOf: currentNode.
        ancestors addLast: currentNode.
    ].
    ^ancestors

    "Created: / 13-10-2006 / 15:39:19 / janfrog"
    "Modified: / 01-11-2006 / 16:15:06 / janfrog"
!

xpathAncestorOrSelfOf: anObject

    "
        Returns all ancestors including Document node and node
        itself in REVERSE DOCUMENT ORDER
    "

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    ^(self xpathAncestorOf: anObject) 
        addFirst: anObject;
        yourself

    "Created: / 13-10-2006 / 15:39:12 / janfrog"
    "Modified: / 24-10-2006 / 12:02:31 / janfrog"
!

xpathAttributeOf: anObject 

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathAttributeOf: anObject

    "Created: / 13-10-2006 / 15:39:19 / janfrog"
    "Modified: / 14-12-2006 / 23:32:32 / janfrog"
!

xpathChildOf:anObject 

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathChildOf: anObject

    "Created: / 13-10-2006 / 15:39:19 / janfrog"
    "Modified: / 14-12-2006 / 23:32:47 / janfrog"
!

xpathDescendantOf: anObject

    "
        Returns all descendants in DOCUMENT ORDER
    "

    | stream |
    self ensureNotReleased; ensureIsValidNodeId: anObject.
    stream := (OrderedCollection new:5) writeStream.
    self xpathDescendantOf:anObject on:stream.
    ^stream contents

    "Created: / 13-10-2006 / 15:39:12 / janfrog"
    "Modified: / 24-10-2006 / 12:02:42 / janfrog"
!

xpathDescendantOrSelfOf: anObject

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    ^(self xpathDescendantOf: anObject)
        addFirst: anObject;
        yourself

    "Created: / 13-10-2006 / 15:39:12 / janfrog"
    "Modified: / 24-10-2006 / 12:03:48 / janfrog"
!

xpathFollowingOf: anObject

    "
        <a>
            <b>
                <c/>
                <d/>
            </b>
            <e/>
        </a>
        <x/>

        xpathFollowingOf:<c/>  will return <d/>, <e/>, <x/>
    "

    | stream |
    self ensureNotReleased; ensureIsValidNodeId: anObject.
    stream := (OrderedCollection new:5) writeStream.
    self xpathFollowingOf:anObject on:stream.
    ^stream contents

    "Created: / 13-10-2006 / 15:39:12 / janfrog"
    "Modified: / 24-10-2006 / 12:03:53 / janfrog"
!

xpathFollowingSiblingOf:anObject 

    "
        When called on document node, empty collection is returned
    "

    | childNodes |
    self ensureNotReleased; ensureIsValidNodeId: anObject.
    (self xpathIsDocument:anObject) ifTrue:[^#()].


    childNodes := self xpathChildOf: (self xpathParentOf: anObject).
    ^childNodes copyFrom: (childNodes indexOf: anObject) + 1

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
    "Modified: / 08-11-2006 / 11:54:09 / janfrog"
!

xpathParentOf:anObject

    "
        Returns a parent of given object.
        Parent of attribute IS its the element node which the
        attribute belongs to.
        For Document node, nil is returned.
    "

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathParentOf: anObject

    "Created: / 13-10-2006 / 15:39:19 / janfrog"
    "Modified: / 14-12-2006 / 23:33:27 / janfrog"
!

xpathPrecedingOf: anObject

    | stream |
    self ensureNotReleased; ensureIsValidNodeId: anObject.
    stream := (OrderedCollection new:5) writeStream.
    self xpathPrecedingOf:anObject on:stream.
    ^stream contents

    "Created: / 13-10-2006 / 15:39:12 / janfrog"
    "Modified: / 24-10-2006 / 12:04:00 / janfrog"
!

xpathPrecedingSiblingOf:anObject 

    "
        When called on document node, empty collection is returned
    "

    | childNodes |
    self ensureNotReleased; ensureIsValidNodeId: anObject.
    (self xpathIsDocument:anObject) ifTrue:[^#()].

    childNodes := self xpathChildOf: (self xpathParentOf: anObject).
    ^childNodes copyTo: (childNodes indexOf: anObject) - 1

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
    "Modified: / 08-11-2006 / 11:54:14 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath axes - private'!

xpathDescendantOf:anObject on:aStream

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    ((self xpathIsElement:anObject) not 
        and:[ (self xpathIsDocument:anObject) not ]) ifTrue:[ ^ self ].
    self xpathPrivateDescendantOf:anObject on:aStream.

    "Modified: / 24-10-2006 / 12:04:08 / janfrog"
!

xpathFollowingOf:anObject on:aStream 

    "
        <a>
            <b>
                <c/>
                <d/>
            </b>
            <e/>
        </a>
        <x/>

        xpathFollowingOf:<c/>  will return <d/>, <e/>, <x/>
    "

    | currentNode |

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    currentNode := anObject.
    [
        self xpathIsDocument: currentNode
    ] whileFalse:[
        (self xpathFollowingSiblingOf: currentNode) do:
            [:following|
            aStream nextPut: following.
            self xpathDescendantOf:following on: aStream].
        currentNode := self xpathParentOf: currentNode.
    ].

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
!

xpathPrecedingOf:anObject on:aStream 

    | currentNode |

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    currentNode := anObject.
    [
        self xpathIsDocument: currentNode
    ] whileFalse:[
        (self xpathPrecedingSiblingOf: currentNode) do:
            [:following|
            aStream nextPut: following.
            self xpathDescendantOf:following on: aStream].
        currentNode := self xpathParentOf: currentNode.
    ].

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
!

xpathPrivateDescendantOf:anObject on: aStream 


    (self xpathChildOf: anObject) do:[:element | 
        aStream nextPut:element.
        self xpathDescendantOf:element on:aStream
    ]

    "Created: / 24-10-2006 / 12:06:40 / janfrog"
    "Modified: / 03-11-2006 / 12:23:50 / ked"
    "Modified: / 08-11-2006 / 11:11:44 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath helpers'!

xpathContextOf: anObject
    |context|

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    context := (XPathContext new)
                node:anObject;
                position:(self xpathPositionOf:anObject);
                documentAdaptor:self.

    (self xpathParentOf: anObject) isNil 
        ifTrue:[context contextSize:1]
         ifFalse:[context contextSize:
                    (self xpathChildOf: (self xpathParentOf: anObject)) size].

    ^ context.

    "Created: / 13-10-2006 / 17:32:55 / janfrog"
    "Modified: / 24-10-2006 / 12:04:16 / janfrog"
!

xpathNodePositionComparator

    ^XPathNodePositionComparator new documentAdaptor:self

    "Created: / 13-10-2006 / 19:52:23 / janfrog"
!

xpathPositionOf:anObject 
    |parent type|

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    parent := self xpathParentOf:anObject.
    type := (self xpathIsAttribute: anObject)
                ifTrue:[#attribute]
                ifFalse:[#node].

    ^parent 
        ifNil:[1]
        ifNotNil:
            [|siblings|
            siblings :=(self xpathIsAttribute: anObject)
                            ifTrue:[self xpathAttributeOf: parent]
                            ifFalse:[self xpathChildOf: parent].
            siblings identityIndexOf: anObject
            ]

    "Created: / 13-10-2006 / 17:04:37 / janfrog"
    "Modified: / 24-10-2006 / 12:04:21 / janfrog"
!

xpathPositionVectorOf:anObject 
    "The result is a vector of positions of all ancestors of the node. Example: [1,3,2,53].
     This is used to compare node positions of nodes from different document levels."
    
    |pos node|

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    pos := XPathNodePosition new
            elementPosition:(OrderedCollection new);
            attributePosition:(OrderedCollection new).
    node := anObject.
    [ node isNil ] whileFalse:[
        (self xpathIsAttribute:node)
            ifTrue:[pos attributePosition addFirst:(self xpathPositionOf: node)]
            ifFalse:[pos elementPosition addFirst:(self xpathPositionOf: node)].
        node := self xpathParentOf: node.
    ].
    ^ pos.

    "Created: / 13-10-2006 / 18:33:08 / janfrog"
    "Modified: / 24-10-2006 / 12:04:25 / janfrog"
!

xpathRootContext
    |context|

    self ensureNotReleased; ensureIsValidNodeId: document.
    context := XPathContext new.
    context 
        node: document;
        position:1; 
        contextSize:1; 
        documentAdaptor:self.
    ^context.

    "Created: / 13-10-2006 / 17:28:37 / janfrog"
    "Modified: / 24-10-2006 / 12:04:36 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath primitives'!

primXpathAttributeOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:13:04 / janfrog"
!

primXpathAttributeValueOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:17:15 / janfrog"
!

primXpathChildOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:14:30 / janfrog"
!

primXpathElementValueOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:17:20 / janfrog"
!

primXpathIsAttribute: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:15:50 / janfrog"
!

primXpathIsDocument: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:16:09 / janfrog"
!

primXpathIsDocumentFragment: anObject

    ^self subclassResponsibility

    "Created: / 10-08-2007 / 09:16:01 / janfrog"
!

primXpathIsElement: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:15:46 / janfrog"
!

primXpathIsText: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:15:55 / janfrog"
!

primXpathLocalNameOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:16:28 / janfrog"
!

primXpathNameOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:21:00 / janfrog"
!

primXpathNamespaceOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:16:33 / janfrog"
!

primXpathParentOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:14:35 / janfrog"
!

primXpathTextValueOf: anObject

    ^self subclassResponsibility

    "Created: / 14-12-2006 / 23:17:11 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath testing'!

xpathIsAttribute: anObject 
    "raise an error: must be redefined in concrete subclass(es)"

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathIsAttribute: anObject

    "Created: / 13-10-2006 / 17:07:58 / janfrog"
    "Modified: / 14-12-2006 / 23:33:48 / janfrog"
!

xpathIsDocument: anObject
    "raise an error: must be redefined in concrete subclass(es)"

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathIsDocument: anObject

    "Created: / 13-10-2006 / 20:59:25 / janfrog"
    "Modified: / 14-12-2006 / 23:34:11 / janfrog"
!

xpathIsDocumentFragment: anObject
    "raise an error: must be redefined in concrete subclass(es)"

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathIsDocumentFragment: anObject

    "Created: / 10-08-2007 / 09:15:46 / janfrog"
!

xpathIsDocumentOrDocumentFragment: nodeId

    ^(self xpathIsDocument: nodeId) or:[self xpathIsDocumentFragment: nodeId]

    "Created: / 14-11-2007 / 16:14:07 / janfrog"
!

xpathIsElement:anObject 
    "raise an error: must be redefined in concrete subclass(es)"

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathIsElement: anObject

    "Created: / 13-10-2006 / 15:39:19 / janfrog"
    "Modified: / 14-12-2006 / 23:34:26 / janfrog"
!

xpathIsIgnorableText: anObject

    ^(self xpathIsText: anObject) 
        and:[(self xpathValueOf: anObject) allSatisfy:[:c|c isXMLWhiteSpace]]

    "Created: / 01-11-2006 / 16:40:48 / janfrog"
!

xpathIsText: anObject 

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathIsText: anObject

    "Created: / 13-10-2006 / 15:39:19 / janfrog"
    "Modified: / 14-12-2006 / 23:35:11 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath values'!

xpathLocalNameOf:anObject

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathLocalNameOf: anObject

    "Created: / 13-10-2006 / 20:37:24 / janfrog"
    "Modified: / 14-12-2006 / 23:35:43 / janfrog"
!

xpathNameOf: anObject

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathNameOf: anObject

    "Created: / 01-11-2006 / 16:34:38 / janfrog"
    "Modified: / 14-12-2006 / 23:35:57 / janfrog"
!

xpathNamespaceOf: anObject

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathNamespaceOf: anObject

    "Created: / 13-10-2006 / 20:37:24 / janfrog"
    "Modified: / 14-12-2006 / 23:36:17 / janfrog"
!

xpathValueOf: anObject

    self ensureNotReleased; ensureIsValidNodeId: anObject.
    (self xpathIsAttribute:anObject) ifTrue:
        [^self xpathAttributeValueOf: anObject].
    (self xpathIsElement: anObject) ifTrue:
        [^self xpathElementValueOf: anObject].
    (self xpathIsText: anObject) ifTrue:
        [^self xpathTextValueOf: anObject].
    (self xpathIsDocument: anObject) ifTrue:
        [^self xpathDocumentValueOf: anObject].
    ^nil

    "Created: / 13-10-2006 / 15:39:12 / janfrog"
    "Modified: / 24-10-2006 / 12:04:44 / janfrog"
! !

!XPathDocumentAdaptor methodsFor:'xpath values - private'!

xpathAttributeValueOf: anObject 

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathAttributeValueOf: anObject

    "Created: / 13-10-2006 / 21:02:46 / janfrog"
    "Modified: / 14-12-2006 / 23:36:59 / janfrog"
!

xpathDocumentValueOf: anObject

    self halt.

    ^self xpathValueOf:(self xpathParentOf: anObject)

    "Created: / 13-10-2006 / 17:53:00 / janfrog"
    "Modified: / 18-10-2006 / 15:24:19 / janfrog"
!

xpathElementValueOf:anObject

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathElementValueOf: anObject

    "Created: / 13-10-2006 / 20:59:10 / janfrog"
    "Modified: / 14-12-2006 / 23:37:20 / janfrog"
!

xpathTextValueOf:anObject 

    self ensureNotReleased ; ensureIsValidNodeId: anObject.
    ^ self primXpathTextValueOf: anObject

    "Created: / 13-10-2006 / 20:59:10 / janfrog"
    "Modified: / 14-12-2006 / 23:37:40 / janfrog"
! !

!XPathDocumentAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDocumentAdaptor.st,v 1.19 2007-12-05 21:41:45 vranyj1 Exp $'
! !
