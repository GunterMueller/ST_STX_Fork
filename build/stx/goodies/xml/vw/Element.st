"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Node subclass:#Element
	instanceVariableNames:'tag attributes namespaces elements definition'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!

Element comment:'XML document element boundaries are either delimited by start-tags and end-tags, or, for empty elements, by an empty-element tag. Each element has a type, identified by name, sometimes called its "generic identifier" (GI), and may have a set of attribute specifications. Each attribute specification has a name and a value.

Instance Variables:
	tag     <String | NodeTag>  the identifier for the element
	attributes      <Collection>  the element''s attributes
	namespaces      <Dictionary>  a mapping of tag qualifiers to namespace URIs
	elements        <SequenceableCollection>  child text, comments, PIs and elements
	userData        <Object>  extra space for a client program to add annotations
	definition      <XML.Pattern>  defines the type constraints for the content
'
!


!Element class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
!

tag:tag

        ^self new setTag:tag attributes:nil elements:nil

    "Modified (format): / 18-07-2018 / 11:53:15 / Claus Gittinger"
!

tag:tag attributes:attributes

        ^self new setTag:tag attributes:attributes elements:nil

    "Created: / 18-07-2018 / 11:53:21 / Claus Gittinger"
!

tag:tag attributes:attributes elements:elements

        ^self new setTag:tag attributes:attributes elements:elements

    "Modified (format): / 18-07-2018 / 11:53:10 / Claus Gittinger"
!

tag:tag elements:elements

        ^self new setTag:tag attributes:nil elements:elements

    "Modified (format): / 18-07-2018 / 11:53:02 / Claus Gittinger"
! !

!Element methodsFor:'accessing'!

anyElementNamed: elementName
        "Answer the one and only element named elementName.
         Raise an error, if there is not exactly one element.
         This will return the receiver if its name matches the requirement."

        |list|

        list := self anyElementsNamed: elementName.
        list size ~= 1 ifTrue: [KeyNotFoundError raiseErrorString: 'There is not a unique element with this tag'].
        ^ list first.

    "Modified (comment): / 13-02-2017 / 20:35:25 / cg"
!

anyElementsNamed: elementName
        "Traverse the tree and return all the elements named elementName"

        | list |

        list := OrderedCollection new.
        self elementsDo:[:e |
                (e isElement and: [e tag isLike: elementName]) ifTrue: [list add: e]
        ].
        ^ list
!

attributeNamed: attributeName   
        "##add MU 11/7/2000 13:38"
        ^(self attributes
                detect: [:a | a tag isLike: attributeName]
                ifNone: nil)

    "Modified: / 31-10-2010 / 15:10:52 / cg"
!

attributes

	^attributes == nil
		ifTrue: [#()]
		ifFalse: [attributes]
!

characterData
    "return all concatenated character data"
    
    | str |

    str := CharacterWriteStream on:(String new:128).
    self characterDataOnto: str.
    ^ str contents

    "Modified (comment): / 09-02-2017 / 22:18:35 / cg"
!

characterDataDo:aBlock
    "recursively apply aBlock for every characterdata piece"

    self elements do:[:i | 
        i isContent ifTrue:[
            i characterDataDo:aBlock
        ]
    ].

    "Created: / 18-07-2011 / 15:24:00 / cg"
!

characterDataOnto: str

	self elements do: [:i |
		i isContent ifTrue: [i characterDataOnto: str]].
!

childNodes
        "##add -umejava"
        ^self elements select:[:each | each isElement]
!

definition

	^definition
!

definition: aPattern

	definition := aPattern
!

description

	^'an %<<1s>> element' expandMacrosWith: tag
!

elementNamed: elementName

        | list |
        list := self elementsNamed: elementName.
        list size = 1 ifFalse: [KeyNotFoundError raiseErrorString: 'There is not a unique element with this tag'].
        ^ list first
!

elementNamed: elementName ifAbsent:exceptionValue
    | list |

    list := self elementsNamed: elementName.
    list size = 1 ifFalse: [ ^ exceptionValue value ].
    ^ list first

    "Created: / 26-01-2011 / 09:57:07 / cg"
!

elements

	^elements == nil
		ifTrue: [#()]
		ifFalse: [elements]
!

elementsNamed: elementName

	^self elements select: [:e | e isElement and: [e tag isLike: elementName]]
!

elementsWithTextDo:aBlock
    "return all text elements"
    
    ^ self elements 
        select: [:e | e isText ]
        thenDo:aBlock

    "Created: / 14-07-2018 / 11:19:12 / Claus Gittinger"
!

elementsWithTexts
    "return all text elements"
    
    ^ self elements select: [:e | e isText ]

    "Created: / 14-07-2018 / 11:18:50 / Claus Gittinger"
!

elementsWithoutTexts
    "return a collection of all non-text elements"
    
    "##add -umejava"
    ^self elements reject: [:e | e isText ].

    "Modified (comment): / 09-02-2017 / 22:17:58 / cg"
!

elementsWithoutTextsDo:aBlock
    "evaluate a block for all non-text elements"
    
    self elements 
        reject: [:e | e isText ]
        thenDo:aBlock.

    "Created: / 09-02-2017 / 22:17:43 / cg"
!

expandedName

	^tag expandedName
!

hasElementNamed: elementName

        | list |
        list := self elementsNamed: elementName.
        ^list notEmpty

    "Created: / 14-09-2007 / 11:14:19 / cg"
!

hasElementsWithoutText
    "answer true, if there is a subelement, which is not text"

    ^ self elements contains:[:e | e isText not].
!

indexOf: aChild

	aChild parent == self ifFalse: [^nil].
	^aChild isAttribute
		ifTrue: [-1]
		ifFalse: [elements indexOf: aChild ifAbsent: [nil]]
!

namespaces: aDictionary

	namespaces := aDictionary
!

selectNodes: aBlock

	^self attributes, self elements select: aBlock
!

tag

	^tag
!

tagName
    ^tag asString

    "Created: / 19-07-2018 / 08:02:13 / Claus Gittinger"
!

valueOfAttribute: attributeName ifAbsent: aBlock

	^(self attributes
		detect: [:a | a tag isLike: attributeName]
		ifNone: [^aBlock value]) value
! !

!Element methodsFor:'accessing - xpath like'!

/ anElementName
    "XPath like processing - answer all the elements named anElementName"

    |nodeSet|

    nodeSet := NodeSet new.
    self addElementsNamed:anElementName to:nodeSet.
    ^ nodeSet.
!

// anElementName
    "XPath like processing - traverse the tree and answer all the elements named anElementName"

    |nodeSet|

    nodeSet := NodeSet new.
    self addAllElementsNamed:anElementName to:nodeSet.
    ^ nodeSet.








!

/@ anAttributeName
    "XPath like processing - answer a nodeSet with attributes named anAttributeName"

    |nodeSet|

    nodeSet := NodeSet new.
    self addAttributesNamed:anAttributeName to:nodeSet.
    ^ nodeSet.
!

@ anAttributeName
    "XPath like processing - answer the attribute named anAttributeName"

    ^ (self attributeNamed:anAttributeName) value.
!

addAllAttributesNamed:attributeName to:aCollection
    "Recursively (depth-first) traverse the element tree and add any 
     sub-elements atributes named attributeName to aCollection"

    self elementsDo:[:e |
         e isElement ifTrue:[e addAttributesNamed:attributeName to:aCollection]
    ].
    self addAttributesNamed:attributeName to:aCollection.
!

addAllElementsNamed:elementName to:aCollection
    "Recursively (depth-first) traverse the element tree and add any 
     sub-element named elementName to aCollection"

    (elementName at:1) = $@ ifTrue:[
        self addAllAttributesNamed:(elementName copyFrom:2) to:aCollection.
    ] ifFalse:[
        elementName = '*' ifTrue:[
            self elementsDo:[:e |
                 e isElement ifTrue: [aCollection add: e]
            ].
        ] ifFalse:[
            elementName == #'text()' ifTrue:[
                self elementsDo:[:e |
                     e isText ifTrue: [aCollection add: e]
                ].
            ] ifFalse:[
                self elementsDo:[:e |
                     (e isElement and:[e tag isLike:elementName]) ifTrue:[aCollection add: e]
                ].
            ].
        ].
    ].
!

addAttributesNamed:anAttributeName to:aCollection
    "XPath like processing - add attributes named anAttributeName to aCollection"

    attributes notEmptyOrNil ifTrue:[
        anAttributeName = '*' ifTrue:[
            aCollection addAll:self attributes.
        ] ifFalse:[
            "attributes are not allowed to occur more than once in a single element in
             well-formed xml. We handle this case here anyway"
            self attributes do:[:a |
                 (a tag isLike: anAttributeName) ifTrue: [aCollection add:a]
            ].
        ].
    ]
!

addElementsNamed:elementName to:aCollection
    "Traverse the tree and add the direct child elements named elementName to aCollection"

    |attributeName|

    (elementName at:1) = $@ ifTrue:[
        elementName = '@*' ifTrue:[
            aCollection addAll:self attributes.
        ] ifFalse:[
            attributeName := elementName copyFrom:2.
            "attributes are not allowed to occur more than once in a single element in
             well-formed xml. We handle this case here anyway"
            self attributes do:[:a |
                 (a tag isLike: attributeName) ifTrue: [aCollection add:a]
            ].
        ].
    ] ifFalse:[
        elementName = '*' ifTrue:[
            self elements do:[:e |
                e isElement ifTrue: [aCollection add: e]
            ].
        ] ifFalse:[
            elementName == #'text()' ifTrue:[
                self elements do:[:e |
                     e isText ifTrue: [aCollection add: e]
                ].
            ] ifFalse:[
                self elements do:[:e |
                     (e isElement and:[e tag isLike: elementName]) ifTrue: [aCollection add: e]
                ].
            ].
        ].
    ].
!

allAttributesNamed:attributeName do:aBlock
    "Recursively (depth-first) traverse the element tree and evaluate aBlock for each"

    self elementsDo:[:e |
         e isElement ifTrue:[e attributesNamed:attributeName do:aBlock]
    ].
    self attributesNamed:attributeName do:aBlock.

    "Created: / 20-01-2011 / 17:43:46 / cg"
!

allElementsNamed:elementName do:aBlock
    "Recursively (depth-first) traverse the element tree and evaluates aBlock for each"

    (elementName at:1) = $@ ifTrue:[
        self allAttributesNamed:(elementName copyFrom:2) do:aBlock.
    ] ifFalse:[
        elementName = '*' ifTrue:[
            self elementsDo:[:e |
                 e isElement ifTrue: [aBlock value: e]
            ].
        ] ifFalse:[
            elementName == #'text()' ifTrue:[
                self elementsDo:[:e |
                     e isText ifTrue: [aBlock value: e]
                ].
            ] ifFalse:[
                self elementsDo:[:e |
                     (e isElement and:[e tag isLike:elementName]) ifTrue:[aBlock value: e]
                ].
            ].
        ].
    ].

    "Created: / 20-01-2011 / 17:41:04 / cg"
!

attributesNamed:anAttributeName do:aBlock
    "XPath like processing - evaluate aBlock for all attributes named anAttributeName"

    attributes notEmptyOrNil ifTrue:[
        anAttributeName = '*' ifTrue:[
            self attributes do:aBlock
        ] ifFalse:[
            "attributes are not allowed to occur more than once in a single element in
             well-formed xml. We handle this case here anyway"
            self attributes do:[:a |
                 (a tag isLike: anAttributeName) ifTrue: [aBlock value:a]
            ].
        ].
    ]

    "Created: / 20-01-2011 / 17:43:19 / cg"
! !

!Element methodsFor:'comparing'!

= anXmlElement
    |otherAttributes otherElements|

    self == anXmlElement ifTrue:[^ true].
    anXmlElement isElement ifFalse:[
        ^ false.
    ].
    otherAttributes := anXmlElement attributes.
    attributes size ~= otherAttributes size ifTrue:[
        ^ false.
    ].
    otherElements := anXmlElement elements.
    elements size ~= otherElements size ifTrue:[
        ^ false.
    ].
    tag ~= anXmlElement tag ifTrue:[
        ^ false.
    ].
    attributes notEmptyOrNil ifTrue:[
        attributes with:otherAttributes do:[:eachAttribute :eachOtherAttribute| 
            eachAttribute = eachOtherAttribute ifFalse:[
                ^ false.
            ].
        ].
    ].
    elements notEmptyOrNil ifTrue:[
        elements with:otherElements do:[:eachElement :eachOtherElement| 
            eachElement = eachOtherElement ifFalse:[
                ^ false.
            ].
        ].
    ].

    ^ true.
!

hash
    ^ (tag hash bitXor:elements hash) bitXor:attributes hash
! !

!Element methodsFor:'copying'!

cloneTree
    "answer a copy of the tree, so that removal of child elements
     from the copy does not affect the original node."

    |clone|

    "must determine the tree position now,
     later the parent doesn't know about the clone"
    self treePosition.  
    clone := self shallowCopy.
    elements notNil ifTrue:[
        clone setElements:(elements collect:[:eachElement| |eachClone|
            eachClone := eachElement cloneTree.
            eachClone parent:clone.
            eachClone.
        ]).
    ].
    attributes notNil ifTrue:[
        clone setAttributes:(attributes collect:[:eachAttribute| |eachClone|
            eachAttribute treePosition.  
            eachClone := eachAttribute shallowCopy.
            eachClone parent:clone.
            eachClone.
        ]).
    ].
    ^ clone
! !

!Element methodsFor:'enumerating'!

childElementsDo:aBlock
    "enumerate my direct child-elements and
     evaluate aBlock for each sub-element."

    self elements do:aBlock

    "Created: / 13-07-2018 / 21:17:31 / Claus Gittinger"
!

elementsDo:aBlock
    "recursively (depth-first) descend into my child-elements and
     evaluate aBlock for each sub-element.
     Bad naming: should be called allElementsDo:"

    self elements do:[:each | 
        aBlock value:each.
        each elementsDo:aBlock
    ]

    "Created: / 13-09-2007 / 17:23:27 / cg"
!

nodesDo:aBlock 
    "Evaluate aBlock for myself and recursively (depth-first) descend into my child-nodes and
     evaluate aBlock for each sub-node."
    
    aBlock value:self.
    self attributes do:[:att | 
        att nodesDo:aBlock
    ].
    self elements do:[:el | 
        el nodesDo:aBlock
    ]

    "Modified: / 13-09-2007 / 17:24:18 / cg"
!

nodesReverseDo: aBlock

        aBlock value: self.
        self attributes reverseDo: [:att |
                att nodesReverseDo:aBlock
        ].
        self elements reverseDo: [:el |
                el nodesReverseDo:aBlock
        ]
!

saxDo: aDriver forBodyDo: aBlock
    "a variation on #saxDo: that lets the client
    control how the body of the element is to be
    printed."

    namespaces == nil
        ifFalse: [namespaces keysAndValuesDo: [:qual :uri |
            aDriver startPrefixMapping: qual uri: uri]].
    aDriver startElement: self tag namespace
            localName: self tag type
            qName: self tag asString
            attributes: self attributes.
    (aDriver respondsTo: #closeOpenTag) ifTrue: [aDriver closeOpenTag].
    aBlock value.
    aDriver endElement: self tag namespace
            localName: self tag type
            qName: self tag asString.
    namespaces == nil
        ifFalse: [namespaces keysAndValuesDo: [:qual :uri |
            aDriver endPrefixMapping: qual]].
! !

!Element methodsFor:'initialization'!

initialize
    tag := 'undefined'.
    attributes := #( ).
! !

!Element methodsFor:'modifying'!

addNode: aNode
        "/ the following might look ugly, but saves a lot of memory,
        "/ as all elements with only one or two children store them in an array
        "/ instead of an orderedCollection.

        elements isNil ifTrue:[
            elements := Array with:aNode.
        ] ifFalse:[
            elements size == 1 ifTrue:[
                elements := Array with:(elements at:1) with:aNode.
            ] ifFalse:[
                elements class == Array ifTrue:[
                    elements := elements asOrderedCollection
                ].
                elements add:aNode.
            ].
        ].
        aNode parent:self.
!

removeAllNodes
        "##add -umejava"
        self childNodes copy do: [:each | self removeNode: each].
!

removeNode: aNode
    "remove a child node; raises an error if the given argument is
     not a child of the receiver"

    "##add -umejava"
    elements == nil ifTrue: [
        elements := OrderedCollection new
    ] ifFalse: [
        elements class == Array ifTrue: [
            elements := elements asOrderedCollection
        ]
    ].
    elements remove: aNode
! !

!Element methodsFor:'namespaces'!

namespaceAt: qualifier

	^namespaces == nil
		ifTrue: [nil]
		ifFalse: [namespaces at: qualifier ifAbsent: [nil]]
!

qualifierAtNamespace: ns

	^namespaces == nil
		ifTrue: [nil]
		ifFalse:
			[namespaces keysAndValuesDo: 
				[:qualifier :namespace | namespace = ns ifTrue: [^qualifier]].
			nil]
! !

!Element methodsFor:'printing'!

prettyPrintColorizedOn:aStream depth:indent 
    |prefs tagEmphasis shownElements any withCRs|

    prefs := UserPreferences current.
    
    tagEmphasis := (Smalltalk at:#Text) 
                        addEmphasis: prefs xmlTagEmphasis 
                        to:(#color->prefs xmlTagColor).

    aStream 
        emphasis:tagEmphasis; 
        nextPut:$<;
        nextPutAll:tag asString;
        emphasis:nil.

    attributes notEmptyOrNil ifTrue:[
        withCRs := (attributes size > 1) or:[attributes first tag qualifier = 'xmlns'].
        attributes do:[:eachAttr | 
            withCRs ifTrue:[
                aStream cr; spaces:(indent + 2) * 2.
            ] ifFalse:[    
                aStream space.
            ].
            eachAttr prettyPrintColorizedOn:aStream
        ]
    ].

    aStream emphasis:tagEmphasis. 
    elements isEmptyOrNil ifTrue:[
        aStream nextPutAll:'/>'.
    ] ifFalse:[
        aStream nextPut:$>.
        aStream emphasis:nil. 

        shownElements := elements reject:[:str | str isText and:[str isStripped]].
        (shownElements size == 1 and:[shownElements first isText]) ifTrue:[
            shownElements first prettyPrintColorizedOn:aStream depth:indent + 1
        ] ifFalse:[
            any := false.
            shownElements do:[:eachElem | 
                eachElem isString ifTrue:[
                    aStream cr; spaces:(indent + 1) * 2.
                    aStream nextPutAll:eachElem.
                    any := true.
                ] ifFalse:[
                    (eachElem isText not or:[(eachElem text ? '') withoutSeparators notEmpty]) ifTrue:[
                        aStream cr; spaces:(indent + 1) * 2.
                        eachElem prettyPrintColorizedOn:aStream depth:indent + 1.   
                        any := true.
                    ].
                ]
            ].
            any ifTrue:[
                aStream cr; spaces:indent * 2
            ].
        ].
        aStream emphasis:tagEmphasis. 
        aStream nextPutAll:'</'; nextPutAll:tag asString; nextPut:$>.
    ].
    aStream emphasis:nil.

    "Created: / 17-02-2011 / 14:25:32 / cg"
    "Modified (format): / 19-04-2017 / 15:01:38 / stefan"
!

prettyPrintOn:aStream depth:indent 
    |elem any|

    aStream nextPut:$<.
    aStream nextPutAll:tag asString.
    attributes isNil ifFalse:[
        attributes do:[:eachAttribute | 
            aStream space.
            eachAttribute prettyPrintOn:aStream
        ]
    ].
    elements isEmptyOrNil ifTrue:[
        aStream nextPutAll:'/>'
    ] ifFalse:[
        aStream nextPut:$>.
        elem := elements reject:[:str | str isText and:[ str isStripped ] ].
        (elem size <= 1 and:[ (elem contains:[:n | n isText not ]) not ]) ifTrue:[
            elem do:[:e | 
                e prettyPrintOn:aStream depth:indent + 1
            ]
        ] ifFalse:[
            any := false.
            elem do:[:eachElement | 
                eachElement isString ifTrue:[
                    aStream cr; spaces:(indent + 1) * 2.
                    aStream nextPutAll:eachElement.
                    any := true.
                ] ifFalse:[
                    (eachElement isText and:[(eachElement text ? '') withoutSeparators isEmpty]) ifFalse:[
                        aStream cr; spaces:(indent + 1) * 2.
                        eachElement prettyPrintOn:aStream depth:indent + 1.   
                        any := true.
                    ].
                ]
            ].
            any ifTrue:[
                aStream cr; spaces:indent * 2
            ].
        ].
        aStream nextPutAll:'</'; nextPutAll:tag asString; nextPut:$>
    ]

    "Modified: / 17-02-2011 / 14:44:41 / cg"
    "Modified: / 19-04-2017 / 14:39:58 / stefan"
!

printAsOneLineOn: aStream
        | elem |

        aStream nextPut: $<.
        aStream nextPutAll: tag asString.
        attributes == nil
                ifFalse: [1 to: attributes size do: 
                        [:i | | a |
                        a := attributes at: i.
                        aStream space.
                        a printOn: aStream]].
        elements isEmptyOrNil
                ifTrue: [aStream nextPutAll: '/>']
                ifFalse:
                        [aStream nextPut: $>.
                        elem := elements reject: [:str | str isText and: [str isStripped]].
                        (elem size <= 1 and: [(elem contains: [:n | n isText not]) not])
                                ifTrue: [elem do: [:e |
                                                        e printOn: aStream]]
                                ifFalse:
                                        [1 to: elem size do: [:i | | e |
                                                e := elem at: i.
                                                e isString 
                                                        ifTrue: [aStream nextPutAll: e]
                                                        ifFalse: [e printOn: aStream ]].
                                        ].
                        aStream nextPutAll: '</', tag asString, '>']

    "Created: / 21-01-2011 / 13:55:06 / cg"
!

printCanonicalOn: aStream
        | elem az |

        aStream nextPut: $<.
        aStream nextPutAll: tag asString.
        attributes notNil ifTrue:[
            attributes size == 1 ifTrue:[
                aStream space.
                attributes first printCanonicalOn: aStream.
            ] ifFalse:[
                az := attributes asSortedCollection: [:x :y | x key < y key].
                az do: [:at |
                        aStream space.
                        at printCanonicalOn: aStream]
            ].
        ].
        aStream nextPut: $>.
        elem := elements == nil
                ifTrue: [#()]
                ifFalse: [elements" reject: [:str | str isBlankText]"].
        elem do: [:e | e printCanonicalOn: aStream].
        aStream nextPutAll: '</', tag asString, '>'

    "Modified: / 21-01-2011 / 13:53:51 / cg"
!

printHTMLOn: aStream
        | elem az |

        aStream nextPut: $<.
        aStream nextPutAll: tag asString.
        attributes == nil
                ifFalse:
                        [az := attributes asSortedCollection: [:x :y | x key < y key].
                        az do: [:at |
                                aStream space.
                                at prettyPrintOn: aStream]].
        aStream nextPut: $>.
        elem := elements == nil
                ifTrue: [#()]
                ifFalse: [elements" reject: [:str | str isBlankText]"].
        self isHTMLBlock ifTrue: [aStream cr].
        elem do: [:e |
                e printHTMLOn: aStream.
                self isHTMLBlock ifTrue: [aStream cr]].
        aStream nextPutAll: '</', tag asString, '>'

    "Modified: / 21-01-2011 / 13:54:03 / cg"
!

printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock
        | elem az |

        aStream nextPut: $<.
        aStream nextPutAll: tag asString.
        attributes == nil
                ifFalse:
                        [az := attributes asSortedCollection: [:x :y | x key < y key].
                        az do: [:at |
                                aStream space.
                                at printNoIndentOn: aStream endSpacing: endSpacingBlock spacing: spacingBlock]].
        aStream nextPut: $>.
        elem := elements == nil
                ifTrue: [#()]
                ifFalse: [elements reject: [:e | e isBlankText]].
        (elem contains: [:e | e isElement])
                ifTrue:
                        [endSpacingBlock value: self value: elem.
                        elem do: [:e | e
                                        printNoIndentOn: aStream
                                        endSpacing: endSpacingBlock
                                        spacing: spacingBlock]
                                separatedBy: [spacingBlock value: self value: elem].
                        endSpacingBlock value: self value: elem]
                ifFalse: [elem do: [:e | e
                                        printNoIndentOn: aStream
                                        endSpacing: endSpacingBlock
                                        spacing: spacingBlock]].
        aStream nextPutAll: '</', tag asString, '>'

    "Modified: / 21-01-2011 / 13:54:07 / cg"
!

simpleDescription

	^'<', self tag asString, '>'
! !

!Element methodsFor:'private'!

attributes: a

	attributes := a.
	a == nil ifFalse: [a do: [:i | i parent: self]].
!

condenseList
    "condense the elements list;
     if it is empty, make it nil;
     otherwise, make it an array"
     
    elements notNil ifTrue: [
        elements size = 0 ifTrue: [
            elements := nil
        ] ifFalse: [
            elements := elements asArray
        ]
    ]

    "Modified (comment): / 09-02-2017 / 22:16:11 / cg"
!

condenseText
    "concatenate text elements into the smallest number of elements.
     Return the receiver"

    |copyElements str textElementClass size|

    size := elements size.
    size <= 1 ifTrue:[
        ^ self
    ].

    copyElements := (Array new:size) writeStream.
    str := nil.

    1 to:size do:[:idx | |eachElement|
        eachElement := elements at:idx.
        (eachElement isText and:[str notNil or:[idx ~~ size and:[(elements at:idx+1) isText]]]) ifTrue:[
            "this is a text element and the previous one or next one is a text element, too"
            str isNil ifTrue:[
                str := (String new:eachElement text size) writeStream
            ].
            textElementClass := eachElement class.
            str nextPutAll:eachElement text
        ] ifFalse:[
            "this is not a text element"
            str notNil ifTrue:[
                copyElements nextPut:(textElementClass new text:str contents).
                copyElements nextPut:eachElement.
                str := nil.
            ] ifFalse:[
                copyElements nextPut:eachElement
            ].
        ].
    ].
    str notNil ifTrue:[
        copyElements nextPut:(textElementClass new text:str contents)
    ].
    elements := copyElements contents.

    "Modified (comment): / 09-02-2017 / 22:15:12 / cg"
!

elements: e

	elements := e.
	self isEmpty
		ifFalse:
			[self condenseText.
			elements do: [:elm | elm parent: self]]
!

setAttributes:aCollection
    "private entries to set the attributes without reparenting"

    attributes := aCollection
!

setElements:aCollection
    "private entries to set the elements without condensing"

    elements := aCollection
!

setTag: t attributes: a elements: e

	tag := t isString
			ifTrue: [NodeTag new qualifier: '' ns: '' type: t]
			ifFalse: [t].
	self attributes: a.
	self elements: e
! !

!Element methodsFor:'private helpers'!

treePositionOf:aNode
    treePosition isNil ifTrue:[
        treePosition := parent treePositionOf:self.
    ].
    elements notNil ifTrue:[
        ^ treePosition copyWith:(elements identityIndexOf:aNode ifAbsent:[0])
    ].

    ^ treePosition.
! !

!Element methodsFor:'testing'!

hasSubNodes

	^elements size > 0 or: [attributes size > 0]
!

isContent

	^true
!

isElement

	^true
!

isEmpty

	^elements == nil
!

isHTMLBlock

        ^#('p' 'html' 'head' 'body') includes: tag type asLowercase
!

isLike: aNode

	^self class == aNode class
		and: [self tag isLike: aNode tag]
!

verifyContents

	self isEmpty
		ifFalse: [elements do: [:elm | elm verifyContents]]
! !

!Element methodsFor:'visiting'!

acceptVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    "stub code automatically generated - please change if required"

    ^ aVisitor visitElement:self
! !

!Element class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Element.st,v 1.62 2018-07-19 09:23:36 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Element.st,v 1.62 2018-07-19 09:23:36 cg Exp $'
! !

