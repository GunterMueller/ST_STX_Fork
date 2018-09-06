"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XDMAdaptor
	instanceVariableNames:'document released documentURI'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-XDM'
!


!XDMAdaptor class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 24-10-2006 / 11:15:06 / janfrog"
! !

!XDMAdaptor class methodsFor:'accessing'!

documentClass

    ^self subclassResponsibility

    "Created: / 13-10-2006 / 21:05:26 / janfrog"
! !

!XDMAdaptor class methodsFor:'testing'!

isAbstract

    ^self == XDMAdaptor

    "Created: / 13-10-2006 / 21:05:14 / janfrog"
! !

!XDMAdaptor methodsFor:'accessing'!

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
!

itemKind
    ^ XQuery::AccessedNodeKind instance.

    "Created: / 27-06-2009 / 18:38:15 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:26:09 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAdaptor methodsFor:'checking'!

ensureIsValidAttributeId: nodeId 

    (nodeId nodeKind = #attribute)
        ifFalse:[self invalidNodeIdError: 'Not an attribute']

    "Created: / 31-10-2007 / 10:21:04 / janfrog"
    "Modified: / 12-03-2012 / 13:54:27 / Adam Senk <senkadam@gmail.com>"
!

ensureIsValidElementId: nodeId 

    (nodeId isElement)
        ifFalse:[self invalidNodeIdError: 'Not an element']

    "Created: / 31-10-2007 / 10:18:19 / janfrog"
    "Modified: / 12-03-2012 / 13:52:49 / Adam Senk <senkadam@gmail.com>"
!

ensureIsValidElementOrAttributeId: nodeId 

    ((nodeId isAttr) or:[nodeId isElement])
        ifFalse:[self invalidNodeIdError: 'Not an attribute']

    "Created: / 31-10-2007 / 10:22:12 / janfrog"
    "Modified: / 07-02-2012 / 19:37:49 / Adam Senk <senkadam@gmail.com>"
!

ensureIsValidElementOrDocumentId: nodeId 


    (( nodeId isElement) or:[nodeId isDocument])
        ifFalse:[self invalidNodeIdError: 'Not an element or document']

    "Created: / 31-10-2007 / 10:18:19 / janfrog"
    "Modified: / 07-02-2012 / 21:36:16 / Adam Senk <senkadam@gmail.com>"
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

!XDMAdaptor methodsFor:'error reporting'!

invalidNodeIdError: aString

    XQuery::InvalidNodeIdError raiseErrorString: aString

    "Created: / 31-10-2007 / 10:18:59 / janfrog"
    "Modified: / 06-04-2010 / 11:58:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!XDMAdaptor methodsFor:'initialization & release'!

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

!XDMAdaptor methodsFor:'node importing'!

importForeignNode:foreignNodeId "adaptor:foreignXPathDocumentAdaptor" 
    |builder|

    builder := self importingBuilder.
    (XQuery::XQueryResultXMLReader new)
        "setDocumentAdaptor:foreignXPathDocumentAdaptor;"
        setContentHandler:builder;
        visit:foreignNodeId.
    ^ builder document

    "Created: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 06-02-2012 / 23:48:05 / Adam Senk <senkadam@gmail.com>"
    "Created: / 07-02-2012 / 18:44:08 / Adam Senk <senkadam@gmail.com>"
!

importForeignNode:foreignNodeId adaptor:foreignXPathDocumentAdaptor 
    |builder|

    builder := self importingBuilder.
    (XQuery::XQueryResultXMLReader new)
        "setDocumentAdaptor:foreignXPathDocumentAdaptor;"
        setContentHandler:builder;
        visit:foreignNodeId.
    ^ builder document

    "Created: / 05-12-2007 / 14:26:29 / janfrog"
    "Modified: / 06-02-2012 / 23:48:05 / Adam Senk <senkadam@gmail.com>"
!

importingBuilder

    ^self importingBuilderClass new

    "Created: / 14-11-2007 / 14:29:21 / janfrog"
!

importingBuilderClass

    ^self subclassResponsibility

    "Created: / 14-11-2007 / 14:29:09 / janfrog"
! !

!XDMAdaptor methodsFor:'printing'!

printOn: aStream

    super printOn:aStream.
    aStream nextPutAll:' on '.
    documentURI printOn: aStream

    "Created: / 20-09-2007 / 12:50:11 / janfrog"
! !

!XDMAdaptor methodsFor:'testing'!

isReleased

    ^released

    "Created: / 12-12-2006 / 10:45:18 / janfrog"
! !

!XDMAdaptor methodsFor:'trigger creating'!

connectTriggerDef: triggerDefNodeId to: nodeId
     self error: 'This XDMAdaptor does not support trigger funcionality'

    "Created: / 25-03-2012 / 14:02:03 / Adam Senk <senkadam@gmail.com>"
! !

!XDMAdaptor methodsFor:'update primitives'!

updDelete: nodeId
   |type|
    self ensureNotReleased ; ensureIsValidNodeId: nodeId.

   type:=self dmNodeKind: nodeId.
     type='attribute'
        ifTrue:[self primUpdDeleteAttribute: nodeId]
        ifFalse:[self primUpdDeleteNode: nodeId]

    "Created: / 24-10-2007 / 16:09:53 / janfrog"
    "Modified: / 31-10-2007 / 10:17:25 / janfrog"
    "Modified: / 30-01-2012 / 19:11:43 / Adam Senk <senkadam@gmail.com>"
!

updInsert:sourceNodeId after:targetNodeId 
    "String"
    
    self
        ensureNotReleased.
        "ensureIsValidElementOrAttributeId:sourceNodeId;
        ensureIsValidElementOrDocumentId:targetNodeId."

    self 
        primUpdInsert:sourceNodeId nodeId
        into:targetNodeId nodeId parent
        after:targetNodeId nodeId.

    "Modified: / 21-11-2007 / 13:58:38 / janfrog"
    "Modified: / 01-05-2012 / 12:39:31 / Adam Senk <senkadam@gmail.com>"
!

updInsert:insertedNodeId asFirstInto:parentNodeId 
    "|childNodes|"

    self
        ensureNotReleased.
        "ensureIsValidNodeId:insertedNodeId nodeId."
       " ensureIsValidElementOrDocumentId:parentNodeId."
    self 
        primUpdInsert:insertedNodeId nodeId
        into: parentNodeId nodeId
        before: nil.

      "((childNodes:= self xpathChildOf: parentNodeId) isEmpty 
                ifTrue:[ nil ]
                ifFalse:[ childNodes anyOne ])"

    "Modified: / 21-11-2007 / 14:20:28 / janfrog"
    "Modified: / 01-05-2012 / 15:00:21 / Adam Senk <senkadam@gmail.com>"
!

updInsert:insertedNodeId asLastInto:parentNodeId 

    self
        ensureNotReleased.
        "ensureIsValidElementOrAttributeId:insertedNodeId;
        ensureIsValidElementOrDocumentId:parentNodeId. "
    self 
        primUpdInsert:insertedNodeId nodeId
        into:parentNodeId nodeId
        after:(self dmChildren:parentNodeId nodeId) last

    "Modified: / 21-11-2007 / 13:59:02 / janfrog"
    "Modified: / 01-05-2012 / 12:42:19 / Adam Senk <senkadam@gmail.com>"
!

updInsert:insertedNodeId before:referenceNodeId 
    "String"
    
    self
        ensureNotReleased.
        "ensureIsValidElementOrAttributeId:insertedNodeId;
        ensureIsValidElementOrDocumentId:referenceNodeId."
    self 
        primUpdInsert:insertedNodeId nodeId
        into: (self dmParent: insertedNodeId nodeId)
        before:referenceNodeId nodeId.

    "Created: / 21-11-2007 / 11:31:22 / janfrog"
    "Modified: / 21-11-2007 / 14:19:11 / janfrog"
    "Modified: / 01-05-2012 / 12:39:58 / Adam Senk <senkadam@gmail.com>"
!

updInsert:insertedNodeId into:parentNodeId 

    ^self updInsert: insertedNodeId asFirstInto: parentNodeId

    "Modified: / 21-11-2007 / 12:15:08 / janfrog"
!

updInsertAttribute:anAttr into:targetNodeId 
    self
        ensureNotReleased;
        ensureIsValidElementId:targetNodeId nodeId;
        ensureIsValidAttributeId:anAttr nodeId.
    self primUpdInsertAttribute:anAttr nodeId nodeName into:targetNodeId nodeId

    "Modified: / 31-10-2007 / 10:22:31 / janfrog"
    "Modified: / 01-05-2012 / 16:09:38 / Adam Senk <senkadam@gmail.com>"
!

updRename: nodeId to: newName "String"

    "self ensureNotReleased ; ensureIsValidElementOrAttributeId: nodeId. "
    self primUpdRename: nodeId to: newName.

    "Modified: / 31-10-2007 / 10:22:31 / janfrog"
    "Modified: / 03-03-2012 / 21:06:14 / Adam Senk <senkadam@gmail.com>"
!

updReplaceNode:nodeRep with:replacementNodeIds 


    self
        ensureNotReleased.
       " ensureIsValidNodeId:nodeId;
        ensureIsValidNodeIds:replacementNodeIds."

    (nodeRep isElementNode) ifTrue:[
        replacementNodeIds do:[:node | 
            self 
                updInsert:(NodeItem withNode:node documentAdaptor: nodeRep documentAdaptor)
                after:nodeRep
        ].
        self primUpdDeleteNode:nodeRep nodeId.
    ] ifFalse:[
        replacementNodeIds do:[:node | 
            self primUpdInsertAttribute:(NodeItem withNode:node documentAdaptor: nodeRep documentAdaptor) into:(self dmParent:(nodeRep nodeId))
        ].
        self primUpdDeleteAttribute:nodeRep nodeId
    ]

    "Created: / 14-11-2007 / 14:17:16 / janfrog"
    "Modified: / 21-11-2007 / 13:59:39 / janfrog"
    "Modified: / 01-05-2012 / 15:15:55 / Adam Senk <senkadam@gmail.com>"
!

updReplaceValueOf:nodeId with:newValue 

 self
        ensureNotReleased;
        ensureIsValidNodeId:nodeId nodeId.

    (nodeId isElementNode) 
        ifTrue:
            ["delete all child nodes"            
            (nodeId xpathChild) do:[:node|self updDelete: node nodeId ].
            "insert new node"
            self updInsert: (NodeItem withNode:newValue documentAdaptor: nodeId documentAdaptor) into: nodeId]
        ifFalse:
            [self primUpdReplaceValueOf:nodeId with:newValue]

    "Modified: / 21-11-2007 / 12:48:36 / janfrog"
    "Modified: / 01-05-2012 / 16:07:15 / Adam Senk <senkadam@gmail.com>"
! !

!XDMAdaptor methodsFor:'update primitives - primitives'!

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

!XDMAdaptor methodsFor:'xdm accessors'!

dmAttributes: node
    " The collection of the nodeIds is expected"

    ^ self subclassResponsibility .

    "Created: / 19-04-2009 / 17:51:36 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 15-09-2009 / 19:34:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri: node
    ^ self subclassResponsibility .

    "Created: / 19-04-2009 / 17:51:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 26-07-2009 / 20:23:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:52:05 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmDocumentUri: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:52:12 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmIsId: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:52:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmIsIdrefs: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:54:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNamespaceNodes: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:54:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNamspaceBindings: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:54:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNilled: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:54:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind: node
    ^ self subclassResponsibility .

    "Created: / 19-04-2009 / 17:54:52 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 15-09-2009 / 20:28:44 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:54:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:55:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:55:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:52:37 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:55:14 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmUnparsedEntityPublicId: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:55:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmUnparsedEntitySystemId: nodeId
    ^ self shouldImplement.

    "Created: / 19-04-2009 / 17:55:26 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAdaptor methodsFor:'xpath accessing'!

xpathDocument
    "
        Returns a Document node ID
    "

    self ensureNotReleased.
    ^document

    "Created: / 18-10-2006 / 15:25:31 / janfrog"
    "Modified: / 24-10-2006 / 12:01:32 / janfrog"
    "Modified: / 07-10-2009 / 12:34:24 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xpathDocumentURI
    self shouldNeverBeSent.

    "
        Returns a Document URI
    "

    self ensureNotReleased.
    ^documentURI

    "Created: / 20-09-2007 / 12:48:48 / janfrog"
    "Modified: / 07-10-2009 / 12:32:35 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAdaptor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
