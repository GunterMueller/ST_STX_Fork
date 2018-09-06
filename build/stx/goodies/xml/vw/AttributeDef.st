"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#AttributeDef
	instanceVariableNames:'name default type flags'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

AttributeDef comment:'XML documents may contain attribute-list declarations that are used to define the set of attributes pertaining to a given element type. These attribute-list declarations are also used to establish type constraints for the attributes and to provide default values for attributes. Attribute-list declarations contain attribute definitions and this class is used to instantiate these attribute definitions.

An attribute definition specifies the name (name instance variable) of the attribute, the data type of the attribute (type instance variable) and an optional default value (default instance variable) for the attribute

Instance Variables:
	name    <XML.NodeTag>           name of attribute
	default <String | nil>                                  default value, if any
	type    <XML.AttributeType>     type used for validation
	flags   <Integer>                               encoding for fixed, implied and required type attributes
'
!


!AttributeDef methodsFor:'accessing'!

default

	^default
!

default: n

	flags := 0.
	default := nil.
	n = #required
		ifTrue: [flags := 1]
		ifFalse: [n = #implied
			ifTrue: [flags := 2]
			ifFalse:
				[n class == Association
					ifFalse: [self error: 'Invalid default'].
				n key ifTrue: [flags := 4].
				default := n value]]
!

hasDefault

	^(self isImplied or: [self isRequired]) not
!

isFixed

	^(flags bitAnd: 4) = 4
!

isImplied

	^(flags bitAnd: 2) = 2
!

isRequired

	^(flags bitAnd: 1) = 1
!

name

	^name
!

name: n

	name := n
!

tag

	^name
!

type

	^type
!

type: n

	type := n
! !

!AttributeDef methodsFor:'private'!

value

	^self default
!

value: str

	default := str
! !

!AttributeDef methodsFor:'validating'!

completeValidationAgainst: aParser
        "Modifed to handle IMPLIED (no value to validate) attributes. REW"
        self isImplied ifFalse: [type completeValidationAgainst: aParser from: self].

    "Modified: / 19-11-2016 / 13:07:09 / cg"
!

selfValidateFor: aParser

	type validateDefinition: self for: aParser
!

validateValueOf: anAttribute for: aParser

	type validateValueOf: anAttribute for: aParser.
	(self isFixed not or: [anAttribute value = self default])
		ifFalse: [aParser invalid: ('The attribute "<1s>" was declared FIXED, but the value used in the document ("<2s>") did not match the default ("<3s>")'
						expandMacrosWith: anAttribute tag asString
						with: anAttribute value
						with: self default)].
! !

!AttributeDef class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/AttributeDef.st,v 1.7 2016-11-19 12:07:31 cg Exp $'
! !

