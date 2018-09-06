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
"{ Package: 'stx:libwidg2' }"

"{ NameSpace: Smalltalk }"

SimpleView subclass:#ViewScroller
	instanceVariableNames:'frame scrolledView keepViewsChannel model verticalScrollStep
		horizontalScrollStep resizeScrolledViewVertical
		resizeScrolledViewHorizontal'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Basic'
!

!ViewScroller class methodsFor:'documentation'!

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
    This wrapper view allows scrolling of views (in contrast to scrolling
    of contents which can be done by any view).

    Normally, scrolling is done by putting a view into a ScrollableView (which
    simply wraps the scrollbars around) and have the scrollbars send scrollUp:/
    scrollDown: etc. send to the scrolledView.
    The default implementation of scrolling (in View) modifies the transformation,
    and does a bit-copy of the contents with redraw of the exposed area.

    However, there are situations, where you want to scroll a view itself.
    For example, if you need many buttons in a panel, which do not fit.

    This class provides the basic mechanism to implement this.
    It is a wrapper, which implements scrolling by modifying the origin of its
    single subview when asked to scroll. Thus, it can be put into a ScrollableView
    like any other, but will move its subview when asked to scroll instead.
    (i.e. reimplement all scroll messages by manipulating its subviews origin
     instead of its contents' transformation offset)

    The subview should have a constant extent, which will be taken for the
    scrollbar position/height computation.
    Since the subview is represented directly by the underlying window systems view
    implementation, there may be a limit on the maximum size of that view. For
    example, in X, dimensions may not be larger than 32767 pixels.

    [Instance variables:]
        model                <ValueHolder>      the model which keeps the current scrolledView.

        keepViewsChannel     <ValueHolder>      boolean holder; if the value is false (the default),
                                                the previous scrolled view is destroyed, whenever a
                                                new scrolled view is set. If true, it is unmapped and
                                                kept.
                                                Set this flag, if the application changes the scrolled
                                                view but wants them to be kept for fast switching.

        horizontalScrollStep <SmallInteger>     amount to scroll when stepping left/right in pixels
        verticalScrollStep   <SmallInteger>     amount to scroll when stepping up/down    in pixels

        frame                <SimpleView>       the one and only container of the visible scrolledView
                                                and all invisible scrolledViews if existent.

        scrolledView         <SimpleView | nil> the current scrolled view or nil

    [see also:]
        ScrollableView HVScrollableView

    [author:]
        Claus Gittinger
"
!

examples
"
  scroll a panel of buttons:
                                                                [exBegin]
    |top frame vscroller v panel|

    top := StandardSystemView new.
    top extent:100@400.

    frame := ScrollableView for:ViewScroller in:top.
    frame origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    vscroller := frame scrolledView.
    panel := VerticalPanelView new.
    panel horizontalLayout:#fit.
    1 to:100 do:[:i |
        Button label:(i printString) in:panel
    ].
    vscroller scrolledView:panel.
    top open.
                                                                [exEnd]

  same, defining what a scroll step is:
                                                                [exBegin]
    |top frame vscroller v panel|

    top := StandardSystemView new.
    top extent:100@400.

    frame := ScrollableView for:ViewScroller in:top.
    frame origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    vscroller := frame scrolledView.
    vscroller verticalScrollStep:20.
    panel := VerticalPanelView new.
    panel horizontalLayout:#fit.
    1 to:100 do:[:i |
        Button label:(i printString) in:panel
    ].
    vscroller scrolledView:panel.
    top open.
                                                                [exEnd]


  same, horizontally. Also change layout in panel for nicer look
  and make panel adjust its height:
  (since the buttons are defined to fill vertically, the vertical
   scrollbar is useless here - its here as example; not for its function)
                                                                [exBegin]
    |top frame vscroller v panel|

    top := StandardSystemView new.
    top extent:300@100.

    frame := HVScrollableView for:ViewScroller in:top.
    frame origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    vscroller := frame scrolledView.
    panel := HorizontalPanelView new.
    panel verticalLayout:#fit.
    panel horizontalLayout:#fit.
    1 to:100 do:[:i |
        Button label:(i printString) in:panel
    ].
    vscroller scrolledView:panel.
    panel height:1.0.
    top open.
                                                                [exEnd]


  scroll a panel of buttons and other views:
  (not good looking, but a demo that it can be done ...)
                                                                [exBegin]
    |top frame vscroller v panel textView1 textView2|

    top := StandardSystemView new.

    frame := HVScrollableView for:ViewScroller in:top.
    frame origin:0.0 @ 0.0 corner:1.0 @ 1.0.

    vscroller := frame scrolledView.

    panel := VerticalPanelView new.
    panel horizontalLayout:#leftSpace.
    panel extent:1.0@1.0.

    textView1 := ScrollableView for:EditTextView in:panel.
    textView1 extent:1.0 @ 300.
    textView1 scrolledView contents:('keyboard.rc' asFilename readStream contents).

    textView2 := ScrollableView for:EditTextView in:panel.
    textView2 extent:500 @ 300.
    textView2 scrolledView contents:('Make.proto' asFilename readStream contents).

    1 to:100 do:[:i |
        Button label:(i printString) in:panel
    ].
    vscroller resizeScrolledViewHorizontal:true.
    vscroller scrolledView:panel.
    
    top open.
                                                                [exEnd]
"
! !

!ViewScroller methodsFor:'accessing'!

destroyAllClientViews
    "destroy all client views"

    frame destroySubViews.

    scrolledView notNil ifTrue:[
        scrolledView removeDependent:self.
        scrolledView := nil.        
        self sizeChanged:nil.
    ].
    model value:nil.
!

keepViews
    "returns the value of the boolean channel: keepViewsChannel.
        for more information see: #keepViewsChannel"

    ^ keepViewsChannel value ? false
!

keepViews:aBool
    "set the value of the boolean channel: keepViewsChannel.
        for more information see: #keepViewsChannel:
    "
    keepViewsChannel value:aBool
!

resizeScrolledViewHorizontal
    ^ resizeScrolledViewHorizontal
!

resizeScrolledViewHorizontal:aBoolean
    "if true, the scrolled view is actually NOT scrolled horizontally,
     but instead always resized to fit.
     Set this, if only vertical scrollability is wanted (i.e. the view
     itself does adjust its size horizontally (for example, in a settings dialog,
     the subcanvas to be enbedded has a horizontal panel, taking all of the space)"

    resizeScrolledViewHorizontal := aBoolean.
!

resizeScrolledViewVertical
    ^ resizeScrolledViewVertical
!

resizeScrolledViewVertical:aBoolean
    "if true, the scrolled view is actually NOT scrolled vertically,
     but instead always resized to fit.
     Set this, if only horizontal scrollability is wanted (i.e. the view
     itself does adjust its size vertically (for example, in a settings dialog,
     the subcanvas to be enbedded has a vertical panel, taking all of the space)"

    resizeScrolledViewVertical := aBoolean.
    scrolledView notNil ifTrue:[
        self resizeScrolledView
    ].
!

scrolledView
    "return the view which is scrolled"

    ^ scrolledView 
!

scrolledView:aView
    "set a new scolled view; dependent on the #keepViewsChannel
     the old scolled view will be destroyed or unmapped."

    |extent|

    scrolledView ~~ aView ifTrue:[
        scrolledView notNil ifTrue:[
            scrolledView removeDependent:self.
            self keepViews ifTrue:[ scrolledView beInvisible ]
                          ifFalse:[ scrolledView destroy ].
        ].
        scrolledView := aView.
        scrolledView notNil ifTrue:[
            scrolledView addDependent:self.

            "test whether new scrolled view not nil and
             not already added to my subViews.
            "
            (scrolledView superView ~~ frame) ifTrue:[

                scrolledView borderWidth:0; level:0.
                extent := scrolledView preferredExtent.
                frame addSubView:scrolledView.

                "/ test whether the new view is a scrollWrapper.
                "/ in this case scrolling can be done by this view

                scrolledView isScrollWrapper ifTrue:[
                    scrolledView isHorizontalScrollable ifTrue:[ extent x:1.0 ].     
                    scrolledView isVerticalScrollable   ifTrue:[ extent y:1.0 ].
                ].

                resizeScrolledViewHorizontal ifTrue:[ extent x:1.0 ].
                resizeScrolledViewVertical   ifTrue:[ extent y:1.0 ].

                scrolledView extent:extent.
            ].
        ].
        realized ifTrue:[
            scrolledView notNil ifTrue:[scrolledView beVisible].
            self sizeChanged:nil.
        ].
        self sensor addEventListener:self.
    ].
    model value:scrolledView.

    "Modified: / 08-08-2010 / 15:19:38 / cg"
!

scrolledViews
    "Returns the collection of all scrolled views including the current scrolled view
     and all unmapped scrolled views."

    |subviews|

    frame notNil ifTrue:[
        subviews := frame subViews.
        subviews notNil ifTrue:[ ^ subviews ]
    ].
    ^ #()

    "Modified: / 08-08-2010 / 15:19:46 / cg"
! !

!ViewScroller methodsFor:'accessing-channels'!

keepViewsChannel
    "boolean holder; if the value is false (the default), the previous scrolled view is
     destroyed, whenever a new scrolled view is set.  if true, it is unmapped and kept.
     Set this flag, if the application changes the scrolled view but wants
     them to be kept for fast switching.
    "
    ^ keepViewsChannel
!

keepViewsChannel:aHolder
    "boolean holder; if the value is false (the default), the previous scrolled view is
     destroyed, whenever a new scrolled view is set.  if true, it is unmapped and kept.
     Set this flag, if the application changes the scrolled view but wants
     them to be kept for fast switching.
    "
    |oldValue|

    oldValue := keepViewsChannel value.
    keepViewsChannel removeDependent:self.

    (keepViewsChannel := aHolder) isNil ifTrue:[
        keepViewsChannel := oldValue asValue.
    ].
    keepViewsChannel addDependent:self.
    self update:nil with:nil from:keepViewsChannel.
!

model
    "value holder, which keeps the current scrolledView or nil
    "
    ^ model
!

model:aHolder
    "value holder, which keeps the current scrolledView or nil
    "
    model removeDependent:self.

    aHolder isNil ifTrue:[ model := nil asValue ]
                 ifFalse:[ model := aHolder     ].

    model addDependent:self.
    self update:nil with:nil from:model.
! !

!ViewScroller methodsFor:'accessing-look'!

horizontalScrollStep:something
    "set the value of the instance variable 'horizontalScrollStep' (automatically generated)"

    horizontalScrollStep := something.
!

verticalScrollStep:something
    "set the value of the instance variable 'verticalScrollStep' (automatically generated)"

    verticalScrollStep := something.
! !

!ViewScroller methodsFor:'change & update'!

resizeScrolledView
    "forces a recomputation of the scrolled view's size"

    |oldExtent newExtent xIsRelative yIsRelative|

    scrolledView isNil ifTrue:[
        ^ self
    ].
    oldExtent   := scrolledView extent copy.
    newExtent   := scrolledView preferredExtent copy.

    xIsRelative := resizeScrolledViewHorizontal.
    yIsRelative := resizeScrolledViewVertical.

    scrolledView isScrollWrapper ifTrue:[
        scrolledView isHorizontalScrollable ifTrue:[
            xIsRelative := true.
        ].     
        scrolledView isVerticalScrollable ifTrue:[
            yIsRelative := true.
        ].
    ].

    resizeScrolledViewHorizontal ifTrue:[ newExtent x:1.0 ].
    resizeScrolledViewVertical   ifTrue:[ newExtent y:1.0 ].

    xIsRelative ifTrue:[
        newExtent x:1.0.
        oldExtent x:1.0.
    ].
    yIsRelative ifTrue:[
        newExtent y:1.0.
        oldExtent y:1.0.
    ].
    true "oldExtent ~= newExtent" ifTrue:[
        scrolledView extent:newExtent.

"/        realized ifTrue:[
"/            self sizeChanged:nil.
"/        ].
    ].
!

update:something with:aParameter from:changedObject
    changedObject == scrolledView ifTrue:[
        something == #sizeOfView ifTrue:[
            (resizeScrolledViewHorizontal not or:[ resizeScrolledViewVertical not ]) ifTrue:[ 
                self repositionScrolledView.
                self changed:#sizeOfContents.        "update possible scrollers"
            ].
        ].
        ^ self
    ].

    changedObject == model ifTrue:[
        self scrolledView:(model value).
        ^ self
    ].

    changedObject == keepViewsChannel ifTrue:[
        self keepViews ifFalse:[ |views|
            "destroy all client views other than the actual scrolled view
            "
            views := frame subViews.
            views size ~~ 0 ifTrue:[
                views copy do:[:v | v ~~ scrolledView ifTrue:[ v destroy ] ].
            ]
        ].
        ^ self
    ].

    super update:something with:aParameter from:changedObject
! !

!ViewScroller methodsFor:'delegation'!

viewBackground:aColor
    super viewBackground:aColor.
    frame notNil ifTrue:[
        frame viewBackground:aColor
    ].
! !

!ViewScroller methodsFor:'event handling'!

processEvent:anEvent    
    "return true, if the event was eaten"

    |appl evView viewToScroll|

    anEvent isMouseWheelEvent ifTrue:[
        scrolledView isNil ifTrue:[
            ^ false
        ].

        appl := self application.
        appl notNil ifTrue:[    "/ might happen that my application is nil
            evView := anEvent view.
            viewToScroll := anEvent targetView.

            "/ because I am catching all scroll events (which is a kludge),
            "/ walk up the hierarchy and see if there is no other scrolled view involved.
            "/ if not, handle the scroll.
            "/ BETTER SOLUTION:
            "/  unhandled mouseWheel events should be forwarded to the container

            [ viewToScroll ~~ scrolledView
              and:[ viewToScroll ~~ self 
              and:[ viewToScroll notNil
              and:[ (viewToScroll isScrollWrapper not
                    or:[ viewToScroll isVerticalScrollable not ]) 
              and:[ (viewToScroll handlesMouseWheelMotion:anEvent inView:evView) not ]]]]
            ] whileTrue:[
                viewToScroll := viewToScroll container.
            ].
            viewToScroll isNil ifTrue:[
                ^ false
            ].

            viewToScroll == scrolledView ifTrue:[
                appl
                    enqueueMessage:#mouseWheelMotion:x:y:amount:deltaTime:
                    for:self
                    arguments:(anEvent arguments).
                ^ true
            ].
        ].
    ].
    ^ false
!

repositionScrolledView
    "Reposition the scrolledView, if required"

    |newOrigin|

    "/ self resizeScrolledView.

    "
     if we are beyond the end, scroll up a bit
    "
    ((self viewOrigin y + self height) > self heightOfContents) ifTrue:[
        newOrigin := (self heightOfContents - self height) max:0.
        self scrollVerticalTo: newOrigin.
    ].
    "
     if we are right of the end, scroll left a bit
    "
    ((self viewOrigin x + self width) > self widthOfContents) ifTrue:[
        newOrigin := (self widthOfContents - self width) max:0.
        self scrollHorizontalTo: newOrigin.
    ].

    "Modified: 24.5.1996 / 17:48:44 / cg"
!

sizeChanged:how
    "my size changed. Reposition the scrolledView, if required"

    super sizeChanged:how.
    self changed:#sizeOfContents.        "update possible scrollers"

    self repositionScrolledView.
    self resizeScrolledView
! !

!ViewScroller methodsFor:'focus handling'!

canTab
    ^ false
! !

!ViewScroller methodsFor:'initialization & release'!

initialize
    "initialize all models of the view"

    super initialize.

    resizeScrolledViewVertical := false.
    resizeScrolledViewHorizontal := false.

    frame := SimpleView origin:0.0@0.0 corner:1.0@1.0 in:self.
    frame borderWidth:0; level:0.
    frame viewBackground:self viewBackground.

    keepViewsChannel := false asValue.
    keepViewsChannel addDependent:self.

    model := nil asValue.
    model addDependent:self.
!

realize
    super realize.
    self sensor addEventListener:self.

!

release
    "release all dependencies"

    keepViewsChannel removeDependent:self.
    model            removeDependent:self.

    super release.
! !

!ViewScroller methodsFor:'queries-contents'!

heightOfContents
    "return my contents' height; this is the scrolledViews height"

    scrolledView isNil ifTrue:[^ super heightOfContents].
    ^ scrolledView height

    "Modified: 24.5.1996 / 17:34:48 / cg"
!

viewOrigin
    "the viewOrigin (for scrollBars) is based upon the scrolledViews origin"

    scrolledView isNil ifTrue:[^ 0@0].
    ^ scrolledView origin negated

    "Modified: 24.5.1996 / 17:48:13 / cg"
!

widthOfContents
    "return my contents' width; this is the scrolledViews width"

    scrolledView isNil ifTrue:[^ super widthOfContents].
    ^ scrolledView width

    "Modified: 24.5.1996 / 17:34:56 / cg"
! !

!ViewScroller methodsFor:'scrolling'!

horizontalScrollStep
    "return the amount by which to step-scroll horizontally"

    ^ horizontalScrollStep ? (self width // 2)
!

scrollTo:aPoint redraw:doRedraw
    "change origin of scrolledView to scroll to aPoint"

    |wCont hCont "{ Class:SmallInteger }"
     iw ih       "{ Class:SmallInteger }"
     viewOrigin orgX orgY newX newY dX dY|

    scrolledView isNil ifTrue:[^ self].

    viewOrigin := scrolledView origin.
    orgX := viewOrigin x negated.
    orgY := viewOrigin y negated.

    newX := aPoint x.
    newY := aPoint y.
    wCont := self widthOfContents.
    hCont := self heightOfContents.
    iw := self innerWidth.
    ih := self innerHeight.

    ((newX + iw) > wCont) ifTrue:[
        newX := wCont - iw
    ].
    (newX < 0) ifTrue:[
        newX := 0
    ].
    ((newY + ih) > hCont) ifTrue:[
        newY := hCont - ih
    ].
    (newY < 0) ifTrue:[
        newY := 0
    ].
    dX := newX-orgX.
    dY := newY-orgY.
    ((dX ~= 0) or:[dY ~= 0]) ifTrue:[
        self originWillChange.
        scrolledView origin:(newX negated @ newY negated).
        self originChanged:(dX negated @ dY negated).
    ]

    "Modified: 21.8.1996 / 09:17:49 / stefan"
!

verticalScrollStep
    "return the amount by which to step-scroll vertically"

    verticalScrollStep notNil ifTrue:[ ^ verticalScrollStep].
    ^ (device verticalPixelPerMillimeter * 20) asInteger
"/    ^ (self height // 3)
! !

!ViewScroller class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

