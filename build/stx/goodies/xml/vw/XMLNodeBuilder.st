"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#XMLNodeBuilder
	instanceVariableNames:'tagStack tagOnStackTop tags unresolvableNamespace'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Parsing'
!

XMLNodeBuilder comment:'This class along with it''s subclass NodeBuilder is used by the XMLParser to distill an XML document into it''s component elements. Since XML elements are tag delimited and nest
properly within each other in a well-formed XML document, this class contains code to
process the tags and build a dictionary of xml elements

Instance Variables:
	tagStack        <OrderedCollection> 
	tags    <Dictionary>
'
!


!XMLNodeBuilder class methodsFor:'instance creation'!

new

        ^self basicNew initialize
! !

!XMLNodeBuilder class methodsFor:'constants'!

reservedXmlNamespace
"
    Namespace constraint: Reserved Prefixes and Namespace Names

    The prefix xml is by definition bound to the namespace name http://www.w3.org/XML/1998/namespace. It may, but need not, be declared, and must not be bound to any other namespace name. No other prefix may be bound to this namespace name.

    The prefix xmlns is used only to declare namespace bindings and is by definition bound to the namespace name http://www.w3.org/2000/xmlns/. It must not be declared. No other prefix may be bound to this namespace name.

    All other prefixes beginning with the three-letter sequence x, m, l, in any case combination, are reserved. This means that

        * users should not use them except as defined by later specifications
        * processors must not treat them as fatal errors.

"
        ^'http://www.w3.org/XML/1998/namespace'
! !

!XMLNodeBuilder methodsFor:'accessing'!

currentElement
    "cg: added for twoFlower *compatibility with newer XMLParser framework"

    ^ tagStack last
!

currentTag
    ^ tagOnStackTop
!

elementStack
    "cg: added for twoFlower *compatibility with newer XMLParser framework"

    ^ tagStack 
!

popTag
    "cg: added for twoFlower *compatibility with newer XMLParser framework"

    tagStack removeLast.
    tagStack notEmpty ifTrue:[
        tagOnStackTop := tagStack last tag.
    ].
!

pushTag:tag
    "cg: added for twoFlower *compatibility with newer XMLParser framework"

    |savedTagStackTop|

    savedTagStackTop := tagOnStackTop.
    tagOnStackTop := tag.
    tagStack addLast:(ElementContext new tag:tag).
!

pushTag:tag whileDoing:aBlock
    |savedTagStackTop|

    savedTagStackTop := tagOnStackTop.
    tagOnStackTop := tag.
    tagStack addLast:(ElementContext new tag:tag).
    ^ aBlock ensure:[tagStack removeLast. tagOnStackTop := savedTagStackTop]
!

unresolvableNamespace
    "get the namespace to be used, if it cannot be resolved.
     An error is raised if this is nil."

    ^ unresolvableNamespace
!

unresolvableNamespace:aString
    "set the namespace to be used, if it cannot be resolved.
     An error is raised if this is nil."

    unresolvableNamespace := aString
! !

!XMLNodeBuilder methodsFor:'building'!

externalGeneralEntity: nameString id: arrayIDs ndata: ndata uri: aUri
	"Needed for SAX. REW" 
	^(GeneralEntity new)
		externalFrom: arrayIDs;
		name: nameString;
		ndata: ndata
!

externalParameterEntity: nameString id: arrayIDs
	"Needed for SAX. REW" 
	^(ParameterEntity new)
		externalFrom: arrayIDs;
		name: nameString
!

internalGeneralEntity: nameString value: string
	"Needed for SAX. REW" 
	^(GeneralEntity new)
		name: nameString;
		text: string
!

internalParameterEntity: nameString value: string
	"Needed for SAX. REW" 
	^(ParameterEntity new)
		name: nameString;
		text: string
! !

!XMLNodeBuilder methodsFor:'initialization'!

initialize

	tagStack := OrderedCollection new.
	tags := Dictionary new.
! !

!XMLNodeBuilder methodsFor:'namespaces'!

correctAttributeTag: attribute

	| ns tag key qual type |
	qual := attribute tag qualifier.
	qual isEmpty
		ifTrue: [^self].
	type := attribute tag type.
	ns := self findNamespace: qual.
	key := Array with: qual with: ns with: type.
	tag := tags at: key ifAbsentPut: [NodeTag new qualifier: qual ns: ns type: type].
	attribute tag: tag
!

correctTag: tag

        | ns type key qualifier |
        qualifier := tag qualifier.
        type := tag type.
        ns := self findNamespace: qualifier.
        key := Array with: qualifier with: ns with: type.
        ^ tags at: key ifAbsentPut: [NodeTag new qualifier: qualifier ns: ns type: type]
!

findNamespace: ns
    | nsURI |
    ns = 'xml' ifTrue: [^ self class reservedXmlNamespace].
    ns = 'xmlns' ifTrue: [^ '<!!-- xml namespace -->'].
    tagStack size to: 1 by: -1 do: [:i |
        nsURI := (tagStack at: i) findNamespace: ns.
        nsURI notNil ifTrue:[^ nsURI]
    ].
    ns = '' ifTrue: [^ ''].
    ns = #Smalltalk ifTrue: [^ ''].
    ^ self unresolvableNamespaceFor:ns.
!

postProcessElement: anElement
        |topElementContext|
        
        topElementContext := tagStack last.
        topElementContext definesNamespaces
                ifTrue: [anElement namespaces:topElementContext namespaces].
        ^ anElement
!

resolveNamespaces: attributes

        | newAttributes |
        attributes == nil
                ifTrue: [newAttributes := #()]
                ifFalse:
                        [newAttributes := OrderedCollection new: attributes size.
                        attributes do: [:attr |
                                newAttributes add: attr.
                                attr tag qualifier = 'xmlns'
                                        ifTrue: [tagStack last defineNamespace: attr]
                                        ifFalse: [(attr tag isLike: 'xmlns')
                                                ifTrue: [tagStack last defineDefaultNamespace: attr]
                                                ifFalse: []]].
                        newAttributes do: [:attr | self correctAttributeTag: attr]].
        tagOnStackTop := self correctTag: tagStack last tag.
        tagStack last tag: tagOnStackTop.

        ^newAttributes isEmpty
                ifTrue: [nil]
                ifFalse: [newAttributes asArray]
!

unresolvableNamespaceFor:aNsQualifier
    "if a namespace qualifier cannot be resolved"

    unresolvableNamespace notNil ifTrue:[
        ^ unresolvableNamespace.
    ].

    ^ XMLParser invalid:('The namespace qualifier <1s> has not been bound to a namespace URI' expandMacrosWith: aNsQualifier).
! !

!XMLNodeBuilder methodsFor:'queries'!

isTreeBuilding
    "answer true, if our builder wants the XML parser to build
     a tree of elements.
     Subclasses may redefine this."

    ^ true
! !

!XMLNodeBuilder class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLNodeBuilder.st,v 1.17 2012-12-19 16:46:56 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/XMLNodeBuilder.st,v 1.17 2012-12-19 16:46:56 stefan Exp $'
! !

