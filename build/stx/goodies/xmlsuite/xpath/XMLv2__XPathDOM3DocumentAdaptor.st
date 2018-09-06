"{ Package: 'stx:goodies/xmlsuite/xpath' }"

"{ NameSpace: XMLv2 }"

XPathDocumentAdaptor subclass:#XPathDOM3DocumentAdaptor
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-XPath-Adaptors'
!


!XPathDOM3DocumentAdaptor class methodsFor:'accessing'!

documentClass
    "Superclass says that I am responsible to implement this method"

    ^XMLv2::Document

    "Created: / 24-10-2006 / 12:06:40 / janfrog"
! !

!XPathDOM3DocumentAdaptor methodsFor:'checking'!

ensureIsValidNodeId:anObject 


    (anObject isKindOf:XMLv2::Node) ifFalse:
        [XPathInvalidNodeIdError raiseErrorString:'Invalid node id']

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
! !

!XPathDOM3DocumentAdaptor methodsFor:'node importing'!

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

!XPathDOM3DocumentAdaptor methodsFor:'resource management'!

primReleaseResources

    "Created: / 12-12-2006 / 10:46:47 / janfrog"
! !

!XPathDOM3DocumentAdaptor methodsFor:'update primitives - primitives'!

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
!

primUpdInsertAttribute:anAttr into: targetNodeId 

    targetNodeId setAttribute:anAttr name value:anAttr value

    "Created: / 31-10-2007 / 09:55:44 / janfrog"
!

primUpdRename: aNode to: name "String"
    "Superclass says that I am responsible to implement this method"

    aNode localName: name

    "Created: / 31-10-2007 / 09:55:21 / janfrog"
!

primUpdReplaceValueOf:nodeId with:newValue 
    "Superclass says that I am responsible to implement this method"
    
    nodeId value:(self xpathValueOf: newValue).

    "Created: / 14-11-2007 / 15:17:24 / janfrog"
    "Modified: / 05-12-2007 / 13:45:30 / janfrog"
! !

!XPathDOM3DocumentAdaptor methodsFor:'xpath primitives'!

primXpathAttributeOf: anObject 

    | attributes |
    ^(attributes := anObject attributes)
        ifNil:[#()]
        ifNotNil:[attributes]

    "Created: / 14-12-2006 / 23:17:53 / janfrog"
!

primXpathAttributeValueOf: anObject 

    ^anObject value

    "Created: / 24-10-2006 / 12:06:39 / janfrog"
    "Modified: / 14-12-2006 / 23:21:47 / janfrog"
!

primXpathChildOf: anObject 

    ^anObject childNodes

    "Created: / 14-12-2006 / 23:18:06 / janfrog"
!

primXpathElementValueOf: anObject 

    ^anObject tagName

    "Created: / 14-12-2006 / 23:21:32 / janfrog"
!

primXpathIsAttribute: anObject 

    ^anObject isAttr

    "Created: / 14-12-2006 / 23:18:32 / janfrog"
!

primXpathIsDocument: anObject 

    ^anObject isDocument

    "Created: / 14-12-2006 / 23:19:52 / janfrog"
!

primXpathIsDocumentFragment:aNode 
    "Superclass says that I am responsible to implement this method"

    ^aNode isDocumentFragment

    "Created: / 10-08-2007 / 09:16:21 / janfrog"
!

primXpathIsElement:anObject 

    ^anObject isElement

    "Created: / 14-12-2006 / 23:19:07 / janfrog"
!

primXpathIsText:anObject 

    ^anObject isText

    "Created: / 14-12-2006 / 23:20:10 / janfrog"
!

primXpathLocalNameOf: anObject 

    ^anObject localName

    "Created: / 14-12-2006 / 23:22:07 / janfrog"
!

primXpathNameOf: anObject

    ^anObject nodeName

    "Created: / 14-12-2006 / 23:21:12 / janfrog"
!

primXpathNamespaceOf: anObject 

    ^anObject namespaceURI

    "Created: / 14-12-2006 / 23:22:23 / janfrog"
!

primXpathParentOf: anObject 

    ^anObject isDocument 
        ifTrue:[nil]
        ifFalse:[anObject isAttr
                    ifTrue:[anObject ownerElement]
                    ifFalse:[anObject parentNode]]

    "Created: / 14-12-2006 / 23:18:23 / janfrog"
    "Modified: / 10-04-2007 / 12:14:36 / janfrog"
!

primXpathTextValueOf: anObject 

    ^anObject data

    "Created: / 14-12-2006 / 23:22:35 / janfrog"
! !

!XPathDOM3DocumentAdaptor class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/xpath/XMLv2__XPathDOM3DocumentAdaptor.st,v 1.16 2007-12-05 21:41:49 vranyj1 Exp $'
! !
