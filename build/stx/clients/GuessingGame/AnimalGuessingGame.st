"{ Package: 'stx:clients/GuessingGame' }"

"{ NameSpace: Games }"

GuessingGame subclass:#AnimalGuessingGame
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'games-AnimalGuessing'
!


!AnimalGuessingGame methodsFor:'asking'!

askForInitialItem
    ^ Dialog request:'No data yet.\\Enter the name of an animal:' withCRs.
!

askForInitialQuestion
    ^ Dialog request:'No data yet.\\Enter a question, which is true for this animal:' withCRs.
!

askForNewItem
    ^ Dialog request:'Enter the name of this (new) animal:' withCRs
! !

!AnimalGuessingGame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GuessingGame/AnimalGuessingGame.st,v 1.2 2002-11-20 12:30:58 cg Exp $'
! !
