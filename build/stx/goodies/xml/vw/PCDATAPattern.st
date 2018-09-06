"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ConcretePattern subclass:#PCDATAPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

PCDATAPattern comment:'This class represents a content constraint or pattern in an element type declaration indicating that the element content includes parsed character data. This is typically used in mixed content type patterns and is signified by the presence of the string ''#PCDATA'' in the element content
declaration.'
!


!PCDATAPattern methodsFor:'accessing'!

description

	^'#PCDATA'
! !

!PCDATAPattern methodsFor:'testing'!

isPCDATAPattern
    ^ true
!

matches: aNode

	^aNode isText
! !

!PCDATAPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/PCDATAPattern.st,v 1.7 2008-03-08 11:01:33 cg Exp $'


! !
