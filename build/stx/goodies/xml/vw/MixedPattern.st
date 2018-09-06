"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ComplexPattern subclass:#MixedPattern
	instanceVariableNames:'items'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

MixedPattern comment:'This class represents the ''mixed'' element content constraint in an element type declaration. An element type has mixed content when elements of that type may contain both other child elements and character data (text) as specified in the element content declaration.

Note: For mixed content type elements, one can''t control the order in which the child elements, mixed in among the text, appear.

Instance Variables:
	items   <SequenceableCollection>  comment
'
!


!MixedPattern class methodsFor:'instance creation'!

on: aList

	1 to: aList size do: [:i |
		i+1 to: aList size do: [:j |
			((aList at: i) name asString = (aList at: j) name asString)
				ifTrue: [XMLParser invalid: 'Duplicate element names in a mixed content specification.']]].
	^self new on: (aList size = 0 ifTrue: [#()] ifFalse: [aList])
! !

!MixedPattern methodsFor:'accessing'!

items
    ^ items
! !

!MixedPattern methodsFor:'coercing'!

alternateHeads

	^items, followSet
!

pushDownFollowSet

	items do: [:i | i addFollow: self; addFollows: followSet].
	^items
! !

!MixedPattern methodsFor:'initialization'!

on: aList

	items := (Array with: PCDATAPattern new), aList
! !

!MixedPattern methodsFor:'testing'!

couldBeText

	^true
! !

!MixedPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/MixedPattern.st,v 1.8 2008-03-08 11:01:14 cg Exp $'


! !
