"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
              All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

View subclass:#PluggableView
	instanceVariableNames:'redrawAction buttonPressAction keyPressAction'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!PluggableView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) Claus Gittinger / 2006 by eXept Software AG
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
    a view for which the redraw, button and key-actions can be plugged as
    blocks.
    Mostly useful for little examples (where we dont want to add a full-blown class
    for.

    [author:]
        Claus Gittinger (cg@alan)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"

    a simple lissajous figure
                                                                [exBegin]
    |v|

    v := PluggableView new.
    v viewBackground:Color black.
    v redrawAction:[
        |offsX offsY scaleX scaleY|

        scaleX := v width - 10 // 2.
        scaleY := v height - 10 // 2.
        offsX := v width // 2.
        offsY := v height // 2.

        0 to:360 do:[:degrees |
            |radians x y|

            radians := degrees degreesToRadians.
            x := (radians * 3 ) cos.
            y := (radians * 5 ) sin.

            x := x * scaleX + offsX.
            y := y * scaleY + offsY.
            v atX:x y:y put:Color red.
        ].
    ].
    v open.
                                                                [exEnd]
"
! !

!PluggableView methodsFor:'accessing'!

buttonPressAction:something
    "set the value of the instance variable 'buttonPressAction' (automatically generated)"

    buttonPressAction := something.
!

keyPressAction:something
    "set the value of the instance variable 'keyPressAction' (automatically generated)"

    keyPressAction := something.
!

redrawAction:something
    "set the value of the instance variable 'redrawAction' (automatically generated)"

    redrawAction := something.
! !

!PluggableView methodsFor:'events'!

buttonPress:button x:x y:y
    buttonPressAction notNil ifTrue:[
        buttonPressAction value:button value:(x @ y)
    ]
!

keyPress:key x:x y:y
    keyPressAction notNil ifTrue:[
        keyPressAction value:key value:(x @ y)
    ]
!

redraw
    super redraw.
    redrawAction notNil ifTrue:[
        redrawAction value
    ]
!

sizeChanged:how
    super sizeChanged:how.
    self clear.
    self redraw.
! !

!PluggableView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libview2/PluggableView.st,v 1.2 2003-01-09 16:58:22 cg Exp $'
! !

