"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#DocumentFragment
	instanceVariableNames:'children'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!DocumentFragment methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

postAdoptedBy:aDocument

    super postAdoptedBy: aDocument.

    self childNodes do:
        [:child|aDocument recursivelyAdoptNode:child]

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    aBoolean ifFalse:[
        children := OrderedCollection new
    ] ifTrue:[
        children := children 
                    collect:[:child | (aDocument importNode:child deep:true) setParentNode:self ]
    ]

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
! !

!DocumentFragment methodsFor:'DOM3 interface'!

childNodes

    ^children

    "Created: / 10-12-2006 / 21:01:42 / janfrog"
!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

isDefaultNamespace:uri

    ^"unknown"false

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

lookupNamespaceURI:prefix

    ^"unknown"false

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

nodeName

    ^'#document-fragment'

    "Created: / 17-06-2005 / 11:26:23 / janfrog"
!

nodeType

    ^Node DOCUMENT_FRAGMENT_NODE

    "Created: / 17-06-2005 / 11:44:06 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

ownerDocument

    ^self parent

    "Created: / 17-06-2005 / 11:57:30 / janfrog"
!

parentNode

    ^self domError:'Document fragment has no parent' code:#NOT_SUPPORTED_ERR

    "Created: / 17-06-2005 / 12:04:43 / janfrog"
! !

!DocumentFragment methodsFor:'DOM3 interface - extensions'!

createAttribute:localName

    ^Attr new
        localName:localName;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createAttribute:qualifiedName ns:ns

    ^Attr new
        qualifiedName:qualifiedName;
        ns:ns;
        nodeValue:'';
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createCDATASection:aString

    ^CDATASection new
        data:aString;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createComment:aString

    ^Comment new
        data:aString;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createDocumentFragment

    ^DocumentFragment new
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createDocumentType: qualifiedName publicId:publicId systemId: systemId


    ^self shouldImplement

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createElement:localName

    ^Element new
        qualifiedName:localName;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createElement:qualifiedName ns:ns

    ^Element new
        qualifiedName:qualifiedName;
        ns:ns;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createEntityReference:aString

    ^EntityReference new
        setOwnerDocument: self;
        "appendChild:
            (Entity new
                setOwnerDocument:self;
                setNotationName: aString)"
        yourself

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createProcessingInstruction:target data:data

    ^ProcessingInstruction new
        target:target;
        data:data;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
!

createTextNode:aString

    ^Text new
        data:aString;
        setOwnerDocument:self

    "Created: / 10-08-2007 / 09:24:13 / janfrog"
! !

!DocumentFragment methodsFor:'accessing'!

document

    ^self parent ifNil:[self]

    "Created: / 17-06-2005 / 11:58:44 / janfrog"
! !

!DocumentFragment methodsFor:'children'!

insertChild:childNode before:refNode

    refNode 
        ifNil:[self childNodes addLast:childNode]
        ifNotNil:[self childNodes insert:childNode before:refNode]

    "Created: / 18-06-2005 / 19:33:30 / janfrog"
!

insertYourselfAfter:refNode in:parentNode 
    self childNodes do:[:childNode | 
        parentNode insertChild:childNode after:refNode
    ]

    "Created: / 21-11-2007 / 10:58:42 / janfrog"
!

insertYourselfBefore:refNode in:parentNode 
    self childNodes do:[:childNode | 
        parentNode insertChild:childNode before:refNode
    ]

    "Created: / 18-06-2005 / 19:32:23 / janfrog"
! !

!DocumentFragment methodsFor:'initialization'!

initialize

    super initialize.
    children := NodeList new

    "Created: / 17-06-2005 / 12:39:32 / janfrog"
! !

!DocumentFragment methodsFor:'testing'!

isDocumentFragment
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!DocumentFragment methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitDocumentFragment:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!DocumentFragment class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__DocumentFragment.st,v 1.5 2007-11-22 21:41:37 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
