"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#NodeTag
	instanceVariableNames:'namespace type qualifier'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

NodeTag comment:'In XML all elements or nodes are delimited by start and end tags (or empty-element tags) and instances of this class are used to represent the name which appears in those tags. The name is composed of a simple type name

Instance Variables:
	namespace       <String> URI of the (XML) namespace of the element or attribute
	type    <String> Name of tag, used to indicate element type, within the chosen namespace
	qualifier       <String> type qualifier of the original XML document. Two NodeTags are considered equivalent if their namespace and type are equal, even if the qualifiers are different. This is primarily used only if it is desired to store the XML Document as a serialized string again. Qualiofiers are used with xmlns and xmlns:foo attributes to discover the namespace of the NodeTag.
'
!


!NodeTag methodsFor:'accessing'!

expandedName

	^namespace isEmpty
		ifTrue: [type]
		ifFalse: [namespace, '#', type]
!

namespace

	^namespace
!

qualifier

	^qualifier
!

type

	^type
! !

!NodeTag methodsFor:'comparing'!

< aNodeTag
    ^ self asString < aNodeTag asString
!

= aNodeTag 
    "Needed for canonical XML. REW"
    
    ^ (aNodeTag isKindOf:self class) 
        and:[type = aNodeTag type 
        and:[(namespace notEmptyOrNil and:[namespace = aNodeTag namespace]) 
             or:[qualifier = aNodeTag qualifier]
        ]]
!

hash
	"Needed for canonical XML. REW" 
	^type hash
! !

!NodeTag methodsFor:'converting'!

asString

	^qualifier isEmpty
		ifTrue: [type]
		ifFalse: [qualifier, ':', type]
! !

!NodeTag methodsFor:'initialization'!

qualifier: q ns: ns type: typeStr
        namespace := ns.
        type := typeStr.
        qualifier := q.
        qualifier = 'xml' ifTrue: [ namespace := XMLNodeBuilder reservedXmlNamespace ].
! !

!NodeTag methodsFor:'printing'!

printOn: aStream

	aStream nextPutAll: '{', self asString, '}'
! !

!NodeTag methodsFor:'testing'!

isLike: aName 
        "strings do not come with namespace information, so when matching a string, we
                can only compare qualifier and type ... this is needed so elements in the dom tree
                can be accessed by name even when xmlns or xmlns:Q attributes are in use"
        
        ^aName isString 
                ifTrue: [ self isLikeString: aName ]
                ifFalse: [ namespace = aName namespace and: [ type = aName type ] ]
!

isLikeForValidation:aNodeTag
    "for validation purposes, nodetags are equal if qualifier and prefix are equal.
      this does not work if prefixes are re-defined, but it's better than the status quo"

    ^ qualifier = aNodeTag qualifier and:[type = aNodeTag type]
!

isLikeString: aName 
        | tmp |
        tmp := aName asCollectionOfSubstringsSeparatedBy: $:.
        tmp size > 2 
                ifTrue: 
                        [ XML::XMLSignal 
                                raiseErrorString: ('an element name is either NAME or Q:NAME: %1' 
                                                bindWith: aName). ].
        tmp size =  2 ifTrue:[
                ^ qualifier = tmp first and:[type = (tmp at:2)]
        ].
        ^ type = tmp first
! !

!NodeTag class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/NodeTag.st,v 1.13 2009-05-11 10:55:52 stefan Exp $'
! !
