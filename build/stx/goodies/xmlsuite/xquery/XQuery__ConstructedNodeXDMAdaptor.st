"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

XDMAdaptor subclass:#ConstructedNodeXDMAdaptor
	instanceVariableNames:'xdmAccessor'
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-XDM'
!

ConstructedNodeXDMAdaptor class instanceVariableNames:'instance'

"
 No other class instance variables are inherited by this class.
"
!

!ConstructedNodeXDMAdaptor class methodsFor:'documentation'!

documentation
"
    Document adaptor for constructed XQuery items. Originally the class has
        different functionality and was rewriten many times, so there are still
        some strange codes. The code clean-up is required.

    [author:]

    [instance variables:]

    [class variables:]

    [see also:]

"
! !

!ConstructedNodeXDMAdaptor class methodsFor:'accessing'!

documentClass

    ^self

    "Created: / 02-11-2006 / 11:51:56 / ked"
    "Modified: / 03-11-2006 / 11:29:24 / ked"
!

instance
    instance ifNil:[
        instance := self new.
    ].
    ^ instance

    "Created: / 03-11-2006 / 11:19:39 / ked"
! !

!ConstructedNodeXDMAdaptor methodsFor:'accessing'!

documentURI
    ^ '#xquery-constructed-document'.

    "Created: / 12-06-2009 / 23:33:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

itemKind
    ^ ConstructedNodeKind instance.

    "Created: / 27-06-2009 / 18:38:31 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:29:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xdmAccessor
    xdmAccessor ifNil: [
        xdmAccessor := XDMAccessors instance.
    ].

    ^ xdmAccessor

    "Modified: / 29-09-2009 / 12:17:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

xdmAccessor:something
    xdmAccessor := something.
! !

!ConstructedNodeXDMAdaptor methodsFor:'checking'!

ensureIsValidNodeId:anObject 

    ^self

    "Created: / 03-11-2006 / 11:28:23 / ked"
!

ensureNotReleased 

    ^self

    "Created: / 03-11-2006 / 12:19:28 / ked"
! !

!ConstructedNodeXDMAdaptor methodsFor:'deprecated'!

xpathDocumentOf: aNodeId
    "this method could be deleted???"
    self shouldNeverBeReached.

    aNodeId nodeParent 
        ifNil:[ ^ aNodeId. ]
        ifNotNil:[ ^ self xpathDocumentOf:aNodeId nodeParent. ].

    "Modified: / 03-11-2006 / 20:53:39 / ked"
    "Created: / 14-12-2006 / 23:25:54 / janfrog"
    "Modified: / 22-06-2009 / 17:48:52 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ConstructedNodeXDMAdaptor methodsFor:'item changing'!

addAttribute: attribute of: constructedItem
    | attributes |
    self shouldNeverBeSent.


    attributes := self xdmAccessor dmAttributesFor: constructedItem.
    attributes add: attribute.
    self xdmAccessor dmAttributes: attributes for: constructedItem.

    "Created: / 26-07-2009 / 15:46:23 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:28:13 / Jan Kurs <kursj1@fel.cvut.cz>"
!

addChild: childNode of: constructedItem
    | children |
    self shouldNeverBeSent.

    children := self xdmAccessor dmChildrenFor: constructedItem.
    children add: childNode.
    self xdmAccessor dmChildren: children for: constructedItem.

    "Created: / 26-07-2009 / 15:50:38 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:28:28 / Jan Kurs <kursj1@fel.cvut.cz>"
!

nodeParent: element of: nodeId
    self shouldNeverBeSent.

    self xdmAccessor dmParent: element for: nodeId.

    "Created: / 26-07-2009 / 15:46:45 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:30:10 / Jan Kurs <kursj1@fel.cvut.cz>"
!

nodeValue: value of: nodeId
    self shouldNeverBeSent.

    nodeId itemValue: value.

    "Created: / 26-07-2009 / 15:44:55 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 12:30:14 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ConstructedNodeXDMAdaptor methodsFor:'node importing'!

importingBuilderClass
    "Superclass XMLv2::XPathDocumentAdaptor says that I am responsible to implement this method"

    self shouldImplement
! !

!ConstructedNodeXDMAdaptor methodsFor:'resource management'!

primReleaseResources

    ^self

    "Created: / 12-12-2006 / 10:46:25 / janfrog"
! !

!ConstructedNodeXDMAdaptor methodsFor:'xdm accessors'!

dmAttributes: constructedItem
    ^ self xdmAccessor dmAttributesFor: constructedItem .

    "Created: / 15-09-2009 / 19:34:27 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 29-09-2009 / 12:18:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri: constructedItem
    ^ self xdmAccessor dmBaseUriFor: constructedItem .

    "Modified: / 29-09-2009 / 11:58:00 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren: constructedItem
    ^ self xdmAccessor dmChildrenFor: constructedItem .

    "Created: / 29-09-2009 / 12:18:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmDocumentUri: constructedItem
    ^ self xdmAccessor dmDocumentUriFor: constructedItem .

    "Created: / 29-09-2009 / 12:18:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind: constructedItem
    ^ self xdmAccessor dmNodeKindFor: constructedItem.

    "Created: / 15-09-2009 / 20:29:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 29-09-2009 / 12:56:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: constructedItem
    ^ self xdmAccessor dmNodeNameFor: constructedItem .

    "Created: / 29-09-2009 / 12:19:06 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: constructedItem
    ^ self xdmAccessor dmParentFor: constructedItem .

    "Created: / 29-09-2009 / 12:19:20 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue: constructedItem
    ^ self xdmAccessor dmStringValueFor: constructedItem .

    "Created: / 29-09-2009 / 12:19:45 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName: constructedItem
    ^ self xdmAccessor dmTypeNameFor: constructedItem .

    "Created: / 29-09-2009 / 12:19:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue: constructedItem
    ^ self xdmAccessor dmTypedValueFor: constructedItem .

    "Created: / 29-09-2009 / 12:20:08 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ConstructedNodeXDMAdaptor methodsFor:'xdm setters'!

dmAttributes: attributes for: constructedItem
    ^ self xdmAccessor dmAttributes: attributes for: constructedItem .

    "Created: / 07-10-2009 / 12:26:48 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri: baseUri for: constructedItem
    ^ self xdmAccessor dmBaseUri: baseUri for: constructedItem .

    "Created: / 03-10-2009 / 13:41:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren: children for: constructedItem
    ^ self xdmAccessor dmChildren: children for: constructedItem .

    "Created: / 07-10-2009 / 12:30:56 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind: nodeKind for: constructedItem
   self xdmAccessor dmNodeKind: nodeKind for: constructedItem .

    "Created: / 03-10-2009 / 13:48:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: nodeName for: constructedItem
   self xdmAccessor dmNodeName: nodeName for: constructedItem .

    "Created: / 03-10-2009 / 14:23:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: parent for: constructedItem
   self xdmAccessor dmParent: parent for: constructedItem .

    "Created: / 03-10-2009 / 17:43:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue: stringValue for: constructedItem
   self xdmAccessor dmStringValue: stringValue for: constructedItem .

    "Created: / 03-10-2009 / 13:52:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName: typeName for: constructedItem
   self xdmAccessor dmTypeName: typeName for: constructedItem .

    "Created: / 03-10-2009 / 13:49:25 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue: typedValue for: constructedItem
   self xdmAccessor dmTypedValue: typedValue for: constructedItem .

    "Created: / 03-10-2009 / 13:48:21 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!ConstructedNodeXDMAdaptor class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
