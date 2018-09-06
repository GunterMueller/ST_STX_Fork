"
 COPYRIGHT (c) 2017 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libwidg' }"

"{ NameSpace: Smalltalk }"

ButtonController subclass:#DragRectangleController
	instanceVariableNames:'action startPoint lastX lastY'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-Controllers'
!

!DragRectangleController class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2017 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
!

documentation
"
    drags a rectangle
"
!

examples
"
    |v c|

    v := View new openAndWait.
    c := DragRectangleController new.
    c action:[:rect | Transcript showCR:rect ].
    v openAndWait.
    
    v controller:c.
"
! !

!DragRectangleController class methodsFor:'utilities'!

dragRectangleIn:aView thenDo:action
    "drag a rectangle in aView"
    
    |dragController oldController oldCursor|
    
    dragController := DragRectangleController new.
    dragController view:aView.
    oldController := aView controller.
    oldCursor := aView cursor.

    aView cursor:Cursor origin.
    dragController action:[:rectOrNil |
        |image|

        aView controller:oldController.
        aView cursor:oldCursor.
        action value:rectOrNil.
    ].
    
    aView controller:dragController.
! !

!DragRectangleController methodsFor:'accessing'!

action:aBlock
    "set the block which will be called when the rectangle drag is finished.
     The block will be called with a nil arg, if escape is pressed"
     
    action := aBlock
!

lastMousePoint
    lastX isNil ifTrue:[^ nil].
    ^ lastX @ lastY
!

startPoint
    ^ startPoint
! !

!DragRectangleController methodsFor:'event handling'!

buttonMotion:buttonState x:x y:y
    (buttonState == 0 or:[startPoint isNil]) ifTrue:[
        super buttonMotion:buttonState x:x y:y.
        ^ self
    ].
    
    lastX notNil ifTrue:[
        view xoring:[
            view displayRectangle:(startPoint corner:(lastX@lastY))
        ].
    ].
    
    lastX := x.
    lastY := y.

    startPoint ~= (x@y) ifTrue:[
        view xoring:[
            view displayRectangle:(startPoint corner:(lastX@lastY))
        ].
    ].
!

buttonPress:button x:x y:y
    startPoint := x@y.
    view cursor:(Cursor corner).
!

buttonRelease:button x:x y:y
    |rect|
    
    startPoint isNil ifTrue:[
        super buttonRelease:button x:x y:y.
        ^ self
    ].

    lastX notNil ifTrue:[
        view xoring:[
            view displayRectangle:(startPoint corner:(lastX@lastY))
        ].
    ].
    rect := startPoint corner:(lastX@lastY).
    startPoint := lastX := lastY := nil.
    action value:rect.
!

keyPress:key x:x y:y
    startPoint isNil ifTrue:[
        super keyPress:key x:x y:y.
        ^ self
    ].

    lastX notNil ifTrue:[
        view xoring:[
            view displayRectangle:(startPoint corner:(lastX@lastY))
        ].
    ].

    startPoint := nil.
    action value:nil.
! !

!DragRectangleController class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

