"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#ENTITY_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

ENTITY_AT comment:'This class represents the ENTITY attribute type. This is a tokenized type of attribute that signifies to the XML parser that for the purposes of validating, the values of entity type attributes must match the name of an unparsed entity declared in the document type definition.'
!


!ENTITY_AT methodsFor:'validating'!

completeValidationAgainst: aParser from: anAttribute

        self validateValueOf: anAttribute for: aParser

    "Modified: / 19-11-2016 / 12:29:25 / cg"
!

validateDefinition: anAttributeDefinition for: aParser

	^self
!

validateValueOf: anAttribute for: aParser

	| v ent |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v includes: Character space)
		ifTrue: [aParser notPermitted: 'white space in ENTITY attributes'].
	(aParser isValidName: v)
		ifFalse: [aParser invalid: ('An ENTITY attribute (<1s>="<2s>") does not match the required syntax of a Name.'
					expandMacrosWith: anAttribute tag asString
					with: v)].
	ent := aParser dtd generalEntityAt: v.
	ent == nil
		ifTrue: [aParser invalid: ('Undeclared unparsed entity "<1s>" used by attribute type "<2s>"'
						expandMacrosWith: v
						with: anAttribute tag asString)]
		ifFalse: [ent isParsed
			ifTrue: [aParser invalid: ('The entity "<1s>" used by attribute type "<2s>" is a parsed entity and should be unparsed'
							expandMacrosWith: v
							with: anAttribute tag asString)]
			ifFalse: []]
! !

!ENTITY_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ENTITY_AT.st,v 1.8 2016-11-19 11:30:47 cg Exp $'
! !

