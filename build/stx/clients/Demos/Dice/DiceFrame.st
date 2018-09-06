"{ Package: 'stx:clients/Demos/Dice' }"

"{ NameSpace: CodingExamples_GUI }"

StandardSystemView subclass:#DiceFrame
	instanceVariableNames:'diceView rollButton'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Dice'
!


!DiceFrame methodsFor:'initialization'!

initialize
    |theDice SZ|

    SZ := 250 @ 250.

    super initialize.

    self extent:SZ.
    self maxExtent:SZ.
    self minExtent:SZ.

    theDice := Dice new.
    diceView := DiceView in:self.
    diceView dice:theDice.

    rollButton := Button in:self.
    rollButton label:'Gamble'.
    rollButton action:[ theDice roll ].
    rollButton origin:(0 @ 130).
    rollButton corner:SZ.
! !

!DiceFrame class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Dice/DiceFrame.st,v 1.1 2002-12-06 10:49:10 cg Exp $'
! !
