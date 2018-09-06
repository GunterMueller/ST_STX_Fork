"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#NodeKind
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!

NodeKind class instanceVariableNames:'instance copyCnt hybridCnt hybridToCopyCnt'

"
 No other class instance variables are inherited by this class.
"
!

!NodeKind class methodsFor:'documentation'!

documentation
"
    This class is suppost to define behaviour of the XQuery item. See
        the subclasses to more details. This class is Singleton.

    [author:]
        Jan Kurs (kursj1@fel.cvut.cz)

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!NodeKind class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    "/ please change as required (and remove this comment)
    "/ instance := nil.
    copyCnt := 0.
    hybridCnt := 0.
     hybridToCopyCnt := 0.

    "Modified: / 08-02-2010 / 16:40:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NodeKind class methodsFor:'instance creation'!

instance
    instance ifNil:[
        instance := self new.
    ].
    ^ instance

    "Created: / 12-06-2009 / 20:28:15 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind class methodsFor:'accessing'!

copyCnt
    ^ copyCnt.
!

hybridCnt
    ^ hybridCnt.
!

incCopyCnt
    copyCnt := copyCnt + 1.
!

incHybridCnt
    hybridCnt := hybridCnt + 1.
!

incHybridToCopyCnt
    hybridToCopyCnt := hybridToCopyCnt + 1.
!

printCnt
    Transcript cr.
    Transcript show: 'hybrid: ', hybridCnt asString, 
                     ' hybrid to copy: ', hybridToCopyCnt asString,
                     ' copy: ', copyCnt asString.
!

resetCnt
    hybridCnt := 0.
    hybridToCopyCnt := 0.
    copyCnt := 0.
    "/self printCnt.

    "Modified: / 06-04-2010 / 12:01:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!NodeKind methodsFor:'item changing - adding'!

addAttribute:attribute forItem:item 
    | attributes |
    self assert: item nodeId class = attribute class.



    attributes := item dmAttributes.
    attributes add: attribute.
    item dmAttributes: attributes.

    "Modified: / 07-10-2009 / 12:29:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

addChild:childNodeId forItem:item
    | children |
    self assert: item nodeId class = childNodeId class.

    children := item dmChildren.
    children add: childNodeId.
    item dmChildren: children.

    "Created: / 26-07-2009 / 15:49:47 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:29:52 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind methodsFor:'item changing - appending'!

appendAtomicValue:atomicValue into:item
    "Superclass XQuery::SequenceItemKind says that I am responsible to implement this method"

    | textValue |

    textValue := self convertToTextNode: atomicValue.
    ^ self appendText: textValue into: item.

    "Modified: / 05-10-2009 / 16:12:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendAttribute: anAttribute into:item
    | attribute |
    attribute := self copy: anAttribute.

    "3.7.3.3 Document Node Constructors
        3. If the content sequence contains an attribute node, a type error is raised [err:XPTY0004]."
    (item dmNodeKind = 'document') ifTrue: [
        XQueryInterpreterError raiseErrorString: 'Document node cannot contain any attributes'.
    ].

    " If two or more attributes have the same node-name, a dynamic error is raised [err:XQDY0025]."
    item xpathAttribute do: [ :attr |
        attr dmNodeName qName = attribute dmNodeName qName ifTrue:
        [
            "TODO: add error number and error message"
            XQueryInterpreterError new raise
        ].
    ].

    self addAttribute: attribute nodeId forItem: item.
    attribute dmParent: item nodeId.

    (attribute dmNodeName qName = 'xml:base') ifTrue: [
        item dmBaseUri: attribute dmTypedValue
    ].

    "Modified: / 07-10-2009 / 11:21:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendDocument:document into:item
    "Superclass XQuery::SequenceItemKind says that I am responsible to implement this method"


    (document xpathChild) do:
    [ :child |
        child appendInto: item.
    ]

    "Created: / 22-09-2009 / 21:29:40 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendElement:element into:item
    | newElement |

    newElement := NodeItem withNode: element dmNodeKind.
    HybridNodeKind instance register:newElement toOldItem:  element.

    self addChild: newElement nodeId forItem: item.
    newElement dmParent: item nodeId.
    newElement dmBaseUri: item dmBaseUri.

    "Modified: / 07-10-2009 / 11:22:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendItem: item into: parentElement
    "TODO - je tento osklivy IF nezbytny???"
    self assert: (item class = NodeItem).
    self assert: (parentElement class = NodeItem).
    self assert: (parentElement itemKind = ConstructedNodeKind instance).


    item isElementNode ifTrue:[
        ^ parentElement appendElement:item.
    ].
    item isTextNode ifTrue:[
        ^ parentElement appendText:item.
    ].
    item isAttributeNode ifTrue:[
        ^ parentElement appendAttribute:item.
    ].

    item isDocumentNode ifTrue:[
        ^ parentElement appendDocument:item.
    ].

    item isAtomicValue ifTrue:[
        ^ parentElement appendAtomicValue:item.
    ].

    "Created: / 28-06-2009 / 16:40:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:27:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendText: aText into:item
    | text lastChild |
    text := NodeItem withNode: aText dmNodeKind.
    HybridNodeKind instance register: text toOldItem: aText.

"/    text := self copy: aText.
"/
"/    "TODO: check the logic"
"/
    lastChild := self getLastChild: item.

    lastChild isNil ifTrue: [
        self addChild: text nodeId forItem: item.
        text dmParent: item nodeId.
    ] ifFalse: [
        (lastChild isSubtypeOf: 'text') ifTrue: [
            | val |
            val := lastChild dmTypedValue stringValue, 
                        ' ', 
                        text dmTypedValue stringValue.
            lastChild dmTypedValue: (AtomicItem withString: val).
            lastChild dmStringValue: val.
        ] ifFalse: [
            self addChild: text nodeId forItem: item.
            text dmParent: item nodeId.
        ].
    ].

    "Modified: / 07-10-2009 / 11:22:37 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind methodsFor:'private'!

convertToTextNode: atomicValue
    ^ NodeItem withText: atomicValue stringValue.

    "Created: / 07-07-2009 / 23:06:30 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 16:12:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

copy: oldSequenceItem
    | sequenceItem |
    "/NodeKind incCopyCnt.

    sequenceItem := NodeItem withNode: oldSequenceItem dmNodeKind.

    sequenceItem dmBaseUri: oldSequenceItem dmBaseUri.
    sequenceItem dmNodeName: oldSequenceItem dmNodeName.
    sequenceItem dmStringValue: oldSequenceItem dmStringValue.
    sequenceItem dmTypeName: oldSequenceItem dmTypeName.
    sequenceItem dmTypedValue: oldSequenceItem dmTypedValue.

    (oldSequenceItem xpathChild) do: [ : child |
        child appendInto: sequenceItem.
    ].

    (oldSequenceItem xpathAttribute) do: [ : attribute |
        attribute appendInto: sequenceItem.
    ].

    ^ sequenceItem.

    "Created: / 06-10-2009 / 18:20:15 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2010 / 12:01:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

getLastChild: item
    | children |
    children := item xpathChild.

    (children size == 0) ifTrue: [
        ^ nil.
    ] ifFalse: [
        ^ children last.
    ].

    "Created: / 07-07-2009 / 23:04:39 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind methodsFor:'testing'!

isAccesedNode
  ^false.

    "Created: / 24-04-2012 / 15:21:41 / Adam Senk <senkadam@gmail.com>"
!

isConstructedNode
  ^false.

    "Created: / 24-04-2012 / 15:22:01 / Adam Senk <senkadam@gmail.com>"
!

isHybridNode
  ^false.

    "Created: / 24-04-2012 / 15:22:08 / Adam Senk <senkadam@gmail.com>"
! !

!NodeKind methodsFor:'transformations'!

transformNodeId:nodeId usingDocumentAdaptor:adaptor
    ^ self transformNodeIds: (OrderedCollection with: nodeId) usingDocumentAdaptor: adaptor.

    "Created: / 04-10-2009 / 12:37:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

transformNodeIds:nodeIds usingDocumentAdaptor: adaptor
    self subclassResponsibility.

    "Created: / 12-06-2009 / 21:27:18 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 28-06-2009 / 18:15:53 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind methodsFor:'xdm accessors'!

dmAttributesForItem: seqItem

    ^ seqItem documentAdaptor dmAttributes: seqItem nodeId.

    "Created: / 15-09-2009 / 19:33:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUriForItem: seqItem

    ^ seqItem documentAdaptor dmBaseUri: seqItem nodeId.

    "Created: / 25-07-2009 / 17:14:02 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 26-07-2009 / 21:01:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildrenForItem: seqItem

    ^ seqItem documentAdaptor dmChildren: seqItem nodeId.

    "Created: / 02-10-2009 / 20:10:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKindForItem: seqItem

    ^ seqItem documentAdaptor dmNodeKind: seqItem nodeId.

    "Created: / 15-09-2009 / 20:31:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeNameForItem: seqItem

    ^ seqItem documentAdaptor dmNodeName: seqItem nodeId.

    "Created: / 02-10-2009 / 20:00:11 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParentForItem: seqItem

    ^ seqItem documentAdaptor dmParent: seqItem nodeId.

    "Created: / 04-10-2009 / 11:56:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValueForItem: seqItem

    ^ seqItem documentAdaptor dmStringValue: seqItem nodeId.

    "Created: / 29-09-2009 / 13:17:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeNameForItem: seqItem

    ^ seqItem documentAdaptor dmTypeName: seqItem nodeId.

    "Created: / 29-09-2009 / 16:25:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValueForItem: seqItem

    ^ seqItem documentAdaptor dmTypedValue: seqItem nodeId.

    "Created: / 29-09-2009 / 16:09:46 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind methodsFor:'xdm setters'!

dmAttributes:attributes forItem:seqItem 
    seqItem documentAdaptor dmAttributes: attributes for: seqItem nodeId.

    "Created: / 07-10-2009 / 12:25:17 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri:aBaseUri forItem:seqItem 
    seqItem documentAdaptor dmBaseUri: aBaseUri for: seqItem nodeId.

    "Created: / 26-07-2009 / 16:35:09 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:07:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren:children forItem:seqItem 
    seqItem documentAdaptor dmChildren: children for: seqItem nodeId.

    "Created: / 07-10-2009 / 12:25:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind:nodeKind forItem:seqItem 
    seqItem documentAdaptor dmNodeKind:nodeKind for: seqItem nodeId.

    "Created: / 03-10-2009 / 13:21:55 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:07:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: nodeName forItem:seqItem 
    seqItem documentAdaptor dmNodeName: nodeName for: seqItem nodeId.

    "Created: / 03-10-2009 / 14:23:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:07:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: parent forItem:seqItem 
    seqItem documentAdaptor dmParent: parent for: seqItem nodeId.

    "Created: / 03-10-2009 / 17:43:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:07:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue:typedValue forItem:seqItem 
    seqItem documentAdaptor dmStringValue:typedValue for:seqItem nodeId.

    "Created: / 03-10-2009 / 13:52:03 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName:typeName forItem:seqItem 
    seqItem documentAdaptor dmTypeName:typeName for:seqItem nodeId.

    "Created: / 03-10-2009 / 13:45:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue:typedValue forItem:seqItem 
    seqItem documentAdaptor dmTypedValue:typedValue for:seqItem nodeId.

    "Created: / 03-10-2009 / 13:45:47 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind methodsFor:'xpath axes'!

xpathAncestorForItem: item
    | currentNode ancestors |

    currentNode := item.
    ancestors := OrderedCollection new.

    [ currentNode xpathParent notEmpty ] whileTrue:[
        currentNode := currentNode xpathParent first.
        ancestors addLast: currentNode.
    ].


"/    [ currentNode xpathIsDocument ] whileFalse:[
"/        currentNode := currentNode xpathParent first.
"/        ancestors addLast: currentNode.
"/    ].

    ^ XQuerySequence 
        withAll: ancestors.

    "Created: / 29-06-2009 / 00:07:42 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 22-09-2009 / 20:50:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathAncestorOrSelfForItem: item
    ^ (self xpathAncestorForItem: item) 
            addFirst: item; 
            yourself.

    "Created: / 29-06-2009 / 00:28:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathAttributeForItem:item
    ^ self 
        transformNodeIds:(self dmAttributesForItem:item) 
        usingDocumentAdaptor: (item documentAdaptor).

    "Created: / 03-10-2009 / 21:20:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 11:59:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathChildForItem:item
    ^ self 
        transformNodeIds:(self dmChildrenForItem:item) 
        usingDocumentAdaptor: (item documentAdaptor).

    "Created: / 28-06-2009 / 12:50:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 11:59:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDescendantsForItem:item
    | collection |
    collection := (OrderedCollection new:5).
    self xpathDescendantsForItem: item toCollection: collection.

    ^ XQuerySequence withAll: collection.

    "Created: / 28-06-2009 / 23:32:45 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 11:57:52 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDescendantsForItem:item toCollection: collection
     (item xpathChild) do:[:item | 
        collection add:item.
        self xpathDescendantsForItem: item toCollection:collection
     ].

    "Created: / 28-06-2009 / 23:32:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDescendantsOrSelfForItem:item
    ^ (self xpathDescendantsForItem: item) 
        addFirst: item; 
        yourself.

    "Created: / 28-06-2009 / 23:38:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 11:57:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDocumentForItem:item
    ^ self 
        transformNodeIds:(self dmChildrenForItem:item) 
        usingDocumentAdaptor: (item documentAdaptor).

    "Created: / 06-10-2009 / 11:37:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathParentForItem:item
    | parent |

    parent := (self dmParentForItem: item).
    parent ifNotNil: [
        ^ self 
            transformNodeId: parent
            usingDocumentAdaptor: (item documentAdaptor).
    ] ifNil: [
        ^ XQuerySequence new.
    ].

    "Created: / 22-09-2009 / 20:27:53 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:36:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathPrecedingSiblingForItem: seqItem
    | siblings |

    siblings := self xpathChildForItem: (self xpathParentForItem: seqItem) first.
    ^ siblings copyTo: (siblings indexOf: seqItem) - 1

    "Modified: / 04-10-2009 / 18:03:33 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!NodeKind class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !

NodeKind initialize!
