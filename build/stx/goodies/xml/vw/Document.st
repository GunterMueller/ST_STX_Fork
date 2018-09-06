"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Document
	instanceVariableNames:'root nodes xmlVersion dtd ids'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Document comment:'This class represents an XML document entity and serves as the root of the document entity tree. Each XML document has one entity (root) called the document entity, which serves as the starting point for the XML processor and may contain the whole document (nodes collection). 

According to the XML 1.0 specification, XML documents may and should begin with an XML declaration which specifies the version of XML (xmlVersion instance variable) being used. 

The XML document type declaration which must appear before the first element in a document contains or points to markup declarations that provide the grammar for this document. This grammar is known as document type definition (dtd instance variable). An XML document is valid if it has an associated document type declaration and if the document complies with the constraints expressed in it. If the document type declaration is not present, the document can be at most well formed.

Instance Variables:
	root    <XML.Node>  
	nodes   <Collection>  
	xmlVersion      <String>  
		Version of the XML specification to which the document is conformant
	dtd     <XML.DocumentType>
		Associated document type definition 
	ids     <Dictionary>  
'
!


!Document class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!Document methodsFor:'IDs'!

atID: key ifAbsent: aBlock

	^ids at: key ifAbsent: aBlock
!

registerID: attribute from: aParser

	(ids includesKey: attribute value)
		ifTrue: [aParser invalid: ('The id "<1s>" was used more than once' expandMacrosWith: attribute value)].
	ids at: attribute value put: attribute.
	aParser resolveIDREF: attribute value
!

updateIDs

	| attr |
	ids keys do: [:key |
		attr := ids at: key.
		(attr isAttribute and: [attr value = key])
			ifFalse: [self error: 'Attempt to update the ID dictionary twice'].
		ids at: key put: attr parent].
! !

!Document methodsFor:'accessing'!

/ elementName
    "XPath like access to the root element"

    (root notNil and:[elementName = '*' or:[root tag isLike:elementName]]) ifTrue:[
        ^ NodeSet with:root
    ].

    ^ NodeSet new.
!

// elementName
    "XPath like access to all subelements named elementName"

    |nodeSet|

    nodeSet := NodeSet new.

    root notNil ifTrue:[
        (elementName = '*' or:[root tag isLike:elementName]) ifTrue:[
            nodeSet add:root.
        ].
        root addAllElementsNamed:elementName to:nodeSet.
    ].

    ^ nodeSet.
!

addNamespaceDefinitions

	| d tag |
	d := Dictionary new.
	self nodesDo: [:aNode |
		tag := aNode tag.
		tag isNil
			ifFalse:
				[(d at: tag qualifier ifAbsent: [tag namespace]) = tag namespace
					ifFalse: [self error: 'Using the same tag for multiple namespaces is not currently supported'].
				d at: tag qualifier put: tag namespace]].
	(d at: '' ifAbsent: ['']) = ''
		ifTrue: [d removeKey: '' ifAbsent: []].
	d removeKey: 'xml' ifAbsent: [].
	d removeKey: 'xmlns' ifAbsent: [].
	self root namespaces: d
!

addNode: aNode

	nodes add: aNode.
	aNode parent: self.
	aNode isElement
		ifTrue: [root == nil
			ifTrue: [root := aNode]
			ifFalse: [self error: 'It is illegal to have more than one element node at the top level in a document']]
!

document

	^self
!

dtd

	^dtd
!

dtd: aDTD

	dtd := aDTD
!

elements

	^nodes
!

pathName

    ^ ''
!

root

	^root
!

selectNodes: aBlock

	^nodes select: aBlock
!

xmlVersion
    ^ xmlVersion
!

xmlVersion: aString

	xmlVersion := aString
! !

!Document methodsFor:'comparing'!

= anXmlDocument
    ^ self == anXmlDocument
        or:[anXmlDocument isDocument 
            and:[nodes = anXmlDocument elements
            and:[xmlVersion = anXmlDocument xmlVersion]]]
!

hash
    ^ nodes hash
! !

!Document methodsFor:'copying'!

cloneTree
    "answer a copy of the tree, so that removal of child elements
     from the copy does not affect the original node."

    |clone|

    clone := self shallowCopy.
    nodes notNil ifTrue:[
        clone addAll:(nodes collect:[:eachElement| eachElement cloneTree]).
    ].
    ^ clone
! !

!Document methodsFor:'enumerating'!

nodesDo: aBlock

        aBlock value: self.
        self elements do: [:el |
                el nodesDo: aBlock]

    "Modified: / 13-09-2007 / 17:29:09 / cg"
!

nodesReverseDo: aBlock

        aBlock value:self.
        self elements reverseDo: [:el |
                el nodesReverseDo:aBlock
        ]
!

treePosition
    "answer a SequencableCollection which holds the position of the node
     in the document tree"

    ^ #().
! !

!Document methodsFor:'flags'!

hasDTD

	^(self flags bitAnd: 16r100) = 16r100
!

hasExternalDTD

	^(self flags bitAnd: 16r200) = 16r200
!

noteDTD

	self flags: (self flags bitOr: 16r100)
!

noteExternalDTD

	self flags: (self flags bitOr: 16r200)
!

notePEReference

	self flags: (self flags bitOr: 16r400)
!

usesParameterEntities

	^(self flags bitAnd: 16r400) = 16r400
! !

!Document methodsFor:'initialization'!

initialize
    nodes := OrderedCollection new.
    ids := Dictionary new.
! !

!Document methodsFor:'printing'!

prettyPrintOn: aStream
    self printHeaderOn:aStream.
    nodes do: [:n | n prettyPrintOn: aStream. aStream cr]
!

printCanonicalOn: aStream
    "/ no version header in canonical XML;
    "/ see https://www.w3.org/TR/2001/REC-xml-c14n-20010315
    "/ self printHeaderOn:aStream.

    nodes do: [:n | n printCanonicalOn: aStream]
!

printHTMLOn: aStream
    self printHeaderOn:aStream.
    nodes do: [:n | n printHTMLOn: aStream]
!

printHeaderOn:aStream
    xmlVersion notNil ifTrue:[
        aStream 
            nextPutAll:'<?xml version="';
            nextPutAll:xmlVersion;
            nextPutAll:'"?>';
            cr.
    ].
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock
    self printHeaderOn:aStream.
    nodes do: [:n | n printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock]
!

printOn: aStream
    self printHeaderOn:aStream.
    nodes do: [:n | n printOn: aStream]
! !

!Document methodsFor:'private helpers'!

treePositionOf:aNode
    "return a collection containing the position of the node in the document"

    ^ IntegerArray with:(nodes identityIndexOf:aNode ifAbsent:[0]).
! !

!Document methodsFor:'testing'!

hasSubNodes

	^nodes size > 0
!

isContent

	^true
!

isDocument

	^true
!

verifyContents

	root verifyContents
! !

!Document methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitDocument:self
! !

!Document class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Document.st,v 1.19 2018-02-15 13:55:34 cg Exp $'
! !

