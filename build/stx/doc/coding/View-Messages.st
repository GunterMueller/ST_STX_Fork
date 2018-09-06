"{ NameSpace: CodingExamples_GUI }"

View subclass:#EventMessageView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'examples-Views'
!

!EventMessageView class methodsFor:'documentation'!

documentation
"
  this example demonstrates messages sent to views.

  Evaluate the following expression, and watch the output in
  the xterm for what is going on ...

  [author:]
     Claus Gittinger

  [start with:]
     EventMessageView new open
"
! !

!EventMessageView methodsFor:'event messages'!

buttonPress:button x:x y:y
    self showWhere.
    super buttonPress:button x:x y:y
!

buttonRelease:button x:x y:y
    self showWhere.
    super buttonRelease:button x:x y:y
!

configureX:x y:y width:newWidth height:newHeight
    self showWhere.
    super configureX:x y:y width:newWidth height:newHeight 
!

destroyed 
    self showWhere.
    super destroyed 
!

exposeX:x y:y width:w height:h
    self showWhere.
    super exposeX:x y:y width:w height:h
!

keyPress:key x:x y:y
    self showWhere.
    super keyPress:key x:x y:y
!

keyRelease:key x:x y:y
    self showWhere.
    super keyRelease:key x:x y:y
!

mapped 
    self showWhere.
    super mapped 
!

pointerEnter:state x:x y:y
    self showWhere.
    super pointerEnter:state x:x y:y 
!

pointerLeave:state
    self showWhere.
    super pointerLeave:state 
!

sizeChanged:how 
    self showWhere.
    super sizeChanged:how 
!

unmapped 
    self showWhere.
    super unmapped 
!

visibilityChange:how
    self showWhere.
    super visibilityChange:how 
! !

!EventMessageView methodsFor:'messages'!

create
    self showWhere.
    super create
!

destroy 
    self showWhere.
    super destroy 
!

initEvents
    self showWhere.
    super initEvents
!

initStyle
    self showWhere.
    super initStyle
!

initialize
    self showWhere.
    super initialize
!

realize 
    self showWhere.
    super realize. 
    self enableEvent:#visibilityChange.
!

terminate 
    self showWhere.
    super terminate 
!

unrealize 
    self showWhere.
    super unrealize 
! !

!EventMessageView methodsFor:'private'!

showWhere
    |sender sel|

    sender := thisContext sender sender.
    sel := sender selector.

    [
       ((sel startsWith:'valueWithReceiver:')
        or:[(sel startsWith:'perform:')
        or:[(sel startsWith:'sendEventWithFocusOn:')
        or:[(sel startsWith:'sendEvent:')
        or:[(sel startsWith:'handle:do:')
        or:[sender isBlockContext
        ]]]]])
    ] whileTrue:[
        sender := sender sender.
        sel := sender selector.
    ].
    (thisContext sender selector printStringPaddedTo:15) printCR.
    '     sender: ' print. sender printCR.
    '     process: ' print. Processor activeProcess nameOrId print.
                        '(' print.
                        Processor activeProcess id print.
                        ')' printNL.
! !

!EventMessageView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/doc/coding/View-Messages.st,v 1.9 1997-01-03 21:40:40 cg Exp $'
! !
