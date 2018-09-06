"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

NodeKind subclass:#HybridNodeKind
	instanceVariableNames:'hybrids'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!


!HybridNodeKind methodsFor:'accessing'!

hybrids
    hybrids isNil ifTrue: [
        hybrids := Dictionary new.
    ].
    ^ hybrids.

    "Created: / 03-10-2009 / 17:20:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 23:14:54 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind methodsFor:'hybrid transformations'!

clearHybrids
    self hybrids removeAll.

    "Created: / 04-10-2009 / 14:04:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

copy: oldSequenceItem to: sequenceItem

    "/NodeKind incHybridToCopyCnt.

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

    "Created: / 03-10-2009 / 23:48:30 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:16:53 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2010 / 12:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isHybrid: nodeId
    ^ (self hybrids at: nodeId ifAbsent: [ nil ]) notNil.

    "Created: / 03-10-2009 / 22:55:15 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 14:07:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

register: sequenceItem toOldItem: oldSequenceItem
"/    NodeKind incHybridCnt.
"/    sequenceItem itemKind: self.
"/    self hybrids at: sequenceItem nodeId put: oldSequenceItem.

    "FOR TESTING ONLY"
    "/NodeKind incCopyCnt.
    sequenceItem itemKind: self.
    self hybrids at: sequenceItem nodeId put: oldSequenceItem.
    self toConstructed: sequenceItem.

    "Created: / 03-10-2009 / 23:25:25 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-04-2010 / 12:01:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

sequenceItemForHybrid: hybridId
    ^ self hybrids at: hybridId ifAbsent: [ self error: 'no adaptor for hybrid' ].

    "Created: / 03-10-2009 / 23:38:31 / Jan Kurs <kursj1@fel.cvut.cz>"
!

toConstructed: seqItem
    | oldSequenceItem |

    oldSequenceItem := (self sequenceItemForHybrid: seqItem nodeId).
    self unregister: seqItem.
    self copy:  oldSequenceItem to: seqItem.

    ^ seqItem.

    "Created: / 06-10-2009 / 17:23:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

unregister: sequenceItem
    sequenceItem itemKind: ConstructedNodeKind instance.
    self hybrids removeKey: sequenceItem nodeId.

    "Created: / 03-10-2009 / 17:23:31 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:29:10 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind methodsFor:'item changing - appending'!

appendAtomicValue:atomicValue into:item
    ^ self shouldNeverBeSent.

    "Modified: / 06-10-2009 / 18:13:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendAttribute:attribute into:item
    ^ self shouldNeverBeSent.

    "Modified: / 06-10-2009 / 18:13:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendDocument:document into:item
    ^ self shouldNeverBeSent.

    "Created: / 22-09-2009 / 21:29:40 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 18:14:03 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendElement:element into:item
    ^ self shouldNeverBeSent.

    "Modified: / 06-10-2009 / 18:14:08 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendItem: item into: parentElement
    self toConstructed: item.
    ^ super appendItem: item into: parentElement.

    "Created: / 28-06-2009 / 16:40:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 18:14:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

appendText:text into:item
    ^ self shouldNeverBeSent.

    "Modified: / 06-10-2009 / 18:14:25 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind methodsFor:'private'!

constructedKind
    ^ ConstructedNodeKind instance.

    "Created: / 04-10-2009 / 13:27:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:28:20 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind methodsFor:'testing'!

isHybridNode
   ^true.

    "Created: / 24-04-2012 / 15:27:38 / Adam Senk <senkadam@gmail.com>"
! !

!HybridNodeKind methodsFor:'transformations'!

transformNodeIds:nodeIds usingDocumentAdaptor:adaptor
    "Superclass XQuery::SequenceItemKind says that I am responsible to implement this method"
"/    self halt: 'this should not happen'.

    ^ XQuerySequence withAll: (nodeIds 
        collect:[:nodeId |
            | kind |
            (self isHybrid: nodeId) ifTrue: [ 
                kind := self. 
            ] ifFalse: [
                kind := self constructedKind.
            ].
            NodeItem new
                nodeId: nodeId;
                documentAdaptor: adaptor;
                itemKind: kind.
       ]
    ).

    "Modified: / 05-10-2009 / 17:05:59 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind methodsFor:'xdm accessors'!

dmAttributesForItem: seqItem
    self toConstructed: seqItem.
    ^ seqItem dmAttributes.

    "Created: / 06-10-2009 / 18:02:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUriForItem: seqItem
    ^ (self sequenceItemForHybrid: seqItem nodeId) dmBaseUri.

    "Created: / 03-10-2009 / 23:45:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildrenForItem: seqItem
    self toConstructed: seqItem.
    ^ seqItem dmChildren.

    "Created: / 03-10-2009 / 23:46:05 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:23:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeNameForItem: seqItem
    ^ (self sequenceItemForHybrid: seqItem nodeId) dmNodeName.

    "Created: / 02-10-2009 / 20:00:11 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 23:43:35 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValueForItem: seqItem
    ^ (self sequenceItemForHybrid: seqItem nodeId) dmStringValue.

    "Created: / 03-10-2009 / 23:45:52 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeNameForItem: seqItem
    ^ (self sequenceItemForHybrid: seqItem nodeId) dmTypeName.

    "Created: / 03-10-2009 / 23:45:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValueForItem: seqItem
    ^ (self sequenceItemForHybrid: seqItem nodeId) dmTypedValue.

    "Created: / 03-10-2009 / 23:45:42 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind methodsFor:'xdm setters'!

dmBaseUri:aBaseUri forItem:seqItem
    (aBaseUri ~= seqItem dmBaseUri) ifTrue:
    [
        self toConstructed: seqItem.
    ].
"/    self toConstructed: seqItem.



    super dmBaseUri: aBaseUri forItem: seqItem

    "Created: / 26-07-2009 / 16:35:09 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:25:11 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind:nodeKind forItem:seqItem 
    self toConstructed: seqItem.

    super dmNodeKind: nodeKind forItem: seqItem.

    "Created: / 03-10-2009 / 13:21:55 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:27:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: nodeName forItem:seqItem 
    self toConstructed: seqItem.

    super dmNodeName: nodeName forItem: seqItem.

    "Created: / 03-10-2009 / 14:23:24 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:31:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: parent forItem:seqItem
"/   self toConstructed: seqItem.

    super dmParent: parent forItem: seqItem.

    "Created: / 03-10-2009 / 17:43:22 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:31:51 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue:typedValue forItem:seqItem 
    self toConstructed: seqItem.

    super dmStringValue:typedValue forItem:seqItem.

    "Created: / 03-10-2009 / 13:52:03 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:31:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName:typeName forItem:seqItem 
    self toConstructed: seqItem.

    super dmTypeName:typeName forItem:seqItem.

    "Created: / 03-10-2009 / 13:45:29 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:32:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue:typedValue forItem:seqItem 
    self toConstructed: seqItem.

    super dmTypedValue:typedValue forItem:seqItem.

    "Created: / 03-10-2009 / 13:45:47 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 17:32:04 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!HybridNodeKind class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
