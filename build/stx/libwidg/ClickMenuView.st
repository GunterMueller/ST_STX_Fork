"
 COPYRIGHT (c) 1991 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"

MenuView subclass:#ClickMenuView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Menus'
!

!ClickMenuView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1991 by Claus Gittinger
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
    ClickMenuViews are like menuViews, but deselects automatically
    after clicked on an entry.

    ClickMenuViews can be used as persistent menus (i.e. non-popping); 
    for example, the old launcher uses an instance of ClickMenuView.

    CAVEAT:
        to support a better NextStep look, some popUpMenus should 
        become automatically a clickMenu ... (really ?)

    [author:]
        Claus Gittinger

    [see also:]
        PopUpMenu PullDownMenu
        MenuView
"
!

examples 
"
    stupid example:
                                                                        [exBegin]
        |top menu1 menu2 application|

        application := Plug new.
        application respondTo:#foo
                         with:[Transcript showCR:'foo'].
        application respondTo:#bar 
                         with:[Transcript showCR:'bar'].
        application respondTo:#baz 
                         with:[Transcript showCR:'baz'].
        application respondTo:#more1 
                         with:[Transcript showCR:'more1'].
        application respondTo:#more2 
                         with:[Transcript showCR:'more2'].
        application respondTo:#more3 
                         with:[Transcript showCR:'more3'].
        application respondTo:#quit 
                         with:[top destroy].

        top := StandardSystemView new.
        menu1 := ClickMenuView 
                    labels:#(
                             'foo'
                             'bar'
                             'baz '
                             '-'
                             'more foo'
                             '='
                             'quit'
                            )
                    selectors:#(
                            foo
                            bar
                            baz
                            nil
                            moreFoo
                            nil
                            quit
                           )
                    receiver:application.

        menu1 subMenuAt:#moreFoo put:(
            PopUpMenu labels:#(
                                'more1 '
                                'more2 '
                                'more3'
                               )
                   selectors:#(
                                more1
                                more2
                                more3
                               )
        ).
        menu1 resize; open.
        top add:menu1.
        top openWithExtent:(menu1 extent).
                                                                        [exEnd]
"
! !

!ClickMenuView methodsFor:'event handling'!

buttonRelease:button x:x y:y
    "redefined to automatically deselect on release"

    super buttonRelease:button x:x y:y.
    self setSelection:nil

    "Modified: 25.5.1996 / 12:26:49 / cg"
! !

!ClickMenuView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg/ClickMenuView.st,v 1.13 1996-05-25 12:22:42 cg Exp $'
! !
