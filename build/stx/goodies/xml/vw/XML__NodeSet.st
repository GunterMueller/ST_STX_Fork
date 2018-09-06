"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

OrderedCollection subclass:#NodeSet
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Nodes'
!


!NodeSet methodsFor:'accessing'!

characterData
    "answer the character data of all my nodes"

    ^ self isEmpty 
        ifTrue:['']
        ifFalse:[
            |characterDataStream|

            characterDataStream := CharacterWriteStream on:''.
            self do:[:eachNode | 
                eachNode characterDataOnto:characterDataStream
            ].
            characterDataStream contents
        ]

    "Created: / 11-04-2008 / 09:43:00 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

characterDataOfEach
    "answer a collection where the elements are the character data of each of my nodes"

    |coll|

    coll := OrderedCollection new:self size.
    self do:[:eachNode|
        coll add:eachNode characterData
    ].

    ^ coll.
! !

!NodeSet methodsFor:'navigation'!

/ elementName 
    "XPath like processing - answer all my elements' child elements named elementName"

    |resultNodeSet|

    resultNodeSet := self species new.
    self do:[:node | 
        node isElement ifTrue:[
            node addElementsNamed:elementName to:resultNodeSet
        ]
    ].
    ^ resultNodeSet

    "Created: / 11-04-2008 / 09:39:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

// elementName 
    "XPath like processing - traverse the tree of all my elements and answer any subelements named elementName"

    |resultNodeSet|

    resultNodeSet := self species new.
    self do:[:node | 
        node isElement ifTrue:[
            node addAllElementsNamed:elementName to:resultNodeSet
        ]
    ].
    ^ resultNodeSet

    "Created: / 11-04-2008 / 09:39:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

/@ attributeName 
    "XPath like processing - answer all my elements attributes named attributeName"

    |resultNodeSet|

    resultNodeSet := self species new.
    self do:[:node | 
        node isElement ifTrue:[
            node addAttributesNamed:attributeName to:resultNodeSet
        ]
    ].
    ^ resultNodeSet
!

@ attributeName
    "XPath like processing - if singleton set, answer an value of
    atribute named attributeName, error otherwise.
    This method is used in libsvn"

    self size = 1 ifTrue:[^self first @ attributeName].
    self error:'More than one element in node set'
! !

!NodeSet class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XML__NodeSet.st,v 1.7 2015-06-14 17:11:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XML__NodeSet.st,v 1.7 2015-06-14 17:11:05 cg Exp $'
! !

