"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#Attr
	instanceVariableNames:'nodeName children isId specified'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Attr class methodsFor:'instance creation'!

fromCincomAttribute: anAttribute

    ^self new
        setNodeName:(NodeName fromCincomNodeTag: anAttribute tag);
        value: anAttribute value

    "Created: / 21-12-2005 / 17:36:25 / janfrog"
!

named:aNodeName value:aString

    ^self new
        setNodeName:aNodeName;
        nodeValue:aString;
        yourself

    "Created: / 05-08-2005 / 13:33:37 / janfrog"
! !

!Attr methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

postAdoptedBy:aDocument

    super postAdoptedBy: aDocument.

    parent := nil.
    specified := true.

    self childNodes do:[:child|
        aDocument recursivelyAdoptNode: child.
        child setParentNode:self
    ]

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    nodeName := nodeName deepCopy.
    parent := nil.
    specified := true.
    isId := false.
    children := children 
                collect:[:child | 
                    (aDocument importNode:child deep:true)
                        setParentNode:self;
                        yourself
                ]

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
    "Modified: / 28-12-2005 / 16:18:05 / janfrog"
!

recusivelyAdoptedBy:aDocument

    "nothing to do"

    "Created: / 19-06-2005 / 13:49:41 / janfrog"
!

removeFromParentChildren

    self parent ifNotNil:[
        self parent removeAttributeNode:self
    ]

    "Created: / 19-06-2005 / 13:28:41 / janfrog"
!

textContentOn:aStream 
    "Superclass says that I am responsible to implement this method"

    self childNodes do:[:node|node textContentOn:aStream]

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
    "Modified: / 18-10-2005 / 14:52:43 / janfrog"
! !

!Attr methodsFor:'DOM3 interface'!

childNodes

    ^children

    "Created: / 17-06-2005 / 11:54:04 / janfrog"
    "Modified: / 17-06-2005 / 14:03:17 / janfrog"
!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

isId

    ^ isId ? false

    "Modified: / 25-11-2005 / 12:32:20 / janfrog"
!

localName

    ^nodeName localName

    "Created: / 17-06-2005 / 11:52:58 / janfrog"
!

lookupNamespaceURI:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

name
    ^ nodeName qualifiedName

    "Modified: / 19-06-2005 / 13:42:23 / janfrog"
!

namespaceURI

    ^nodeName ns

    "Created: / 17-06-2005 / 11:52:12 / janfrog"
!

nodeName
    ^ self name

    "Created: / 17-06-2005 / 11:25:15 / janfrog"
!

nodeType

    ^Node ATTRIBUTE_NODE

    "Created: / 17-06-2005 / 11:42:41 / janfrog"
!

nodeValue

    ^self value

    "Created: / 17-06-2005 / 11:35:37 / janfrog"
!

nodeValue:value

    ^self value:value

    "Created: / 17-06-2005 / 12:07:16 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

ownerElement

    ^self parent

    "Created: / 19-06-2005 / 13:43:01 / janfrog"
!

parentNode

    ^self domError:'Attributes has no parents' code:#NOT_SUPPORTED_ERR

    "Modified: / 17-06-2005 / 12:04:05 / janfrog"
!

prefix

    ^nodeName prefix

    "Created: / 17-06-2005 / 12:10:08 / janfrog"
    "Modified: / 28-06-2005 / 23:35:55 / janfrog"
!

schemaTypeInfo

    ^TypeInfo new

    "Created: / 15-11-2005 / 10:53:29 / janfrog"
    "Modified: / 24-12-2005 / 11:11:46 / janfrog"
!

specified

    ^specified ? true

    "Modified: / 24-12-2005 / 13:42:55 / janfrog"
!

specified:aBoolean

    specified := aBoolean

    "Created: / 19-06-2005 / 13:45:31 / janfrog"
    "Modified: / 24-12-2005 / 13:43:08 / janfrog"
!

value
    ^ self textContent

    "Modified: / 17-06-2005 / 14:03:08 / janfrog"
!

value: aString

    children removeAll.
    children add:(Text new data:aString)

    "Modified: / 17-06-2005 / 14:02:59 / janfrog"
! !

!Attr methodsFor:'accessing'!

isId: aBoolean

    isId := aBoolean

    "Created: / 25-11-2005 / 12:32:38 / janfrog"
!

localName:localName

    nodeName localName:localName

    "Created: / 16-06-2005 / 16:21:53 / janfrog"
!

ns:uri

    nodeName ns:uri

    "Created: / 16-06-2005 / 16:25:42 / janfrog"
!

parent:aNode
    parent := aNode.

    "Created: / 04-08-2005 / 14:31:36 / janfrog"
!

prefix:prefix

    nodeName prefix:prefix

    "Created: / 16-06-2005 / 16:25:42 / janfrog"
    "Modified: / 20-05-2006 / 13:59:52 / janfrog"
!

qualifiedName:qualifiedName

    nodeName qualifiedName:qualifiedName

    "Created: / 28-06-2005 / 23:17:55 / janfrog"
!

setNodeName:aNodeName 
    nodeName := aNodeName

    "Created: / 05-08-2005 / 13:32:16 / janfrog"
!

setOwnerElement: aNode
    self parent: aNode.

    "Created: / 25-12-2005 / 10:17:58 / janfrog"
! !

!Attr methodsFor:'children'!

insertChild:childNode after:refNode

    ^self childNodes insert:childNode after:refNode

    "Created: / 18-06-2005 / 21:51:16 / janfrog"
!

insertChild: childNode before: refNode

    self childNodes insert:childNode before:refNode

    "Created: / 25-12-2005 / 11:18:19 / janfrog"
! !

!Attr methodsFor:'copying'!

copy

    ^self deepCopy

    "Created: / 17-06-2005 / 14:39:08 / janfrog"
! !

!Attr methodsFor:'initialization & release'!

initialize

    super initialize.
    nodeName := NodeName new.
    children := NodeList new

    "Created: / 16-06-2005 / 16:24:40 / janfrog"
    "Modified: / 17-06-2005 / 14:02:09 / janfrog"
! !

!Attr methodsFor:'printing & storing'!

printOn:aStream


    aStream 
        nextPutAll: nodeName qualifiedName;
        nextPut:$=;
        nextPut:$";
        nextPutAll: self value;
        nextPut:$"

    "Created: / 21-05-2006 / 10:01:30 / janfrog"
! !

!Attr methodsFor:'testing'!

isAttr
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isNamespaceDeclarationAttribute

    ^(nodeName prefix isEmptyOrNil and:[nodeName localName = 'xmlns'])
        or:[nodeName prefix='xmlns']

    "Created: / 18-06-2005 / 20:35:36 / janfrog"
! !

!Attr methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitAttr:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Attr class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Attr.st,v 1.7 2006-05-21 08:15:12 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
