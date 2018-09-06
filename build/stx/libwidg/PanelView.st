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

SimpleView subclass:#PanelView
	instanceVariableNames:'hLayout vLayout verticalSpace horizontalSpace mustRearrange
		elementsChangeSize ignoreInvisibleComponents backgroundChannel'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!PanelView class methodsFor:'documentation'!

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
    this is a view for holding subviews. (layout-widget ?)

    Instances of PanelView try to get all their subviews into them,
    arranging subviews left-to-right, top-to-bottom.

    If you don't like its layout, define a new subclass or use one of
    the existing subclasses: HorizontalPanelView and VerticalPanelView.

    The panel assumes, that the elements do not resize themselfes, after it
    became visible. This is not true for all widgets (buttons or labels may
    like to change). If you have changing elements, tell this to the panel
    with 'aPanel elementsChangeSize:true'. In that case, the panel will react
    to size changes, and reorganize things.

    PanelViews normally delay the actual positioning/sizing of their elements,
    until actually displayed. This is useful, if more elements are to
    be added, to avoid repeated configuration of the elements.

    If you want to query for the relative position of an element BEFORE
    the view is visible, you have to send #setChildPositionsIfChanged before
    doing so (otherwise, you may get invalid origins from the subviews). As
    an example, the modalBoxes do so before showing themselfes to ask for the
    position of the ok-button relative to the top-left box-origin, in order to
    position the ok-button under the mouse-pointer.

    [Instance variables:]

        hLayout         <Symbol>        controls horizontal layout; ignored in this
                                        class, but used in Horizontal- and
                                        VerticalPanelViews. See more info there.

        vLayout         <Symbol>        controls vertical layout; ignored in this
                                        class, but used in Horizontal- and
                                        VerticalPanelViews. See more info there.

        horizontalSpace <Integer>       number of pixels to use as space between elements
                                        defaults to ViewSpacing, which is 1mm

        verticalSpace   <Integer>       number of pixels to use as space between elements
                                        defaults to ViewSpacing, which is 1mm

        mustRearrange   <Boolean>       internal flag, if rearrangement is needed

        elementsChangeSize   
                        <Boolean>       if true, the panel takes care of this situation.
                                        By default, this is false.

        ignoreInvisibleComponents
                        <Boolean>       if true, invisible (i.e. hidden) views
                                        are not considered in the layout computation.
                                        If false, they will lead to additional space
                                        between visible components.
                                        The default is false.

    [author:]
        Claus Gittinger
"
!

examples
"
    The generic panelView simply tries to get its
    components arranged for fitting them all into
    its area. No special layout is done, except for
    horizontal/vertical spacings.
    The view is filled top-left to bottom-right
    with subcomponents. Subcomponents are not resized.

    example:
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'panel'.

        p := PanelView in:v.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


   invisible component not considered in layout:
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'panel'.

        p := PanelView in:v.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b2 beInvisible.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]

   invisible component considered in layout:
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'panel'.

        p := PanelView in:v.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        p ignoreInvisibleComponents:false.
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b2 beInvisible.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]
"
! !

!PanelView methodsFor:'accessing'!

elementsChangeSize
    "tell the panel if elements are to change their size by themselfes
     (for example, Labels or Buttons may do so if their contents changes).
     Setting this flag will make the panel reorganize the elements whenever
     any element changes its size."

    ^ elementsChangeSize 
!

elementsChangeSize:aBoolean
    "tell the panel if elements are to change their size by themselfes
     (for example, Labels or Buttons may do so if their contents changes).
     Setting this flag will make the panel reorganize the elements whenever
     any element changes its size."

    elementsChangeSize ~~ aBoolean ifTrue:[
        elementsChangeSize := aBoolean.
        aBoolean ifTrue:[
            self makeMyselfDependentOnSubviews.
        ].
    ].
!

hierarchicalIndexOfChild:aView
    ^ aView hierarchicalIndexInList:subViews
!

horizontalLayout
    "not supported by this view"

    ^ nil
!

horizontalLayout:aLayoutSymbol
    "not supported by this view"

!

horizontalLayout:layoutSymbolH verticalLayout:layoutSymbolV
    self horizontalLayout:layoutSymbolH.
    self verticalLayout:layoutSymbolV
!

horizontalSpace
    "return the horizontal space between elements on pixels (default is 1mm)"

    ^ horizontalSpace 
!

horizontalSpace:numberOfPixels
    "set the horizontal space between elements on pixels (default is 1mm)"

    horizontalSpace ~= numberOfPixels ifTrue:[
	horizontalSpace := numberOfPixels.
	self layoutChanged
    ]
!

ignoreInvisibleComponents
    "return the flag which controls if invisible (unrealized)
     components should be ignored in the layout computation.
     By default, it is false, which means that invisible components will
     lead to a visible space between visible components"

    ^ ignoreInvisibleComponents
!

ignoreInvisibleComponents:aBoolean
    "set/clears the flag which controls if invisible (unrealized)
     components should be ignored in the layout computation.
     By default, it is false, which means that invisible components will
     lead to a visible space between visible components."

    (ignoreInvisibleComponents ~~ aBoolean) ifTrue:[
        aBoolean ifTrue:[
            self makeMyselfDependentOnSubviews.
        ].
        ignoreInvisibleComponents := aBoolean.
        self layoutChanged
    ]

    "Modified: / 20.7.1998 / 14:12:38 / cg"
!

space:numberOfPixels
    "set the space between elements in pixels (default is 1mm) for both directions"

    (verticalSpace ~= numberOfPixels 
    or:[horizontalSpace ~= numberOfPixels]) ifTrue:[
	horizontalSpace := numberOfPixels.
	verticalSpace := numberOfPixels.
	self layoutChanged
    ]
!

verticalLayout
    "not supported by this view"

    ^ nil
!

verticalLayout:aLayoutSymbol
    "not supported by this view"

!

verticalSpace
    "return the vertical space between elements on pixels (default is 1mm)"

    ^ verticalSpace 
!

verticalSpace:numberOfPixels
    "set the vertical space between elements (in pixels).
     The default is computed for 1mm spacing."

    verticalSpace ~= numberOfPixels ifTrue:[
	verticalSpace := numberOfPixels.
	self layoutChanged
    ]
! !

!PanelView methodsFor:'accessing-channels'!

backgroundChannel 
    "return a valueHolder for background color"

    ^ backgroundChannel

    "Modified: / 30.3.1999 / 13:49:28 / stefan"
    "Created: / 30.3.1999 / 13:50:55 / stefan"
!

backgroundChannel:aValueHolder
    "set the backgroundChannel - a valueHolder holding a color"

    |prev|

    prev := backgroundChannel.
    backgroundChannel := aValueHolder.
    self setupChannel:aValueHolder for:#backgroundColorChanged withOld:prev

    "Modified: / 31.10.1997 / 14:38:38 / cg"
    "Created: / 30.3.1999 / 13:48:42 / stefan"
! !

!PanelView methodsFor:'adding & removing subviews'!

addComponent:aComponent
    "redefined to recompute layout when a component is added"

    super addComponent:aComponent.
    self addedView:aComponent

    "Created: 28.1.1997 / 17:44:18 / cg"
!

addSubView:aView
    "redefined to recompute layout when a subview is added"

    super addSubView:aView.
    self addedView:aView
!

addSubView:newView after:aViewOrNil
    "redefined to recompute layout when a subview is added"

    super addSubView:newView after:aViewOrNil.
    self addedView:newView

    "Modified: / 15-07-1996 / 10:15:04 / cg"
    "Modified (format): / 22-03-2012 / 10:37:42 / cg"
!

addSubView:newView before:aViewOrNil
    "redefined to recompute layout when a subview is added"

    super addSubView:newView before:aViewOrNil.
    self addedView:newView

    "Modified: / 15-07-1996 / 10:14:39 / cg"
    "Modified (format): / 22-03-2012 / 10:37:46 / cg"
!

removeSubView:aView
    "redefined to recompute layout when a subview is removed"

    super removeSubView:aView.
    aView removeDependent:self.
    self isBeingDestroyed ifFalse:[
        self layoutChanged
    ].
! !

!PanelView methodsFor:'enumerating subviews'!

changeSequenceOrderFor:aSubView to:anIndex
    "change a subview's position in the subviews collection.
     This affects the arrangemnt of the views."

    |success|

    success := super changeSequenceOrderFor:aSubView to:anIndex.

    success ifTrue:[
        self layoutChanged.
    ].
    ^ success

    "
     |panel comp1 comp2 comp3|

     panel := HorizontalPanelView new.
     comp1 := Label label:'one' in:panel.
     comp2 := Label label:'two' in:panel.
     comp3 := Label label:'three' in:panel.
     panel open.
     Delay waitForSeconds:3.
     panel changeSequenceOrderFor:comp2 to:3.
     Delay waitForSeconds:3.
     panel changeSequenceOrderFor:comp2 to:1.
    "

    "Modified: / 17.1.1998 / 00:13:43 / cg"
! !

!PanelView methodsFor:'event handling'!

backgroundColorChanged
    "called to update the background color"

    |color|

    color := backgroundChannel value.
    self backgroundColor:color.
!

sizeChanged:how
    "my size has changed - must rearrange elements"

    super sizeChanged:how.
    "/ self layoutChanged - no; leads to recursion
    realized ifTrue:[
        self setChildPositions
    ] ifFalse:[
        mustRearrange := true
    ].
!

update:something with:aParameter from:changedObject
    "an element changed its size"

    something == #sizeOfView ifTrue:[
        elementsChangeSize ifTrue:[
            self layoutChanged.
        ].
        ^ self
    ].
"/    something == #preferredExtent ifTrue:[
"/        elementsChangeSize ifTrue:[
"/            self layoutChanged.
"/        ].
"/        ^ self
"/    ].
    something == #visibility ifTrue:[
        ignoreInvisibleComponents ifTrue:[
            self layoutChanged.
        ].
        ^ self
    ].
    ^ super update:something with:aParameter from:changedObject

    "Modified: 28.1.1997 / 17:52:44 / cg"
! !

!PanelView methodsFor:'focus handling'!

wantsFocusWithButtonPress
    "no, do not catch the keyboard focus on button click"

    ^ false


! !

!PanelView methodsFor:'initialization'!

initialize
    super initialize.

    hLayout := vLayout := #center.  "/ notice, this is ignored in this class
				    "/ used by subclasses only
    verticalSpace := ViewSpacing.
    horizontalSpace := ViewSpacing.
    mustRearrange := elementsChangeSize := false.
    ignoreInvisibleComponents := true.
!

mapped
    mustRearrange ifTrue:[
        self setChildPositions
    ].
    super mapped
!

realize
    mustRearrange ifTrue:[
	self setChildPositions
    ].
    super realize
!

resize
    super resize.
    mustRearrange ifTrue:[
	self setChildPositions
    ].
!

setChildPositionsIfChanged
    "set all of my child positions - this is usually delayed,
     until the panel is actually shown (since we don't know, if more
     elements are to be added) thus avoiding repositioning the elements
     over and over. However, sometimes it is nescessary, to force positioning
     the elements, for example, before querying the relative position of
     an element (modalBoxes do so, to position the ok-button under the mouse
     pointer)."

    mustRearrange ifTrue:[
        self setChildPositions
    ].
! !

!PanelView methodsFor:'layout'!

preferredExtent
    "return a good extent, one that makes subviews fit.
     Note that width is considered as given, and compute height here."

    |subViews xpos totalHeight maxHeightInRow first|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    subViews := self subViewsToConsider.
    subViews isEmptyOrNil ifTrue:[
        ^ super preferredExtent.
    ].

    xpos := horizontalSpace.

    totalHeight := 0.
    maxHeightInRow := 0.
    first := true.

    subViews do:[:eachChild | |childPreferredExtent|
        childPreferredExtent := eachChild preferredExtent.
        
        "go to next row, if this subview won't fit"
        first ifFalse: [
            (xpos + childPreferredExtent x + horizontalSpace) > width
            ifTrue: [
                xpos := horizontalSpace.
                totalHeight := totalHeight + maxHeightInRow + verticalSpace.
                maxHeightInRow := 0.
            ]
        ].

        xpos := xpos + (childPreferredExtent x) + horizontalSpace.
        (maxHeightInRow < (childPreferredExtent y)) ifTrue:[
            maxHeightInRow := childPreferredExtent y.
        ].
        first := false
    ].
    maxHeightInRow ~= 0 ifTrue:[
        totalHeight := totalHeight + maxHeightInRow + verticalSpace.
    ].

    ^ width @ totalHeight
!

setChildPositions
    "(re)compute position of every child.
     This method is redefined for different layout characteristics - you may
     even create subclasses with completely different geometry management."

    |first xpos ypos maxHeightInRow thisRow subViews ext|

    subViews := self subViewsToConsider.
    subViews size == 0 ifTrue:[^ self].

"/    self extentChangedFlag ifTrue:[
"/        ext := self computeExtent.
"/        width := ext x.
"/        height := ext y.
"/    ].

    xpos := horizontalSpace.
    ypos := verticalSpace.

    maxHeightInRow := 0.
    first := true.
    thisRow := OrderedCollection new.
    subViews do:[:child |
        "go to next row, if this subview won't fit"
        first ifFalse: [
            (xpos + child widthIncludingBorder + horizontalSpace) > width
            ifTrue: [
                thisRow notEmpty ifTrue:[
                    thisRow do:[:rowElement |
                        rowElement heightIncludingBorder < maxHeightInRow ifTrue:[
                            rowElement top:(rowElement top + (maxHeightInRow - rowElement heightIncludingBorder))
                        ]
                    ]
                ].
                ypos := ypos + verticalSpace + maxHeightInRow.
                xpos := horizontalSpace.
                maxHeightInRow := 0.
                thisRow := OrderedCollection new.
            ]
        ].
        thisRow add:child.
        child origin:(xpos@ypos).
        xpos := xpos + (child widthIncludingBorder) + horizontalSpace.
        (maxHeightInRow < (child heightIncludingBorder)) ifTrue:[
            maxHeightInRow := child heightIncludingBorder
        ].
        first := false
    ].
    thisRow notEmpty ifTrue:[
        thisRow do:[:rowElement |
            rowElement heightIncludingBorder < maxHeightInRow ifTrue:[
                rowElement top:(rowElement top + (maxHeightInRow - rowElement heightIncludingBorder))
            ]
        ]
    ].
    mustRearrange := false

    "Modified: / 17.1.1998 / 00:17:19 / cg"
! !

!PanelView methodsFor:'private'!

addedView:aView
    "added a new element - rearrange components"

    (elementsChangeSize or:[ignoreInvisibleComponents]) ifTrue:[
        aView addDependent:self
    ].
    aView resize.
"/    explicitExtent ~~ true ifTrue:[
"/        self resize
"/    ].
    self layoutChanged

    "Modified: 28.1.1997 / 17:45:10 / cg"
!

layoutChanged
    "called whenever repositioning is required. If the panel view is
     already visible, reposition elements right now. Otherwise, remember
     that a repositioning is needed to do so when the view eventually becomes
     visible."

    super layoutChanged.
    realized ifTrue:[
        self setChildPositions
    ] ifFalse:[
        mustRearrange := true
    ].
!

makeMyselfDependentOnSubviews
    subViews notNil ifTrue:[
        subViews do:[:aView |
            aView addDependent:self
        ]
    ]
!

subViewsToConsider
    "return a collection of subviews which are to be considered in
     the layout. If ignoreInvisibleComponents is true, only visible 
     components are considered; otherwise, all are considered."

    |subViews|

    subViews := self subViews.
    ignoreInvisibleComponents ifTrue:[
        subViews size ~~ 0 ifTrue:[
            subViews := subViews 
                            select:[:v | 
                                    "/ if I am already realized, only consider realized subViews
                                    "/ otherwise, consider subViews which will be shown when I am.
                                    realized 
                                        ifTrue:[v realized]       
                                        ifFalse:[v isHiddenOnRealize not]
                                   ].
        ].
    ].
    ^ subViews

    "Created: / 17.1.1998 / 00:17:05 / cg"
! !

!PanelView methodsFor:'queries'!

isLayoutWrapper
    "answer true, if this view defines the layout of it's subviews"

    ^ true
! !

!PanelView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

