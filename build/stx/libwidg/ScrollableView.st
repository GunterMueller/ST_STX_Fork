"
 COPYRIGHT (c) 1989 by Claus Gittinger
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

SimpleView subclass:#ScrollableView
	instanceVariableNames:'scrolledView vScrollBar hScrollBar scrollBarPosition lockUpdates
		hideVScrollBar hideHScrollBar hasHorizontalScrollBar
		hasVerticalScrollBar horizontalMini verticalMini vScrollBarHidden
		hScrollBarHidden scrolledViewHMargin scrolledViewVMargin
		scrollBarVSpacing scrollBarHSpacing scrolledViewLayout
		hScrollBarLayout vScrollBarLayout hideScrollbarIfPointerOutside'
	classVariableNames:'DefaultScrolledViewLevel DefaultScrolledViewMargin
		DefaultScrollBarSpacing DefaultScrolledViewBorderWidth
		DefaultLevel DefaultScrollBarLevel MyDefaultViewBackgroundColor'
	poolDictionaries:''
	category:'Views-Basic'
!

!ScrollableView class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1989 by Claus Gittinger
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
    a view containing a scrollbar and some other (slave-)view.
    This view wraps scrollbar(s) around the view to be scrolled.
    The scrollbars are setup to send scrollUp/scrollDown/scrollVerticalTo
    and scrollLeft/scrollRight/scrollHorizontalTo- messages whenever moved.
    The view itself has to implement these (there is a default implementation
    in the common View class for this - so your widgets usually don't have to
    care for this).

    For the scrollbars to know about the full (maximum) size, the view
    MUST implement #heightOfContents and/or #widthOfContents.
    The values returned by those methods are used to compute the fraction
    which is visible (i.e. the scrollers thumb heights).

    There are three ways to setup a scrollableView:
    if the type of the view to be scrolled is known in advance,
    use:
        v := ScrollableView for:<ViewClass>
    or:
        v := ScrollableView for:<ViewClass> in:someSuperView


    otherwise, create an empty scrollableView with:

        v := ScrollableView new
    or:
        v := ScrollableView in:someSuperView

    and define the view later with:

        v scrolledView:aViewToBeScrolled


    Finally, if the view to be scrolled has been already created,
    use:

        v := ScrollableView forView:aViewToBeScrolled
    or:
        v := ScrollableView forView:aViewToBeScrolled in:someSuperView

    It is also possible to change the scrolledView later (even multiple times).
    This may be useful if different views are needed to display different types
    of data (see example2) and at creation time, it is not known what type
    of view is required (multidocument format applications).

    If you want to scroll a bunch of other views (instead of a views contents),
    you need a companion class (ViewScroller). See the documentation there.

    By default, scrollbars are full size scrollbars - for horizontal scrolling
    (which is less often used), scrollableViews can optionally be created with
    miniscrollers which take up less screen space.

    Recent changes:
        Originally, there were two classes, for vertical-only and
        horizontal+vertical scrollability.
        These have now been merged into the common ScrollableView class,
        and each scrollability can be controlled individually.


    [author:]
        Claus Gittinger

    [see also:]
        ScrollBar
        Scroller
        ScrolledView
"
!

examples
"
  simple scrolled text:
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example1'.
        top extent:200@100.

        scr := ScrollableView for:EditTextView in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        txt := scr scrolledView.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]


  changing the scrolledView later:
                                                                        [exBegin]
        |top scr txtView1 txtView2 browserView|

        top := StandardSystemView label:'scroll example2'.
        top extent:300@100.

        scr := ScrollableView in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.

        top open.

        (Delay forSeconds:5) wait.

        txtView1 := EditTextView new.
        txtView1 list:#(
                        'wait 5 seconds to see the other text'
                        'line2'
                        'line3'
                        'line4'
                        'line5'
                        'line7'
                        'line8'
                        'line9'
                        'line10'
                  ).
        scr scrolledView:txtView1.

        (Delay forSeconds:5) wait.

        txtView2 := EditTextView new.
        txtView2 list:#('this is the other views text'
                        'alternative line2'
                        'alternative line3'
                        'alternative line4'
                        'alternative line5'
                        'alternative line6').
        scr scrolledView:txtView2.
                                                                        [exEnd]




  using a miniscroller:
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example3'.
        top extent:200@100.

        scr := ScrollableView for:EditTextView miniScroller:true in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        txt := scr scrolledView.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]



  scrolling in both directions:
    Notice: HVScrollableView remains existent for backward compatibility;
            scrollability can now be controlled in both directions at any
            time (see examples below).
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example4'.
        top extent:200@100.

        scr := HVScrollableView for:EditTextView in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        txt := scr scrolledView.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]



  using a full scroller vertically, miniscroller horizontally:
    Notice: HVScrollableView remains existent for backward compatibility;
            scrollability can now be controlled in both directions at any
            time (see examples below).
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example5'.
        top extent:200@100.

        scr := HVScrollableView for:EditTextView miniScrollerH:true in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        txt := scr scrolledView.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]



  using miniscrollers for both directions:
    Notice: HVScrollableView remains existent for backward compatibility;
            scrollability can now be controlled in both directions at any
            time (see examples below).
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example6'.
        top extent:200@100.

        scr := HVScrollableView for:EditTextView miniScroller:true in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        txt := scr scrolledView.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]
  controlling scrollability:
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example6'.
        top extent:200@100.

        txt := EditTextView new.

        scr := ScrollableView forView:txt in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        scr horizontalScrollable:true.
        scr verticalScrollable:false.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]
  controlling scrollability and miniScroller:
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example6'.
        top extent:200@100.

        txt := EditTextView new.

        scr := ScrollableView forView:txt in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        scr horizontalScrollable:true; horizontalMini:false.
        scr verticalScrollable:true; verticalMini:true.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]
  autohiding scrollbars (edit the text to make scrollbars visible/invisible)
  (NOTICE:
        this is controlled by the styleSheet and
        should normally NOT be done by the program):
                                                                        [exBegin]
        |top scr txt|

        top := StandardSystemView label:'scroll example6'.
        top extent:200@100.

        txt := EditTextView new.

        scr := ScrollableView forView:txt in:top.
        scr origin:0.0@0.0 corner:1.0@1.0.
        scr horizontalScrollable:true; horizontalMini:false.
        scr verticalScrollable:true; verticalMini:true.
        scr autoHideScrollBars:true.

        txt list:#('line1'
                   'line2'
                   'line3'
                   'line4'
                   'line5'
                   'line7'
                   'line8'
                   'line9'
                   'line10'
                  ).
        top open
                                                                        [exEnd]
"
! !

!ScrollableView class methodsFor:'instance creation'!

for:aViewClass
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:false 
        miniScrollerV:false 
        origin:nil
        corner:nil 
        in:nil

    "Created: 6.3.1997 / 18:06:22 / cg"
    "Modified: 6.3.1997 / 23:18:32 / cg"
!

for:aViewClass hasHorizontalScrollBar:hasH hasVerticalScrollBar:hasV miniScrollerH:miniH miniScrollerV:miniV 
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    |newView|

    aViewClass notNil ifTrue:[
        newView := aViewClass new.
    ].
    ^ self
        forView:newView
        hasHorizontalScrollBar:hasH 
        hasVerticalScrollBar:hasV 
        miniScrollerH:miniH 
        miniScrollerV:miniV 
        origin:nil 
        corner:nil 
        in:nil

    "Created: 7.4.1997 / 19:00:14 / cg"
!

for:aViewClass hasHorizontalScrollBar:hasH hasVerticalScrollBar:hasV miniScrollerH:miniH miniScrollerV:miniV origin:org corner:corn in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    |newView|

    aViewClass notNil ifTrue:[
        newView := aViewClass new.
    ].
    ^ self
        forView:newView
        hasHorizontalScrollBar:hasH 
        hasVerticalScrollBar:hasV 
        miniScrollerH:miniH 
        miniScrollerV:miniV 
        origin:org 
        corner:corn 
        in:aView

    "
     |top scr|

     top := StandardSystemView extent:200@200.
     scr := ScrollableView for:nil
                 hasHorizontalScrollBar:true
                 hasVerticalScrollBar:true
                 miniScrollerH:false
                 miniScrollerV:false
                 origin:0.0@0.0
                 corner:1.0@1.0
                 in:top.
     top open
    "

    "Modified: 6.3.1997 / 18:36:01 / cg"
!

for:aViewClass in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:false 
        miniScrollerV:false 
        origin:nil
        corner:nil 
        in:aView

    "Modified: 6.3.1997 / 23:18:41 / cg"
!

for:aViewClass miniScroller:mini
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if mini is false, miniscrollers
     if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:mini 
        miniScrollerV:mini 
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 23:18:45 / cg"
!

for:aViewClass miniScroller:mini in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if mini is false, miniscrollers
     if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:mini 
        miniScrollerV:mini 
        origin:nil
        corner:nil 
        in:aView

    "Modified: 6.3.1997 / 23:18:50 / cg"
!

for:aViewClass miniScroller:mini origin:org corner:corn in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if mini is false, miniscrollers
     if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:mini 
        miniScrollerV:mini 
        origin:org
        corner:corn 
        in:aView

    "Modified: 6.3.1997 / 23:18:53 / cg"
!

for:aViewClass miniScrollerH:miniH
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if miniH is false, 
     and a horizontal miniscroller if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 18:30:15 / cg"
!

for:aViewClass miniScrollerH:miniH in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:aView

    "Modified: 6.3.1997 / 18:30:31 / cg"
!

for:aViewClass miniScrollerH:miniH miniScrollerV:miniV
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:miniV
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 18:30:47 / cg"
!

for:aViewClass miniScrollerH:miniH miniScrollerV:miniV in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:miniV
        origin:nil
        corner:nil 
        in:aView

    "Modified: 6.3.1997 / 18:31:02 / cg"
!

for:aViewClass miniScrollerH:miniH miniScrollerV:miniV origin:org corner:corn in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:miniV
        origin:org
        corner:corn 
        in:aView

    "Modified: 6.3.1997 / 18:31:17 / cg"
!

for:aViewClass miniScrollerH:miniH origin:org corner:corn in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have a full horizontal scrollbar if miniH is false,
     a miniscroller if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:false
        origin:org
        corner:corn 
        in:aView

    "Modified: 6.3.1997 / 18:31:28 / cg"
!

for:aViewClass miniScrollerV:miniV origin:org corner:corn in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have a full vertical scrollbar if miniV is false,
     a miniscroller if true."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:false 
        miniScrollerV:miniV
        origin:org
        corner:corn 
        in:aView

    "Modified: 6.3.1997 / 18:31:41 / cg"
!

for:aViewClass origin:org corner:corner in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars."

    ^ self 
        for:aViewClass
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:false 
        miniScrollerV:false
        origin:org
        corner:corner 
        in:aView

    "Modified: 6.3.1997 / 23:19:05 / cg"
!

forView:aView
    "return a new scrolling view scrolling aView.
     The view will have full scrollbars."

    ^ self 
        forView:aView
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:false 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 23:19:08 / cg"
!

forView:aView hasHorizontalScrollBar:hasH hasVerticalScrollBar:hasV miniScrollerH:miniH miniScrollerV:miniV 
    "return a new scrolling view scrolling a aView.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self
        forView:aView
        hasHorizontalScrollBar:hasH 
        hasVerticalScrollBar:hasV 
        miniScrollerH:miniH 
        miniScrollerV:miniV 
        origin:nil 
        corner:nil 
        in:nil
!

forView:aScrolledView hasHorizontalScrollBar:hasH hasVerticalScrollBar:hasV miniScrollerH:miniH miniScrollerV:miniV origin:org corner:corn in:aView
    "return a new scrolling view scrolling an instance of aViewClass.
     The subview is created here.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    |newView dev|

    aView notNil ifTrue:[
        dev := aView graphicsDevice
    ] ifFalse:[ 
        dev := Screen current
    ].
    newView := self basicNew device:dev.
    "/ preset flags to avoid creation and later destruction of scrollBars ...
    newView setVertical:hasV mini:miniV horizontal:hasH mini:miniH.
    newView initialize.
    newView setupVertical:hasV mini:miniV horizontal:hasH mini:miniH.

    aScrolledView notNil ifTrue:[
        newView scrolledView:aScrolledView.
    ].

    org notNil ifTrue:[
        newView origin:org
    ].
    corn notNil ifTrue:[
        newView corner:corn
    ].

    aView notNil ifTrue:[
        aView addSubView:newView
    ].
    ^ newView

    "
     |top scr|

     top := StandardSystemView extent:200@200.
     scr := ScrollableView 
                 forView:(TextView new)
                 hasHorizontalScrollBar:true
                 hasVerticalScrollBar:true
                 miniScrollerH:false
                 miniScrollerV:false
                 origin:0.0@0.0
                 corner:1.0@1.0
                 in:top.
     top open
    "
    "
     |top scr|

     top := StandardSystemView extent:200@200.
     scr := ScrollableView 
                 forView:(TextView new)
                 hasHorizontalScrollBar:false
                 hasVerticalScrollBar:true
                 miniScrollerH:false
                 miniScrollerV:false
                 origin:0.0@0.0
                 corner:1.0@1.0
                 in:top.
     top open
    "

    "Modified: 6.3.1997 / 18:42:40 / cg"
    "Modified: 19.3.1997 / 15:32:51 / stefan"
!

forView:aView in:aSuperView
    "return a new scrolling view scrolling aView.
     The view will have full scrollbars."

    ^ self 
        forView:aView
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:false 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:aSuperView

    "Modified: 6.3.1997 / 23:19:12 / cg"
!

forView:aView miniScrollerH:mini
    "return a new scrolling view scrolling aView.
     The view will have a full vertical scrollbar and a horizontal
     miniScroller if mini is true."

    ^ self 
        forView:aView
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:mini 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 18:32:58 / cg"
!

forView:scrolledView miniScrollerH:miniH miniScrollerV:miniV
    "return a new scrolling view, scrolling aView.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self forView:scrolledView miniScrollerH:miniH miniScrollerV:miniV in:nil

    "Created: / 06-10-2006 / 14:30:30 / cg"
!

forView:scrolledView miniScrollerH:miniH miniScrollerV:miniV in:aView
    "return a new scrolling view, scrolling aView.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self 
        forView:scrolledView
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:miniV
        origin:nil
        corner:nil 
        in:aView

    "Modified: 6.3.1997 / 18:33:20 / cg"
!

in:aView
    "return a new scrolling view to be contained in aView.
     There is no slave view now - this has to be set later via
     the scrolledView: method.
     The view will have full scrollbars."

    ^ self 
        forView:nil
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:false 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:aView

    "Modified: 6.3.1997 / 23:19:19 / cg"
!

miniScroller:mini
    "return a new scrolling view. The subview will be created later.
     The view will have full scrollbars if mini is false, 
     miniscrollers if true."

    ^ self 
        forView:nil
        hasHorizontalScrollBar:self defaultHorizontalScrollable
        hasVerticalScrollBar:self defaultVerticalScrollable
        miniScrollerH:mini 
        miniScrollerV:mini
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 23:19:21 / cg"
!

miniScrollerH:miniH
    "return a new scrolling view. The subview will be created later.
     The view will have full scrollbars if miniH is false, 
     and a horizontal miniscroller if true."

    ^ self 
        forView:nil
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:false
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 18:34:06 / cg"
!

miniScrollerH:miniH miniScrollerV:miniV
    "return a new scrolling view. The subview will be created later.
     The view will have full scrollbars if the corresponding miniH/miniV
     is false, miniscrollers if true."

    ^ self 
        forView:nil
        hasHorizontalScrollBar:true
        hasVerticalScrollBar:true
        miniScrollerH:miniH 
        miniScrollerV:miniV
        origin:nil
        corner:nil 
        in:nil

    "Modified: 6.3.1997 / 18:34:16 / cg"
!

new
    "return a new scrolling view.
     There is no slave view now - this has to be set later via
     the scrolledView: method.
     The view will have full scrollbars."

    ^ self in:nil

    "Modified: / 12.11.1998 / 14:55:54 / cg"
! !

!ScrollableView class methodsFor:'defaults'!

defaultHorizontalScrollable
    ^ false
!

defaultScrollBarPosition
    "return the default position of the scrollBar.
     (max be of interest to panels, to make the handlePosition alike)"

    <resource: #style (#'scrollBar.position')>

    ^ StyleSheet at:#'scrollBar.position' default:#left.

    "
     self defaultScrollBarPosition
    "

    "Modified: / 31.10.1997 / 12:58:15 / cg"
!

defaultVerticalScrollable
    ^ true
!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'scrolledView.level' #'scrolledView.margin'
                       #'scrolledView.borderWidth'
                       #'scrollBar.spacing' #'scrollBar.level'
                       #'scrollableView.level' #'scrollableView.backgroundColor' )>

    |defLevel defMargin defSpacing|

    StyleSheet is3D ifTrue:[
        defLevel := -1.
        defMargin := ViewSpacing // 2.
        defSpacing := defMargin.
    ] ifFalse:[
        defLevel := 0.
        defMargin := 0.
        defSpacing := 0
    ].
    DefaultScrolledViewLevel := StyleSheet at:#'scrolledView.level' default:defLevel.
    DefaultScrolledViewBorderWidth := StyleSheet at:#'scrolledView.borderWidth' default:nil.
    DefaultScrolledViewMargin := StyleSheet at:#'scrolledView.margin' default:defMargin.
    DefaultScrollBarSpacing := StyleSheet at:#'scrollBar.spacing' default:defSpacing.
    DefaultLevel := StyleSheet at:#'scrollableView.level' default:nil.
    DefaultScrollBarLevel := StyleSheet at:#'scrollBar.level' default:nil.
    MyDefaultViewBackgroundColor := StyleSheet at:#'scrollableView.backgroundColor' default:DefaultViewBackgroundColor.

    "
     self updateStyleCache
    "

    "Modified: / 31.10.1997 / 20:57:10 / cg"
! !

!ScrollableView methodsFor:'accessing-behavior'!

autoHideHorizontalScrollBar:aBoolean
    "set/clear the flag which controls if the horizontal scrollBar should
     be made invisible dynamically, if there is nothing to scroll
     (and shown if there is).
     This flags setting is normally controlled by the styleSheet."

    hideHScrollBar := aBoolean.

    "Modified: 19.3.1997 / 16:28:42 / cg"
    "Created: 19.3.1997 / 17:24:39 / cg"
!

autoHideScrollBars:aBoolean
    "set/clear the flag which controls if scrollBars should
     be made invisible dynamically, if there is nothing to scroll
     (and shown if there is).
     This flags setting is normally controlled by the styleSheet."

    hideVScrollBar := hideHScrollBar := aBoolean.

    "Modified: 19.3.1997 / 16:28:42 / cg"
    "Created: 19.3.1997 / 17:24:39 / cg"
!

autoHideVerticalScrollBar:aBoolean
    "set/clear the flag which controls if the vertical scrollBar should
     be made invisible dynamically, if there is nothing to scroll
     (and shown if there is).
     This flags setting is normally controlled by the styleSheet."

    hideVScrollBar := aBoolean.

    "Modified: 19.3.1997 / 16:28:42 / cg"
    "Created: 19.3.1997 / 17:24:39 / cg"
!

readOnly:aBoolean
    scrolledView readOnly:aBoolean
! !

!ScrollableView methodsFor:'accessing-components'!

horizontalScrollBar
    "return the horizontal scrollbar (or nil, if there is none)"

"/    hScrollBar isNil ifTrue:[
"/        self horizontalScrollable:true.
"/    ].
    ^ hScrollBar

    "Created: / 6.3.1997 / 18:06:23 / cg"
    "Modified: / 25.5.1998 / 12:53:58 / cg"
!

removeSubView:aView
    super removeSubView:aView.
    aView == scrolledView ifTrue:[
        scrolledView := nil
    ].
    aView == vScrollBar ifTrue:[
        vScrollBar := nil
    ].
    aView == hScrollBar ifTrue:[
        hScrollBar := nil
    ].




!

scrollBar
    "return the vertical scrollbar (or nil, if there is none)"

"/    vScrollBar isNil ifTrue:[
"/        self verticalScrollable:true.
"/    ].
    ^ vScrollBar

    "Created: / 6.3.1997 / 18:06:23 / cg"
    "Modified: / 25.5.1998 / 12:54:06 / cg"
!

scrolledView
    "return the scrolled view (or nil, if there is none)"

    ^ scrolledView

    "Modified: 6.3.1997 / 16:48:09 / cg"
    "Created: 6.3.1997 / 18:06:23 / cg"
!

scrolledView:aView
    "set the view to scroll"

    aView == scrolledView ifTrue:[^ self "already"].

    scrolledView notNil ifTrue:[
        scrolledView removeDependent:self.
        scrolledView destroy.
        scrolledView := nil.
    ].

    scrolledView := aView.

    aView notNil ifTrue:[
        super addSubViewFirst:aView.
        self setScrollActions.

        realized ifTrue:[
            self setupDimensionsConfigureScrolledView:true.
            self sizeChanged:nil.
            aView realize
        ].
    ]

    "Modified: / 19.3.1997 / 15:32:37 / stefan"
    "Modified: / 21.5.1998 / 00:48:57 / cg"
!

verticalScrollBar
    "return the vertical scrollbar (or nil, if there is none)"

"/    vScrollBar isNil ifTrue:[
"/        self verticalScrollable:true.
"/    ].
    ^ vScrollBar

    "Modified: 6.3.1997 / 16:59:24 / cg"
    "Created: 6.3.1997 / 18:06:23 / cg"
!

widget
    "for ST80 compatibility (where a wrapper returns its wrapped
     widget), return the scrolledView here"

    ^ scrolledView

    "Created: 20.6.1997 / 14:45:16 / cg"
! !

!ScrollableView methodsFor:'accessing-look'!

horizontalMini:aBoolean
    "control the horizontal scrollBar to be either a miniScroller,
     or a full scrollBar."

    |newMini|

    newMini := aBoolean.
    (styleSheet at:#'scrollBar.neverMini' default:false) == true ifTrue:[
        newMini := false.
    ].

    horizontalMini ~~ newMini ifTrue:[
        horizontalMini := newMini.
        self setupForChangedScrollbars.
    ].

    "Created: / 7.3.1997 / 21:57:02 / cg"
    "Modified: / 22.4.1998 / 22:42:25 / ca"
    "Modified: / 21.5.1998 / 00:48:25 / cg"
!

horizontalScrollable:aBoolean
    "enable/disable horizontal scrollability.
     If disabled, the horizontal scrollBar is made invisible."

    hasHorizontalScrollBar ~~ aBoolean ifTrue:[
        hasHorizontalScrollBar := aBoolean.
        hScrollBarHidden := false.
        self setupForChangedScrollbars.
    ].

    "Created: / 7.3.1997 / 21:56:28 / cg"
    "Modified: / 21.5.1998 / 00:48:44 / cg"
!

horizontalScrollable:scrollableBoolean miniScroller:miniScrollerBoolean
    "enable/disable horizontal scrollability.
     If disabled, the horizontal scrollBar is made invisible."

    |newMini|

    newMini := miniScrollerBoolean.
    (styleSheet at:#'scrollBar.neverMini' default:false) == true ifTrue:[
        newMini := false.
    ].

    (hasHorizontalScrollBar ~~ scrollableBoolean 
    or:[scrollableBoolean and:[horizontalMini ~~ newMini]]) ifTrue:[
        horizontalMini := newMini.
        hasHorizontalScrollBar := scrollableBoolean.
        hScrollBarHidden := false.
        self setupForChangedScrollbars.
    ].
    horizontalMini := newMini.
!

setupForChangedScrollbars
    self setupViews.
    shown ifTrue:[
        self setupDimensionsConfigureScrolledView:false.
    ]
!

verticalMini:aBoolean
    "control the vertical scrollBar to be either a miniScroller,
     or a full scrollBar."

    |newMini|

    newMini := aBoolean.
    (styleSheet at:#'scrollBar.neverMini' default:false) == true ifTrue:[
        newMini := false.
    ].

    verticalMini ~~ newMini ifTrue:[
        verticalMini := newMini.
        self setupForChangedScrollbars.
    ]

    "Created: / 7.3.1997 / 21:56:57 / cg"
    "Modified: / 22.4.1998 / 22:42:32 / ca"
    "Modified: / 21.5.1998 / 00:49:10 / cg"
!

verticalScrollable:aBoolean
    "enable/disable vertical scrollability.
     If disabled, the vertical scrollBar is made invisible."

    hasVerticalScrollBar ~~ aBoolean ifTrue:[
        hasVerticalScrollBar := aBoolean.
        "/ vScrollBarHidden := false.
        self setupForChangedScrollbars.
    ]

    "Created: / 7.3.1997 / 21:56:39 / cg"
    "Modified: / 24.8.2001 / 14:55:20 / cg"
! !

!ScrollableView methodsFor:'change & update'!

pointerInView
    |pv dev|

    windowGroup isNil ifTrue:[^ false].
    (pv := windowGroup pointerView) isNil ifTrue:[
        dev := device.
        dev isNil ifTrue:[^ false].
        pv := dev viewFromPoint:(dev pointerPosition).
        pv isNil ifTrue:[^ false].
    ].
    (pv isSameOrComponentOf:self) ifTrue:[^ true].
    "/ Transcript showCR:pv.
    ^ false.
!

update:something with:argument from:changedObject
    "whenever the scrolledView changes its contents, the scroller(s) must
     be updated as well"

    |doUpdate|

    doUpdate := false.

    something == #pointerInView ifTrue:[
        (hideScrollbarIfPointerOutside ? false) ifTrue:[
            doUpdate := true
        ]    
    ].

    changedObject == scrolledView ifTrue:[
        something == #sizeOfContents ifTrue:[
            vScrollBar notNil ifTrue:[
                vScrollBar setThumbFor:scrolledView.
                doUpdate := true
            ].
            hScrollBar notNil ifTrue:[
                hScrollBar setThumbFor:scrolledView.
                doUpdate := true
            ].
        ] ifFalse:[
            something == #originOfContents ifTrue:[
                lockUpdates ifFalse:[
                    vScrollBar notNil ifTrue:[
                        vScrollBar setThumbOriginFor:scrolledView.
                        doUpdate := true
                    ].
                    hScrollBar notNil ifTrue:[
                        hScrollBar setThumbOriginFor:scrolledView.
                        doUpdate := true
                    ].
                ].
            ].    
        ].
    ].

    doUpdate ifTrue:[
        self updateScrollBarVisibility
    ]
!

updateHScrollBarVisibility
    |hide anyChange scrollToOriginOnHide|

    anyChange := false.
    scrollToOriginOnHide := true.

    hideHScrollBar ~~ false ifTrue:[
        hScrollBar notNil ifTrue:[
            hide := hScrollBar thumbHeight >= 100.
            hide ifFalse:[
                (hideScrollbarIfPointerOutside ? false) ifTrue:[
                    (self pointerInView) ifFalse:[
                        scrollToOriginOnHide := false.
                        hide := true.
                    ].
                ].
            ].
            hide ~~ hScrollBar realized not "hScrollBarHidden" ifTrue:[
                hScrollBarHidden := hide.
                hide ifTrue:[
                    scrollToOriginOnHide ifTrue:[
                        "/ just in case: scroll to left
                        scrolledView scrollHorizontalToPercent:0.
                    ].
                    hScrollBar beInvisible
                ] ifFalse:[
                    hScrollBar beVisible
                ].
                "/ hScrollBar setRealized:hide not.
                anyChange := true.
            ]
        ].
    ].
    ^ anyChange

    "Modified: / 24.8.2001 / 15:05:57 / cg"
    "Created: / 24.8.2001 / 15:06:05 / cg"
!

updateScrollBarVisibility
    "check if any scrollbar needs to be hidden or shown"

    |anyChange|

    anyChange := self updateVScrollBarVisibility.
    "/ evaluating or here    
    anyChange := anyChange | self updateHScrollBarVisibility.

    "/ stupid - showing one may need the other and vice versa...
    "/ ...therefore, check again
    anyChange ifTrue:[
        self setupDimensionsConfigureScrolledView:false.

        "/ force bars to recompute...
        scrolledView notNil ifTrue:[
            vScrollBar notNil ifTrue:[
                vScrollBar setThumbFor:scrolledView.
            ].
            hScrollBar notNil ifTrue:[
                hScrollBar setThumbFor:scrolledView.
            ].
        ].

        anyChange := self updateVScrollBarVisibility.
        anyChange := anyChange | self updateHScrollBarVisibility.
        anyChange ifTrue:[
            self setupDimensionsConfigureScrolledView:false.
        ].
    ].

    "Modified: / 19.3.1997 / 15:33:36 / stefan"
    "Modified: / 24.8.2001 / 15:08:58 / cg"
!

updateVScrollBarVisibility
    |hide anyChange scrollToOriginOnHide|

    anyChange := false.
    scrollToOriginOnHide := true.

    hideVScrollBar ~~ false ifTrue:[
        vScrollBar notNil ifTrue:[
            hide := vScrollBar thumbHeight >= 100.
            (hideScrollbarIfPointerOutside ? false) ifTrue:[
                (self pointerInView) ifFalse:[
                    scrollToOriginOnHide := false.
                    hide := true.
                ].
            ].
            hide ~~ vScrollBar realized not" vScrollBarHidden" ifTrue:[
                vScrollBarHidden := hide.
                hide ifTrue:[
                    scrollToOriginOnHide ifTrue:[
                        "/ just in case: scroll to top
                        scrolledView scrollVerticalToPercent:0.
                    ].
                    vScrollBar beInvisible
                ] ifFalse:[
                    vScrollBar beVisible
                ].
                "/vScrollBar setRealized:hide not.
                anyChange := true.
            ]
        ].
    ].
    ^ anyChange

    "Modified: / 24.8.2001 / 15:05:57 / cg"
    "Created: / 24.8.2001 / 15:07:38 / cg"
! !

!ScrollableView methodsFor:'drag & drop'!

dropTarget
    scrolledView isNil ifTrue:[^ nil].
    ^ scrolledView dropTarget
!

dropTarget:aDropTarget
    scrolledView isNil ifTrue:[^ self].
    scrolledView dropTarget:aDropTarget
! !

!ScrollableView methodsFor:'event handling'!

keyPress:key x:x y:y
    "a key was pressed - handle page-keys here"

    <resource: #keyboard ( #Prior #Next ) >

    (key == #Prior)    ifTrue: [^ self pageUp].
    (key == #Next)     ifTrue: [^ self pageDown].

    super keyPress:key x:x y:y

    "Created: 6.3.1997 / 18:06:23 / cg"
!

pointerEnter:state x:x y:y
    super pointerEnter:state x:x y:y.
    (hideScrollbarIfPointerOutside ? false) ifTrue:[
        self updateScrollBarVisibility
    ]
!

pointerLeave:state
    super pointerLeave:state.

    (hideScrollbarIfPointerOutside ? false) ifTrue:[
        self updateScrollBarVisibility
    ]    
!

requestAutoAccept
    "request to accept: this is invoked when a dialog closes via accept or cancel.
     This forces my value to be accepted into my model.
     Any widget may suppress the ok/cancel, by returning false."

    ^ scrolledView requestAutoAccept
!

sizeChanged:how
    "handle size changes - this may change any scrollBars visibility"

    |orgX orgY thV thH scrollH scrollV|

    self changed:#sizeOfView with:how.

    superView notNil ifTrue:[
        superView subViewChangedSize
    ].

    "/ resize components manually, in an order which is optimal

    how == #smaller ifTrue:[
        "/ first resize the horizontalScrollBar,

        scrolledView notNil ifTrue:[
            scrolledView containerChangedSize
        ].
        hScrollBar notNil ifTrue:[
            hScrollBar containerChangedSize
        ].
        vScrollBar notNil ifTrue:[
            vScrollBar containerChangedSize
        ].
    ] ifFalse:[
        hScrollBar notNil ifTrue:[
            hScrollBar containerChangedSize
        ].
        vScrollBar notNil ifTrue:[
            vScrollBar containerChangedSize
        ].
        scrolledView notNil ifTrue:[
            scrolledView containerChangedSize
        ].
    ].

    scrolledView isNil ifTrue:[^ self].
    (hScrollBar isNil and:[vScrollBar isNil]) ifTrue:[
        ^ self
    ].

    vScrollBar notNil ifTrue:[
        vScrollBar setThumbFor:scrolledView.
        orgY := vScrollBar thumbOrigin.
        thV := vScrollBar thumbHeight.
    ].
    hScrollBar notNil ifTrue:[
        hScrollBar setThumbFor:scrolledView.
        orgX := hScrollBar thumbOrigin.
        thH := hScrollBar thumbHeight.
    ].

    "/ splitted, since there are optimized scrollProcedures for each case ...

    hScrollBar isNil ifTrue:[
        "/ only care for vertical ...
        orgY + thV >= 100 ifTrue:[
            vScrollBar thumbOrigin:(100 - thV).
            scrolledView scrollVerticalToPercent:vScrollBar thumbOrigin.
        ].
    ] ifFalse:[
        vScrollBar isNil ifTrue:[
            "/ only care for horizontal ...
            orgX + thH >= 100 ifTrue:[
                hScrollBar thumbOrigin:(100 - thH).
                scrolledView scrollHorizontalToPercent:hScrollBar thumbOrigin.
            ].
        ] ifFalse:[
            "/ care for both ...

            scrollH := scrollV := false.

            orgY + thV >= 100 ifTrue:[
                vScrollBar thumbOrigin:(100 - thV).
                orgY := vScrollBar thumbOrigin.
                scrollV := true.
            ].
            orgX + thH >= 100 ifTrue:[
                hScrollBar thumbOrigin:(100 - thH).
                orgX := hScrollBar thumbOrigin.
                scrollH := true.
            ].
            scrollV ifTrue:[
                scrollH ifTrue:[
                    scrolledView scrollToPercent:(orgX@orgY).
                ] ifFalse:[
                    scrolledView scrollVerticalToPercent:orgY.
                ]
            ] ifFalse:[
                scrollH ifTrue:[
                    scrolledView scrollHorizontalToPercent:orgX.
                ]
            ]
        ]
    ].
    self updateScrollBarVisibility.

    "/ just in case there are more views... (DSV - sigh)
    subViews do:[:eachSubView |
        ((eachSubView ~~ scrolledView)
        and:[(eachSubView ~~ hScrollBar)
        and:[eachSubView ~~ vScrollBar]])   
        ifTrue:[
            eachSubView containerChangedSize
        ]
    ]

    "Modified: 28.3.1997 / 17:25:38 / cg"
!

win32NativeScroll:scrollCode position:newPosition
    "this is generated by a native scrollBar widget"

    scrollCode == #SB_LINEDOWN ifTrue:[
        scrolledView scrollDown.
        ^ self.
    ].
    scrollCode == #SB_LINEUP ifTrue:[
        scrolledView scrollUp.
        ^ self.
    ].
    scrollCode == #SB_LINELEFT ifTrue:[
        scrolledView scrollLeft.
        ^ self.
    ].
    scrollCode == #SB_LINERIGHT ifTrue:[
        scrolledView scrollRight.
        ^ self.
    ].
    scrollCode == #SB_PAGEDOWN ifTrue:[
        self pageDown.
        ^ self.
    ].
    scrollCode == #SB_PAGEUP ifTrue:[
        self pageUp.
        ^ self.
    ].
    scrollCode == #SB_PAGELEFT ifTrue:[
        self pageLeft.
        ^ self.
    ].
    scrollCode == #SB_PAGERIGHT ifTrue:[
        self pageRight.
        ^ self.
    ].
    scrollCode == #SB_THUMBPOSITIONVERTICAL ifTrue:[
        scrolledView scrollVerticalToPercent:newPosition.
        ^ self.
    ].
    scrollCode == #SB_THUMBPOSITIONHORIZONTAL ifTrue:[
        scrolledView scrollHorizontalToPercent:newPosition.
        ^ self.
    ].
    scrollCode == #SB_THUMBTRACKVERTICAL ifTrue:[
        vScrollBar isSynchronous ifTrue:[
            scrolledView scrollVerticalToPercent:newPosition.
        ].
        ^ self.
    ].
    scrollCode == #SB_THUMBTRACKHORIZONTAL ifTrue:[
        hScrollBar isSynchronous ifTrue:[
            scrolledView scrollHorizontalToPercent:newPosition.
        ].
        ^ self.
    ].

    scrollCode == #SB_ENDSCROLL ifTrue:[
        ^ self.
    ].
    self halt:'unexpected scroll operation'.
! !

!ScrollableView methodsFor:'forced scroll'!

pageDown
    "page down - but only if there is a vertical scrollbar"

    vScrollBar notNil ifTrue:[
        vScrollBar pageDown
    ]

    "Created: 6.3.1997 / 18:06:23 / cg"
    "Modified: 19.3.1997 / 16:32:34 / cg"
!

pageLeft
    "page left - but only if there is a horizontal scrollbar"

    hScrollBar notNil ifTrue:[
        hScrollBar pageUp
    ]

    "Created: 19.3.1997 / 16:32:14 / cg"
    "Modified: 19.3.1997 / 16:32:44 / cg"
!

pageRight
    "page right - but only if there is a horizontal scrollbar"

    hScrollBar notNil ifTrue:[
        hScrollBar pageDown
    ]

    "Created: 19.3.1997 / 16:32:22 / cg"
    "Modified: 19.3.1997 / 16:32:48 / cg"
!

pageUp
    "page up - but only if there is a vertical scrollbar"

    vScrollBar notNil ifTrue:[
        vScrollBar pageUp
    ]

    "Created: 6.3.1997 / 18:06:23 / cg"
    "Modified: 19.3.1997 / 16:32:38 / cg"
! !

!ScrollableView methodsFor:'initialization'!

initStyle
    "initialize style specifics"

    <resource: #style (#'scrollBar.position'
                       #'scrollBar.hiding'
                       #'scrollBar.hideIfPointerOutside')>

    super initStyle.

    DefaultLevel notNil ifTrue:[self level:DefaultLevel].
    viewBackground := MyDefaultViewBackgroundColor.
    scrollBarPosition := styleSheet at:#'scrollBar.position' default:#left.
    "/ this controls hiding if there is nothing to scroll (contents fits)
    hideHScrollBar := hideVScrollBar := styleSheet at:#'scrollBar.hiding' default:false.
    "/ this controls automatic hiding if the pointer is outside
    hideScrollbarIfPointerOutside := styleSheet at:#'scrollBar.hideIfPointerOutside' default:false.

    scrolledViewHMargin := scrolledViewVMargin := DefaultScrolledViewMargin.
    scrollBarVSpacing := scrollBarHSpacing := DefaultScrollBarSpacing.

"/    self level:0.
"/    self border:(SimpleBorder width:1 color:Color grey).
!

initialize
    "setup some default"

    verticalMini := horizontalMini := false.
    hasVerticalScrollBar := hasHorizontalScrollBar := false.
    vScrollBarHidden := hScrollBarHidden := true.
    hideScrollbarIfPointerOutside := false.

    super initialize.
!

realize
    "realize (i.e. make me visible).
     Since scrolledView may have done something to its contents
     during init-time we had no chance yet to catch contents-
     changes; do it now"

    self setupDimensionsConfigureScrolledView:true.
    super realize.

    scrolledView notNil ifTrue:[
        vScrollBar notNil ifTrue:[
            vScrollBar setThumbFor:scrolledView
        ].
        hScrollBar notNil ifTrue:[
            hScrollBar setThumbFor:scrolledView
        ].
        self updateScrollBarVisibility.
    ].

    "Modified: / 21.5.1998 / 00:52:18 / cg"
!

releaseHorizontalScrollBar
    "destroy any horizontal scrollBar"

    hScrollBar notNil ifTrue:[
        hScrollBar removeDependent:self.
        hScrollBar destroy.
        hScrollBar := nil
    ].

    "Modified: 6.3.1997 / 17:43:20 / cg"
    "Created: 6.3.1997 / 18:06:23 / cg"
!

releaseVerticalScrollBar
    "destroy any vertical scrollBar"

    vScrollBar notNil ifTrue:[
        vScrollBar removeDependent:self.
        vScrollBar destroy.
        vScrollBar := nil
    ].

    "Created: 6.3.1997 / 18:06:23 / cg"
!

setScrollActions
    "lock prevents repositioning the scroller to the
     actual (often rounded) position while scrolling,
     and keeps it instead at the pointer position.

     (this avoids run-away scroller when scrolling
      textviews, when the text is aligned line-wise).
      Consider this as a kludge."

    lockUpdates := false.

    scrolledView notNil ifTrue:[
        (scrolledView heightOfContentsDependsOnWidth
        or:[scrolledView widthOfContentsDependsOnHeight]) ifTrue:[
            hideScrollbarIfPointerOutside := false.
        ].
    ].

    vScrollBar notNil ifTrue:[
        vScrollBar scrollAction:
            [:position |
                "/ in case the event came after the view was already deconstructed
                scrolledView notNil ifTrue:[
                    lockUpdates := true.
                    scrolledView scrollVerticalToPercent:position.
                    lockUpdates := false
                ].
            ].

        vScrollBar scrollUpAction:
            [
                |sensor|
                "/ in case the event came after the view was already deconstructed
                scrolledView notNil ifTrue:[
                    sensor := self sensor.
                    (sensor shiftDown or:[sensor ctrlDown]) ifTrue:[
                        scrolledView scrollToTop
                    ] ifFalse:[
                        scrolledView scrollUp
                    ]
                ].
            ].

        vScrollBar scrollDownAction:
            [
                |sensor|

                "/ in case the event came after the view was already deconstructed
                scrolledView notNil ifTrue:[
                    sensor := self sensor.
                    (sensor shiftDown or:[sensor ctrlDown]) ifTrue:[
                        scrolledView scrollToBottom
                    ] ifFalse:[
                        scrolledView scrollDown
                    ]
                ].
            ].
    ].

    hScrollBar notNil ifTrue:[
        hScrollBar scrollAction:
            [:position |
                "/ in case the event came after the view was already deconstructed
                scrolledView notNil ifTrue:[
                    lockUpdates := true.
                    scrolledView scrollHorizontalToPercent:position.
                    lockUpdates := false
                ].
            ].

        hScrollBar scrollUpAction:
            [
                |sensor|

                "/ in case the event came after the view was already deconstructed
                scrolledView notNil ifTrue:[
                    sensor := self sensor.
                    (sensor shiftDown or:[sensor ctrlDown]) ifTrue:[
                        scrolledView scrollToLeft
                    ] ifFalse:[
                        scrolledView scrollLeft
                    ]
                ].
            ].

        hScrollBar scrollDownAction:
            [
                |sensor|

                "/ in case the event came after the view was already deconstructed
                scrolledView notNil ifTrue:[
                    sensor := self sensor.
                    (sensor shiftDown or:[sensor ctrlDown]) ifTrue:[
                        scrolledView scrollToRight
                    ] ifFalse:[
                        scrolledView scrollRight
                    ]
                ].
            ].
    ].

    scrolledView addDependent:self.

    "
     pass my keyboard input (and other subviews input)
     to the scrolled view ...
    "
    self delegate:(KeyboardForwarder toView:scrolledView).

    "Modified: 6.3.1997 / 17:03:43 / cg"
    "Created: 6.3.1997 / 18:06:23 / cg"
!

setVertical:isVertical mini:miniV horizontal:isHorizontal mini:miniH 
    "set scrollbar-flags as specified in the arguments"

    |noMiniScrollers|

    vScrollBarHidden := hScrollBarHidden := false.

    hasVerticalScrollBar := isVertical.
    hasHorizontalScrollBar := isHorizontal.

    noMiniScrollers := StyleSheet at:#'scrollBar.neverMini' default:false.
    verticalMini := miniV.
    horizontalMini := miniH.

    noMiniScrollers == true ifTrue:[
        verticalMini := false.
        horizontalMini := false.
    ].

!

setupVertical:isVertical mini:miniV horizontal:isHorizontal mini:miniH 
    "setup scrollbars as specified in the arguments"

    self setVertical:isVertical mini:miniV horizontal:isHorizontal mini:miniH.
    self setupViews.
!

setupViews 
    "setup scrollbars as specified in the arguments"

    |cls|

    hasVerticalScrollBar ifTrue:[
        cls := ScrollBar. 
        verticalMini ifTrue:[
            cls := MiniScroller
        ].
        (vScrollBar notNil
        and:[vScrollBar class ~~ cls]) ifTrue:[
            self releaseVerticalScrollBar
        ].
        vScrollBar isNil ifTrue:[
            vScrollBar := cls in:self.
            "/ realized ifTrue:[
                vScrollBar beVisible.
                "/ vScrollBar realize. 
                vScrollBarHidden := false.
            "/ ]
        ].
        vScrollBar thumbOrigin:0 thumbHeight:100.
        vScrollBar addDependent:self.
    ] ifFalse:[
        vScrollBar notNil ifTrue:[
            self releaseVerticalScrollBar
        ]
    ].

    hasHorizontalScrollBar ifTrue:[
        cls := HorizontalScrollBar. 
        horizontalMini ifTrue:[
            cls := HorizontalMiniScroller
        ].
        (hScrollBar notNil
        and:[hScrollBar class ~~ cls]) ifTrue:[
            self releaseHorizontalScrollBar
        ].
        hScrollBar isNil ifTrue:[
            hScrollBar := cls in:self.
            realized ifTrue:[
                hScrollBar beVisible.
                "/ hScrollBar realize. 
                hScrollBarHidden := false.
            ]
        ].
        hScrollBar thumbOrigin:0 thumbHeight:100.
        hScrollBar addDependent:self.
    ] ifFalse:[
        hScrollBar notNil ifTrue:[
            self releaseHorizontalScrollBar
        ]
    ].

    scrolledView notNil ifTrue:[
        self setScrollActions.
    ]

    "Created: / 6.3.1997 / 18:06:23 / cg"
    "Modified: / 24.8.2001 / 14:58:26 / cg"
! !

!ScrollableView methodsFor:'layout'!

horizontalScrollBarLayout:aLayout
    hScrollBar layout:aLayout
!

scrolledViewLayout:aLayout
    scrolledView layout:aLayout
!

setupDimensionsConfigureScrolledView:configureScrolledView
    "set the components dimensions (i.e. layouts) according to
     the scrollability and hidden settings.
     This may heavily move around the parts ...
     This method is overly complex and we should think about alternatives;
     the reason is that it tries to shift views so that borders overlap
     (to avoid thick borders in-between components).
     This is very questionable, since borders are only used with 2D styles,
     and those 2D styles are more-or-less obsolete anyway.
     "

    |usedScrolledViewHMargin usedScrolledViewVMargin 
     usedScrollBarHSpacing usedScrollBarVSpacing hasV hasH
     vBd         "{ Class: SmallInteger }"
     hBd         "{ Class: SmallInteger }"
     sBd         "{ Class: SmallInteger }"
     wVScroll    "{ Class: SmallInteger }"
     hHScroll    "{ Class: SmallInteger }"
     hLeftOffs   "{ Class: SmallInteger }"
     hRightOffs  "{ Class: SmallInteger }"
     hTopOffs    "{ Class: SmallInteger }"
     hBottomOffs "{ Class: SmallInteger }"
     sLeftOffs   "{ Class: SmallInteger }"
     sRightOffs  "{ Class: SmallInteger }"
     sTopOffs    "{ Class: SmallInteger }"
     sBottomOffs "{ Class: SmallInteger }"
     vLeftOffs   "{ Class: SmallInteger }"
     vRightOffs  "{ Class: SmallInteger }"
     vTopOffs    "{ Class: SmallInteger }"
     vBottomOffs "{ Class: SmallInteger }"
     addMargin   "{ Class: SmallInteger }"
     scrolledViewLevel
    |

    sBd := 0.
    DefaultScrolledViewBorderWidth notNil ifTrue:[
        sBd := DefaultScrolledViewBorderWidth.
        scrolledView notNil ifTrue:[
            scrolledView borderWidth:DefaultScrolledViewBorderWidth.
        ]
    ] ifFalse:[
        scrolledView notNil ifTrue:[
            sBd := scrolledView borderWidth
        ]
    ].

    (hasV := (vScrollBar notNil and:[vScrollBarHidden not])) ifTrue:[
        vBd := vScrollBar borderWidth.
        wVScroll := vScrollBar widthIncludingBorder.
    ] ifFalse:[
        vBd := wVScroll := 0.
    ].

    (hasH := (hScrollBar notNil and:[hScrollBarHidden not])) ifTrue:[
        hBd := hScrollBar borderWidth.
        hHScroll := hScrollBar heightIncludingBorder.
    ] ifFalse:[
        hBd := hHScroll := 0.
    ].

    "/ the raw layout ...

    scrolledViewLayout := ((0.0 @ 0.0) corner:(1.0@1.0)) asLayout.
    hScrollBarLayout := ((0.0 @ 1.0) corner:(1.0@1.0)) asLayout.

    "/ the painful details; mostly complicated for 2D styles,
    "/ where the positions are setUp to overlay borders ...
    "/ (well, with 3D styles, a single pixel error will not be noticed;
    "/  but 2D styles are very sensitive to those;
    "/  the code below may not work correctly with different borderWidths).

"/ DefaultScrolledViewMargin := 10. "/ margin around
"/ DefaultScrollBarSpacing := 2.    "/ space between scrolledView and scrollBar.

    usedScrolledViewHMargin := self usedScrolledViewHMarginWhenHasV:hasV andHasH:hasH.
    usedScrolledViewVMargin := self usedScrolledViewVMarginWhenHasV:hasV andHasH:hasH.
    usedScrollBarVSpacing := self usedScrollBarVSpacingWhenHasV:hasV andHasH:hasH.
    usedScrollBarHSpacing := self usedScrollBarHSpacingWhenHasV:hasV andHasH:hasH.

    vTopOffs := 0 - vBd + usedScrolledViewVMargin + margin.

    usedScrolledViewVMargin == 0 ifTrue:[
        vBottomOffs := vBd - sBd.
    ] ifFalse:[
        vBottomOffs := vBd - usedScrolledViewVMargin + sBd.
    ].


    hLeftOffs := 0 - hBd + usedScrolledViewHMargin + margin.
    hRightOffs := hBd - usedScrolledViewHMargin - sBd.

    sLeftOffs := 0 - hBd + usedScrolledViewHMargin + margin.
    sRightOffs := hBd - usedScrolledViewHMargin - sBd - sBd - sBd.

    usedScrolledViewVMargin == 0 ifTrue:[
        sTopOffs := 0 - sBd + margin.
        sBottomOffs := sBd - sBd.
    ] ifFalse:[
        sTopOffs := 0 + usedScrolledViewVMargin + margin.
        sBottomOffs := sBd - usedScrolledViewVMargin - sBd - sBd - sBd.
    ].

    "/ kludge - for now
    (styleSheet at:#'scrolledView.zeroOffsets') == true ifTrue:[
        vTopOffs := 0.
        hLeftOffs := 0.
        sLeftOffs := 0.
        sTopOffs := 0.
    ].

    addMargin := 0.
"/    DefaultScrollBarLevel == DefaultScrolledViewLevel
"/        addMargin := 1.
"/    ].

    hasV ifTrue:[
        scrollBarPosition == #right ifTrue:[
            "/ right/bottom
            vScrollBarLayout := ((1.0 @ 0.0) corner:(1.0@1.0)) asLayout.

            vRightOffs := 0 - usedScrolledViewHMargin + margin "???".
            vLeftOffs := vRightOffs - wVScroll.

            sRightOffs := sRightOffs - usedScrollBarHSpacing - wVScroll + sBd.

            hRightOffs := hRightOffs - wVScroll - usedScrollBarHSpacing - sBd.

            sRightOffs := sRightOffs - addMargin
        ] ifFalse:[
            "/ left/top
            vScrollBarLayout := ((0.0 @ 0.0) corner:(0.0@1.0)) asLayout.
            vLeftOffs := 0 - vBd + usedScrolledViewHMargin + margin.
            vRightOffs := vLeftOffs + wVScroll "+ margin".

            sLeftOffs := vRightOffs + usedScrollBarHSpacing.
            sRightOffs := 0 - usedScrolledViewHMargin - margin.
            hLeftOffs := hLeftOffs + wVScroll + vBd + usedScrollBarHSpacing.

            sLeftOffs := sLeftOffs + addMargin.
        ].
    ].

    hasH ifTrue:[
        hBottomOffs := 0 - usedScrolledViewVMargin - hBd + margin "???".
        hTopOffs := hBottomOffs - hHScroll.
        usedScrolledViewVMargin == 0 ifTrue:[
            hTopOffs := hTopOffs + sBd + sBd
        ].
        sBottomOffs := sBottomOffs - usedScrollBarVSpacing - hHScroll.
        (vScrollBar notNil and:[vScrollBarHidden not]) ifTrue:[
            vBottomOffs := vBottomOffs - usedScrollBarVSpacing - hHScroll.
        ].

        sBottomOffs := sBottomOffs - addMargin.
        hRightOffs := hRightOffs - addMargin.
    ].

    (hScrollBar notNil
     and:[ hScrollBar borderWidth == 0 
     and:[sBd ~~ 0
     and:[scrollBarPosition == #right]]]) ifTrue:[
        hRightOffs := hRightOffs + sBd + sBd.
    ].

    scrolledView notNil ifTrue:[
        scrolledViewLayout 
            leftOffset:sLeftOffs
            rightOffset:sRightOffs
            topOffset:sTopOffs
            bottomOffset:sBottomOffs.

        configureScrolledView ifTrue:[
            ((hideVScrollBar or:[hideHScrollBar]) not
            and:[(hScrollBar isNil or:[hScrollBarHidden])
            and:[(vScrollBar isNil or:[vScrollBarHidden])]]) ifTrue:[
                scrolledViewLevel := 0
            ] ifFalse:[
                (hScrollBar isNil and:[vScrollBar isNil]) ifTrue:[
                    scrolledViewLevel := 0
                ] ifFalse:[
                    scrolledViewLevel := DefaultScrolledViewLevel.
                ]
            ].
            scrolledView level:scrolledViewLevel
        ].
        self scrolledViewLayout:scrolledViewLayout.
    ].
    hasH ifTrue:[
        hScrollBarLayout 
            leftOffset:hLeftOffs
            rightOffset:hRightOffs
            topOffset:hTopOffs
            bottomOffset:hBottomOffs.

        hScrollBar level:DefaultScrollBarLevel.
        self horizontalScrollBarLayout:hScrollBarLayout.

"/        scrollBarPosition == #right ifTrue:[
"/            "/ right/bottom
"/            hScrollBar viewGravity:#SouthWest.
"/        ] ifFalse:[
"/            hScrollBar viewGravity:#NorthWest.
"/        ]
    ].
    (hasV and:[vScrollBar notNil and:[vScrollBarHidden not]]) ifTrue:[
        vScrollBarLayout 
            leftOffset:vLeftOffs
            rightOffset:vRightOffs
            topOffset:vTopOffs
            bottomOffset:vBottomOffs.

        vScrollBar level:DefaultScrollBarLevel.
        self verticalScrollBarLayout:vScrollBarLayout.

"/        scrollBarPosition == #right ifTrue:[
"/            "/ right/bottom
"/            vScrollBar viewGravity:#NorthEast.
"/        ] ifFalse:[
"/            vScrollBar viewGravity:#NorthWest.
"/        ]
    ].

    "Created: / 21.5.1998 / 00:48:35 / cg"
    "Modified: / 11.2.2000 / 00:00:36 / cg"
!

usedScrollBarHSpacingWhenHasV:hasV andHasH:hasH
    "return the horizontal spacing between scrollBar and scrolledView.
     Made a separate method to allow subclasses to overwrite this (subCanvas)"

    ^ hasV ifTrue:[scrollBarHSpacing] ifFalse:[0]

!

usedScrollBarVSpacingWhenHasV:hasV andHasH:hasH
    "return the vertical spacing between scrollBar and scrolledView.
     Made a separate method to allow subclasses to overwrite this (subCanvas)"

    ^ hasH ifTrue:[scrollBarVSpacing] ifFalse:[0]

!

usedScrolledViewHMarginWhenHasV:hasV andHasH:hasH
    "return the horizontal margin around (outer margin).
     Made a separate method to allow subclasses to overwrite this (subCanvas)"

    ^ scrolledViewHMargin

!

usedScrolledViewVMarginWhenHasV:hasV andHasH:hasH
    "return the vertical margin around (outer margin).
     Made a separate method to allow subclasses to overwrite this (subCanvas)"

    ^ scrolledViewVMargin

!

verticalScrollBarLayout:aLayout
    vScrollBar layout:aLayout
! !

!ScrollableView methodsFor:'queries'!

isHorizontalScrollable
    "return true if I am horizontally scrollable"

    ^ hScrollBar notNil

    "Modified: 6.3.1997 / 17:03:49 / cg"
    "Created: 6.3.1997 / 18:06:23 / cg"
!

isScrollWrapper
     "answer true if this view wraps a possibly larger view and has scroll bars"

     ^ true

    "Created: / 20.6.1998 / 14:15:42 / cg"
!

isScrolling
    "true, if scrollbars thumb is being moved (by user)"

    ^ (vScrollBar notNil and:[vScrollBar isScrolling])
      or:[
             (hScrollBar notNil and:[hScrollBar isScrolling])
         ]
!

isVerticalScrollable
    "return true if I am vertically scrollable"

    ^ vScrollBar notNil

    "Modified: 6.3.1997 / 17:03:52 / cg"
    "Created: 6.3.1997 / 18:06:23 / cg"
!

preferredExtent
    "return my preferredExtent from the scrolledViews prefExtent
     plus the size of the scrollBar"

    |slavesPref prefX prefY margin|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    scrolledView notNil ifTrue:[ 
        slavesPref := scrolledView preferredExtent.
        prefX := slavesPref x.
        prefY := slavesPref y.
        margin := (DefaultScrolledViewMargin * 2) + DefaultScrollBarSpacing.
        vScrollBar notNil ifTrue:[
            prefX := prefX + vScrollBar width + margin.
        ].
        hScrollBar notNil ifTrue:[
            prefY := prefY + hScrollBar height + margin.
        ].

        ^ prefX @ prefY.
    ].

    ^ super preferredExtent.

    "Created: 6.3.1997 / 18:06:24 / cg"
    "Modified: 6.3.1997 / 22:34:09 / cg"
!

preferredExtentForLines:numLines cols:numCols
    "return my preferredExtent from the scrolledViews prefExtent
     plus the size of the scrollBar"

    |slavesPref prefX prefY|

    "/ If I have an explicit preferredExtent ..

    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    scrolledView notNil ifTrue:[ 
        slavesPref := scrolledView preferredExtentForLines:numLines cols:numCols.
        prefX := slavesPref x.
        prefY := slavesPref y.
        vScrollBar notNil ifTrue:[
            prefX := prefX + vScrollBar width + (DefaultScrolledViewMargin * 2) + DefaultScrollBarSpacing.
        ].
        hScrollBar notNil ifTrue:[
            prefY := prefY + hScrollBar height + (DefaultScrolledViewMargin * 2) + DefaultScrollBarSpacing.
        ].

        ^ prefX @ prefY.
    ].

    ^ super preferredExtent.

    "Created: 6.3.1997 / 18:06:24 / cg"
    "Modified: 6.3.1997 / 22:34:30 / cg"
!

respondsTo:aSelector
    scrolledView notNil ifTrue:[
        (scrolledView respondsTo:aSelector) ifTrue:[^ true].
    ].
    ^ super respondsTo:aSelector.

    "
        self new respondsTo:#isScrolling
    "
!

specClass
    "redefined, since my subclasses also want ScrollableViewSpecs"

    ^ ScrollableViewSpec

    "Modified: / 31.10.1997 / 19:48:48 / cg"
! !

!ScrollableView methodsFor:'slave-view messages'!

clear
    "convenient method: forward this to the scrolledView"

    scrolledView notNil ifTrue:[scrolledView clear]

    "Created: 6.3.1997 / 18:06:24 / cg"
    "Modified: 19.3.1997 / 16:34:19 / cg"
!

clearView
    "convenient method: forward this to the scrolledView"

    scrolledView notNil ifTrue:[scrolledView clearView]
!

doesNotUnderstand:aMessage
    "this is funny: all message we do not understand, are passed
     on to the scrolledView - so we do not have to care for all
     possible messages ...(thanks to the Message class)"

     scrolledView notNil ifTrue:[
         ^ aMessage sendTo:scrolledView.
     ].
     ^ super doesNotUnderstand:aMessage

    "Created: 6.3.1997 / 18:06:24 / cg"
    "Modified: 6.3.1997 / 18:38:54 / cg"
!

flash
    "convenient method: forward this to the scrolledView"

    scrolledView notNil ifTrue:[scrolledView flash]
!

flash:message withColor:flashColor
    "convenient method: forward this to the scrolledView"

    scrolledView notNil ifTrue:[
        scrolledView flash:message withColor:flashColor
    ]
!

font:aFont
    super font:aFont.
    scrolledView notNil ifTrue:[
        scrolledView font:aFont
    ]
!

leftButtonMenu
    "return scrolledViews leftbuttonmenu"

    scrolledView isNil ifTrue:[^ nil].
    ^ scrolledView leftButtonMenu

    "Created: 6.3.1997 / 18:06:24 / cg"
!

leftButtonMenu:aMenu
    "pass on leftbuttonmenu to scrolledView"

    scrolledView leftButtonMenu:aMenu

    "Created: 6.3.1997 / 18:06:24 / cg"
!

middleButtonMenu
    "return scrolledViews middlebuttonmenu"

    scrolledView isNil ifTrue:[^ nil].
    ^ scrolledView middleButtonMenu

    "Created: 6.3.1997 / 18:06:24 / cg"
!

middleButtonMenu:aMenu
    "pass on middlebuttonmenu to scrolledView"

    scrolledView notNil ifTrue:[
        scrolledView middleButtonMenu:aMenu
    ].

    "Created: 6.3.1997 / 18:06:24 / cg"




!

model
    "return my scrolledViews model"

    scrolledView isNil ifTrue:[^ nil].
    ^ scrolledView model

    "Modified: 1.3.1997 / 01:38:07 / cg"
    "Created: 6.3.1997 / 18:06:24 / cg"
!

model:aModel
    "forward model change to my scrolledViews"

    ^ scrolledView model:aModel

    "Modified: 5.6.1996 / 17:09:50 / cg"
    "Created: 6.3.1997 / 18:06:24 / cg"
!

requestFocus
    scrolledView notNil ifTrue:[
        ^ scrolledView requestFocus
    ].
    ^  false.
!

rightButtonMenu
    "return scrolledViews rightbuttonmenu"

    scrolledView isNil ifTrue:[^ nil].
    ^ scrolledView rightButtonMenu

    "Created: 6.3.1997 / 18:06:24 / cg"
!

rightButtonMenu:aMenu
    "pass on rightbuttonmenu to scrolledView"

    scrolledView rightButtonMenu:aMenu

    "Created: 6.3.1997 / 18:06:24 / cg"
! !

!ScrollableView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

