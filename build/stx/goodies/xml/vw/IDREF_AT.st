"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#IDREF_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

IDREF_AT comment:'This class represents the IDREF attribute type. This is a tokenized type of attribute and for an XML document to be valid, values of IDREF type attributes must match the value of some ID attribute on some element in the XML document.

ID and IDREF attributes together provide a simple inside-the-document linking mechanism with every IDREF attribute required to point to an ID attribute as stated above.'
!


!IDREF_AT methodsFor:'validating'!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v includes: Character space)
		ifTrue: [aParser notPermitted: 'white space in IDREF attributes'].
	(aParser isValidName: v)
		ifFalse: [aParser invalid: ('An IDREF attribute (<1s>="<2s>") does not match the required syntax of a Name.'
					expandMacrosWith: anAttribute tag asString
					with: v)].
	aParser rememberIDREF: v
! !

!IDREF_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/IDREF_AT.st,v 1.6 2003-04-23 08:44:17 cg Exp $'
! !
