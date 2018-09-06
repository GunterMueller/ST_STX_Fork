"{ Encoding: utf8 }"

"{ Package: 'stx:goodies/xml/stx' }"!

!Collection methodsFor:'xml conversion'!

asXMLElementNamed:aName
    |element subElements|

    element := XML::Element tag:(XML::NodeTag new qualifier: '' ns: '' type:aName).

    self isByteCollection ifTrue:[
        subElements := Array with:(XML::Text text:self) .
    ] ifFalse:[
        self do:[:eachValue|
            subElements isNil ifTrue:[
                subElements := OrderedCollection new.
            ].
            subElements add:(eachValue asXMLElementNamed:aName, '_sub').
        ].
    ].
    subElements notNil ifTrue:[
        element elements:subElements asArray.
    ].
    ^ element
! !

!Dictionary methodsFor:'xml conversion'!

asXMLDocument
    |rootNode|

    rootNode := self asXMLElementNamed:'root'.
    ^ XML::Document new addNode:rootNode; yourself.
! !

!Dictionary methodsFor:'xml conversion'!

asXMLElementNamed:aName
    |attributes elements element|

    element :=  XML::Element tag:(XML::NodeTag new qualifier: '' ns: '' type:aName).

    self keysAndValuesDo:[:eachKey :eachValue|
        eachValue isNonByteCollection ifTrue:[
            elements isNil ifTrue:[
                elements := OrderedCollection new.
            ].
            elements add:(eachValue asXMLElementNamed:eachKey).
        ] ifFalse:[
            attributes isNil ifTrue:[
                attributes := OrderedCollection new.
            ].
            attributes add:(eachValue asXMLAttributeNamed:eachKey).
        ].
    ].
    elements notNil ifTrue:[
        element elements:elements asArray.
    ].
    attributes notNil ifTrue:[
        element attributes:attributes asArray.
    ].
    ^ element
! !

!Object methodsFor:'xml conversion'!

asXMLAttributeNamed:aName
    ^ XML::Attribute name:aName value:self asString.
! !

!Object methodsFor:'xml conversion'!

asXMLElementNamed:aName
    |element|

    element := XML::Element tag:(XML::NodeTag new qualifier: '' ns: '' type:aName).
    element elements:(Array with:(XML::Text text:self asString)).

    ^ element
! !

!stx_goodies_xml_stx class methodsFor:'documentation'!

extensionsVersion_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/stx/extensions.st,v 1.2 2015-03-18 16:45:07 stefan Exp $'
! !
