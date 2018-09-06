"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Object subclass:#Node
	instanceVariableNames:'parent userData ownerDocument'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Node class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.

    "Created: / 16-06-2005 / 16:22:56 / janfrog"
! !

!Node class methodsFor:'document position codes'!

DOCUMENT_POSITION_CONTAINED_BY

    ^16r10

    "Created: / 11-05-2005 / 18:40:56 / janfrog"
!

DOCUMENT_POSITION_CONTAINS

    ^16r08

    "Created: / 11-05-2005 / 18:40:42 / janfrog"
!

DOCUMENT_POSITION_DISCONNNECTED

    ^16r01

    "Created: / 11-05-2005 / 18:39:39 / janfrog"
!

DOCUMENT_POSITION_FOLLOWING

    ^16r04

    "Created: / 11-05-2005 / 18:40:28 / janfrog"
!

DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC

    ^16r20

    "Created: / 11-05-2005 / 18:41:11 / janfrog"
!

DOCUMENT_POSITION_PRECEDING

    ^16r02

    "Created: / 11-05-2005 / 18:40:14 / janfrog"
! !

!Node class methodsFor:'node type codes'!

ATTRIBUTE_NODE

    ^2

    "Created: / 08-05-2005 / 18:30:08 / janfrog"
!

CDATA_SECTION_NODE

    ^4

    "Created: / 08-05-2005 / 18:30:30 / janfrog"
!

COMMENT_NODE

    ^8

    "Created: / 08-05-2005 / 18:31:24 / janfrog"
!

DOCUMENT_FRAGMENT_NODE

    ^11

    "Created: / 08-05-2005 / 18:31:46 / janfrog"
!

DOCUMENT_NODE

    ^9

    "Created: / 08-05-2005 / 18:31:31 / janfrog"
!

DOCUMENT_TYPE_NODE

    ^10

    "Created: / 08-05-2005 / 18:31:38 / janfrog"
!

ELEMENT_NODE

    ^1

    "Created: / 08-05-2005 / 18:30:00 / janfrog"
!

ENTITY_NODE

    ^6

    "Created: / 08-05-2005 / 18:30:56 / janfrog"
!

ENTITY_REFERENCE_NODE

    ^5

    "Created: / 08-05-2005 / 18:30:45 / janfrog"
!

NOTATION_NODE

    ^12

    "Created: / 08-05-2005 / 18:31:56 / janfrog"
!

PROCESSING_INSTRUCTION_NODE

    ^7

    "Created: / 08-05-2005 / 18:31:12 / janfrog"
!

TEXT_NODE

    ^3

    "Created: / 08-05-2005 / 18:30:18 / janfrog"
! !

!Node methodsFor:'Compatibility-VW'!

name

    "same as localName"
    ^self localName

    "Created: / 11-05-2005 / 19:36:32 / janfrog"
!

ns

    "same as namespaceURI"
    ^self namespaceURI

    "Created: / 11-05-2005 / 19:36:48 / janfrog"
! !

!Node methodsFor:'DOM3 helpers'!

computeLookupPrefix:prefix 
    ^ self subclassResponsibility

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

domConfig

    ^self ownerDocument domConfig

    "Created: / 23-12-2005 / 20:46:39 / janfrog"
!

getElementsByTagName:localName ns:nsUri into:nodeList usingSelectBlock:selectBlock

    "Nothing to do here"

    "Created: / 25-11-2005 / 11:43:46 / janfrog"
!

postAdoptedBy:aDocument 

    self setOwnerDocument: aDocument

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    self subclassResponsibility

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

recusivelyAdoptedBy:aDocument

    self childNodes do:[:child|
        aDocument adoptNode:child.
        child childNodes recusivelyAdoptedBy:aDocument
    ]

    "Created: / 19-06-2005 / 13:49:20 / janfrog"
!

removeFromParentChildren

    self parent ifNotNil:[self parent removeChild:self]

    "Created: / 19-06-2005 / 13:27:52 / janfrog"
!

setOwnerDocument:aDocument

    "Set owner document. Should be called only by
    Document>>createXXX methods and in Document>>adoptNode:"

    ownerDocument := aDocument

    "Created: / 28-06-2005 / 22:27:07 / janfrog"
!

setOwnerDocument:aDocument recursively: aBoolean

    "Set owner document. Should be called only by
    Document>>createXXX methods and in Document>>adoptNode:"

    ownerDocument := aDocument.
    aBoolean ifTrue:
        [self childNodes do:[:child|child setOwnerDocument:aDocument recursively: aBoolean]]

    "Created: / 24-12-2005 / 11:23:55 / janfrog"
!

textContentOfChildrenOn:aStream

    (self childNodes 
        reject:[:node| node isComment or:[node isProcessingInstruction]])
        do:[:node| node textContentOn:aStream]

    "Created: / 17-06-2005 / 13:47:36 / janfrog"
!

textContentOn:aStream

    ^self subclassResponsibility

    "Created: / 17-06-2005 / 13:47:48 / janfrog"
! !

!Node methodsFor:'DOM3 interface'!

appendChild: aNode

    self insert:aNode before:nil

    "Created: / 10-05-2005 / 13:47:40 / janfrog"
    "Modified: / 18-06-2005 / 19:37:35 / janfrog"
!

attributes

    ^nil

    "Created: / 09-05-2005 / 22:30:12 / janfrog"
!

baseURI

    ^nil.

    "Created: / 17-06-2005 / 11:56:11 / janfrog"
    "Modified: / 25-11-2005 / 11:41:11 / janfrog"
!

childNodes

    ^NodeList new

    "Created: / 09-05-2005 / 22:22:24 / janfrog"
!

cloneNode:deep

    ^deep 
        ifTrue:[self deepCopy]
        ifFalse:[self copy]

    "Created: / 15-11-2005 / 11:00:20 / janfrog"
!

compareDocumentPosition:anotherNode

    ^self subclassResponsibility

    "Created: / 11-05-2005 / 18:41:55 / janfrog"
!

firstChild

    ^self childNodes firstIfEmpty: [nil]

    "Created: / 09-05-2005 / 22:22:45 / janfrog"
!

getFeature:feature version:version

    self errorNoFeatures.
    ^nil

    "Created: / 11-05-2005 / 18:50:29 / janfrog"
!

getUserDataForKey:key

    ^(self userData at:key ifAbsent:[^nil]) first

    "Created: / 11-05-2005 / 18:54:07 / janfrog"
!

hasAttributes

    ^self attributes notNil
!

hasChildNodes

    ^self childNodes notEmptyOrNil

    "Created: / 10-05-2005 / 13:49:02 / janfrog"
!

insert:newNode before:refNode

    newNode == refNode ifTrue:[^self].
    (self childNodes includesIdentical:newNode)
        ifTrue:[self removeChild:newNode].

    newNode insertYourselfBefore:refNode in:self.

    "Created: / 10-05-2005 / 13:43:36 / janfrog"
    "Modified: / 18-06-2005 / 19:41:15 / janfrog"
!

isDefaultNamespace:ns

    ^self parent ifNotNil:[
        self parent isDefaultNamespace:ns
    ] ifNil:[
        "unknown"false
    ]

    "Created: / 11-05-2005 / 18:45:44 / janfrog"
    "Modified: / 18-06-2005 / 20:32:00 / janfrog"
!

isEqualNode: anotherNode

    ^self = anotherNode

    "Created: / 11-05-2005 / 18:44:45 / janfrog"
!

isSameNode:anotherNode
    "Check node proxies, anotherNode isn't necessary the one compared."

    ^self == anotherNode

    "Created: / 11-05-2005 / 18:44:45 / janfrog"
!

isSupported: feature version: version

    ^false

    "Created: / 11-05-2005 / 18:44:45 / janfrog"
    "Modified: / 18-06-2005 / 19:49:07 / janfrog"
!

lastChild

    ^self childNodes lastIfEmpty: [nil]

    "Created: / 09-05-2005 / 22:22:55 / janfrog"
!

localName

    ^nil

    "Created: / 10-05-2005 / 13:50:31 / janfrog"
    "Modified: / 17-06-2005 / 11:53:08 / janfrog"
!

lookupNamespaceURI:ns

    ^self parent ifNotNil:[
        self parent lookupNamespaceURI:ns
    ] ifNil:[
        "unknown"false
    ]

    "Created: / 11-05-2005 / 18:45:37 / janfrog"
    "Modified: / 18-06-2005 / 21:14:38 / janfrog"
!

lookupPrefix:namespaceURI 
    namespaceURI isEmptyOrNil ifTrue:[
        ^ nil
    ].
    ^ self computeLookupPrefix:namespaceURI

    "Created: / 11-05-2005 / 18:45:08 / janfrog"
    "Modified: / 18-06-2005 / 21:13:11 / janfrog"
!

namespaceURI

    ^nil

    "Created: / 10-05-2005 / 13:49:58 / janfrog"
    "Modified: / 17-06-2005 / 11:52:02 / janfrog"
!

nextSibling

    | pos |
    ^(pos := self position) = (self parentNode childNodes size)
        ifTrue:[nil]
        ifFalse:[self parentNode childNodes at:pos + 1]

    "Created: / 09-05-2005 / 22:26:29 / janfrog"
!

nodeName

    ^self subclassResponsibility

    "Created: / 08-05-2005 / 18:37:13 / janfrog"
!

nodeType

    ^self subclassResponsibility

    "Created: / 08-05-2005 / 18:37:13 / janfrog"
!

nodeValue

    ^nil

    "Created: / 08-05-2005 / 18:37:13 / janfrog"
!

nodeValue:value

    "Nothing to do"

    "Created: / 17-06-2005 / 12:08:06 / janfrog"
!

normalize

    self subclassResponsibility
!

ownerDocument

    ^ownerDocument

    "Created: / 10-05-2005 / 13:40:12 / janfrog"
    "Modified: / 28-06-2005 / 22:18:33 / janfrog"
!

parentNode

    ^self parent

    "Created: / 09-05-2005 / 22:26:02 / janfrog"
!

prefix

    ^nil

    "Created: / 10-05-2005 / 13:50:11 / janfrog"
    "Modified: / 17-06-2005 / 12:09:40 / janfrog"
!

prefix: aString

    "Created: / 10-05-2005 / 13:50:11 / janfrog"
    "Modified: / 17-06-2005 / 12:09:55 / janfrog"
!

previousSibling

    | pos |
    ^(pos := self position) = 1
        ifTrue:[nil]
        ifFalse:[self parentNode childNodes at:pos - 1]

    "Created: / 09-05-2005 / 22:25:57 / janfrog"
!

removeChild:node

    ^self childNodes remove:node

    "Created: / 10-05-2005 / 13:47:22 / janfrog"
    "Modified: / 18-06-2005 / 20:01:21 / janfrog"
!

replaceChild:oldNode with:newNode

    | idx |
    idx := self childNodes identityIndexOf:oldNode.
    idx isZero not ifTrue:[self childNodes at:idx put:newNode].
    ^oldNode

    "Created: / 10-05-2005 / 13:47:00 / janfrog"
    "Modified: / 18-06-2005 / 20:03:25 / janfrog"
!

setUserData:userData handler:handler forKey:key

    self userData at:key put:(Array with:userData with:handler)

    "Created: / 11-05-2005 / 18:53:36 / janfrog"
!

textContent

    | textContentStream |
    textContentStream := UnicodeString new writeStream.
    self textContentOn:textContentStream.
    ^textContentStream contents

    "Created: / 11-05-2005 / 18:42:10 / janfrog"
    "Modified: / 17-06-2005 / 13:53:05 / janfrog"
! !

!Node methodsFor:'DOM3 interface - extensions'!

cloneNode

    ^self copy

    "Created: / 10-05-2005 / 13:49:32 / janfrog"
    "Modified: / 17-06-2005 / 14:37:43 / janfrog"
!

cloneNodeDeep

    ^self deepCopy

    "Created: / 10-05-2005 / 13:49:39 / janfrog"
!

expandedName

    ^self namespaceURI ifNil:[
        self namespaceURI , '#' , self localName
    ] ifNotNil:[
        self localName
    ]

    "Created: / 11-05-2005 / 19:34:34 / janfrog"
!

qualifiedName

    ^(self prefix notNil and:[self prefix notEmpty]) ifTrue:[
        self prefix , ':' , self localName
    ] ifFalse:[
        self localName
    ]

    "Created: / 11-05-2005 / 19:32:54 / janfrog"
    "Modified: / 21-05-2006 / 10:05:32 / janfrog"
! !

!Node methodsFor:'accessing'!

parent
    ^ parent

    "Created: / 09-05-2005 / 22:27:27 / janfrog"
!

position

    ^self parentNode childNodes identityIndexOf:self

    "Created: / 09-05-2005 / 22:27:10 / janfrog"
!

userData

    "User data is represented as dictionary 
        key -> Array with:userData with:handler"

    userData ifNil:[userData := Dictionary new].
    ^userData

    "Created: / 11-05-2005 / 18:48:19 / janfrog"
! !

!Node methodsFor:'children'!

insertChild:newNode after:refNode 
    self domError:(self class nameWithoutPrefix) asString 
                , ' cannot contain children'
        code:#'HIERARCHY_REQUEST_ERR'

    "Created: / 18-06-2005 / 21:49:42 / janfrog"
!

insertChild:newNode before:refNode 
    self domError:(self class nameWithoutPrefix) asString 
                , ' cannot contain children'
        code:#'HIERARCHY_REQUEST_ERR'

    "Created: / 18-06-2005 / 19:32:55 / janfrog"
!

insertYourselfBefore:refNode in:parentNode 

    parentNode insertChild:self before:refNode.
    parent := parentNode.
    ownerDocument := parentNode ownerDocument

    "Created: / 18-06-2005 / 19:32:23 / janfrog"
    "Modified: / 23-12-2005 / 21:05:17 / janfrog"
! !

!Node methodsFor:'comparing'!

= anotherNode
    "Fixed: check that anotherNode understands to #nodeType
     This prevents program to fail when comparing with different objects.
     MP
    "
    ^ (anotherNode respondsTo: #nodeType) and:
      [(self nodeType = anotherNode nodeType) and:
        [(self nodeName = anotherNode nodeName) and:
            [(self localName = anotherNode localName) and:
                [(self namespaceURI = anotherNode namespaceURI) and:
                    [(self prefix = anotherNode prefix) and:
                        [(self nodeValue = anotherNode nodeValue) and:
                            [(self attributes = anotherNode attributes) and:
                                [(self childNodes = anotherNode childNodes)
                                    ]]]]]]]]

    "Created: / 18-06-2005 / 19:56:02 / janfrog"
    "Modified: / 08-04-2009 / 00:50:10 / Martin Plicka <plickm1@fel.cvut.cz>"
!

hash

    ^(self nodeType hash) bitXor:
        (self nodeName hash bitXor:
            (self localName hash bitXor:
                (self namespaceURI hash bitXor:
                    (self prefix hash bitXor:
                        (self nodeValue hash bitXor:
                            (self attributes hash bitXor:
                                (self childNodes hash)))))))

    "Created: / 18-06-2005 / 19:53:07 / janfrog"
! !

!Node methodsFor:'debugging'!

inspector2Tab

    ^self newInspector2Tab
        label: 'XML';
        priority: 75;
        application: (DOM3Inspector on: self)

    "Created: / 10-01-2010 / 10:16:24 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

inspectorExtraAttributes

    ^Dictionary new
        at:'-xml' put:[self asXMLString];
        yourself

    "Created: / 23-12-2005 / 20:27:31 / janfrog"
! !

!Node methodsFor:'error reporting'!

domError:description code:code

    DOMException new
        messageText:description;
        code:code;
        raise

    "Created: / 17-06-2005 / 12:01:53 / janfrog"
!

errorNoFeatures

    self error: 'DOM features not supported yet'
!

errorNotSupported

    self 
        domError: 'Adopting of such node is not supported'
        code: DOMException NOT_SUPPORTED_ERR

    "Created: / 24-12-2005 / 10:49:34 / janfrog"
! !

!Node methodsFor:'initialization & release'!

initialize

    "nothing to do"

    "Created: / 16-06-2005 / 16:23:24 / janfrog"
!

setParentNode: aNode

    parent := aNode

    "Created: / 25-12-2005 / 10:24:41 / janfrog"
! !

!Node methodsFor:'native interface'!

doesNotUnderstand: aMessage

    | nodes |

    nodes := self childNodes nodesWithLocalName:aMessage selector.
    nodes isEmpty ifTrue:[^super doesNotUnderstand: aMessage].
    nodes size = 1 ifTrue:[^nodes first].
    ^nodes

    "Created: / 11-11-2006 / 09:06:55 / janfrog"
! !

!Node methodsFor:'notification'!

notifyUserHandlersAbout:operation destinationNode:dstNode 

    userData ifNotNil:[
        userData keysAndValuesDo:[:key :dataAndHandler | 
            dataAndHandler second 
                handleOperation:operation
                key:key
                data:dataAndHandler first
                sourceNode:self
                destinationNode:dstNode
       ]
    ]

    "Created: / 25-12-2005 / 10:10:30 / janfrog"
!

notifyUserHandlersAboutNodeAdopted:dstNode 

    self 
        notifyUserHandlersAbout:UserDataHandler NODE_ADOPTED
        destinationNode: dstNode

    "Created: / 25-12-2005 / 10:14:00 / janfrog"
!

notifyUserHandlersAboutNodeCloned:dstNode 

    self 
        notifyUserHandlersAbout:UserDataHandler NODE_CLONED
        destinationNode: dstNode

    "Created: / 25-12-2005 / 10:13:39 / janfrog"
!

notifyUserHandlersAboutNodeImported:dstNode 

    self 
        notifyUserHandlersAbout:UserDataHandler NODE_IMPORTED
        destinationNode: dstNode

    "Created: / 25-12-2005 / 10:13:49 / janfrog"
! !

!Node methodsFor:'testing'!

isAttr
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isCDATASection
    ^ false

    "Created: / 05-08-2005 / 14:28:34 / janfrog"
!

isCharacterData
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isComment

    ^false

    "Created: / 08-05-2005 / 18:38:09 / janfrog"
    "Modified: / 05-08-2005 / 14:29:12 / janfrog"
!

isDocument
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isDocumentFragment
    ^ false

    "Modified: / 05-08-2005 / 14:27:51 / janfrog"
!

isDocumentType
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isElement
    ^ false

    "Modified: / 05-08-2005 / 14:27:51 / janfrog"
!

isEntity
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isEntityReference
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isIgnorableText

    ^false

    "Created: / 07-04-2007 / 15:29:52 / janfrog"
!

isNotation
    ^ false

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
!

isProcessingInstruction
    ^ false

    "Modified: / 05-08-2005 / 14:27:51 / janfrog"
!

isText

    ^false

    "Created: / 08-05-2005 / 18:39:14 / janfrog"
    "Modified: / 05-08-2005 / 14:28:56 / janfrog"
! !

!Node methodsFor:'utilities'!

asColorXMLString
    |stream reader writer|

    stream := (Smalltalk at:#Text) new writeStream.
    reader := DOM3XMLReader new.
    writer := IndentingAndHighlightingXMLWriter on:stream.
    reader setContentHandler:writer.
    reader parseNode:self.
    ^ stream contents

    "Created: / 12-12-2006 / 00:44:37 / janfrog"
!

asXMLString
    |stream|

    stream := UnicodeString new writeStream.
    self xmlPrintOn: stream.
    ^ stream contents

    "Created: / 23-12-2005 / 20:25:08 / janfrog"
    "Modified: / 17-10-2007 / 08:32:52 / janfrog"
    "Modified: / 29-03-2009 / 18:23:57 / Martin Plicka <plickm1@fel.cvut.cz>"
!

xmlPrintOn:stream 
    |reader writer|

    reader := DOM3XMLReader new.
    writer := IndentingXMLWriter on:stream.
    reader setContentHandler:writer.
    reader parseNode:self.

    "Modified: / 17-10-2007 / 08:32:52 / janfrog"
    "Created: / 29-03-2009 / 18:22:02 / Martin Plicka <plickm1@fel.cvut.cz>"
! !

!Node methodsFor:'xpath support'!

xpathAt: xpathExpressionString

    |  |
    self halt.

    "Created: / 11-11-2006 / 08:57:34 / janfrog"
! !

!Node class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Node.st,v 1.10 2007/10/17 13:19:32 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
