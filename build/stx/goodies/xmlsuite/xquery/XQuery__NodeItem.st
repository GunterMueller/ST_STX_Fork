"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#NodeItem
	instanceVariableNames:'itemKind documentAdaptor nodeId'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!

!NodeItem class methodsFor:'documentation'!

documentation
"
    Sequence item is the only element, that could be in the
        XQuerySequence

    [author:]

    [instance variables:
        itemKind - kind of item (could be accessed type or constructed type) - realy neccessary???
        documentAdaptor - specifies the document adaptor for the nodeId
        nodeId - pointer to the data object stored in storage model.
    ]

    [class variables:]

    [see also:]

"
! !

!NodeItem class methodsFor:'instance creation'!

withNode: nodeKind
    ^ self createConstructedItem: nodeKind

    "Modified: / 05-12-2007 / 15:59:13 / janfrog"
    "Created: / 03-10-2009 / 13:11:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withNode: aNodeId documentAdaptor: aDocumentAdaptor
    ^ (NodeItem new)
        nodeId: aNodeId;
        documentAdaptor: aDocumentAdaptor;
        itemKind: aDocumentAdaptor itemKind.

    "Created: / 22-06-2009 / 19:22:17 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:16:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

withText: string
    ^ (self createConstructedItem: 'text')
        dmTypedValue: (AtomicItem withString: string);
        dmStringValue: string.

    "Created: / 28-03-2007 / 22:50:10 / janfrog"
    "Modified: / 05-12-2007 / 15:59:13 / janfrog"
    "Modified: / 05-10-2009 / 16:15:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem class methodsFor:'private'!

createConstructedItem: itemKind
    ^ NodeItem new
        nodeId: XQueryConstructedItem new;
        documentAdaptor: ConstructedNodeXDMAdaptor instance;
        itemKind: ConstructedNodeKind instance;
        dmNodeKind: itemKind;
        yourself.

    "Created: / 03-10-2009 / 13:11:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 11:13:57 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-01-2010 / 11:34:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NodeItem methodsFor:'accessing'!

documentAdaptor
    ^ documentAdaptor

    "Created: / 12-06-2009 / 23:32:10 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 21-06-2009 / 16:39:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

documentAdaptor:something
    documentAdaptor := something.

    "Modified: / 21-06-2009 / 16:39:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

itemKind
    "if the itemKind is not specified, return the default itemKind (=AccessedKind)

    is it necessary to have Accessed and Constructed kinds - IMHO NOT"

    itemKind isNil ifTrue: [
        self itemKind: AccessedNodeKind instance.
    ].

    ^ itemKind.

    "Modified: / 07-10-2009 / 10:26:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

itemKind:something
    itemKind := something.
!

nodeId
    "nodeId is pointer to the data object in storage model"

    ^ nodeId.

    "Created: / 14-11-2007 / 13:51:02 / janfrog"
    "Modified: / 22-06-2009 / 17:31:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

nodeId:something
    nodeId := something.

    "Modified: / 12-06-2009 / 23:40:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

type
    ^ self dmTypeName

    "Created: / 05-10-2009 / 17:24:50 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 18:36:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

typeName
    ^ self dmTypeName

    "Modified: / 05-10-2009 / 18:36:01 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Created: / 20-04-2010 / 21:03:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NodeItem methodsFor:'accessing - xpath axes'!

xpathAncestor
    ^ self itemKind xpathAncestorForItem: self.

    "Created: / 07-10-2006 / 22:05:08 / ked"
    "Modified: / 03-11-2006 / 12:00:09 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 29-09-2009 / 12:29:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathAncestorOrSelf
    ^ self itemKind xpathAncestorOrSelfForItem: self.

    "Created: / 07-10-2006 / 22:05:24 / ked"
    "Modified: / 03-11-2006 / 12:00:19 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 29-06-2009 / 00:28:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathAttribute
    ^ self itemKind xpathAttributeForItem: self.

    "Created: / 07-10-2006 / 22:05:38 / ked"
    "Modified: / 03-11-2006 / 12:00:32 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 03-10-2009 / 21:18:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathChild
    ^ self itemKind xpathChildForItem: self.

    "Created: / 07-10-2006 / 22:06:01 / ked"
    "Modified: / 03-11-2006 / 12:00:52 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 03-10-2009 / 18:04:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDescendant
    ^ self itemKind xpathDescendantsForItem: self.

    "Created: / 07-10-2006 / 22:06:12 / ked"
    "Modified: / 03-11-2006 / 12:01:10 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 28-06-2009 / 23:50:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDescendantOrSelf
    ^ self itemKind xpathDescendantsOrSelfForItem: self

    "Created: / 07-10-2006 / 22:06:25 / ked"
    "Modified: / 03-11-2006 / 12:01:26 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 28-06-2009 / 23:55:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDocument
    ^ self itemKind xpathDocumentForItem: self.

    "Created: / 19-10-2006 / 16:03:39 / ked"
    "Modified: / 03-11-2006 / 12:17:12 / ked"
    "Modified: / 21-11-2007 / 14:03:28 / janfrog"
    "Modified: / 29-09-2009 / 12:31:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathFollowing
    ^ self itemKind xpathFollowingForItem: self.    
"/^ self 
"/        transformNodeIds:(self documentAdaptor xpathFollowingOf:self nodeId).

    "Created: / 07-10-2006 / 22:06:34 / ked"
    "Modified: / 03-11-2006 / 12:03:07 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 04-10-2009 / 12:24:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathFollowingSibling
    ^ self itemKind xpathFollowingSiblingForItem: self.

    "Created: / 07-10-2006 / 22:06:54 / ked"
    "Modified: / 03-11-2006 / 12:03:18 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 04-10-2009 / 12:25:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathParent
    ^self itemKind xpathParentForItem: self.

    "Created: / 07-10-2006 / 22:07:06 / ked"
    "Modified: / 03-11-2006 / 12:03:57 / ked"
    "Modified: / 05-12-2007 / 21:52:11 / janfrog"
    "Modified: / 04-10-2009 / 12:24:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathPreceding
    ^ self itemKind xpathPrecedingForItem: self.

    "Created: / 07-10-2006 / 22:07:17 / ked"
    "Modified: / 03-11-2006 / 12:04:29 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 04-10-2009 / 12:26:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathPrecedingSibling
    ^ self itemKind xpathPrecedingSiblingForItem: self.

    "Created: / 07-10-2006 / 22:07:30 / ked"
    "Modified: / 03-11-2006 / 12:10:03 / ked"
    "Modified: / 18-11-2007 / 08:02:18 / janfrog"
    "Modified: / 04-10-2009 / 12:26:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathSelf
    ^ self

    "Created: / 07-10-2006 / 22:07:39 / ked"
    "Modified: / 03-11-2006 / 12:10:22 / ked"
    "Modified: / 21-11-2007 / 14:03:28 / janfrog"
    "Modified: / 04-10-2009 / 12:27:02 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'accessing - xpath tests'!

xpathIsAtomicValue
    ^ self isAtomicValue.

    "Modified: / 03-11-2006 / 12:11:09 / ked"
    "Modified: / 18-11-2007 / 08:13:11 / janfrog"
    "Created: / 09-05-2009 / 18:51:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:27:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsAttribute
    ^ self isAttributeNode.

    "Created: / 19-10-2006 / 16:03:38 / ked"
    "Modified: / 03-11-2006 / 12:11:09 / ked"
    "Modified: / 18-11-2007 / 08:13:11 / janfrog"
    "Modified: / 03-10-2009 / 21:33:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsComment
    ^ self isCommentNode

    "Created: / 22-09-2009 / 21:41:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:33:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsDocument
    ^ self isDocumentNode

    "Created: / 19-10-2006 / 16:03:39 / ked"
    "Modified: / 03-11-2006 / 12:11:27 / ked"
    "Modified: / 05-12-2007 / 21:43:46 / janfrog"
    "Modified: / 29-09-2009 / 12:45:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsElement
    ^ self isElementNode.

    "Created: / 19-10-2006 / 16:03:39 / ked"
    "Modified: / 03-11-2006 / 12:11:39 / ked"
    "Modified: / 18-11-2007 / 08:13:59 / janfrog"
    "Modified: / 29-09-2009 / 13:13:09 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsIgnorableText
    self halt: 'needs revision'.
    ^ self documentAdaptor xpathIsIgnorableText:self nodeId.

    "Created: / 03-12-2006 / 12:18:49 / ked"
    "Modified: / 19-11-2007 / 12:47:16 / janfrog"
    "Modified: / 03-10-2009 / 21:33:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsNode
    ^ self isNode

    "Modified: / 03-11-2006 / 12:11:50 / ked"
    "Modified: / 18-11-2007 / 08:09:17 / janfrog"
    "Created: / 09-05-2009 / 23:00:17 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:32:33 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathIsText
    ^ self isTextNode.

    "Created: / 19-10-2006 / 16:03:39 / ked"
    "Modified: / 03-11-2006 / 12:11:50 / ked"
    "Modified: / 18-11-2007 / 08:09:17 / janfrog"
    "Modified: / 29-09-2009 / 13:13:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'accessing - xpath values'!

xpathLocalName
    ^ self dmNodeName localName.

    "Modified: / 03-11-2006 / 12:12:04 / ked"
    "Created: / 24-12-2006 / 17:52:13 / janfrog"
    "Modified: / 18-11-2007 / 08:08:52 / janfrog"
    "Modified: / 06-10-2009 / 12:36:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathName
    ^ self dmNodeName qName.

    "Created: / 02-11-2006 / 11:47:47 / ked"
    "Modified: / 03-11-2006 / 12:12:04 / ked"
    "Modified: / 18-11-2007 / 09:40:55 / janfrog"
    "Modified: / 03-10-2009 / 14:34:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathNamespace
    ^ self dmNodeName namespaceURI.

    "Modified: / 03-11-2006 / 12:12:04 / ked"
    "Created: / 24-12-2006 / 17:52:24 / janfrog"
    "Modified: / 18-11-2007 / 08:08:34 / janfrog"
    "Modified: / 03-10-2009 / 14:33:34 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'comparing'!

= anotherNode
   ^anotherNode class = self class 
        and:[anotherNode nodeId = self nodeId]

    "Created: / 05-10-2009 / 14:00:12 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'converting'!

asDocumentFragment

    | domBuilder |
    domBuilder := XMLv2::DOM3Builder new.
    XQueryResultXMLReader new
            setContentHandler: domBuilder;
            visit: self.
    ^domBuilder document

    "Modified: / 07-06-2009 / 21:26:33 / Jan Kurs <kursj1@fel.cvut.cz>"
!

asString 

    | result childrenCollection attributesCollection |

    self xpathIsText ifTrue:[
        ^self dmTypedValue value.
    ].

    self xpathIsAtomicValue ifTrue:[
        ^self xpathValue asString.
    ].

    self xpathIsAttribute ifTrue:[
        ^self xpathName, '="', self dmTypedValue stringValue, '"'.
    ].

    self xpathIsComment ifTrue:[
        ^ '<!!--', self xpathValue, '-->'.
    ].


    self assert: self xpathIsElement | self xpathIsDocument.

    childrenCollection := self xpathChild.
    attributesCollection := self xpathAttribute.

    result := ''.

    self xpathIsElement ifTrue:[
        result := result, '<', self xpathName.

        attributesCollection do:[:attribute |
            result := result, ' ', attribute asString.
        ].

        childrenCollection size > 0 ifTrue:[
            result := result, '>'.
        ] ifFalse:[
            result := result, '/>'.
        ].
    ].

    childrenCollection do:[:child |
        result := result, child asString.
    ].

    self xpathIsElement & (childrenCollection size > 0) ifTrue:[
        result := result, '</', self xpathName,'>'.
    ].

    ^result.

    "Created: / 01-12-2006 / 12:36:32 / ked"
    "Modified: / 06-10-2009 / 12:53:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

atomizedValue
    ^ self dmTypedValue.

    "Created: / 04-10-2009 / 19:03:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 15:57:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

stringValue

    ^ self dmStringValue.

    "Created: / 05-10-2009 / 17:34:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

value
    | children |
    self halt: 'deprecated'.

    (self type isSubtypeOf: (TypeFactory getType: 'node')) ifTrue:[
        self xpathIsText ifTrue:[
"/            "TODO - pokus o typovou 'heuristiku' na beztypovych datech"
"/            ^Object errorSignal
"/                handle:[:ex | ex returnWith:(self xpathValue)]
"/                do:[self xpathValue asNumber].
              ^ self stringValue.
        ].
        self xpathIsAttribute ifTrue:[
            ^self xpathValue 
        ] ifFalse:[
            self assert: self xpathIsElement.

            children := self xpathChild.

            children size = 0 ifTrue:[
                ^nil.
            ].

            self assert: children size = 1.
            "TODO: xpath muze byt i atomicValue - ale chtelo by to poresit,
                kdy je to text a kdy atomic value"
            "/self assert: children first xpathIsText.

            "TODO - pokus o typovou 'heuristiku' na beztypovych datech"
            ^Object errorSignal
                handle:[:ex | ex returnWith:(children first xpathValue)]
                do:[children first xpathValue asNumber].
        ]
    ] ifFalse:[
        ^self xpathValue
    ].

    "Created: / 03-05-2009 / 11:47:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 11:19:44 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'debugging support'!

inspector2TabXDMProperties

    | columns |
    columns := Array 
                    with:(DataSetColumnSpec label:'Property' editorType:#None  selector:#first)
                    with:(DataSetColumnSpec label:'Value'    editorType:#None  selector:#second).


    ^self newInspector2Tab
        label:'XDM Properties';
        priority: 75;
        view: (DataSetView new
                    columnDescriptors: columns;
                    listHolder: [self dmProperties];
                    autoHideScrollBars:false)
! !

!NodeItem methodsFor:'initialization & release'!

releaseResources

    self documentAdaptor releaseResourcesIfNotAlready

    "Created: / 12-12-2006 / 10:50:09 / janfrog"
    "Modified: / 21-06-2009 / 16:33:15 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'item changing - appending'!

appendAtomicValue:atomicValue
    self itemKind appendAtomicValue: atomicValue into: self.

    "Created: / 09-05-2009 / 17:28:54 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-07-2009 / 18:16:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendAttribute: attribute
    self itemKind appendAttribute: attribute into: self.

    "Created: / 29-03-2007 / 13:28:46 / janfrog"
    "Modified: / 28-06-2009 / 18:08:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendDocument: element
    self itemKind appendDocument: element into: self.

"/    self nodeChildren add: constructedElement.
"/    constructedElement nodeParent: self.

    "Created: / 22-09-2009 / 21:29:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendElement: element
    self itemKind appendElement: element into: self.

"/    self nodeChildren add: constructedElement.
"/    constructedElement nodeParent: self.

    "Created: / 29-03-2007 / 13:28:06 / janfrog"
    "Modified: / 28-06-2009 / 17:34:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendInto:parentElement 
    self itemKind appendItem: self into: parentElement.

    "Created: / 29-03-2007 / 13:57:20 / janfrog"
    "Modified: / 27-06-2009 / 17:57:03 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendText: text
    self itemKind appendText: text into: self.

"/    self nodeChildren add: constructedText.
"/    constructedText nodeParent: self.

    "Created: / 29-03-2007 / 13:29:07 / janfrog"
    "Modified: / 28-06-2009 / 18:05:06 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'printing'!

printOn:aStream 
    aStream nextPut:$(.
    self dmNodeName ifNil: ['nil' printOn: aStream] ifNotNil: [self dmNodeName qName printOn:aStream. ].
    aStream nextPut:$ .
    self nodeId printOn:aStream.
    aStream nextPut:$).
    aStream nextPut:$[.
    self dmNodeKind printOn:aStream.
    aStream nextPut:$].
    aStream nextPut:$ .
    aStream nextPut:$-.
    aStream nextPut:$ .
    super printOn:aStream.

    "Created: / 14-02-2007 / 00:03:56 / janfrog"
    "Modified: / 07-10-2009 / 11:36:36 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'queries'!

containsCellStoreNode
    "TODO: delete this function - it was created to overcome
        difficulties connected with removal of XQuerySequenceItem class"
    ^ self isCellStoreNode.

    "Created: / 03-05-2009 / 16:10:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

containsNode

    self halt: 'deprecated'.
    "TODO: delete this function - it was created to overcome
        difficulties connected with removal of XQuerySequenceItem class"
    ^ true.

    "Created: / 03-05-2009 / 15:27:44 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:28:46 / Jan Kurs <kursj1@fel.cvut.cz>"
!

hasParent
    ^self xpathParent notEmpty

    "Created: / 21-11-2007 / 09:28:15 / janfrog"
    "Modified: / 06-10-2009 / 14:12:31 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'testing'!

isAtomicValue
    ^ false

    "Created: / 09-05-2009 / 17:27:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 14:20:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isAttributeNode
    ^ self dmNodeKind = 'attribute'.

    "Created: / 29-03-2007 / 13:55:15 / janfrog"
    "Modified: / 03-10-2009 / 21:29:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isCellStoreNode

    ^false

    "Created: / 14-11-2007 / 13:59:33 / janfrog"
!

isCommentNode

    ^ self dmNodeKind = 'comment'.

    "Created: / 19-07-2009 / 18:07:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:29:39 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isDocumentFragmentNode

    ^self documentAdaptor xpathIsDocumentFragment: self nodeId

    "Modified: / 14-11-2007 / 14:04:01 / janfrog"
    "Created: / 07-06-2009 / 21:13:18 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isDocumentNode
    ^ self dmNodeKind = 'document'.

    "Created: / 14-11-2007 / 11:51:39 / janfrog"
    "Modified: / 14-11-2007 / 14:04:01 / janfrog"
    "Modified: / 03-10-2009 / 21:30:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isElementNode
    ^ self dmNodeKind = 'element'.

    "Created: / 29-03-2007 / 13:55:15 / janfrog"
    "Modified: / 03-10-2009 / 21:29:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isElementOrAttributeNode
    ^self isElementNode 
        or:[self isAttributeNode]

    "Created: / 29-03-2007 / 16:01:39 / janfrog"
    "Modified: / 03-10-2009 / 21:30:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isNode
    ^ true

    "Created: / 09-05-2009 / 23:00:32 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 14:20:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isSequenceItem
    ^ true

    "Created: / 05-10-2009 / 14:11:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isSubtypeOf: anotherType
    ^ TypeFactory isType: (self dmNodeKind) subtypeOf: anotherType.

    "Created: / 04-10-2009 / 17:21:33 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isTextNode
    ^ self dmNodeKind = 'text'.

    "Created: / 29-03-2007 / 13:55:15 / janfrog"
    "Modified: / 03-10-2009 / 21:31:26 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isType: anotherTypeName
    ^ self typeName = anotherTypeName.

    "Created: / 05-10-2009 / 17:24:50 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isTypedValueSubtypeOf: anotherType
    ^ TypeFactory isType: (self dmTypeName) subtypeOf: anotherType.

    "Created: / 04-10-2009 / 17:22:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isXQueryAccessedNode
    self halt: 'deprecated'.
    ^ false

    "Modified: / 29-10-2006 / 15:30:47 / ked"
    "Modified: / 03-10-2009 / 21:31:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

isXQueryConstructedNode
    self halt: 'deprecated'.
    ^ false

    "Created: / 29-10-2006 / 15:30:47 / ked"
    "Modified: / 03-10-2009 / 21:31:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'xdm accessors'!

dmAttributes
    ^ self itemKind dmAttributesForItem: self.

    "Created: / 19-04-2009 / 14:21:33 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 15-09-2009 / 19:32:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri
    ^ self itemKind dmBaseUriForItem: self.

    "Created: / 19-04-2009 / 14:31:53 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 25-07-2009 / 17:12:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren
    ^ self itemKind dmChildrenForItem: self.

    "Created: / 02-10-2009 / 20:09:49 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmIsId: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:52:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmIsIdrefs
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:32:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNamespaceNodes
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:32:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNamspaceBindings
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:32:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNilled
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:32:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind
    "returns a string identifying the kind of node. It will be one of the following, 
        depending on the kind of node: 'attribute', 'comment', 'document', 'element', 
      'namespace', 'processing-instruction', or 'text'."

    ^ self itemKind dmNodeKindForItem: self.

    "Created: / 19-04-2009 / 14:32:46 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 15-09-2009 / 20:31:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName
    ^ self itemKind dmNodeNameForItem: self.

    "Created: / 19-04-2009 / 14:32:51 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 02-10-2009 / 19:59:52 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:32:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmProperties

    ^#(
        ('dm-attributes'            dmAttributes)
        ('dm-base-uri'              dmBaseUri)
        ('dm-children'              dmChildren)
        ('dm-is-idrefs'             dmIsIdrefs)
        ('dm-namespace-nodes'       dmNamespaceNodes)
        ('dm-namespace-bindings'    dmNamespaceBindings)
        ('dm-nilled'                dmNilled)
        ('dm-node-kind'             dmNodeKind)
        ('dm-node-name'             dmNodeName)
        ('dm-parent'                dmParent)
        ('dm-string-value'          dmStringValue)
        ('dm-type-name'             dmTypeName)
        ('dm-typed-value'           dmTypedValue)
        ('dm-unparsed-entity-public-id'   dmUnparsedEntityPublicId)
        ('dm-unparsed-entity-system-id'   dmUnparsedEntitySystemId)
    ) collect:
        [:pair|
        | value |
        value := 
            [(self perform: pair second) printString]
                on: Error do: [:ex|('ERROR: ' asText colorizeAllWith:Color red) , ex description].
        Array with: pair first with: value].
!

dmStringValue
    ^ self itemKind dmStringValueForItem: self.

    "Created: / 29-09-2009 / 13:17:00 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName
    ^ self itemKind dmTypeNameForItem: self.

    "Created: / 29-09-2009 / 16:25:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue
    ^ self itemKind dmTypedValueForItem: self.

    "Created: / 19-04-2009 / 14:33:17 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 29-09-2009 / 16:09:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmUnparsedEntityPublicId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:33:27 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmUnparsedEntitySystemId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 14:33:38 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem methodsFor:'xdm setters'!

dmAttributes: attributes
    self itemKind dmAttributes: attributes forItem: self.

    "Created: / 07-10-2009 / 12:24:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri: aBaseUri
    self itemKind dmBaseUri: aBaseUri forItem: self.

    "Created: / 26-07-2009 / 16:34:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren: children
    self itemKind dmChildren: children forItem: self.

    "Created: / 07-10-2009 / 12:24:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind: nodeKind
    self itemKind dmNodeKind: nodeKind forItem: self.

    "Created: / 03-10-2009 / 13:21:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: nodeName
    self itemKind dmNodeName: nodeName forItem: self.

    "Created: / 03-10-2009 / 14:22:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: nodeParent
    self itemKind dmParent: nodeParent forItem: self.

    "Created: / 03-10-2009 / 17:47:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue: stringValue
    self itemKind dmStringValue: stringValue forItem: self.

    "Created: / 03-10-2009 / 13:51:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName: typeName
    self itemKind dmTypeName: typeName forItem: self.

    "Created: / 03-10-2009 / 13:44:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue: typedValue
    self itemKind dmTypedValue: typedValue forItem: self.

    "Created: / 03-10-2009 / 13:44:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeItem class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
