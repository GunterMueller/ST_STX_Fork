"{ Package: 'stx:clients/Demos/Dice' }"

"{ NameSpace: CodingExamples_GUI }"

View subclass:#AbstractDiceView
	instanceVariableNames:'myDice'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Dice'
!


!AbstractDiceView methodsFor:'accessing'!

dice:aDice
    myDice := aDice.
    myDice addDependent:self.
! !

!AbstractDiceView methodsFor:'change & update'!

update:what with:aParameter from:changedObject
    self redraw
! !

!AbstractDiceView methodsFor:'drawing'!

redraw
    self redrawBackground.
    self redrawDiceValue.
!

redrawBackground
    |bounds|

    self paint:Color red.
    bounds := Rectangle origin:0@0 extent:(self width @ self height).
    self fillRectangle:bounds.
! !

!AbstractDiceView methodsFor:'event handling'!

sizeChanged:how
    self redraw
! !

!AbstractDiceView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/Dice/AbstractDiceView.st,v 1.1 2002-12-06 10:49:17 cg Exp $'
! !
