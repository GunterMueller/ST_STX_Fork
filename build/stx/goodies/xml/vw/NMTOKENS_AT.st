"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#NMTOKENS_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

NMTOKENS_AT comment:'This class represents the NMTOKENS attribute type. This is a tokenized type of attribute and for the purposes of validation, values of each NMTOKENS type attributes must match each Nmtoken, which is any mixture of legal name characters as defined in the XML 1.0 specification. '
!


!NMTOKENS_AT methodsFor:'validating'!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v tokensBasedOn: Character space) do: [:nm |
		(aParser isValidNmToken: nm)
			ifFalse: [aParser invalid: ('An NMTOKENS attribute (<1s>="<2s>") does not match the required syntax of a list of NmTokens.'
					expandMacrosWith: anAttribute tag asString
					with: v)]]
! !

!NMTOKENS_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/NMTOKENS_AT.st,v 1.7 2003-04-23 08:44:17 cg Exp $'
! !
