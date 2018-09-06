"{ Package: 'stx:clients/Demos/Dice' }"

"{ NameSpace: CodingExamples_GUI }"

AbstractDiceView subclass:#DigitalDiceView
	instanceVariableNames:''
	classVariableNames:'PointCoordinates'
	poolDictionaries:''
	category:'demos-Dice'
!


!DigitalDiceView class methodsFor:'initialization'!

initialize
    |points1 points2 points3 points4 points5 points6 |

    PointCoordinates := Array new:6.

    points1 := OrderedCollection new.
    points1 add:((1/2) @ (1/2)).

    points2 := OrderedCollection new.
    points2 add:((3/4) @ (1/4)).
    points2 add:((1/4) @ (3/4)).

    points3 := OrderedCollection new.
    points3 add:((3/4) @ (1/4)).
    points3 add:((1/2) @ (1/2)).
    points3 add:((1/4) @ (3/4)).

    points4 := OrderedCollection new.
    points4 add:((1/4) @ (1/4)).
    points4 add:((3/4) @ (1/4)).
    points4 add:((3/4) @ (3/4)).
    points4 add:((1/4) @ (3/4)).

    points5 := OrderedCollection new.
    points5 add:((1/4) @ (1/4)).
    points5 add:((3/4) @ (1/4)).
    points5 add:((3/4) @ (3/4)).
    points5 add:((1/4) @ (3/4)).
    points5 add:((1/2) @ (1/2)).

    points6 := OrderedCollection new.
    points6 add:((1/4) @ (1/4)).
    points6 add:((3/4) @ (1/4)).
    points6 add:((3/4) @ (3/4)).
    points6 add:((1/4) @ (3/4)).
    points6 add:((1/4) @ (1/2)).
    points6 add:((3/4) @ (1/2)).

    PointCoordinates at:1 put:points1.
    PointCoordinates at:2 put:points2.
    PointCoordinates at:3 put:points3.
    PointCoordinates at:4 put:points4.
    PointCoordinates at:5 put:points5.
    PointCoordinates at:6 put:points6.

    "
     DiceView initialize
    "
! !

!DigitalDiceView class methodsFor:'examples'!

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
! !

!DigitalDiceView methodsFor:'drawing'!

redrawDiceValue
    |f x y diceValue diceValueString|

    self paint:Color white.

    diceValue := myDice diceValue.
    diceValueString := diceValue printString.

    "/ f := self font.
    "/ y := f ascent.

    self font:(Font family:'courier' size:28).

    x := self width / 2.
    y := (self height / 2) + (self font ascent / 2).

    self displayString:diceValueString x:x y:y.
! !

!DigitalDiceView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Dice/DigitalDiceView.st,v 1.1 2002-12-06 10:49:30 cg Exp $'
! !

DigitalDiceView initialize!
