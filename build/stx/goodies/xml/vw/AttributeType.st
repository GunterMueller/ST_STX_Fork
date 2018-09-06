"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

Object subclass:#AttributeType
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

AttributeType comment:'This class with its various subclasses represents the type of the XML attribute. According to the XML 1.0 specification, XML attribute types are of three kinds:a string type, a set of tokenized types, and enumerated types. The string type may take any literal string as a value, the tokenized types have varying lexical and semantic constraints and the enumerated type attibutes can take one of a list of values provided in the declaration.

Subclasses of AttributeType represent these various types of XML attributes '
!


!AttributeType methodsFor:'testing'!

isID

	^false
! !

!AttributeType methodsFor:'validating'!

completeValidationAgainst: aParser from: anAttribute
    "/ intentionally left blank
    ^ self

    "Modified (comment): / 19-11-2016 / 12:29:59 / cg"
!

simpleValidateValueOf: anAttribute for: aParser

	| v |
	v := anAttribute value copy.
	v replaceAll: Character cr with: Character space.
	v replaceAll: Character lf with: Character space.
	v replaceAll: Character tab with: Character space.
	anAttribute value: v
!

validateDefinition: anAttributeDefinition for: aParser

	anAttributeDefinition hasDefault
		ifTrue: [self validateValueOf: anAttributeDefinition for: aParser]
!

validateValueOf: anAttribute for: aParser
	"We're going to do this the hard way for now."

	| v v1 |
	self simpleValidateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	[v1 := v copyReplaceAll: '  ' with: ' '.
	v1 = v] whileFalse: [v := v1].
	(v size > 1 and: [v first = Character space])
		ifTrue: [v := v copyFrom: 2 to: v size].
	(v size > 1 and: [v last = Character space])
		ifTrue: [v := v copyFrom: 1 to: v size-1].
	anAttribute value: v
! !

!AttributeType class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/AttributeType.st,v 1.8 2016-11-19 11:30:51 cg Exp $'
! !

