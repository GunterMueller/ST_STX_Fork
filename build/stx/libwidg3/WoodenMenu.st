"
 COPYRIGHT (c) 1994 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

"{ Package: 'private' }"

SimpleView subclass:#WoodenMenu
	instanceVariableNames:'drawers'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Fun'
!

!WoodenMenu class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1994 by Claus Gittinger
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
    a menu consisting of pulled boxes - this is for demonstration purposes only.

    [see also:]
        WoodenBox GraniteBox PullDownMenu

    [author:]
        Claus Gittinger
"
!

examples
"
                                                                [exBegin]
    (WoodenMenu extent:400@200) open
                                                                [exEnd]

                                                                [exBegin]
    |top menu|
    top := StandardSystemView new.
    top extent:600@400.
    menu := WoodenMenu in:top.
    menu width:1.0; height:200.
    top open.
                                                                [exEnd]
"
! !

!WoodenMenu methodsFor:'initialization'!

initialize
    |x y idx h1 maxHeight|

    super initialize.

    drawers := Array new:5.
    1 to:5 do:[:index |
	|d|

	d := WoodenBox in:self.
	d label:('tools' , index printString).
	d extent:(10 @ 150).
	drawers at:index put:d.
    ].

    h1 := (drawers at:1) pullButton height + (ViewSpacing * 2).

    idx := 0.
    y := -40.
    maxHeight := 0.
    drawers do:[:aDrawer |
	|i|

	i := idx.
	aDrawer origin:[(width / 5 * i) asInteger @ (aDrawer height negated + h1)].
	aDrawer extent:[(width / 5) asInteger @ aDrawer height].
        
	idx := idx + 1.
	aDrawer pullButton action:[self pullMenu:i+1].
	maxHeight := maxHeight max:(aDrawer height).
    ].
    self height:maxHeight.

    "
     WoodenMenu new open
    "
! !

!WoodenMenu methodsFor:'pulling'!

pullMenu:index
    |d h1 button|

    h1 := (drawers at:1) pullButton height + (ViewSpacing * 2).

    d := drawers at:index.
    button := d pullButton.

    self slowDraw:d.

    d origin:(d origin x @ 0).

    button action:[d origin:[(width / 5 * (index-1)) rounded 
			     @ (d height negated + h1)].
		   button action:[self pullMenu:index]
    ].
!

slowDraw:drawer
    |step|

    step := (drawer origin y negated / 3) rounded.

    drawer origin y to:0 by:step do:[:y |
        drawer origin:(drawer origin x @ y).
        device flush.
        10 timesRepeat:[Processor yield.
            windowGroup processExposeEvents.
            Processor yield.
        ].
        device flush.
        (Delay forSeconds:0.03) wait
    ].

    drawer origin:(drawer origin x @ 0).
! !

!WoodenMenu class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/WoodenMenu.st,v 1.8 2000-08-16 15:44:15 cg Exp $'
! !
