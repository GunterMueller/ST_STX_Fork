"{ Package: 'stx:clients/GuessingGame' }"

"{ NameSpace: Games }"

Object subclass:#GuessingGame
	instanceVariableNames:'currentNode'
	classVariableNames:'DataBase'
	poolDictionaries:''
	category:'games-AnimalGuessing'
!

!GuessingGame class methodsFor:'documentation'!

documentation
"
    An example of a simple, naive expert system;
    guess an animal.

    [author:]

    [see also:]

    [instance variables:]

    [class variables:]
"
!

examples
"
  to clear the database, execute:
                                                              [exBegin]
    Games::AnimalGuessingGame clearDatabase
                                                                [exEnd]


  to play the guessing game, execute:
                                                              [exBegin]
    [true] whileTrue:[
        Games::AnimalGuessingGame start
    ]
                                                                [exEnd]
"
! !

!GuessingGame class methodsFor:'cleanup'!

clearDatabase
    DataBase := nil.

    "
     AnimalGuessingGame clearDatabase
    "
! !

!GuessingGame class methodsFor:'playing'!

start
    self new startInNode:(self dataBase)
! !

!GuessingGame class methodsFor:'queries'!

dataBase
    ^ DataBase
! !

!GuessingGame methodsFor:'asking'!

askForInitialItem
    ^ Dialog request:'No data yet.\\Enter the name of an item:' withCRs.
!

askForInitialQuestion
    ^ Dialog request:'No data yet.\\Enter a question, which is true for this item:' withCRs.
!

askForNewItem
    ^ Dialog request:'Enter the name of this (new) item:' withCRs
! !

!GuessingGame methodsFor:'guessing'!

askAboutNode:aNode
    |item question newNode newLeaf answer whichNode whichItem|

    answer := Dialog confirm:(aNode question , ' ?').
    answer ifTrue:[
        whichNode := aNode yesNode
    ] ifFalse:[
        whichNode := aNode noNode
    ].

    whichNode isNil ifTrue:[
        item := self askForNewItem.
        item size == 0 ifTrue:[^ self].

        newLeaf := GuessingGameLeafNode new.
        newLeaf answer:item.
        answer ifTrue:[
            aNode yesNode:newLeaf
        ] ifFalse:[
            aNode noNode:newLeaf
        ].
        ^  self        
    ].
    whichNode isLeaf ifFalse:[
        ^ self askAboutNode:whichNode.
    ].

    whichItem := whichNode answer article , ' ' , whichNode answer.

    answer := Dialog confirm:('Is it ' , whichItem  , ' ?').
    answer ifTrue:[
        Dialog information:'Thats it: ', whichItem.
        ^ self.
    ].

    item := self askForNewItem. 
    item size == 0 ifTrue:[^ self].
    question := Dialog request:('Enter a question, which is true for ' , 
                                item article , ' ' , item , ',\but false for ' , whichItem) withCRs.
    question size == 0 ifTrue:[^ self].

    newNode := (GuessingGameNode new).
    newNode question:question.
    newLeaf := GuessingGameLeafNode new.
    newLeaf answer:item.
    newNode yesNode:newLeaf.
    newNode noNode:whichNode.

    answer ifTrue:[
        aNode yesNode:newNode
    ] ifFalse:[
        aNode noNode:newNode
    ].

    "
     DataBase := nil.
     self new start
    "
!

startInNode:aNode
    |animal question newNode newLeaf|

    aNode isNil ifTrue:[
        animal := self askForInitialItem.
        animal size == 0 ifTrue:[^ self].
        question := self askForInitialQuestion.
        question size == 0 ifTrue:[^ self].

        newNode := GuessingGameNode new.
        newNode question:question.
        newLeaf := GuessingGameLeafNode new.
        newLeaf answer:animal.
        newNode yesNode:newLeaf.
        DataBase := newNode.
        ^  self.
    ].

    ^ self askAboutNode:aNode

    "
     DataBase := nil.
     self new start
    "
! !

!GuessingGame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/GuessingGame/GuessingGame.st,v 1.3 2007-03-06 15:52:06 cg Exp $'
! !
