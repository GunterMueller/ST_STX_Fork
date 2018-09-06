"{ Package: 'stx:goodies/xmlsuite/core' }"

"{ NameSpace: XMLv2 }"

Node subclass:#Document
	instanceVariableNames:'documentType children documentElement inputEncoding standalone
		domConfig xmlVersion'
	classVariableNames:''
	poolDictionaries:''
	category:'XML Suite-DOM3'
!


!Document methodsFor:'DOM3 helpers'!

computeLookupPrefix:arg 
    "Superclass says that I am responsible to implement this method"
    
    self shouldImplement

    "Created: / 18-06-2005 / 21:13:11 / janfrog"
!

postAdoptedBy:aDocument 

    self errorNotSupported

    "Created: / 25-12-2005 / 10:15:19 / janfrog"
!

postImportBy:aDocument deep:aBoolean 
    ^ self errorNotSupported

    "Created: / 25-12-2005 / 11:01:36 / janfrog"
!

recursivelyAdoptNode: aNode 

    self adoptNode: aNode.
    aNode childNodes do:
        [:child|self recursivelyAdoptNode: child]

    "Created: / 25-12-2005 / 10:30:58 / janfrog"
!

setDocumentType: aDocumentType
    documentType := aDocumentType.
    self childNodes addFirst: aDocumentType.
!

textContentOn:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
! !

!Document methodsFor:'DOM3 interface'!

adoptNode:aNode 
    aNode isNil ifTrue:[^ self errorNotSupported].

    aNode 
        notifyUserHandlersAboutNodeAdopted:self;
        removeFromParentChildren;
        postAdoptedBy:self.

    ^aNode

    "Created: / 19-06-2005 / 13:27:04 / janfrog"
    "Modified: / 25-12-2005 / 11:29:31 / janfrog"
!

childNodes

    ^children

    "Created: / 18-06-2005 / 19:44:37 / janfrog"
!

compareDocumentPosition:arg 
    "Superclass says that I am responsible to implement this method"

    self shouldImplement

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
!

createAttribute:localName

    ^Attr new
        localName:localName;
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:38:26 / janfrog"
!

createAttribute:qualifiedName ns:ns

    ^Attr new
        qualifiedName:qualifiedName;
        ns:ns;
        nodeValue:'';
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:39:34 / janfrog"
!

createCDATASection:aString

    ^CDATASection new
        data:aString;
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:40:53 / janfrog"
!

createComment:aString

    ^Comment new
        data:aString;
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:42:06 / janfrog"
!

createDocumentFragment

    ^DocumentFragment new
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:42:37 / janfrog"
    "Modified: / 10-08-2005 / 22:26:44 / janfrog"
!

createDocumentType: qualifiedName publicId:publicId systemId: systemId


    ^self shouldImplement

    "Created: / 15-11-2005 / 12:08:14 / janfrog"
!

createElement:localName

    ^Element new
        qualifiedName:localName;
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:43:20 / janfrog"
    "Modified: / 24-12-2005 / 10:57:00 / janfrog"
!

createElement:qualifiedName ns:ns

    ^Element new
        qualifiedName:qualifiedName;
        ns:ns;
        setOwnerDocument:self

    "Created: / 28-06-2005 / 22:43:30 / janfrog"
!

createEntityReference:aString

    ^EntityReference new
        setOwnerDocument: self;
        "appendChild:
            (Entity new
                setOwnerDocument:self;
                setNotationName: aString)"
        yourself

    "Created: / 24-12-2005 / 10:28:53 / janfrog"
    "Modified: / 25-12-2005 / 11:12:24 / janfrog"
!

createProcessingInstruction:target data:data

    ^ProcessingInstruction new
        target:target;
        data:data;
        setOwnerDocument:self

    "Created: / 10-08-2005 / 22:26:26 / janfrog"
!

createTextNode:aString

    ^Text new
        data:aString;
        setOwnerDocument:self

    "Created: / 25-10-2005 / 17:18:34 / janfrog"
!

doctype

    ^documentType

    "Created: / 19-06-2005 / 13:17:53 / janfrog"
!

documentElement

    ^documentElement

    "Created: / 19-06-2005 / 13:18:44 / janfrog"
!

documentURI

    self see:'Dodelat'.
    ^nil "for now"

    "Created: / 19-06-2005 / 13:19:14 / janfrog"
    "Modified: / 25-10-2005 / 17:12:04 / janfrog"
!

domConfig

    ^domConfig

    "Created: / 10-08-2005 / 22:25:03 / janfrog"
!

getElementsByTagName:localName

    ^self getElementsByTagName:localName ns:nil

    "Created: / 24-08-2005 / 12:22:55 / janfrog"
    "Modified: / 25-11-2005 / 12:07:33 / janfrog"
!

getElementsByTagName:localName ns:ns


    ^self documentElement getElementsByTagName:localName ns:ns

    "Created: / 24-08-2005 / 12:23:02 / janfrog"
    "Modified: / 25-11-2005 / 12:08:20 / janfrog"
!

implementation

    ^XMLSuiteDOM3Implementation default

    "Created: / 19-06-2005 / 13:18:18 / janfrog"
    "Modified: / 19-06-2005 / 15:33:58 / janfrog"
!

importNode:aNode deep:aBoolean 
    |newNode|

    newNode := aNode shallowCopy.
    newNode postImportBy:self deep:aBoolean.
    aNode notifyUserHandlersAboutNodeImported:newNode.
    ^ newNode

    "Created: / 15-11-2005 / 11:51:53 / janfrog"
    "Modified: / 25-12-2005 / 11:01:36 / janfrog"
!

inputEncoding

    ^inputEncoding

    "Created: / 19-06-2005 / 13:20:47 / janfrog"
!

isDefaultNamespace:ns

    ^ self documentElement isDefaultNamespace:ns

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

lookupNamespaceURI:ns

    ^self documentElement lookupNamespaceURI:ns

    "Created: / 18-06-2005 / 20:18:17 / janfrog"
!

nodeName

    ^'#document'

    "Created: / 17-06-2005 / 11:29:59 / janfrog"
!

nodeType

    ^Node DOCUMENT_NODE

    "Created: / 17-06-2005 / 11:43:57 / janfrog"
!

normalize
    "Superclass says that I am responsible to implement this method"

    self childNodes do:
        [:child|child normalize]

    "Created: / 18-06-2005 / 20:18:16 / janfrog"
    "Modified: / 23-12-2005 / 20:43:15 / janfrog"
!

normalizeDocument

    self normalize

    "Created: / 28-12-2005 / 16:48:59 / janfrog"
!

ownerDocument

    ^self

    "Created: / 17-06-2005 / 11:57:19 / janfrog"
    "Modified: / 23-12-2005 / 21:07:25 / janfrog"
!

parentNode

    ^self domError:'Document has no parent' code:#NOT_SUPPORTED_ERR

    "Created: / 17-06-2005 / 12:04:31 / janfrog"
!

renameNode: node namespaceUri: nsURI qualifiedName: qName

    ^self shouldImplement

    "Created: / 15-11-2005 / 12:34:19 / janfrog"
!

replaceChild: oldNode with: newNode

(oldNode nodeType = Node DOCUMENT_TYPE_NODE) ifTrue: [documentType := newNode].

^ super replaceChild: oldNode with: newNode.
!

strictErrorChecking

    ^true

    "Created: / 19-06-2005 / 13:21:06 / janfrog"
!

strictErrorChecking:aBoolean

    aBoolean ifFalse:[
        self error:'strictErrorChecking cannot be set to false'
    ]

    "Created: / 19-06-2005 / 13:22:00 / janfrog"
!

xmlEncoding

    ^self inputEncoding

    "Created: / 19-06-2005 / 13:22:54 / janfrog"
!

xmlStandalone

    ^standalone

    "Created: / 19-06-2005 / 13:23:24 / janfrog"
!

xmlVersion

    ^xmlVersion

    "Created: / 19-06-2005 / 13:24:17 / janfrog"
    "Modified: / 28-12-2005 / 16:18:14 / janfrog"
! !

!Document methodsFor:'children'!

insertChild:childNode after:refNode

    childNode isElement ifTrue:[
        documentElement ifNil:[
            documentElement := childNode
        ] ifNotNil:[
            ^self 
                domError:'Cannot insert second root element'
                code:#HIERARCHY_REQUEST_ERR                
        ]
    ].       
    refNode 
        ifNil:[self childNodes addLast:childNode]
        ifNotNil:[self childNodes insert:childNode after:refNode]

    "Created: / 21-11-2007 / 12:04:06 / janfrog"
!

insertChild:childNode before:refNode

    childNode isElement ifTrue:[
        documentElement ifNil:[
            documentElement := childNode
        ] ifNotNil:[
            ^self 
                domError:'Cannot insert second root element'
                code:#HIERARCHY_REQUEST_ERR                
        ]
    ].       
    refNode 
        ifNil:[self childNodes addLast:childNode]
        ifNotNil:[self childNodes insert:childNode before:refNode]

    "Created: / 18-06-2005 / 19:43:47 / janfrog"
!

insertYourselfAfter:refNode in:parentNode 
    self childNodes do:[:childNode | 
        parentNode insertChild:childNode after:refNode
    ]

    "Created: / 21-11-2007 / 10:58:03 / janfrog"
!

insertYourselfBefore:refNode in:parentNode 
    self childNodes do:[:childNode | 
        parentNode insertChild:childNode before:refNode
    ]

    "Created: / 20-09-2007 / 12:25:01 / janfrog"
! !

!Document methodsFor:'initialization'!

initialize

    super initialize.
    children := NodeList new.
    domConfig := DOMConfiguration new.
    xmlVersion := '1.0'

    "Created: / 18-06-2005 / 19:44:25 / janfrog"
    "Modified: / 28-12-2005 / 16:18:14 / janfrog"
!

setInputEncoding: aString

    inputEncoding := aString

    "Created: / 28-12-2005 / 16:18:14 / janfrog"
!

setStandalone: aBoolean

    standalone := aBoolean

    "Created: / 28-12-2005 / 16:18:14 / janfrog"
!

setXmlVersion: aString

    xmlVersion := aString

    "Created: / 28-12-2005 / 16:18:14 / janfrog"
! !

!Document methodsFor:'testing'!

isDocument
    ^ true

    "Created: / 05-08-2005 / 14:27:51 / janfrog"
! !

!Document methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitDocument:self

    "Created: / 05-08-2005 / 13:09:35 / janfrog"
! !

!Document methodsFor:'xpath'!

/ aString

    ^documentElement qualifiedName = aString 
        ifTrue:[NodeList with: documentElement]
        ifFalse:[NodeList new].

    "Created: / 15-07-2010 / 12:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

// aString

    ^NodeList streamContents:
        [:nodeStream|
        documentElement qualifiedName = aString 
            ifTrue:[nodeStream nextPut: documentElement].
        documentElement childNodes
            nodesWithQName: aString on: nodeStream recursively: true].

    "Created: / 15-07-2010 / 12:43:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Document class methodsFor:'documentation'!

version
    ^ '$Header: /opt/data/cvs/stx/goodies/xmlsuite/XMLv2__Document.st,v 1.9 2007-11-22 21:41:43 vranyj1 Exp $'
!

version_SVN
    ^ '$Id$'
! !
