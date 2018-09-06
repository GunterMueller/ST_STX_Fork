"{ Package: 'stx:clients/GuessingGame' }"

"{ NameSpace: Games }"

Object subclass:#GuessingGameNode
	instanceVariableNames:'question yesNode noNode'
	classVariableNames:'DataBase'
	poolDictionaries:''
	category:'games-AnimalGuessing'
!


!GuessingGameNode methodsFor:'accessing'!

noNode
    "return the value of the instance variable 'noNode' (automatically generated)"

    ^ noNode
!

noNode:something
    "set the value of the instance variable 'noNode' (automatically generated)"

    noNode := something.
!

question
    "return the value of the instance variable 'question' (automatically generated)"

    ^ question
!

question:something
    "set the value of the instance variable 'question' (automatically generated)"

    question := something.
!

yesNode
    "return the value of the instance variable 'yesNode' (automatically generated)"

    ^ yesNode
!

yesNode:something
    "set the value of the instance variable 'yesNode' (automatically generated)"

    yesNode := something.
! !

!GuessingGameNode methodsFor:'queries'!

isLeaf
    ^ false
! !

!GuessingGameNode class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GuessingGame/GuessingGameNode.st,v 1.2 2002-11-20 12:30:53 cg Exp $'
! !
