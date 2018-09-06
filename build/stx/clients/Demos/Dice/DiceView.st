"{ Package: 'stx:clients/Demos/Dice' }"

"{ NameSpace: CodingExamples_GUI }"

AbstractDiceView subclass:#DiceView
	instanceVariableNames:''
	classVariableNames:'PointCoordinates'
	poolDictionaries:''
	category:'demos-Dice'
!


!DiceView class methodsFor:'initialization'!

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

!DiceView methodsFor:'drawing'!

drawPointAtX:x y:y
    self paint:Color white.
    self fillCircleX:x y:y radius:(self height / 10).
!

drawPoints:aCollectionOfCoordinates
    aCollectionOfCoordinates do:[:eachRelPoint |
        |rX rY|

        rX := eachRelPoint x.
        rY := eachRelPoint y.

        self drawPointAtX:(self width * rX) y:(self height * rY).
    ].
!

redrawDicePoints
    self redrawDicePointsVersion2
!

redrawDiceValue
    self redrawDicePoints.
! !

!DiceView methodsFor:'drawing - version1'!

redraw1Point
    |points|

    points := OrderedCollection new.
    points add:((1/2) @ (1/2)).

    self drawPoints:points 
!

redraw2Point
    |points|

    points := OrderedCollection new.
    points add:((3/4) @ (1/4)).
    points add:((1/4) @ (3/4)).

    self drawPoints:points 
!

redraw3Point
    |points|

    points := OrderedCollection new.
    points add:((3/4) @ (1/4)).
    points add:((1/2) @ (1/2)).
    points add:((1/4) @ (3/4)).

    self drawPoints:points 
!

redrawDicePointsVersion1
    |diceValue drawMessage |

    diceValue := myDice diceValue.

    drawMessage := ('redraw' , diceValue printString , 'Point') asSymbol.
    "/ drawMessage := #(#redraw1Point #redraw2Point #redraw3Point #redraw4Point #redraw5Point #redraw6Point)
    "/                at:diceValue.

    self perform:drawMessage
! !

!DiceView methodsFor:'drawing - version2'!

redrawDicePointsVersion2
    |diceValue coords |

    diceValue := myDice diceValue.

    coords := PointCoordinates at:diceValue.
    self drawPoints:coords.
! !

!DiceView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Dice/DiceView.st,v 1.1 2002-12-06 10:49:01 cg Exp $'
! !

DiceView initialize!
