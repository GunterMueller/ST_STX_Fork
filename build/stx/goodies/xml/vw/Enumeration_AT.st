"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#Enumeration_AT
	instanceVariableNames:'values'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

Enumeration_AT comment:'This class represents the Enumeration attribute type. Enumerated attributes can take one of a list of values provided in the declaration.

Instance Variables:
	values  <Collection>
'
!


!Enumeration_AT class methodsFor:'instance creation'!

withAll: list

	^self new values: list
! !

!Enumeration_AT methodsFor:'accessing'!

values: aList

	values := aList
! !

!Enumeration_AT methodsFor:'validating'!

validateValueOf: anAttribute for: aParser

	| v |
	super validateValueOf: anAttribute for: aParser.
	v := anAttribute value.
	(values includes: v)
		ifFalse: [aParser invalid: ('An attribute (<1s>="<2s>") should have had a value from <3p>.'
					expandMacrosWith: anAttribute tag asString
					with: v
					with: values asArray)]
! !

!Enumeration_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/Enumeration_AT.st,v 1.6 2003-04-23 08:44:16 cg Exp $'
! !
