"{ NameSpace: TDV }"

AbstractComponent subclass:#DrawableComponent
	instanceVariableNames:'draw'
	classVariableNames:''
	poolDictionaries:''
	category:'TDV-AbstractComponents'
!


!DrawableComponent methodsFor:'accessing'!

aspectAt:aKey put:aValue
"store an aspect identified by its symbol and its value;

<return: self>
"  

    aKey == #draw
	ifTrue:[draw := aValue].
    super aspectAt:aKey put:aValue



! !

!DrawableComponent methodsFor:'initialization'!

initialize

    super initialize.
    draw := false.


! !

!DrawableComponent methodsFor:'protocol'!

drawComponent
"initialize myself to be read for drawing;
in subclasses always class super draw

<return: self>
"   
    initialized == false 
	ifTrue:[necesassaryVariableInitialized := self initBeforeDrawing.
		initialized := true].
    (necesassaryVariableInitialized and:[draw])
	ifTrue:[self draw].

! !

!DrawableComponent class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DataViewer/DrawableComponent.st,v 1.4 1999-04-23 15:22:49 cg Exp $'
! !
