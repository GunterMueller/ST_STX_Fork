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

"{ Package: 'stx:clients/DrawTool' }"

PatternMenu subclass:#LineMenu
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-DrawTool'
!

!LineMenu class methodsFor:'documentation'!

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
    a menu for linewidths. Instead of textual entries,
    it shows bitmaps with short line segments in different widths.

    You can use LineMenus as persistent menus - or within
    a popUp- or pullDownmenu. See examples.

    [author:]
        Claus Gittinger

    [see also:]
        PopUpMenu PullDownMenu
        PatternMenu
        DrawTool
"
!

examples
"
    as a persistent menu:
                                                                        [exBegin]
        |p |

        p := LineMenu lineWidths:#(1 2 5 10 20) 
                   selectors:#value:
                        args:#(1 2 5 10 20)
                    receiver:[:val | Transcript showCR:val]
                         for:nil.
        p open.
                                                                        [exEnd]



    in a popup-menus:
                                                                        [exBegin]
        |v p|

        v := View new.
        p := LineMenu lineWidths:#(1 2 5 10 20) 
                   selectors:#value:
                        args:#(1 2 5 10 20)
                    receiver:[:val | Transcript showCR:val]
                         for:nil.
        v middleButtonMenu:(PopUpMenu forMenu:p).
        v open
                                                                        [exEnd]

    See example for use in a pullDown menu in the DrawTools source.
"
! !

!LineMenu class methodsFor:'instance creation'!

lineWidths:widths selectors:selectors args:args receiver:anObject for:aTopMenu
    "create & return a new lineMenu for lineWidths in the widths arg.
     Selected items will send the corresponding selector from the
     selectors array (optionally with an argument from the args array)
     to anObject."

    |newMenu|

    newMenu := self forMenu:aTopMenu.
    newMenu lineWidths:widths.
    newMenu selectors:selectors.
    newMenu args:args.
    newMenu receiver:anObject.
    ^ newMenu

    "Modified: 5.6.1996 / 11:30:17 / cg"
!

lineWidths:widths selectors:selectors receiver:anObject for:aTopMenu
    "create & return a new lineMenu for lineWidths in the widths arg.
     Selected items will send the corresponding selector from the
     selectors array to anObject."

    ^ self 
        lineWidths:widths 
        selectors:selectors 
        args:nil 
        receiver:anObject 
        for:aTopMenu

    "Modified: 27.4.1996 / 13:57:29 / cg"
! !

!LineMenu methodsFor:'accessing'!

lineWidths:widths
    "setup the patterns for lineWidths in the widths arg."

    ^ self lineWidths:widths styles:(Array new:widths size withAll:#solid)

    "Modified: 5.6.1996 / 11:36:18 / cg"
!

lineWidths:widths styles:styles
    "setup the patterns for lineWidths in the widths arg."


    |wEach hEach|

    hEach := widths max + 2.
    wEach := 64.
    ^ self lineWidths:widths styles:styles width:wEach height:hEach

    "Modified: 5.6.1996 / 11:38:04 / cg"
!

lineWidths:widths styles:styles width:wEach height:hEach
    "setup the patterns for lineWidths in the widths arg."

    |nWidths patterns|

    nWidths := widths size.
    patterns := Array new:nWidths.
    1 to:nWidths do:[:index |
        |bitmap|

        bitmap := Form width:wEach height:hEach depth:1.
        bitmap paint:(Color colorId:0).
        bitmap fillRectangleX:0 y:0 width:wEach height:hEach.
        bitmap paint:(Color colorId:1).
        bitmap lineWidth:(widths at:index).
        bitmap lineStyle:(styles at:index).
        bitmap displayLineFromX:1 y:(hEach // 2) toX:(wEach - 1) y:(hEach // 2).
        patterns at:index put:bitmap.
    ].
    self patterns:patterns.
    self patternSize:(wEach @ hEach).
    self windowRatio:(1 @ nWidths).

    "Created: 5.6.1996 / 11:37:34 / cg"
    "Modified: 14.6.1996 / 16:19:37 / cg"
! !

!LineMenu class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/clients/DrawTool/LineMenu.st,v 1.10 2000-10-13 09:35:52 mb Exp $'
! !
