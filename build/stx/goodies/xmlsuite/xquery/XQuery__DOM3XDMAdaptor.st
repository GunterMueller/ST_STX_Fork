"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAdaptor subclass:#DOM3XDMAdaptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-XDM'
!


!DOM3XDMAdaptor class methodsFor:'accessing'!

documentClass
    "Superclass says that I am responsible to implement this method"

    ^XMLv2::Document

    "Created: / 24-10-2006 / 12:06:40 / janfrog"
! !

!DOM3XDMAdaptor methodsFor:'checking'!

ensureIsValidNodeId:anObject 

    (anObject isKindOf:XMLv2::Node) ifFalse:
        [InvalidNodeIdError raiseErrorString:('Invalid node id (%1)' bindWith: anObject)]

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
    "Modified: / 06-04-2010 / 11:59:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!DOM3XDMAdaptor methodsFor:'node importing'!

importingBuilder

    ^self importingBuilderClass new
        autoWrapInDocumentFragment:false;
        yourself

    "Created: / 14-11-2007 / 14:42:29 / janfrog"
!

importingBuilderClass
    "Superclass says that I am responsible to implement this method"

    ^XMLv2::DOM3Builder

    "Created: / 14-11-2007 / 14:29:28 / janfrog"
! !

!DOM3XDMAdaptor methodsFor:'resource management'!

primReleaseResources

    "Created: / 12-12-2006 / 10:46:47 / janfrog"
! !

!DOM3XDMAdaptor methodsFor:'update primitives - primitives'!

primUpdDeleteAttribute: anAttr


    anAttr ownerElement removeAttributeNode: anAttr

    "Created: / 31-10-2007 / 09:55:44 / janfrog"
!

primUpdDeleteNode: aNode
    "Superclass says that I am responsible to implement this method"

    aNode parentNode removeChild: aNode

    "Created: / 31-10-2007 / 09:55:08 / janfrog"
!

primUpdInsert:insertedNodeId into:nodeId after:referenceNodeId 

    nodeId insertChild:insertedNodeId after: referenceNodeId

    "Created: / 21-11-2007 / 13:55:03 / janfrog"
!

primUpdInsert:sourceNodeId into:nodeId before:referenceNodeId 

    nodeId insertChild:sourceNodeId before: referenceNodeId

    "Created: / 21-11-2007 / 13:55:38 / janfrog"
    "Modified: / 07-02-2012 / 20:40:25 / Adam Senk <senkadam@gmail.com>"
!

primUpdInsertAttribute:anAttr into: targetNodeId 

    targetNodeId setAttribute:anAttr nodeId localName value: anAttr stringValue.

    "Created: / 31-10-2007 / 09:55:44 / janfrog"
    "Modified: / 01-05-2012 / 15:17:31 / Adam Senk <senkadam@gmail.com>"
!

primUpdRename: aNode to: name "String"
    "Superclass says that I am responsible to implement this method"

    aNode localName: name

    "Created: / 31-10-2007 / 09:55:21 / janfrog"
!

primUpdReplaceValueOf:nodeId with:newValue 
    "Superclass says that I am responsible to implement this method"
    
    nodeId nodeId value:(newValue nodeValue).

    "Created: / 14-11-2007 / 15:17:24 / janfrog"
    "Modified: / 05-12-2007 / 13:45:30 / janfrog"
    "Modified: / 07-02-2012 / 19:15:00 / Adam Senk <senkadam@gmail.com>"
! !

!DOM3XDMAdaptor methodsFor:'xdm accessors'!

dmAttributes: item
    item attributes ifNil:
    [
        ^ OrderedCollection new.
    ] ifNotNil: [
        ^ item attributes
    ].

    "Created: / 15-09-2009 / 19:34:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 15:58:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri: item
    ^ item baseURI.

    "Modified: / 04-10-2009 / 12:00:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren: item
    ^ item childNodes.

    "Created: / 29-09-2009 / 12:18:21 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 21:55:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind: item
    item isElement ifTrue: [ ^ #'element' ].
    item isDocument ifTrue: [ ^ #'document' ].
    item isAttr ifTrue: [ ^ #'attribute' ].
    item isText ifTrue: [ ^ #'text' ].
    item isComment ifTrue: [ ^ #'comment' ].
    item isProcessingInstruction ifTrue: [ ^ #'processing-instruction' ].

    self shouldNeverBeReached.

    "Created: / 15-09-2009 / 20:29:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 13:41:57 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 18-03-2010 / 09:37:35 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dmNodeName: item
    item isDocument ifTrue: [
        ^ nil.
    ].
    item isText ifTrue: [
        ^ nil.
    ].


    ^ XQuery::AtomicItem withValue:
        (XQuery::QName new
            localName: item localName;
            prefix: item prefix;
            namespaceURI: item namespaceURI;
            yourself)
        asType: 'xs:QName'.

    "Created: / 29-09-2009 / 12:19:06 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 18:26:04 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: node
    ^ node parent.

    "Created: / 29-09-2009 / 12:19:20 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 17:29:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue: item
    ^ (self dmTypedValue: item) asString

    "Created: / 29-09-2009 / 12:19:45 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 22:47:09 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName: constructedItem
    ^ (TypeFactory getType: (self dmNodeKind: constructedItem)) typeName

    "Created: / 29-09-2009 / 12:19:57 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:16:04 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 20-04-2010 / 21:13:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

dmTypedValue: item
    item isElement ifTrue:[
        ^ XQuery::AtomicItem withValue: item textContent.
    ].

    
    ^ XQuery::AtomicItem withValue: item nodeValue.

    "Created: / 29-09-2009 / 12:20:08 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 17:05:47 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!DOM3XDMAdaptor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
