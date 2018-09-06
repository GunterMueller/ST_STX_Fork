"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#IDREFS_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

IDREFS_AT comment:'This class represents the IDREFS attribute type. This is a tokenized type of attribute and for an XML document to be valid, each of the values of IDREFS type attributes must match each of the values of some ID attribute on some element in the XML document.'
!


!IDREFS_AT methodsFor:'validating'!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v tokensBasedOn: Character space) do: [:nm |
		(aParser isValidName: nm)
			ifFalse: [aParser invalid: ('An IDREFS attribute (<1s>="<2s>") does not match the required syntax of a list of Names.'
					expandMacrosWith: anAttribute tag asString
					with: v)].
		aParser rememberIDREF: nm]
! !

!IDREFS_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/IDREFS_AT.st,v 1.7 2003-04-23 08:44:17 cg Exp $'
! !
