"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#Element
	instanceVariableNames:'nodeName attributes children'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Element class methodsFor:'instance creation'!

named:nodeName attributes:attrs

    ^self new
        setNodeName:nodeName;
        setAttributes:attrs;
        yourself

    "Created: / 04-08-2005 / 13:27:49 / janfrog"
! !

!Element methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

getElementsByTagName:localName ns:nsUri into:nodeList

    | selectBlock nsUriToSearch |
    nsUriToSearch := nsUri = '*' ifTrue:[nil] ifFalse:[nsUri].
    selectBlock := nsUriToSearch  
                    ifNil:[[:e| e localName = localName]]
                    ifNotNil:[[:e| e localName = localName and:[e namespaceURI = nsUriToSearch]]].

    self getElementsByTagName:localName 
            ns:nsUri 
            into:nodeList   
            usingSelectBlock:selectBlock

    "Created: / 24-08-2005 / 12:39:54 / janfrog"
    "Modified: / 23-12-2005 / 15:31:21 / janfrog"
!

getElementsByTagName:localName ns:nsUri into:nodeList usingSelectBlock:selectBlock


    (selectBlock value:self) 
        ifTrue:[nodeList add:self].

    self childNodes do:
        [:child|child getElementsByTagName:localName ns:nsUri into:nodeList usingSelectBlock:selectBlock]

    "Created: / 24-08-2005 / 12:45:56 / janfrog"
    "Modified: / 25-11-2005 / 12:17:12 / janfrog"
!

namespaceDeclarationAttributes

    ^self attributes select:[:attr|attr isNamespaceDeclarationAttribute]

    "Created: / 18-06-2005 / 20:36:22 / janfrog"
!

normalizeCDataSections

    (self domConfig getParameter:'cdata-sections')
        ifTrue:[^self].

    1 to: children size do:[:idx|
        | node |
        node := children at:idx.
        node isCDATASection ifTrue:[
            children at:idx put:(Text new data:node data)
        ]
    ]

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

normalizeComments

    (self domConfig getParameter: 'comments')
        ifFalse:[children := children reject:[:child|child isComment]]

    "Created: / 28-12-2005 / 16:18:05 / janfrog"
!

normalizeNamespaces

    "see appendix B.1 in DOM3 Core"

    "Created: / 18-06-2005 / 20:17:22 / janfrog"
!

normalizeTextNodes

    | newChildren |
    newChildren := children class new:children size.
    children do:[:child|
        child isText ifTrue:[
            newChildren isEmpty ifTrue:[
                newChildren add: child
            ] ifFalse:[
                newChildren last isText ifTrue:[
                    newChildren last appendData: child data
                ] ifFalse:[
                    newChildren add:child                    
                ]
            ]
        ] ifFalse:[
            newChildren add:child
        ]
    ].
    children := newChildren.

    "Created: / 23-12-2005 / 21:01:26 / janfrog"
!

postAdoptedBy:aDocument 

    super postAdoptedBy:aDocument.

    attributes := attributes reject:[:attr| attr specified not].
    attributes do:[:attr|aDocument adoptNode:attr].

    self childNodes do:
        [:child|aDocument recursivelyAdoptNode:child]

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    nodeName := nodeName deepCopy.
    attributes := attributes 
                select:[:attr | attr specified ]
                thenCollect:[:attr | (aDocument importNode:attr deep:true) setParentNode:self ].
    aBoolean ifFalse:[
        children := OrderedCollection new
    ] ifTrue:[
        children := children 
                    collect:[:child | (aDocument importNode:child deep:true) setParentNode:self ]
    ]

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

recusivelyAdoptedBy:aDocument

    super recusivelyAdoptedBy:aDocument.
    self specifiedAttributes do:[:attr|
        aDocument adoptNode:attr
    ]

    "Created: / 19-06-2005 / 13:50:54 / janfrog"
!

specifiedAttributes

    ^self attributes select:[:attr|attr specified]

    "Created: / 19-06-2005 / 13:51:20 / janfrog"
!

textContentOn: aStream 
    "Superclass says that I am responsible to implement this method"

    self textContentOfChildrenOn: aStream

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
    "Modified: / 11-11-2006 / 09:30:59 / janfrog"
! !

!Element methodsFor:'DOM3 interface'!

attributes

    ^attributes

    "Created: / 17-06-2005 / 11:37:03 / janfrog"
!

childNodes

    ^children

    "Created: / 17-06-2005 / 11:54:17 / janfrog"
!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

getAttribute:attrName

    ^(attributes getValueByLocalName:attrName)
        ifNil:['' "default value as specified in DOM3-Core.pdf, page 86"].

    "Created: / 16-06-2005 / 13:46:42 / janfrog"
!

getAttribute:localName ns:nsUri

    ^(attributes getValueByURI:nsUri localName:localName)
        ifNil:['']

    "Created: / 16-06-2005 / 13:50:42 / janfrog"
!

getAttributeNode:attrName 
    ^ attributes nodeWithLocalName:attrName

    "Created: / 16-06-2005 / 13:48:00 / janfrog"
    "Modified: / 25-11-2005 / 12:26:43 / janfrog"
!

getAttributeNode:localName ns:nsUri 
    ^ attributes nodesWithURI:nsUri localName:localName

    "Created: / 16-06-2005 / 14:12:35 / janfrog"
    "Modified: / 16-06-2005 / 15:53:47 / janfrog"
!

getElementsByTagName:localName

    ^self getElementsByTagName:localName ns:nil.

    "Created: / 16-06-2005 / 14:14:49 / janfrog"
    "Modified: / 24-08-2005 / 12:40:32 / janfrog"
!

getElementsByTagName:localName ns:nsUri

    | nodeList |
    nodeList := NodeList new:16.
    self getElementsByTagName:localName ns:nsUri into:nodeList.
    ^nodeList

    "Created: / 16-06-2005 / 14:14:49 / janfrog"
    "Modified: / 24-08-2005 / 12:41:10 / janfrog"
!

hasAttribute:localName 
    ^ (attributes nodesWithLocalName:localName) size > 0

    "Created: / 16-06-2005 / 13:53:03 / janfrog"
    "Modified: / 16-06-2005 / 15:54:10 / janfrog"
!

hasAttribute:localName ns:nsUri 
    ^ (attributes nodesWithURI:nsUri localName:localName) notNil

    "Created: / 16-06-2005 / 13:53:10 / janfrog"
    "Modified: / 16-06-2005 / 15:53:47 / janfrog"
!

isDefaultNamespace:ns

    | defaultNSDeclAttr |

    self prefix isEmptyOrNil ifTrue:[^nodeName ns = ns].

    (self attributes notEmptyOrNil 
        and:[defaultNSDeclAttr := self attributes nodeWithLocalName:'xmlns']) 
            ifTrue:[^defaultNSDeclAttr value = ns].

    self parent notNil ifTrue:[^self parent isDefaultNamespace:ns].

    ^"unknown"false.

    "Created: / 16-06-2005 / 16:37:58 / janfrog"
    "Modified: / 18-06-2005 / 20:25:24 / janfrog"
!

localName

    ^nodeName localName

    "Modified: / 17-06-2005 / 11:52:46 / janfrog"
!

lookupNamespaceURI:prefix

    (self namespaceURI notNil and:[self prefix = prefix]) ifTrue:[
        ^self namespaceURI].

    (self hasAttributes) ifTrue:[
        self namespaceDeclarationAttributes do:[:attr|
            ((attr prefix = 'xmlns') and:[attr localName = prefix])
                ifTrue:[^attr value isEmptyOrNil not 
                            ifTrue:[attr value]
                            ifFalse:[nil]]
                ifFalse:[
                    (attr localName = 'xmlns' and:[attr prefix == nil])
                        ifTrue:[^attr value isEmptyOrNil not 
                            ifTrue:[attr value]
                            ifFalse:[nil]]]]].

    ^super lookupNamespaceURI:prefix

    "Created: / 16-06-2005 / 16:37:58 / janfrog"
    "Modified: / 18-06-2005 / 21:24:59 / janfrog"
!

namespaceURI

    ^nodeName ns

    "Modified: / 17-06-2005 / 11:52:26 / janfrog"
!

nodeName

    ^self tagName

    "Modified: / 17-06-2005 / 11:26:41 / janfrog"
!

nodeType

    ^Node ELEMENT_NODE

    "Created: / 17-06-2005 / 11:43:57 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"
    
    self 
        normalizeCDataSections;
        normalizeComments;
        normalizeTextNodes.
    self childNodes do:[:child | 
        child normalize
    ]

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
    "Modified: / 28-12-2005 / 16:18:05 / janfrog"
!

prefix

    ^nodeName prefix

    "Created: / 17-06-2005 / 12:10:08 / janfrog"
    "Modified: / 28-06-2005 / 23:34:53 / janfrog"
!

prefix:prefix

    ^nodeName prefix:prefix

    "Created: / 17-06-2005 / 12:10:18 / janfrog"
    "Modified: / 07-04-2007 / 15:02:23 / janfrog"
!

removeAttribute:attrName

    attributes removeNamedItem:attrName.

    "Created: / 16-06-2005 / 13:47:14 / janfrog"
    "Modified: / 16-06-2005 / 16:00:25 / janfrog"
!

removeAttribute:localName ns:nsUri

    attributes removeNamedItem:localName ns:nsUri

    "Created: / 16-06-2005 / 13:51:40 / janfrog"
    "Modified: / 16-06-2005 / 16:00:40 / janfrog"
!

removeAttributeNode:attr

    attributes remove:attr ifAbsent:[nil]

    "Created: / 16-06-2005 / 13:48:58 / janfrog"
    "Modified: / 16-06-2005 / 16:12:09 / janfrog"
!

schemaTypeInfo

    TypeInfo new

    "Created: / 16-06-2005 / 13:53:20 / janfrog"
    "Modified: / 24-12-2005 / 11:11:53 / janfrog"
!

setAttribute:qualifiedName ns:ns value:value

    | oldNode |

    (oldNode := attributes getQualifiedNamedItem:qualifiedName)
        ifNotNil:[oldNode value:value]
        ifNil:[
            attributes add:
                (Attr new
                    qualifiedName:qualifiedName;
                    ns:ns;
                    value:value;
                    parent:self)
        ]

    "Created: / 16-06-2005 / 13:47:00 / janfrog"
    "Modified: / 31-08-2005 / 14:24:53 / masca"
    "Modified: / 25-10-2005 / 17:08:04 / janfrog"
!

setAttribute:localName value:value

    | oldNode |
    (oldNode := attributes getNamedItem:localName)
        ifNotNil:[oldNode value:value]
        ifNil:[
            attributes add:
                (Attr new
                    localName:localName;
                    value:value;
                    parent:self)
        ]

    "Created: / 16-06-2005 / 13:47:00 / janfrog"
    "Modified: / 18-06-2005 / 20:29:00 / janfrog"
!

setAttributeNode:attr

    | oldAttr |
    (oldAttr := attributes getNamedItem:attr localName ns:attr namespaceURI)
        ifNotNil:[attributes remove:oldAttr].
    attributes add:attr.
    attr parent:self.

    "Created: / 16-06-2005 / 13:48:43 / janfrog"
    "Modified: / 23-12-2005 / 15:28:28 / janfrog"
!

setAttributeNodeNS:attr

    self setAttributeNode:attr

    "Created: / 16-06-2005 / 13:52:12 / janfrog"
    "Modified: / 16-06-2005 / 16:36:14 / janfrog"
!

setIdAttribute:localName isId:isId

    self setIdAttribute:localName ns:nil isId:isId

    "Created: / 16-06-2005 / 13:53:47 / janfrog"
    "Modified: / 23-12-2005 / 15:22:08 / janfrog"
!

setIdAttribute:localName ns: nsUri isId:isId

    | attr |
    attr := Attr new
                localName: localName;
                ns: nsUri.
    attr value: (self identityHash printString , '.' , attr identityHash printString).
    self setIdAttributeNode:attr isId: isId

    "Created: / 16-06-2005 / 13:53:47 / janfrog"
    "Modified: / 31-08-2005 / 12:14:28 / masca"
    "Modified: / 23-12-2005 / 15:21:49 / janfrog"
!

setIdAttributeNode:attr isId:isId

   attr isId: isId.
   self setAttributeNode: attr

    "Created: / 16-06-2005 / 13:54:00 / janfrog"
    "Modified: / 25-11-2005 / 12:43:29 / janfrog"
!

tagName

    ^nodeName qualifiedName

    "Created: / 16-06-2005 / 13:46:19 / janfrog"
! !

!Element methodsFor:'DOM3 interface - extensions'!

getAttribute:localName ns:nsUri ifAbsent: aBlock

    ^(attributes getValueByURI:nsUri localName:localName)
        ifNil:aBlock

    "Created: / 07-04-2007 / 10:46:01 / janfrog"
! !

!Element methodsFor:'accessing'!

localName:localName

    nodeName localName:localName

    "Created: / 07-04-2007 / 10:12:49 / janfrog"
!

ns:ns

    nodeName ns:ns

    "Created: / 11-08-2005 / 22:32:16 / janfrog"
!

prefic:prefix

    nodeName prefix:prefix

    "Created: / 07-04-2007 / 14:49:30 / janfrog"
!

qualifiedName:qualifiedName

    nodeName qualifiedName:qualifiedName

    "Created: / 28-06-2005 / 23:18:06 / janfrog"
!

setAttributes:attrs

    attributes := attrs.
    attributes setOwnerElement: self.

    "Created: / 04-08-2005 / 13:26:57 / janfrog"
    "Modified: / 12-11-2007 / 18:39:20 / janfrog"
!

setNodeName:aNodeName 
    nodeName := aNodeName

    "Created: / 04-08-2005 / 13:27:05 / janfrog"
! !

!Element methodsFor:'children'!

insertChild:childNode after:refNode 
    self childNodes insert:childNode after:refNode.
    self onInsertChild: childNode after: refNode.

    "Created: / 21-11-2007 / 12:04:29 / janfrog"
!

insertChild:childNode before:refNode 
    self childNodes insert:childNode before:refNode.
    self onInsertChild: childNode before: refNode.

    "Created: / 18-06-2005 / 19:32:55 / janfrog"
    "Modified: / 07-04-2007 / 11:11:09 / janfrog"
! !

!Element methodsFor:'children hooks'!

onInsertChild: childNode after: refNode

    "Created: / 21-11-2007 / 12:04:35 / janfrog"
!

onInsertChild: childNode before: refNode

    "Created: / 07-04-2007 / 11:11:32 / janfrog"
! !

!Element methodsFor:'initialization & release'!

initialize

    super initialize.
    nodeName := NodeName new.
    attributes := Attributes new setOwnerElement: self.
    children := NamedNodeMap new.

    "Created: / 16-06-2005 / 16:24:01 / janfrog"
    "Modified: / 12-11-2007 / 18:39:33 / janfrog"
! !

!Element methodsFor:'testing'!

isElement
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!Element methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitElement:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Element methodsFor:'xpath'!

/ aString

    ^children nodesWithQName: aString

    "Created: / 15-07-2010 / 12:54:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

// aString

    ^children nodesWithQName: aString recursively: true

    "Created: / 15-07-2010 / 13:40:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

@ aString

    ^attributes getValueByQualifiedName: aString

    "Created: / 15-07-2010 / 13:19:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Element class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Element.st,v 1.8 2007-11-22 21:42:03 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
