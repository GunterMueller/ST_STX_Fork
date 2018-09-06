"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ComplexPattern subclass:#SequencePattern
	instanceVariableNames:'items'
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

SequencePattern comment:'This class represents the ''sequence'' element content constraint in an element type declaration. According to the XML 1.0 specification, the ''sequence'' pattern/rule signifies that content particles occuring in a sequence list (declared in the DTD) must each appear in the element content in the order given in the list.

Instance Variables:
	items   <SequenceableCollection> Collection of content particles
'
!


!SequencePattern class methodsFor:'instance creation'!

on: aList

	^self new on: aList
! !

!SequencePattern methodsFor:'accessing'!

items
    ^ items
! !

!SequencePattern methodsFor:'coercing'!

alternateHeads

	^Array with: items first
!

pushDownFollowSet

	1 to: items size-1 do: [:i |
		(items at: i) addFollow: (items at: i+1)].
	items last addFollows: followSet.
	^items
! !

!SequencePattern methodsFor:'initialization'!

on: aList

	items := aList
! !

!SequencePattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/SequencePattern.st,v 1.8 2008-03-08 11:01:53 cg Exp $'


! !
