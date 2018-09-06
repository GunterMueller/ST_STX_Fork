"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ConcretePattern subclass:#AnyPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

AnyPattern comment:'This class represents the ANY element content constraint in an element type declaration. According to the XML 1.0 specification the ANY pattern/rule is used to indicate to the validating
parser that the element can contain any elements in any order, as long as it doesn''t break any of the other rules of XML and the types of any child elements have been declared.'
!


!AnyPattern methodsFor:'accessing'!

description

	^'ANY'
! !

!AnyPattern methodsFor:'coercing'!

alternateHeads

	^followSet copyWith: self
!

pushDownFollowSet

	self addFollow: self.
	^nil
! !

!AnyPattern methodsFor:'testing'!

couldBeText

	^true
!

matches: aNode

	^true
! !

!AnyPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/AnyPattern.st,v 1.6 2003-04-23 08:44:16 cg Exp $'


! !
