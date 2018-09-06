"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#Node
	instanceVariableNames:'parent flags treePosition'
	classVariableNames:'CanonCharacterTable'
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Node comment:'An XML.Node represents a logical component of an XML Document. Logically, the
document is composed of declarations, elements, comments, character references, and 
processing instructions, all of which are indicated in the document by explicit markup. 
The various subclasses of XML.Node represent these various components.

Subclasses must implement the following messages:
        printing
                printCanonicalOn:
                printHTMLOn:
                printNoIndentOn:endSpacing:spacing:

Instance Variables:
        parent  <XML.Node | nil> 
        flags   <SmallInteger> 
'
!


!Node methodsFor:'Twoflower'!

isHTMLBodyElement

	^ false
! !

!Node methodsFor:'accessing'!

children
    "Visualworks uses the method #children to do essentially the same as elements.
    I suppose children may be the better name."
    ^ self elements
!

discard

    "speed up common cases"
    (flags isNil or:[flags == 0]) ifTrue:[
        flags := 1.
    ] ifFalse:[
        flags := flags bitOr:1.
    ].
!

document

        ^parent document
!

elements
    "Visualworks uses the method #children to do essentially the same as this. Does not do much though"
    self shouldNotImplement
!

expandedName

        ^''
!

flags
    flags isNil ifTrue:[^ 0].
    ^ flags
!

flags: flagBits

        flags := flagBits
!

parent

        ^parent
!

parent: aNode

        parent := aNode
!

pathName
    "answer the path name of this node"

    |parentPathName tagType|

    tagType := self tag type.

    parentPathName := parent pathName.

    parentPathName size == 0 ifTrue:[
        ^ tagType.
    ].
    ^ parentPathName, '.', tagType

    "Modified: / 20-04-2005 / 11:41:13 / cg"
!

selectNodes: aBlock

        ^#()
!

tag

        ^nil
!

unDiscard
    "clear the discard flag"

    "speed up common cases"
    flags isNil ifTrue:[
        ^ self.
    ].

    flags == 1 ifTrue:[
        flags := nil.
    ] ifFalse:[
        flags := flags bitClear:1.
    ].
! !

!Node methodsFor:'copy'!

cloneTree
    "answer a copy of the tree, so that removal of child elements
     from the copy does not affect the original node.

     Make a shallowCopy to protect the parent"

    ^ self shallowCopy
! !

!Node methodsFor:'enumerating'!

elementsDo: aBlock
    "/ intentionally left blank

    "Created: / 13-09-2007 / 17:28:24 / cg"
!

nodesDo: aBlock

        aBlock value: self
!

nodesReverseDo: aBlock

        aBlock value: self
!

treePosition
    "answer a SequencableCollection which holds the position of the node
     in the document tree"

    treePosition isNil ifTrue:[
        treePosition := parent treePositionOf:self.
    ].

    ^ treePosition
! !

!Node methodsFor:'inspecting'!

inspector2TabTree
    "extra tab to be shown in an inspector2."

    |sub|

    XML::XMLInspector isNil ifTrue:[^ nil ].

    sub := XML::XMLInspector embeddableInspectorApplicationFor:self.

    ^ self newInspector2Tab
        label: 'DOM';
        priority: 75;
        view: sub

    "Created: / 18-08-2011 / 11:54:07 / cg"
!

inspector2Tabs
    "extra tab to be shown in an inspector2."

    ^ super inspector2Tabs , #( inspector2TabTree )

    "Created: / 18-08-2011 / 11:49:55 / cg"
!

inspectorExtraAttributes
    "extra (pseudo instvar) entries to be shown in an inspector."

    ^ super inspectorExtraAttributes
        add:('- >> inspect tree <<' -> [ XML::XMLInspector openOn:self. self ]);
        yourself

    "Created: / 17-11-2010 / 19:05:26 / cg"
! !

!Node methodsFor:'namespaces'!

findNamespaceAt: qualifier

        | ns node |
        qualifier = 'xml' ifTrue: [^XML_URI].
        ns := nil.
        node := self.
        [node isElement and: [ns == nil]]
                whileTrue:
                        [ns := node namespaceAt: qualifier.
                        node := node parent].
        ^ns
!

findQualifierAtNamespace: ns

        | qual node |
        qual := nil.
        node := self.
        [node isElement and: [qual == nil]]
                whileTrue:
                        [qual := node qualifierAtNamespace: ns.
                        node := node parent].
        ^qual
!

namespaceAt: qualifier

        ^nil
!

qualifierAtNamespace: ns

        ^nil
! !

!Node methodsFor:'printing & storing'!

canonCharacterTable
        CanonCharacterTable isNil ifTrue:[
            CanonCharacterTable := Dictionary new.
            CanonCharacterTable 
                    at: Character cr put: '&#xD;';  "/ http:www.w3.org/TR/2001/REC-xml-c14n-20010315#Page.10 (Attribute nodes)
                    at: Character lf put: '&#xA;';
                    at: Character tab put: '&#9;';
                    at: $& put: '&amp;';
                    at: $< put: '&lt;';
                    at: $> put: '&gt;';
                    at: $" put: '&quot;'.
            (Smalltalk isSmalltalkX) ifTrue:[
                CanonCharacterTable at:(Character return) put: '&#xD;'
            ].
        ].
        ^ CanonCharacterTable
!

canonicalPrintString
        | s |

        s := (String new:128) writeStream.
        self printCanonicalOn: s.
        ^s contents
!

displayOn:aGCOrStream

    "/ what a kludge - Dolphin and Squeak mean: printOn: a stream;
    "/ old ST80 means: draw-yourself on a GC.
    aGCOrStream isStream ifFalse:[
        ^ super displayOn:aGCOrStream.
    ].

    self prettyPrintOn:aGCOrStream.

    "Modified (comment): / 22-02-2017 / 16:48:18 / cg"
!

noIndentPrintString
        | s |

        s := (String new: 1024) writeStream.
        self printNoIndentOn: s.
        ^s contents

    "Modified: / 21-01-2011 / 13:56:10 / cg"
!

prettyPrintColorizedOn: aStream
    self prettyPrintOn: aStream

    "Created: / 17-02-2011 / 14:27:18 / cg"
!

prettyPrintColorizedOn: aStream depth:indent
    self prettyPrintOn: aStream depth:indent

    "Created: / 17-02-2011 / 14:15:19 / cg"
!

prettyPrintOn: aStream
    self prettyPrintOn: aStream depth: 0 
!

prettyPrintOn: aStream depth:indent
    "self subclassResponsibility"
!

printCanonical:text on:aStream 
    "Print myself on the stream in the form described by 
     James Clark's canonical XML."

    self printCanonical:text withEscapedLineFeeds:true on:aStream
!

printCanonical:text withEscapedLineFeeds:withEscapedLineFeeds on:aStream 
    "Print myself on the stream in the form described by 
     James Clark's canonical XML."

    | d |

    d := self canonCharacterTable.
    text do:[:c |  
        |translatedChar|

        (c ~~ Character nl or:[withEscapedLineFeeds]) ifTrue:[        
            translatedChar := d at:c ifAbsent:[].
        ].
        translatedChar isNil ifTrue:[
            aStream nextPut:c.
        ] ifFalse:[
            aStream nextPutAll:translatedChar.
        ].
    ]
!

printCanonicalOn: aStream
        "Print myself on the stream in the form described by James
        Clark's canonical XML."

        self subclassResponsibility
!

printHTMLOn: aStream
        "Print myself on the stream in a form usual for HTML."

        self subclassResponsibility
!

printNoIndentOn: aStream
        "Print myself on the stream with line breaks between adjacent
        elements, but no indentation."

        self printNoIndentOn: aStream
                endSpacing: [:node :list | aStream cr]
                spacing: [:node :list | aStream cr]
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock
        "Print myself on the stream with line breaks between adjacent
        elements, but no indentation."

        self subclassResponsibility
!

printOn: aStream
    "/ self printAsOneLineOn: aStream
    self prettyPrintOn: aStream

    "Modified: / 21-01-2011 / 13:55:36 / cg"
!

simpleDescription

        ^self printString
!

storeOn: aStream
    "blocked: ascii storeString not possible (recursive - element - children - parent)"

    self shouldNotImplement
! !

!Node methodsFor:'queries'!

hasAncestor: aNode

        | p |
        p := self parent.
        [p == nil] whileFalse:
                [p == aNode ifTrue: [^true].
                p := p parent].
        ^false
!

hasSubNodes

        ^false
!

precedes:aNode 
    |n1 n1P n2 n2P myDocument|

    myDocument := self document.
    aNode document == myDocument ifFalse:[
        self error:'These nodes can''t be ordered. They are not in the same document.'
    ].
    aNode == myDocument ifTrue:[^ false].
    self == myDocument ifTrue:[^ true].

    n1 := self.
    n2 := aNode.
    (n2 hasAncestor:n1) ifTrue:[^ true].
    (n1 hasAncestor:n2) ifTrue:[^ false].

    [(n1P := n1 parent) == (n2P := n2 parent)] whileFalse:[
        [n1P hasAncestor:n2P] whileTrue:[ n1 := n1P. n1P := n1 parent ].
        [n2P hasAncestor:n1P] whileTrue:[ n2 := n2P. n2P := n2 parent ].
        n1P == n2P ifFalse:[
            n1 := n1P. n1P := n1 parent.
            n2 := n2P. n2P := n2 parent.
        ]
    ].
    ^ (n1P indexOf:n1) < (n1P indexOf:n2)
!

xPath
    |parentsXPath siblingsWithSameTag siblingsWithSameTagIncludingMe
     areSiblingsLikeMe tagType index uniqueAttribute|

    parent isNil ifTrue:[
        ^ ''.
    ].

    parentsXPath := parent xPath.
    areSiblingsLikeMe := false.

    tagType := self tag type.

    siblingsWithSameTag := OrderedCollection new.
    siblingsWithSameTagIncludingMe := OrderedCollection new.
    parent elements do:[:eachSibling |
        eachSibling ~~ self ifTrue:[
            eachSibling tag notNil ifTrue:[
                tagType = eachSibling tag type ifTrue:[  
                    areSiblingsLikeMe := true.
                    siblingsWithSameTag add:eachSibling.
                    siblingsWithSameTagIncludingMe add:eachSibling.   
                ]
            ]
        ] ifFalse:[
            siblingsWithSameTagIncludingMe add:eachSibling.   
        ].    
    ].

    "
     I am not sure if this position counter *should* 
     really start at 1 or at 0.
     cg: yes, they do start at 0!!
    "
    areSiblingsLikeMe ifTrue:[
        "/ is there any attribute, by which all siblings differ?
        "/ then take that. This is better than taking the index.
        uniqueAttribute := self attributes 
                            detect:[:someAttribute |
                                |myAttributeValue|

                                myAttributeValue := (self attributeNamed:someAttribute key) value.
                                (siblingsWithSameTag 
                                    allSatisfy:[:sibling | 
                                        (sibling attributeNamed:(someAttribute key)) value ~= myAttributeValue])]
                            ifNone:nil.

        uniqueAttribute notNil ifTrue:[
            ^ parentsXPath, '/', tagType,'[@',uniqueAttribute key asString,'="',(self attributeNamed:uniqueAttribute key) value,'"]'
        ].

        index := siblingsWithSameTagIncludingMe identityIndexOf:self.
        ^ parentsXPath, '/', tagType,'[', index printString,']'
    ].

    ^ parentsXPath, '/', tagType
! !

!Node methodsFor:'testing'!

isAttribute

        ^false
!

isBlankText

        ^false
!

isComment

        ^false
!

isContent

        ^false
!

isDiscarded

    ^ flags notNil and:[flags == 1 or:[flags bitTest:1]]
!

isDocument

        ^false
!

isElement

        ^false
!

isEntity
    ^ false
!

isLike: aNode

        ^self class == aNode class
!

isProcessingInstruction

        ^false
!

isText

        ^false
!

isYAXODomNode
    ^ false
!

verifyContents

        ^true
! !

!Node methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitNode:self
! !

!Node class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Node.st,v 1.45 2018-02-15 13:54:38 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Node.st,v 1.45 2018-02-15 13:54:38 cg Exp $'
! !

