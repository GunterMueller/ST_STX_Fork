"{ Package: 'stx:goodies/xmlsuite/xquery' }"

"{ NameSpace: XQuery }"

Object subclass:#XDMAccessors
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XQuery-Sequence'
!

XDMAccessors class instanceVariableNames:'theInstance'

"
 No other class instance variables are inherited by this class.
"
!


!XDMAccessors class methodsFor:'accessing'!

instance

    theInstance ifNil:[theInstance := self new].
    ^theInstance

    "Created: / 05-12-2007 / 14:48:07 / janfrog"
! !

!XDMAccessors methodsFor:'private'!

getAccessorFor: xdm
    (xdm nodeKind = TypeAttribute instance typeName) ifTrue:
    [
        ^ AttributeAccessor instance.
    ].

    (xdm nodeKind = TypeElement instance typeName) ifTrue:
    [
        ^ ElementAccessor instance.
    ].

    (xdm nodeKind = TypeDocument instance typeName) ifTrue:
    [
        ^ DocumentAccessor instance.
    ].

    (xdm nodeKind = TypeText instance typeName) ifTrue:
    [
        ^ TextAccessor instance.
    ].
    ^ self shouldNeverBeReached.

"/    (xdm nodeKind = TypeXSAnyAtomicType instance typeName) ifTrue:
"/    [
"/        ^ AtomicTypeAccessors instance.
"/    ].

    "Created: / 29-09-2009 / 12:02:39 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 07-10-2009 / 10:31:05 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAccessors methodsFor:'xdm accessors'!

dmAttributesFor: xdm
    ^ (self getAccessorFor: xdm) primDmAttributesFor: xdm.

    "Created: / 29-09-2009 / 11:33:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUriFor: xdm
    ^ (self getAccessorFor: xdm) primDmBaseUriFor: xdm.

    "Created: / 29-09-2009 / 11:23:15 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildrenFor: xdm
    ^ (self getAccessorFor: xdm) primDmChildrenFor: xdm.

    "Created: / 29-09-2009 / 11:29:30 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmDocumentUriFor: xdm
    ^ (self getAccessorFor: xdm) primDmDocumentUriFor: xdm.

    "Created: / 29-09-2009 / 11:29:57 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKindFor: xdm
    "returns a string identifying the kind of node. It will be one of the following, 
        depending on the kind of node: 'attribute', 'comment', 'document', 'element', 
      'namespace', 'processing-instruction', or 'text'."

    ^ xdm nodeKind.

    "Created: / 29-09-2009 / 11:32:21 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeNameFor: xdm
    ^ (self getAccessorFor: xdm) primDmNodeNameFor: xdm.

    "Created: / 29-09-2009 / 11:30:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParentFor: xdm
    ^ (self getAccessorFor: xdm) primDmParentFor: xdm.

    "Created: / 29-09-2009 / 11:30:58 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValueFor: xdm
    ^ (self getAccessorFor: xdm) primDmStringValueFor: xdm.

    "Created: / 29-09-2009 / 11:31:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeNameFor: xdm
    ^ (self getAccessorFor: xdm) primDmTypeNameFor: xdm.

    "Created: / 29-09-2009 / 11:31:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValueFor: xdm
    ^ (self getAccessorFor: xdm) primDmTypedValueFor: xdm.

    "Created: / 29-09-2009 / 11:31:54 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAccessors methodsFor:'xdm accessors - private'!

primDmAttributesFor: xdm
    ^ xdm attributes.

    "Created: / 29-09-2009 / 12:09:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmBaseUriFor: xdm
    ^ xdm baseUri.

    "Created: / 29-09-2009 / 12:09:36 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmChildrenFor: xdm
    ^ xdm children.

    "Created: / 29-09-2009 / 12:09:41 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmDocumentUriFor: xdm
    ^ xdm documentUri.

    "Created: / 29-09-2009 / 12:09:47 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmNodeNameFor: xdm
    ^ xdm nodeName.

    "Created: / 29-09-2009 / 12:09:55 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmParentFor: xdm
    ^ xdm parent.

    "Created: / 29-09-2009 / 12:10:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmStringValueFor: xdm
    ^ xdm stringValue

    "Created: / 29-09-2009 / 12:10:37 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 16:45:52 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmTypeNameFor: xdm
    ^ xdm typeName.

    "Created: / 29-09-2009 / 12:10:43 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmTypedValueFor: xdm
    ^ xdm typedValue.

    "Created: / 29-09-2009 / 12:10:50 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAccessors methodsFor:'xdm setters'!

dmAttributes: attributes for: xdm
    ^ (self getAccessorFor: xdm) primDmAttributes: attributes for: xdm.

    "Created: / 03-10-2009 / 13:25:42 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmBaseUri: baseUri for: xdm
     ^ (self getAccessorFor: xdm) primDmBaseUri: baseUri for: xdm.

    "Created: / 03-10-2009 / 13:26:01 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmChildren: children for: xdm
    ^ (self getAccessorFor: xdm) primDmChildren: children for: xdm.

    "Created: / 02-10-2009 / 20:17:01 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 13:35:38 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeKind: nodeKind for: xdm
    xdm nodeKind: nodeKind.

    "Created: / 03-10-2009 / 13:29:03 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmNodeName: nodeName for: xdm
    ^ (self getAccessorFor: xdm) primDmNodeName: nodeName for: xdm.

    "Created: / 03-10-2009 / 13:29:41 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 15:56:16 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmParent: parent for: xdm
        ^ (self getAccessorFor: xdm) primDmParent: parent for: xdm.

    "Created: / 02-10-2009 / 20:21:50 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 03-10-2009 / 13:36:29 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmStringValue: stringValue for: xdm
    self assert: (stringValue class isSubclassOf: CharacterArray).

    ^ (self getAccessorFor: xdm) primDmStringValue: stringValue asString for: xdm.

    "Created: / 03-10-2009 / 13:30:55 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 04-10-2009 / 12:15:11 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypeName: typeName for: xdm
    ^ (self getAccessorFor: xdm) primDmTypeName: typeName for: xdm.

    "Created: / 03-10-2009 / 13:30:32 / Jan Kurs <kursj1@fel.cvut.cz>"
!

dmTypedValue: typedValue for: xdm
    self assert: (typedValue isAtomicValue).
    ^ (self getAccessorFor: xdm) primDmTypedValue: typedValue for: xdm.

    "Created: / 03-10-2009 / 13:30:13 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 05-10-2009 / 14:27:58 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAccessors methodsFor:'xdm setters - private'!

primDmAttributes: attributes for: xdm
    xdm attributes: attributes.

    "Created: / 03-10-2009 / 13:31:53 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmBaseUri: baseUri for: xdm
    xdm baseUri: baseUri.

    "Created: / 03-10-2009 / 13:31:59 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmChildren: children for: xdm
    xdm children: children.

    "Created: / 03-10-2009 / 13:32:02 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmNodeKind: nodeKind for: xdm
    xdm nodeKind: nodeKind.

    "Created: / 03-10-2009 / 13:32:07 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmNodeName: nodeName for: xdm
    self assert: (nodeName isSubtypeOf: 'xs:QName').
    xdm nodeName: nodeName.

    "Created: / 03-10-2009 / 13:32:16 / Jan Kurs <kursj1@fel.cvut.cz>"
    "Modified: / 06-10-2009 / 15:56:34 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmParent: parent for: xdm
    xdm parent: parent.

    "Created: / 03-10-2009 / 13:32:23 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmStringValue: stringValue for: xdm
    xdm stringValue: stringValue.

    "Created: / 03-10-2009 / 13:32:33 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmTypeName: typeName for: xdm
    xdm typeName: typeName.

    "Created: / 03-10-2009 / 13:32:39 / Jan Kurs <kursj1@fel.cvut.cz>"
!

primDmTypedValue: typedValue for: xdm
    xdm typedValue: typedValue.

    "Created: / 03-10-2009 / 13:32:47 / Jan Kurs <kursj1@fel.cvut.cz>"
! !

!XDMAccessors class methodsFor:'documentation'!

version_SVN
    ^ '$Id$'
! !
