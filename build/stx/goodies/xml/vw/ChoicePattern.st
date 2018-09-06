"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ComplexPattern subclass:#ChoicePattern
	instanceVariableNames:'items'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

ChoicePattern comment:'This class represents the ''choice'' element content constraint in an element type declaration. According to the XML 1.0 specification, the ''choice'' pattern/rule signifies that any content particle in a choice list (declared in the DTD) may appear in the element content at the location where the choice list appears in the grammar

Instance Variables:
	items   <XML.Pattern> Collection of content particles
'
!


!ChoicePattern class methodsFor:'instance creation'!

on: aList

	^self new on: aList
! !

!ChoicePattern methodsFor:'coercing'!

alternateHeads

	^items
!

pushDownFollowSet

	items do: [:i | i addFollows: followSet].
	^items
! !

!ChoicePattern methodsFor:'initialization'!

on: aList

	items := aList
! !

!ChoicePattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/ChoicePattern.st,v 1.7 2005-05-11 09:29:03 cg Exp $'


! !
