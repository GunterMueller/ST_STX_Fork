"
 COPYRIGHT (c) 1997 by eXept Software AG
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

ScrollableView subclass:#SequenceView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Lists'
!

!SequenceView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1997 by eXept Software AG
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
    implements a SelectionInListView with configurable scrollbars

    ST-80 compatibility

    [see also:]
        SelectionInListView
"
!

examples
"
    same behavior as a SelectionInListView, but scrollable
                                                                        [exBegin]
    |view|

    view := self extent:100@100.
    view list:#( 'a' 'b' 'c' 'd' 'e' 'f' 'g' 'h' 'in der Ruhe liegt die Kraft').
    view multipleSelectOk:true.
    view openAndWait.
                                                                        [exEnd]
"
! !

!SequenceView class methodsFor:'defaults'!

defaultFont
    ^ SelectionInListView defaultFont

    "Created: / 20.6.1998 / 14:17:01 / cg"
! !

!SequenceView methodsFor:'Compatibility-ST80'!

optimizeForText
    "dummy - ST-80 compatibility"

    "Created: / 6.7.1998 / 13:26:18 / cg"
! !

!SequenceView methodsFor:'initialization'!

initialize
    "setup a ScrollableView scrolling a SelectionInList instance"

    super initialize.

    self verticalScrollable:true;     verticalMini:false.
    self horizontalScrollable:true; horizontalMini:false.

    self scrolledView:SelectionInListView new
! !

!SequenceView methodsFor:'slave-view messages'!

enabled:aBoolean
    "senders assume that I am the listView - not a wrapper"

    scrolledView enabled:aBoolean
!

font:aFont
    "set the font for the scrolled view"

    |scrolledView|
    
    super font:aFont.
    (scrolledView := self scrolledView) notNil ifTrue:[scrolledView font:aFont].
!

invalidate
    "senders assume that I am the listView - not a wrapper"

    scrolledView invalidate
!

invalidate:aRectangle
    "senders assume that I am the listView - not a wrapper"

    scrolledView invalidate:aRectangle
!

invalidate:aRectangle repairNow:doRepair
    "senders assume that I am the listView - not a wrapper"

    scrolledView invalidate:aRectangle repairNow:doRepair
!

invalidateDeviceRectangle:aRectangle repairNow:doRepair
    "senders assume that I am the listView - not a wrapper"

    scrolledView invalidateDeviceRectangle:aRectangle repairNow:doRepair
!

invalidateRepairNow:doRepair
    "senders assume that I am the listView - not a wrapper"

    scrolledView invalidateRepairNow:doRepair
! !

!SequenceView class methodsFor:'documentation'!

version
    ^ '$Header$'
! !

