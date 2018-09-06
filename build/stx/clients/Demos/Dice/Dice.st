"{ Package: 'stx:clients/Demos/Dice' }"

"{ NameSpace: CodingExamples_GUI }"

Object subclass:#Dice
	instanceVariableNames:'generator diceValue'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Dice'
!


!Dice class methodsFor:'instance creation'!

new
    |newDice|

    newDice := super new.
    newDice initGenerator.
    newDice roll.
    ^ newDice
! !

!Dice class methodsFor:'examples'!

example1
    |theDice diceView rollButton|

    theDice := Dice new.
    theDice roll.

    diceView := DiceView new.
    diceView dice:theDice.
    diceView open.

    rollButton := Button new.
    rollButton action:[ theDice roll ].
    rollButton open.

    "
     self example1.
    "
!

example2
    |theDice diceView rollButton|

    theDice := Dice new.
    theDice roll.

    diceView := DigitalDiceView new.
    diceView dice:theDice.
    diceView open.

    rollButton := Button new.
    rollButton action:[ theDice roll ].
    rollButton open.

    "
     self example2.
    "
!

example3
    |theDice diceView1 diceView2 rollButton|

    theDice := Dice new.
    theDice roll.

    diceView1 := DiceView new.
    diceView1 dice:theDice.
    diceView1 open.

    diceView2 := DigitalDiceView new.
    diceView2 dice:theDice.
    diceView2 open.

    rollButton := Button new.
    rollButton action:[ theDice roll ].
    rollButton open.

    "
     self example3.
    "
!

example4
    |theDice topView diceView1 diceView2 rollButton|

    theDice := Dice new.
    theDice roll.

    topView := StandardSystemView new.
    topView label:'DiceExample'.

    diceView1 := DiceView in:topView.
    diceView1 origin:(0.0 @ 0.0).
    diceView1 corner:(1.0 @ (1/3)).
    diceView1 dice:theDice.

    diceView2 := DigitalDiceView in:topView.
    diceView2 origin:(0.0 @ (1/3)).
    diceView2 corner:(1.0 @ (2/3)).
    diceView2 dice:theDice.

    rollButton := Button in:topView.
    rollButton action:[ theDice roll ].
    rollButton origin:(0.0 @ (2/3)).
    rollButton corner:(1.0 @ 1.0).
    rollButton label:'Roll'.

    topView open.

    "
     self example4.
    "
! !

!Dice methodsFor:'accessing'!

diceValue
    "return the value of the instance variable 'diceValue' (automatically generated)"

    ^ diceValue
!

diceValue:something
    "set the value of the instance variable 'diceValue' (automatically generated)"

    diceValue := something.
    self changed:#diceValue.
! !

!Dice methodsFor:'dice operations'!

roll
    self diceValue:(generator nextIntegerBetween:1 and:6)
! !

!Dice methodsFor:'initialization'!

initGenerator
    generator := Random new.
! !

!Dice class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Dice/Dice.st,v 1.1 2002-12-06 10:49:37 cg Exp $'
! !
