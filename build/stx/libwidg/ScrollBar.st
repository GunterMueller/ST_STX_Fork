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

SimpleView subclass:#ScrollBar
	instanceVariableNames:'thumb button1 button2 buttonLayout elementSpacing orientation'
	classVariableNames:'DefaultButtonPositions DefaultLevel DefaultElementSpacing
		DefaultScrollerBordered DefaultHScrollBarHeight
		DefaultVScrollBarWidth'
	poolDictionaries:''
	category:'Views-Interactors'
!

!ScrollBar class methodsFor:'documentation'!

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
    this class implements vertical scrollbars with scroller and
    2 step-scroll buttons. when moved or stepped, it performs a
    predefined action.

    The action is specified by:                 the block to be evaluated for step-up
        aScrollBar scrollUpAction:aBlock 
        (scrollLeftAction for hor-Scrollbars)

        aScrollBar scrollDownAction:aBlock      the block to be evaluated for step-down
        (scrollRightAction for hor-Scrollbars)

        aScrollbar scrollAction:aBlock          the block to be evaluated for scroll
                                                passing percentage as argument.

    Scrollbars can scroll syncronous (i.e. every movement is notified immediately via the
    scrollAction) or asynchronous (i.e. only one notification takes place at the end of the movement).
    The choice is up to the user of the scrollbar (typically, views which are complicated to redraw,
    will set it to asynchronous.)

    Most often scrollbars are used hidden with ScrollableView or HVScrollableView (i.e. you
    don't have to care for all the details).

    The scrollBars and scrollers protocols have been made similar enough to
    allow transparent use of either a scroller or a scrollBar in applications.

    [author:]
        Claus Gittinger

    [see also:]
        Scroller Slider
        ScrollableView
"
! !

!ScrollBar class methodsFor:'style changes'!

updateStyleCache
    "extract values from the styleSheet and cache them in class variables"

    <resource: #style (#'scrollBar.buttonPositions' 
                       #'scrollBar.level'
                       #'scrollBar.scrollerBordered' 
                       #'scrollBar.elementSpacing'
                       #'scrollBar.vScrollBarWidth'
                       #'scrollBar.hScrollBarHeight' 
                      )>

    DefaultButtonPositions := StyleSheet at:#'scrollBar.buttonPositions' default:#bottom.
    DefaultLevel := StyleSheet at:#'scrollBar.level'.
    DefaultScrollerBordered := StyleSheet at:#'scrollBar.scrollerBordered' default:false.
    DefaultElementSpacing := StyleSheet 
                                at:#'scrollBar.elementSpacing' 
                                default:(StyleSheet is3D ifTrue:[1] ifFalse:[0]).

    DefaultVScrollBarWidth  := StyleSheet at:#'scrollBar.vScrollBarWidth' default:nil.
    DefaultHScrollBarHeight := StyleSheet at:#'scrollBar.hScrollBarHeight' default:nil.

    "Modified: / 28.4.1999 / 19:27:53 / cg"
! !

!ScrollBar methodsFor:'accessing'!

thumbHeight
    "return height of thumb in percent"

    ^ thumb thumbHeight
!

thumbHeight:newHeight
    "set height of thumb in percent"

    thumb thumbHeight:newHeight.
    self enableDisableButtons
!

thumbOrigin
    "return position of (top of) thumb in percent"

    ^ thumb thumbOrigin
!

thumbOrigin:newOrigin
    "set position of (top of) thumb in percent"

    thumb thumbOrigin:newOrigin.
    self enableDisableButtons.
!

thumbOrigin:newOrigin thumbHeight:newHeight
    "set origin and height of thumb (both in percent)"

    thumb thumbOrigin:newOrigin thumbHeight:newHeight.
    self enableDisableButtons
! !

!ScrollBar methodsFor:'accessing-behavior'!

asynchronousOperation
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #beAsynchronous'.
    self beAsynchronous
!

beAsynchronous
    "set asynchronous-mode - scroll action is performed after movement
     of scroller when mouse-button is finally released (no tracking).
     This is forwarded to the scroller here."

    thumb beAsynchronous
!

beSynchronous
    "set synchronous-mode - scroll action is performed for every movement
     of scroller (tracking).
     This is forwarded to the scroller here."

    thumb beSynchronous
!

isSynchronous
    "return true if the scroll-mode is synchronous.
     If true, the scroll action is performed for every movement of the thumb (tracking).
     If false, the scroll action is only performed at the end."

    ^ thumb isSynchronous
!

scrollAction:aBlock
    "set the action, aBlock to be performed when the scroller is moved.
     This is forwarded to the scroller here."

    thumb scrollAction:aBlock
!

scrollDownAction
    "return the action which is performed on scroll-down.
     (vertical scrollBars)"

    ^ button2 action

    "Created: 28.5.1997 / 15:52:39 / cg"
    "Modified: 28.5.1997 / 15:53:56 / cg"
!

scrollDownAction:aBlock
    "set the action, aBlock to be performed when the down-button is pressed.
     (for vertical scrollBars)"

    button2 action:aBlock

    "Modified: 28.5.1997 / 15:51:39 / cg"
!

scrollLeftAction
    "return the action which is performed on scroll-left
     (for horizontal scrollBars)"

    ^ button1 action

    "Created: 28.5.1997 / 15:51:22 / cg"
!

scrollLeftAction:aBlock
    "set the action to be performed on scroll-left.
     (for horizontal scrollBars)"

    button1 action:aBlock

    "Created: 28.5.1997 / 15:52:55 / cg"
!

scrollRightAction
    "return the action which is performed on scroll-right.
     (for horizontal scrollBars)"

    ^ button2 action

    "Created: 28.5.1997 / 15:53:15 / cg"
!

scrollRightAction:aBlock
    "set the action  to be performed on scroll-right.
     (for horizontal scrollBars)"

    button2 action:aBlock

    "Created: 28.5.1997 / 15:53:30 / cg"
!

scrollUpAction
    "return the action which is performed on scroll-up.
     (for vertical scrollBars)"

    ^ button1 action

    "Created: 28.5.1997 / 15:53:51 / cg"
!

scrollUpAction:aBlock
    "set the action, aBlock to be performed when the up-button is pressed.
     (for vertical scrollBars)"

    button1 action:aBlock

    "Modified: 28.5.1997 / 15:51:33 / cg"
!

synchronousOperation
    <resource: #obsolete>
    self obsoleteMethodWarning:'use #beSynchronous'.
    self beSynchronous
! !

!ScrollBar methodsFor:'accessing-components'!

downButton
    "return the down-button
     (Please: only use this direct access for special applications)"

    ^ button2

    "
     |v|

     v := ScrollableView for:EditTextView.
     v scrolledView contents:('/etc/passwd' asFilename contentsOfEntireFile).
     v scrollBar upButton activeForegroundColor:Color red.
     v scrollBar downButton activeForegroundColor:Color red.
     v open
    "
!

thumb 
    "return the thumb (i.e. the scroller subview)
     (Please: only use this direct access for special applications)"

    ^ thumb

    "
     |v|

     v := ScrollableView for:EditTextView.
     v scrolledView contents:('/etc/passwd' asFilename contentsOfEntireFile).
     v scrollBar thumb thumbColor:(Color red).
     v open
    "

    "Modified: 1.3.1996 / 19:15:50 / cg"
!

upButton
    "return the up-button
     (Please: only use this direct access for special applications)"

    ^ button1

    "
     |v|

     v := ScrollableView for:EditTextView.
     v scrolledView contents:('/etc/passwd' asFilename contentsOfEntireFile).
     v scrollBar upButton foregroundColor:(Color red).
     v scrollBar upButton enteredForegroundColor:(Color red lightened).
     v scrollBar downButton foregroundColor:(Color green).
     v scrollBar downButton enteredForegroundColor:(Color green lightened).
     v open
    "
! !

!ScrollBar methodsFor:'accessing-look'!

allViewBackground:something if:condition
    "blocked for all scrollBars (I want my own background)"

    "/ ^ super allViewBackground:something
!

orientation
    "for ST-80 compatibility, answer this query"

    ^ orientation
!

orientation:aSymbol
    "set the orientation; either #horizontal or #vertical"

    aSymbol ~~ orientation ifTrue:[
        orientation := aSymbol.
    ]
!

thumbColor:aColor
    "set the thumbs color"

    thumb thumbColor:aColor
!

upButtonLabel:label1 downButtonLabel:label2
    "set the labels shown in the buttons.
     Because of the fixed button sizes, this only makes sense with 
     single-character strings or small bitmaps."

    button1 label:label1.
    button2 label:label2.
    self setElementPositions.

    "not bad:
     |v|

     v := ScrollableView for:EditTextView.
     v scrolledView contents:('/etc/passwd' asFilename contentsOfEntireFile).
     v scrollBar upButtonLabel:'+' downButtonLabel:'-'.
     v open
    "

    "also possible :
     |v|

     v := ScrollableView for:EditTextView.
     v scrolledView contents:('/etc/passwd' asFilename contentsOfEntireFile).
     v scrollBar upButtonLabel:'u' downButtonLabel:'d'.
     v open
    "

    "BAD example:
     |v|

     v := ScrollableView for:EditTextView.
     v scrolledView contents:('/etc/passwd' asFilename contentsOfEntireFile).
     v scrollBar upButtonLabel:'up' downButtonLabel:'down'.
     v open
    "

    "Modified: 1.3.1996 / 19:06:50 / cg"
! !

!ScrollBar methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == thumb ifTrue:[
        self enableDisableButtons.
        ^ self.
    ].
    super update:something with:aParameter from:changedObject.
! !

!ScrollBar methodsFor:'events'!

keyPress:key x:x y:y

    <resource: #keyboard (#BeginOfText #EndOfText)>

    (key == #BeginOfText) ifTrue:[
        self scrollToBeginning.
        ^ self
    ].
    (key == #EndOfText) ifTrue:[
        self scrollToEnd.
        ^ self
    ].
    super keyPress:key x:x y:y

    "Created: 6.3.1996 / 17:58:02 / cg"
    "Modified: 7.3.1996 / 13:18:19 / cg"
!

sizeChanged:how
    "when my size changes, I have to resize/reposition the subviews.
     Also, if I became too small, hide thumb/buttons."

    <resource: #style (#name)>

    |upHeight "{ Class: SmallInteger }"
     downHeight "{ Class: SmallInteger }"
     thumbHeight "{ Class: SmallInteger }"
     upAndDownHeight "{ Class: SmallInteger }"
     bw   "{ Class: SmallInteger }" 
     bwn  "{ Class: SmallInteger }"
     sep2 "{ Class: SmallInteger }"
     sep3 "{ Class: SmallInteger }"
     m2   "{ Class: SmallInteger }"
     thumbWidth w h style b1Visible b2Visible thumbVisible 
     b1WasVisible b2WasVisible thumbWasVisible bX bY
     leftWidth rightWidth leftAndRightWidth isHorizontal
     tX tY tW tH tExt bOrg|

    super sizeChanged:how.

    (button1 isNil or:[thumb isNil or:[button2 isNil]]) ifTrue:[^ self].

    bw := self borderWidth.
    bwn := bw negated + margin.
    m2 := margin * 2.

    b1WasVisible := button1 realized.
    b2WasVisible := button2 realized.
    thumbWasVisible := thumb realized.

    (isHorizontal := (orientation == #horizontal)) ifTrue:[
        leftWidth := button1 width + bw.
        rightWidth := button2 width + bw.
        leftAndRightWidth := leftWidth + rightWidth.

        thumbWidth := width - leftAndRightWidth - bw - (elementSpacing * 3).
    "
        ((buttonLayout ~~ #top) and:[buttonLayout ~~ #bottom]) ifTrue:[
            thumbWidth := thumbWidth - bw
        ].
    "
        buttonLayout == #around ifTrue:[
            thumbWidth := thumbWidth + bw
        ].

        "if I become too small, hide buttons"

        width <= (leftAndRightWidth + m2) ifTrue:[
            b1Visible := b2Visible := thumbVisible := false.  
        ] ifFalse:[
            b1Visible := b2Visible := thumbVisible := true.  
        ].

        (thumbWidth < 10) ifTrue:[
            thumbVisible := false.
        ] ifFalse:[
            thumbVisible := true.
        ].
    ] ifFalse:[
        upHeight := button1 height + bw.
        downHeight := button2 height + bw.
        upAndDownHeight := upHeight + downHeight.

        thumbHeight := height - upAndDownHeight - bw - (elementSpacing * 3).
"
        ((buttonLayout ~~ #top) and:[buttonLayout ~~ #bottom]) ifTrue:[
            thumbHeight := thumbHeight - bw
        ].
"
        buttonLayout == #around ifTrue:[
            thumbHeight := thumbHeight + bw
        ].

        "if I become too small, hide buttons and thumb"

        height <= (upAndDownHeight + (m2)) ifTrue:[
            b1Visible := b2Visible := thumbVisible := false.  
        ] ifFalse:[
            b1Visible := b2Visible := thumbVisible := true.  
        ].

        (thumbHeight < 10) ifTrue:[
            thumbVisible := false.
        ] ifFalse:[
            thumbVisible := true.
        ].
    ].

    b1Visible ~~ b1WasVisible ifTrue:[
        self changeVisibilityOf:button1 to:b1Visible.
    ].

    b2Visible ~~ b2WasVisible ifTrue:[
        self changeVisibilityOf:button2 to:b2Visible.
    ].

    thumbVisible ~~ thumbWasVisible ifTrue:[
        self changeVisibilityOf:thumb to:thumbVisible.
    ].

    sep2 := elementSpacing * 2.

    style := styleSheet name.

    isHorizontal ifTrue:[
        "height of buttons is always my width"

        h := height - m2.

        (h ~~ button1 height) ifTrue:[
            button1 height:h.
            button2 height:h
        ].

        thumbHeight := h.

        style == #next ifTrue:[
            thumbHeight := thumbHeight - (thumb borderWidth * 2).
            thumbWidth := thumbWidth - 1
        ] ifFalse:[
            style == #motif ifTrue:[
                thumbWidth := thumbWidth - margin
            ]
        ].

        "
         a kludge: views with width or height of 0 are illegal
         avoid error from view-creation (it will be hidden anyway)
        "
        thumbWidth <= 0 ifTrue:[
            thumbWidth := 1
        ].

        (buttonLayout == #bottom) ifTrue:[
            "buttons at left"
            thumb extent:(thumbWidth @ thumbHeight).
            ^ self
        ].

        (buttonLayout == #top) ifTrue:[
            "buttons at right"
            thumbWidth := thumbWidth + bw.
            thumbVisible ifFalse:[
                bX := elementSpacing
            ] ifTrue:[
                bX := thumbWidth + sep2.
            ].
            tExt := (thumbWidth @ thumbHeight).
            (how == #smaller) ifTrue:[
                "/ resize thumb first
                thumb extent:tExt.
            ].
            button1 origin:(bX @ bwn).
            button2 origin:((bX + leftWidth) @ bwn).
            (how == #smaller) ifFalse:[
                "/ resize thumb last
                thumb extent:tExt
            ].
            ^ self
        ].
        "button around thumb"

        sep3 := 0.
        style == #motif ifTrue:[
"/            sep2 := sep2 + 1.
            sep3 := 1.
        ].

        button1 origin:(bwn @ bwn).
        bX := leftWidth + thumbWidth + sep2.
        tX := leftWidth - bw + elementSpacing.
        style == #os2 ifTrue:[
            bX := bX - margin.
            tW := thumbWidth - m2.
            tX := tX + margin.
        ] ifFalse:[
            bX := bX - (margin // 2).
            tW := thumbWidth + margin - sep3 - (margin // 2).
            tX := tX + sep3.
        ].

        "/ if made smaller, shrink thumb first, then move lower button.
        "/ otherwise, move lower button first, then make thumb larger.
        "/ this avoids a need to redraw the button2.

        bOrg := (bX @ bwn).
        how ~~ #smaller ifTrue:[
            button2 origin:bOrg.
        ].
        thumb extent:(tW @ thumbHeight).
        thumb origin:(tX @ bwn).
        how == #smaller ifTrue:[
            button2 origin:bOrg.
        ].
    ] ifFalse:[
        "width of buttons is always my width"

        w := width - m2.
        (w ~~ button1 width) ifTrue:[
            button1 width:w.
            button2 width:w
        ].

        thumbWidth := w.
        style == #next ifTrue:[
            thumbWidth := thumbWidth - (thumb borderWidth * 2).
            thumbHeight := thumbHeight - 1
        ] ifFalse:[
            style == #motif ifTrue:[
                thumbHeight := thumbHeight - margin
            ]
        ].

        "
         a kludge: views with width or height of 0 are illegal
         avoid error from view-creation (it will be hidden anyway)
        "
        thumbHeight <= 0 ifTrue:[
            thumbHeight := 1
        ].

        (buttonLayout == #top) ifTrue:[
            "buttons at top"
            thumb extent:(thumbWidth @ thumbHeight).
            ^ self
        ].

        (buttonLayout == #bottom) ifTrue:[
            "buttons at bottom"

            thumbHeight := thumbHeight + bw.
            
            bY := thumbHeight + sep2.
            (bY + upAndDownHeight) >= height ifTrue:[
                bY := height - margin - upAndDownHeight
            ].

            button1 viewGravity:#North. 
            button2 viewGravity:#North. 

            tExt := (thumbWidth @ thumbHeight).

            (how == #smaller) ifTrue:[
                "/ resize thumb first
                thumb extent:tExt.
            ].
            button1 origin:(bwn @ bY).
            button2 origin:(bwn @ (bY + upHeight)).
            (how == #smaller) ifFalse:[
                "/ resize thumb last
                thumb extent:tExt
            ].
            ^ self
        ].
        "buttons around thumb"

        sep3 := 0.
        style == #motif ifTrue:[
"/            sep2 := sep2 + 1.
            sep3 := 1.
        ].
        button1 origin:(bwn @ bwn).

        bY := upHeight + thumbHeight + sep2.
        tY := upHeight - bw + elementSpacing.
        style == #os2 ifTrue:[
            bY := bY - margin "+ bw".
            tH := thumbHeight - m2 "+ margin - (margin // 2)".
            tY := tY + margin.
        ] ifFalse:[
            bY := bY - (margin // 2) "+ bw".
            tH := thumbHeight + margin - sep3 - (margin // 2).
            tY := tY + sep3.
        ].

        "/ if made smaller, shrink thumb first, then move lower button.
        "/ otherwise, move lower button first, then make thumb larger.
        "/ this avoids a need to redraw the button2.

        bOrg := (bwn @ bY).
        how ~~ #smaller ifTrue:[
            button2 origin:bOrg.
        ].
        thumb extent:(thumbWidth @ tH).
        thumb origin:(bwn @ tY).
        how == #smaller ifTrue:[
            button2 origin:bOrg.
        ].
    ].

    "Modified: / 3.5.1996 / 23:49:02 / stefan"
    "Modified: / 2.12.1998 / 00:02:14 / cg"
! !

!ScrollBar methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false


! !

!ScrollBar methodsFor:'forced scroll'!

pageDown
    "page down/right"

    thumb pageDown.
    self updateNativeWidget.
!

pageUp
    "page up/left"

    thumb pageUp.
    self updateNativeWidget.
!

scrollToBeginning
    "to top"

    thumb scrollToBeginning.
    self updateNativeWidget.

    "Modified: 6.3.1996 / 17:54:45 / cg"
!

scrollToEnd
    "to end"

    thumb scrollToEnd.
    self updateNativeWidget.

    "Created: 6.3.1996 / 17:54:28 / cg"
    "Modified: 6.3.1996 / 17:54:49 / cg"
! !

!ScrollBar methodsFor:'initialization'!

createElements
    "private: create my elements"

    (device supportsNativeWidgetType:#Scrollbar) ifTrue:[
        "/ native widget contains all I need.
        "/ but I need a thumb from the model
        thumb := Scroller new.
        thumb beInvisible.
        ^ self
    ].

    orientation == #horizontal ifTrue:[
        button1 := ArrowButton leftIn:self.
        button1 name:'leftButton'.
        button2 := ArrowButton rightIn:self.
        button2 name:'rightButton'.
        thumb := HorizontalScroller in:self.
    ] ifFalse:[
        button1 := ArrowButton upIn:self.
        button1 name:'upButton'.
        button2 := ArrowButton downIn:self.
        button2 name:'downButton'.
        thumb := Scroller in:self.
    ].

    "Modified: 28.5.1997 / 15:49:05 / cg"
!

defaultExtent
    "compute my extent from sub-components"

    ^ self preferredExtent


    "Created: 1.3.1996 / 19:22:11 / cg"
!

initStyle
    "setup viewStyle specifics"

    super initStyle.

    buttonLayout := DefaultButtonPositions.
    DefaultLevel notNil ifTrue:[
        self level:DefaultLevel
    ].
    elementSpacing := DefaultElementSpacing

    "Modified: 22.1.1997 / 11:57:41 / cg"
!

initialize
    "setup; create the 2 buttons and a scroller"

    <resource: #style (#'scrollBar.disableButtons')>

    |clr style bw|

    orientation isNil ifTrue:[
        orientation := #vertical
    ].

    super initialize.

    self createElements.

    (styleSheet at:#'scrollBar.disableButtons' default:false) ifTrue:[
        thumb addDependent:self
    ].

    button1 isNil ifTrue:[
        "/ native widget: no buttons
        ^ self
    ].

    button1 autoRepeat:true.
    button2 autoRepeat:true.

    bw := self borderWidth.
    button1 borderWidth:bw.
    DefaultScrollerBordered ifFalse:[
        thumb borderWidth:bw.
    ].
    button2 borderWidth:bw.

    style := styleSheet name.
    ((style = #iris) and:[Screen current hasGrayscales]) ifTrue:[
        "have to change some of Buttons defaults"
        clr := (Color gray:25) onDevice:device.
        button1 passiveLevel:2.
        button2 passiveLevel:2.
        button1 foregroundColor:clr.
        button1 activeForegroundColor:clr.
        button1 enteredForegroundColor:clr.
        button2 foregroundColor:clr.
        button2 activeForegroundColor:clr.
        button2 enteredForegroundColor:clr.
    ].

    self setElementPositions.

    style = #motif ifTrue:[
        clr := thumb thumbColor.
        button1 foregroundColor:clr.
        button2 foregroundColor:clr.

        clr := thumb viewBackground.
        button1 viewBackground:clr.
        button2 viewBackground:clr.
        button1 backgroundColor:clr.
        button2 backgroundColor:clr.
        button1 activeBackgroundColor:clr.
        button2 activeBackgroundColor:clr.
        device hasGrayscales ifFalse:[
            button1 activeForegroundColor:self blackColor.
            button2 activeForegroundColor:self blackColor.
        ]
    ]

    "Modified: / 29.4.1999 / 08:43:30 / cg"
!

reinitialize
    super reinitialize.
    self setElementPositions.
!

setElementPositions
    "position sub-components"

    |bw bwn|

    bw := self borderWidth.
    bwn := bw negated + margin.

    orientation == #horizontal ifTrue:[
        (buttonLayout == #bottom) ifTrue:[
            "buttons at left"
            button1 origin:(bwn @ bwn).
            button1 viewGravity:#West.
            button2 origin:(button1 width @ bwn).
            button2 viewGravity:#West.
            thumb origin:((button1 width 
                           + bw 
                           + button2 width 
                           + elementSpacing + elementSpacing) @ bwn).
            thumb viewGravity:#West.
            ^ self
        ].

        (buttonLayout == #top) ifTrue:[
            "buttons at right"
            button1 viewGravity:#West.
            button2 viewGravity:#West.
            thumb origin:(bwn @ bwn).
            thumb viewGravity:#West
        ].

        "buttonLayout == #around "
        button1 origin:(bwn @ bwn).
        button1 viewGravity:#West.
        button2 viewGravity:#West.
        thumb origin:((button1 width + elementSpacing) @ bwn).
        thumb viewGravity:#West
    ] ifFalse:[
        (buttonLayout == #top) ifTrue:[
            button1 origin:(bwn @ bwn).
            button1 viewGravity:#North.
            button2 origin:(bwn @ (button1 height)).
            button2 viewGravity:#North.
            thumb origin:(bwn @ (button1 height 
                                 + bw 
                                 + button2 height 
                                 + elementSpacing 
                                 + elementSpacing)).
            thumb viewGravity:#North.
            ^ self
        ].
        (buttonLayout == #bottom) ifTrue:[
            device supportsViewGravity ifTrue:[
                button1 viewGravity:#South. 
                button2 viewGravity:#South. 
                thumb viewGravity:#North.
            ].
            thumb origin:(bwn @ bwn).
            ^ self
        ].

        "buttonLayout == #around"
        button1 origin:(bwn @ bwn).
        button1 viewGravity:#North.
    "/    button2 viewGravity:#North.
        thumb origin:(bwn @ (button1 height + elementSpacing)).
        thumb viewGravity:#North
    ]

    "Modified: 28.5.1997 / 15:50:27 / cg"
! !

!ScrollBar methodsFor:'native widget support'!

beNativeWidget
    super beNativeWidget.
    self makeElementsInvisible.
!

makeElementsInvisible
    "when using native widget, my elements are not visible.
     (they are not destroyed, to keep a place for their attributes,
      and to allow future dynamic switching and snapshot restore on
      a non-native system)"

    button1 notNil ifTrue:[
        button1 beInvisible.
    ].
    button2 notNil ifTrue:[
        button2 beInvisible.
    ].
    thumb notNil ifTrue:[
        thumb beInvisible.
    ].
!

nativeWindowType
    "return a symbol describing my native window type 
     (may be used internally by the device as a native window creation hint,
      if the device supports native windows)"

    orientation == #vertical ifTrue:[
        ^ #VerticalScrollBar
    ].
    ^ #HorizontalScrollBar
!

updateNativeWidget
    |id|

    self isNativeWidget ifTrue:[
        (id := self drawableId) notNil ifTrue:[
            device
                setScrollRange:0 to:100 
                redraw:false 
                in:id.

            device
                setScrollPosition:thumb thumbOrigin rounded 
                redraw:false 
                in:id.

            device
                setScrollBarPageSize:thumb thumbHeight rounded 
                redraw:true 
                in:id.
        ]
    ].
! !

!ScrollBar methodsFor:'private'!

changeVisibilityOf:aComponent to:aBoolean
    self isNativeWidget ifTrue:[^ self].

    aComponent hiddenOnRealize:aBoolean not.
    aBoolean ifFalse:[
        aComponent unmap
    ] ifTrue:[
        shown ifTrue:[aComponent realize]
    ].
!

enableDisableButtons
    "only used with styles which disable their buttons if the
     thumb is at either end. Check where the thumb is and enable/disable
     as appropriate."

    <resource: #style (#'scrollBar.disableButtons')>

    |e1 e2 th to ena|

    (styleSheet at:#'scrollBar.disableButtons' default:false) ifFalse:[^ self].
    e1 := e2 := true.
    (th := thumb thumbHeight) notNil ifTrue:[
        (th >= (thumb stop)) ifTrue:[
            e1 := false.
            e2 := false
        ]
    ].
    ((to := thumb thumbOrigin) <= thumb start) ifTrue:[
        e1 := false
    ] ifFalse:[
        th isNil ifTrue:[th := 0].
        (to + th) >= thumb stop ifTrue:[
            e2 := false
        ]
    ].
    button1 enabled:e1. "/ e1 ifTrue:[button1 enable] ifFalse:[button1 disable].
    button2 enabled:e2. "/ e2 ifTrue:[button2 enable] ifFalse:[button2 disable].

    self isNativeWidget ifTrue:[
        self drawableId notNil ifTrue:[
            e1 ifTrue:[
                e2 ifTrue:[
                    "/ both enabled
                    ena := #ENABLE_BOTH.
                ] ifFalse:[
                    ena := #DISABLE_RTDN.
                ]
            ] ifFalse:[
                e2 ifTrue:[
                    ena := #DISABLE_LTUP.
                ] ifFalse:[
                    ena := #DISABLE_BOTH.
                ]
            ].
            device enableScrollBar:ena in:self drawableId.
        ].
    ].

    "Modified: / 29.4.1999 / 08:44:03 / cg"
! !

!ScrollBar methodsFor:'private-scrollview interface'!

setThumbFor:aView
    "adjust thumb for aView 
     (i.e. adjust thumbs origin & size for views size & views contents).
     This is forwarded to the scroller here."

    thumb setThumbFor:aView.
    self isNativeWidget ifTrue:[
        self updateNativeWidget.
    ].
    self enableDisableButtons
!

setThumbHeightFor:aView
    "adjust thumbs height for aViews size & contents.
     This is forwarded to the scroller here."

    thumb setThumbHeightFor:aView.
    self isNativeWidget ifTrue:[
        self updateNativeWidget.
    ].
    self enableDisableButtons
!

setThumbOriginFor:aView
    "adjust thumbs origin for aViews size & contents.
     This is forwarded to the scroller here."

    thumb setThumbOriginFor:aView.
    self isNativeWidget ifTrue:[
        self updateNativeWidget.
    ].
    self enableDisableButtons
! !

!ScrollBar methodsFor:'queries'!

isMiniScroller
    ^ false

    "Created: 7.3.1997 / 16:20:12 / cg"
!

isScrolling
    "true, if thumb is being moved (by user)"

    ^ thumb isScrolling
!

preferredExtent
    "compute my extent from sub-components"

    <resource: #style (#name)>

    |w h form1 form2 style
     height1   "{ Class: SmallInteger }"
     height2   "{ Class: SmallInteger }"
     width1    "{ Class: SmallInteger }"
     width2    "{ Class: SmallInteger }" |

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    "
     need fix - this is a kludge;
     the if should not be needed ...
    "
    style := styleSheet name.

    orientation == #horizontal ifTrue:[
        form1 := ArrowButton leftArrowButtonForm:style on:device.
        form2 := ArrowButton rightArrowButtonForm:style on:device.
    ] ifFalse:[
        form1 := ArrowButton upArrowButtonForm:style on:device.
        form2 := ArrowButton downArrowButtonForm:style on:device.
    ].
    form1 isNil ifTrue:[
        height1 := width1 := 16.
    ] ifFalse:[
        height1 := form1 height.
        width1 := form1 width
    ].
    form2 isNil ifTrue:[
        height2 := width2 := 16
    ] ifFalse:[
        height2 := form2 height.
        width2 := form2 width
    ].

    orientation == #horizontal ifTrue:[
        DefaultHScrollBarHeight notNil ifTrue:[
            h := DefaultHScrollBarHeight
        ] ifFalse:[
            h := height1 max:height2.
        ].
        w := width1 + width2 + (1 * 2) + (HorizontalScroller defaultExtent x).
    ] ifFalse:[
        DefaultVScrollBarWidth notNil ifTrue:[
            w := DefaultVScrollBarWidth
        ] ifFalse:[
            w := width1 max:width2.
        ].
        h := height1 + height2 + (1 * 2) + (Scroller defaultExtent y).
    ].

    style ~~ #normal ifTrue:[
        DefaultHScrollBarHeight isNil ifTrue:[h := h + 4].
        DefaultVScrollBarWidth isNil ifTrue:[w := w + 4].
    ].

    preferredExtent := w @ h.
    ^ preferredExtent

    "Modified: / 28.4.1999 / 19:33:45 / cg"
! !

!ScrollBar class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

