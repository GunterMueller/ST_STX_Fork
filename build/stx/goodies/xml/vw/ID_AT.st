"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#ID_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

ID_AT comment:'This class represents the ID attribute type. This is also a tokenized type of attribute and values of ID type attributes must match legal names as defined in the XML 1.0 specification. 

For an XML document to be valid, ID values must uniquely identify the elements which bear them; i.e. A name must not appear more than once in an XML document as a value of this type. Also for validity purposes, an ID attribute must have a declared default of #IMPLIED or #REQUIRED in the DTD.

ID and IDREF attributes together provide a simple inside-the-document linking mechanism with every IDREF attribute required to point to an ID attribute.'
!


!ID_AT methodsFor:'testing'!

isID

	^true
! !

!ID_AT methodsFor:'validating'!

validateDefinition: anAttributeDefinition for: aParser

	anAttributeDefinition hasDefault
		ifTrue: [XMLParser invalid: 'ID attributes must be either #REQUIRED or #IMPLIED']
!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(v includes: Character space)
		ifTrue: [aParser notPermitted: 'white space in ID attributes'].
	(aParser isValidName: v)
		ifFalse: [aParser invalid: ('An ID attribute (<1s>="<2s>") does not match the required syntax of a Name.'
					expandMacrosWith: anAttribute tag asString
					with: v)].
	aParser documentNode registerID: anAttribute from: aParser
! !

!ID_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ID_AT.st,v 1.7 2003-04-23 08:44:17 cg Exp $'
! !
