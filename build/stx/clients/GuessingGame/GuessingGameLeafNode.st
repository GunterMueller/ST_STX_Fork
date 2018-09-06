"{ Package: 'stx:clients/GuessingGame' }"

"{ NameSpace: Games }"

Object subclass:#GuessingGameLeafNode
	instanceVariableNames:'answer'
	classVariableNames:'DataBase'
	poolDictionaries:''
	category:'games-AnimalGuessing'
!


!GuessingGameLeafNode methodsFor:'accessing'!

answer
    "return the value of the instance variable 'answer' (automatically generated)"

    ^ answer
!

answer:something
    "set the value of the instance variable 'answer' (automatically generated)"

    answer := something.
! !

!GuessingGameLeafNode methodsFor:'queries'!

isLeaf
    ^  true
! !

!GuessingGameLeafNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GuessingGame/GuessingGameLeafNode.st,v 1.2 2002-11-20 12:30:56 cg Exp $'
! !
