"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#NOTATION_AT
	instanceVariableNames:'typeNames'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

NOTATION_AT comment:'This class represents the NOTATION attribute type. A NOTATION attribute identifies a notation element, declared in the DTD with associated system and/or public identifiers, to be used in interpreting the element to which the attribute is attached.

Instance Variables:
	typeNames       <SequenceableCollection>
'
!


!NOTATION_AT class methodsFor:'instance creation'!

typeNames: list

	^self new typeNames: list
! !

!NOTATION_AT methodsFor:'accessing'!

typeNames

	^typeNames
!

typeNames: aList

	typeNames := aList
! !

!NOTATION_AT methodsFor:'validating'!

completeValidationAgainst: aParser from: anAttributeDef

	typeNames do: [:nm |
		aParser notationAt: nm ifAbsent:
			[aParser invalid: ('Undeclared Notation "<1s>" used by attribute type "<2s>"'
							expandMacrosWith: nm
							with: anAttributeDef tag asString)]]
!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(typeNames includes: v)
		ifFalse: [aParser invalid: ('A NOTATION attribute (<1s>="<2s>") should have had a value from <3p>.'
					expandMacrosWith: anAttribute tag asString
					with: v
					with: typeNames asArray)].
! !

!NOTATION_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/NOTATION_AT.st,v 1.7 2003-04-23 08:44:17 cg Exp $'
! !
