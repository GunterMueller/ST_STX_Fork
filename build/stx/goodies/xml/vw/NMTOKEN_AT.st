"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#NMTOKEN_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

NMTOKEN_AT comment:'This class represents the NMTOKEN attribute type. This is a tokenized type of attribute and for the purposes of validation, values of NMTOKEN type attributes must match a Nmtoken, which is any mixture of legal name characters as defined in the XML 1.0 specification. '
!


!NMTOKEN_AT methodsFor:'validating'!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v includes: Character space)
		ifTrue: [aParser notPermitted: 'white space in IDREF attributes'].
	(aParser isValidNmToken: v)
		ifFalse: [aParser invalid: ('An NMTOKEN attribute (<1s>="<2s>") does not match the required syntax of an NmToken.'
					expandMacrosWith: anAttribute tag asString
					with: v)]
! !

!NMTOKEN_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/NMTOKEN_AT.st,v 1.7 2003-04-23 08:44:17 cg Exp $'
! !
