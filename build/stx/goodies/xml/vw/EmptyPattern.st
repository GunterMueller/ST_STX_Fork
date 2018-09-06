"{ Package: 'stx:goodies/xml/vw' }"

"{ NameSpace: XML }"

ConcretePattern subclass:#EmptyPattern
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'XML-VW-Patterns'
!

EmptyPattern comment:'This class represents the EMPTY element content constraint in an element type declaration. According to the XML 1.0 specification the EMPTY element declaration indicates that the element has no content'
!


!EmptyPattern methodsFor:'coercing'!

alternateHeads

	^followSet
! !

!EmptyPattern methodsFor:'testing'!

isEmptyPattern
    ^ true
!

matches: aNode

	^false
! !

!EmptyPattern class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/xml/vw/EmptyPattern.st,v 1.7 2008-09-26 10:58:27 stefan Exp $'


! !
