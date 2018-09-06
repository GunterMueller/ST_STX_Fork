"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#ENTITIES_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

ENTITIES_AT comment:'This class represents the ENTITIES attribute type. This is a tokenized type of attribute that signifies to the XML parser that for the purposes of validating, the values of entities type attributes must match each of the names of unparsed entities declared in the document type definition.'
!


!ENTITIES_AT methodsFor:'validating'!

completeValidationAgainst: aParser from: anAttribute

        self validateValueOf: anAttribute for: aParser

    "Modified: / 19-11-2016 / 12:29:40 / cg"
!

validateDefinition: anAttributeDefinition for: aParser

	^self
!

validateValueOf: anAttribute for: aParser

	| v ent |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v tokensBasedOn: Character space) do: [:nm |
		(aParser isValidName: nm)
			ifFalse: [aParser invalid: ('An ENTITIES attribute (<1s>="<2s>") does not match the required syntax of a list of Names.'
					expandMacrosWith: anAttribute tag asString
					with: v)].
		ent := aParser dtd generalEntityAt: nm.
		ent == nil
			ifTrue: [aParser invalid: ('Undeclared unparsed entity "<1s>" used by attribute type "<2s>"'
						expandMacrosWith: nm
						with: anAttribute tag asString)]
			ifFalse: [ent isParsed
				ifTrue: [aParser invalid: ('The entity "<1s>" used by attribute type "<2s>" is a parsed entity and should be unparsed'
							expandMacrosWith: nm
							with: anAttribute tag asString)]
				ifFalse: []]]
! !

!ENTITIES_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ENTITIES_AT.st,v 1.8 2016-11-19 11:30:55 cg Exp $'
! !

