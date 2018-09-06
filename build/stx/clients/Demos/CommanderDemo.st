"{ NameSpace: Demos }"

Object subclass:#CommanderDemo
	instanceVariableNames:'drawView'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-Graphics'
!

CommanderDemo comment:'
 play around with a commander

 start with:
       CommanderDemo open

 $Header: /cvs/stx/stx/clients/Demos/CommanderDemo.st,v 1.11 1998-07-09 08:09:06 cg Exp $
 written spring 89 by claus
'!

!CommanderDemo class methodsFor:'documentation'!

documentation
"
 demonstrates use of buttons and the commander class


 [see also:]
     PenDemo Commander Pen
     GraphicsContext

 [start with:]
     CommanderDemo open

 [author:]
     Claus Gittinger - written spring 89
"
! !

!CommanderDemo class methodsFor:'startup'!

isVisualStartable
    "returns whether this application class can be started via #open
     (i.e. via a double click on the class in the browser)"

    ^ true

    "Created: / 7.7.1998 / 17:36:45 / cg"
!

open
    "open a new commanderDemo"

    self new open

    "CommanderDemo open"
! !

!CommanderDemo methodsFor:'startup'!

open
    "setup the topView, some buttons and a commander"

    |topView panel fastToggle slowToggle|

    topView := StandardSystemView
                    label:'CommanderDemo'
                    icon:(Image fromFile:'bitmaps/CommanderDemo.icon').

    topView minExtent:(600 @ 400).

    panel := PanelView origin:(0.0 @ 0.0) extent:(1.0 @ 1.0) in:topView.

    drawView := panel.

    Button label:'spiral 121'
          action:[self spiral:121]
              in:panel.

    Button label:'spiral 89'
          action:[self spiral:89]
              in:panel.

    Button label:'spiral 59'
          action:[self spiral:59]
              in:panel.

    Button label:'mandala'
          action:[self mandala]
              in:panel.

"/    slowToggle :=
"/        Toggle label:'slow'
"/              action:[fastToggle turnOff. topView device unBuffered]
"/                  in:panel.
"/
"/    fastToggle :=
"/        Toggle label:'fast'
"/              action:[slowToggle turnOff. topView device buffered]
"/                  in:panel.
"/    fastToggle turnOn.

    Button label:'quit'
          action:[topView destroy]
              in:panel.

    topView open.
! !

!CommanderDemo methodsFor:'user interaction'!

mandala
    "let the commander draw mandalas"

    |bic|
    drawView clear.
    bic := Commander new:4 in:drawView.
    bic fanOut.
    bic do:[:eachPen | eachPen up. eachPen go:100. eachPen down].
    bic do:[:eachPen | eachPen mandala:10 radius:100]
!

spiral:angle
    "let the commander draw spirals"

    |bic|
    drawView clear.
    bic := Commander new:4 in:drawView.
    bic fanOut.
    bic do:[:eachPen | eachPen up. eachPen go:100. eachPen down].
    bic do:[:eachPen | eachPen spiral:200 angle:angle]
! !

!CommanderDemo class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/Demos/CommanderDemo.st,v 1.11 1998-07-09 08:09:06 cg Exp $'
! !
