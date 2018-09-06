"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

AttributeType subclass:#CDATA_AT
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Attributes'
!

CDATA_AT comment:'This class represents the CDATA attribute type. A CDATA attribute is used to identify the data type of attributes which allow arbitrary text in their value.
'
!


!CDATA_AT methodsFor:'validating'!

validateValueOf: anAttribute for: aParser

	self simpleValidateValueOf: anAttribute for: aParser.
! !

!CDATA_AT class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/CDATA_AT.st,v 1.7 2003-04-23 08:44:16 cg Exp $'
! !
