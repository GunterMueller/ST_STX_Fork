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

PanelView subclass:#VerticalPanelView
	instanceVariableNames:'rowHeight'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!VerticalPanelView class methodsFor:'documentation'!

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
    a View which arranges its child-views in a vertical column.
    All real work is done in PanelView - except the layout computation is
    redefined here.

    The layout is controlled by the instance variables: 
	horizontalLayout and verticalLayout
    in addition to 
	horizontalSpace and verticalSpace.

    The vertical layout can be any of:

	#top            arrange elements at the top
	#topSpace       arrange elements at the top, start with spacing
	#bottom         arrange elements at the bottom
	#bottomSpace    arrange elements at the bottom, start with spacing
	#center         arrange elements in the center; ignore verticalSpace
	#spread         spread elements evenly; ignore verticalSpace
	#spreadSpace    spread elements evenly with spacing at ends; ignore verticalSpace
	#fit            like #spread, but resize elements for tight packing; ignore verticalSpace
	#fitSpace       like #fit, with spacing; ignore verticalSpace
	#topFit         like #top, but resize the last element to fit
	#topSpaceFit    like #topSpace, but resize the last element to fit
	#bottomFit      like #bottom, but resize the first element to fit
	#bottomSpaceFit like #bottomSpace, but resize the first element to fit

    the horizontal layout can be:

	#left           place element at the left
	#leftSpace      place element at the left, offset by horizontalSpace
	#center         place elements horizontally centered; ignore horizontalSpace
	#right          place it at the right
	#rightSpace     place it at the right, offset by horizontalSpace
	#fit            resize elements horizontally to fit this panel; ignore horizontalSpace
	#fitSpace       like #fit, but add spacing; ignore horizontalSpace

	#leftMax        like #left, but resize elements to max of them
	#leftSpaceMax   like #leftSpace, but resize elements
	#centerMax      like #center, but resize elements
	#rightMax       like #right, but resize elements to max of them
	#rightSpaceMax  like #rightSpace, but resize elements

    The defaults is #center for both directions.

    The layout is changed by the messages #verticalLayout: and #horizontalLayout:.
    For backward compatibility (to times, where only vLayout existed), the simple
    #layout: does the same as #verticalLayout:. Do not use this old method.

    The panel assumes, that the elements do not resize themselfes, after it
    became visible. This is not true for all widgets (buttons or labels may
    like to change). If you have changing elements, tell this to the panel
    with 'aPanel elementsChangeSize:true'. In that case, the panel will react
    to size changes, and reorganize things.

    If none of these layout/space combinations is exactly what you need in
    your application, create a subclass, and redefine the setChildPositions method.

    CAVEAT: this class started with #top and no horizontal alignments;
    as time went by, more layouts were added and the setup should be changed
    to use different selectors for space, max-resize and alignment
    (i.e. having more and more layout symbols makes things a bit confusing ...)

    [see also:]
	HorizontalPanelView
	VariableVerticalPanel VariableHorizontalPanel
	Label

    [author:]
	Claus Gittinger
"
!

examples
"
    These examples demonstrate the effect of different layout
    settings.
    You should try more examples, combining spacing and different
    verticalLayout:/horizontalLayout: combinations.


    example: default layout (centered)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'center (default)'.
        p := VerticalPanelView in:v.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]


    example: rows
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'center (default)'.
        p := VerticalPanelView in:v.
        p rowHeight:50.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]


    example: horizontal centerMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'hL=centerMax'.
        p := VerticalPanelView in:v.
        p horizontalLayout:#centerMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]


    example: horizontal leftMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'hL=leftMax'.
        p := VerticalPanelView in:v.
        p horizontalLayout:#leftMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: horizontal leftSpaceMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'hL=leftMax'.
        p := VerticalPanelView in:v.
        p horizontalLayout:#leftSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: horizontal rightMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'hL=rightMax'.
        p := VerticalPanelView in:v.
        p horizontalLayout:#rightMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: horizontal rightSpaceMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'hL=rightMaxSpace'.
        p := VerticalPanelView in:v.
        p horizontalLayout:#rightSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'butt3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: top-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=top; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#top.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: topSpace-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=topSpace; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#topSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: top-layout; horizontal fit
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := VerticalPanelView in:v.
        v label:'vL=top; hL=fit'.
        p verticalLayout:#top.
        p horizontalLayout:#fit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: top-layout; horizontal fit with space
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=top; hL=fitSpace'.
        p := VerticalPanelView in:v.
        p verticalLayout:#top.
        p horizontalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: topSpace-layout; horizontal fit with space
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=topSpace; hL=fitSpace'.
        p := VerticalPanelView in:v.
        p verticalLayout:#topSpace.
        p horizontalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: bottom-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=bottom; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#bottom.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: bottomSpace-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=bottomSpace; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#bottomSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: topFit-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=topFit; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#topFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: topSpaceFit-layout; combined with horizontal #fitSpace
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=topFit; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#topSpaceFit.
        p horizontalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: bottomFit-layout (arrange at bottom; resize first to fit)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=bottomFit; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#bottomFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: bottomSpaceFit-layout (arrange at bottom; resize first to fit; with spacing
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=bottomSpaceFit; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#bottomSpaceFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: spread-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=spread; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#spread.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: spreadSpace-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=spreadSpace; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#spreadSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: fit-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=fit; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#fit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: fitSpace-layout
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=fitSpace; hL=center (default)'.
        p := VerticalPanelView in:v.
        p verticalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: fully fitSpace
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=fitSpace; hL=fitSpace'.
        p := VerticalPanelView in:v.
        p verticalLayout:#fitSpace.
        p horizontalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: combine fully fitSpace with scaling button labels
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=fitSpace; hL=fitSpace'.
        p := VerticalPanelView in:v.
        p verticalLayout:#fitSpace.
        p horizontalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b1 adjust:#fit.
        b2 := Button label:'butt2' in:p.
        b2 adjust:#fit.
        b3 := Button label:'button3' in:p.
        b3 adjust:#fit.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: from top, each at left:
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=top; hL=left'.
        p := VerticalPanelView in:v.
        p verticalLayout:#top.
        p horizontalLayout:#left.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: center, right:
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=center; hL=right'.
        p := VerticalPanelView in:v.
        p verticalLayout:#center.
        p horizontalLayout:#right.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'butt2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:100 @ 300.
        v open
                                                                        [exEnd]

    example: a panel in a panel
                                                                        [exBegin]
        |v hp p b1 b2 b3|

        v := StandardSystemView new.

        hp := HorizontalPanelView in:v.
        hp verticalLayout:#fit.
        hp horizontalLayout:#fitSpace.
        hp origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).

        1 to:3 do:[:i |
            p := VerticalPanelView in:hp.
            p borderWidth:0.
            p verticalLayout:#fitSpace.
            p horizontalLayout:#fit.
            b1 := Button label:('button1-' , i printString) in:p.
            b2 := Button label:('butt2-' , i printString) in:p.
            b3 := Button label:('button3-' , i printString) in:p.
        ].

        v extent:300 @ 100.
        v open
                                                                        [exEnd]

    example: checkToggles in a panel
                                                                        [exBegin]
        |panel|

        panel := VerticalPanelView new.
        panel horizontalLayout:#left.

        panel add:((CheckBox on:true asValue) label:'this is toggle number 1'; resize).
        panel add:((CheckBox on:false asValue) label:'nr 2 '; resize).
        panel add:((CheckBox on:true asValue) label:'number 3 '; resize).

        panel extent:(panel preferredExtent).
        panel open
                                                                        [exEnd]
    example: the topFit & bottomFit layouts are great to combine
             labels or enterFields with a selectionInList or textView:
                                                                        [exBegin]
        |panel|

        panel := VerticalPanelView new.
        panel horizontalLayout:#fit.
        panel verticalLayout:#topFit.

        panel add:(Label new label:'this is label number 1'; font:(Font family:'courier' size:16)).
        panel add:(EditField new).
        panel add:(Label new label:'this is label number 1').
        panel add:(ScrollableView for:SelectionInListView).

        panel extent:(panel preferredExtent).
        panel open
                                                                        [exEnd]
"
! !

!VerticalPanelView class methodsFor:'queries'!

possibleHorizontalLayouts
       ^ #(
                #left
                #leftSpace
                #center
                #right
                #rightSpace
                #fit
                #fitSpace
                #leftMax
                #leftSpaceMax
                #centerMax
                #rightMax
                #rightSpaceMax
            )
!

possibleVerticalLayouts
       ^  #(
                #top
                #topSpace
                #bottom
                #bottomSpace
                #center
                #spread
                #spreadSpace
                #fit
                #fitSpace
                #topFit
                #topSpaceFit
                #bottomFit
                #bottomSpaceFit
            ) 
! !

!VerticalPanelView methodsFor:'accessing'!

horizontalLayout
    "return the horizontal layout as symbol.
     the returned value is one of
	#left           place element at the left
	#leftSpace      place element at the left, offset by horizontalSpace
	#center         place elements horizontally centered; ignore horizontalSpace
	#right          place it at the right
	#rightSpace     place it at the right, offset by horizontalSpace
	#fit            resize elements horizontally to fit this panel; ignore horizontalSpace
	#fitSpace       like #fit, but add spacing; ignore horizontalSpace

	#leftMax        like #left, but resize elements to max of them
	#leftSpaceMax   like #leftSpace, but resize elements
	#centerMax      like #center, but resize elements
	#rightMax       like #right, but resize elements to max of them
	#rightSpaceMax  like #rightSpace, but resize elements
      the default is #centered
    "

    ^ hLayout
!

horizontalLayout:aSymbol
    "change the horizontal layout as symbol.
     The argument, aSymbol must be one of:
	#left           place element at the left
	#leftSpace      place element at the left, offset by horizontalSpace
	#center         place elements horizontally centered; ignore horizontalSpace
	#right          place it at the right
	#rightSpace     place it at the right, offset by horizontalSpace
	#fit            resize elements horizontally to fit this panel; ignore horizontalSpace
	#fitSpace       like #fit, but add spacing; ignore horizontalSpace

	#leftMax        like #left, but resize elements to max of them
	#leftSpaceMax   like #leftSpace, but resize elements
	#centerMax      like #center, but resize elements
	#rightMax       like #right, but resize elements to max of them
	#rightSpaceMax  like #rightSpace, but resize elements
      the default (if never changed) is #centered
    "

    (hLayout ~~ aSymbol) ifTrue:[
	hLayout := aSymbol.
	self layoutChanged
    ]
!

layout:something
    "OBSOLETE compatibility interface. Will vanish.
     leftover for historic reasons - do not use any more.
     In the meantime, try to figure out what is meant ... a kludge"

    <resource:#obsolete>

    something isLayout ifTrue:[^ super layout:something].

    self obsoleteMethodWarning:'use #verticalLayout:'.
    ^ self verticalLayout:something

    "Modified: 31.8.1995 / 23:08:54 / claus"
!

rowHeight:something
    rowHeight := something.
!

verticalLayout
    "return the vertical layout as a symbol.
     the returned value is one of
	#top            arrange elements at the top
	#topSpace       arrange elements at the top, start with spacing
	#bottom         arrange elements at the bottom
	#bottomSpace    arrange elements at the bottom, start with spacing
	#center         arrange elements in the center; ignore verticalSpace
	#spread         spread elements evenly; ignore verticalSpace
	#spreadSpace    spread elements evenly with spacing at ends; ignore verticalSpace
	#fit            like #spread, but resize elements for tight packing; ignore verticalSpace
	#fitSpace       like #fit, with spacing; ignore verticalSpace
	#topFit         like #top, but resize the last element to fit
	#topSpaceFit    like #topSpace, but resize the last element to fit
	#bottomFit      like #bottom, but resize the first element to fit
	#bottomSpaceFit like #bottomSpace, but extend the first element to fit
      the default is #centered
    "

    ^ vLayout

    "Modified: 17.8.1997 / 15:20:13 / cg"
!

verticalLayout:aSymbol
    "change the vertical layout as a symbol.
     The argument, aSymbol must be one of:
	#top            arrange elements at the top
	#topSpace       arrange elements at the top, start with spacing
	#bottom         arrange elements at the bottom
	#bottomSpace    arrange elements at the bottom, start with spacing
	#center         arrange elements in the center; ignore verticalSpace
	#spread         spread elements evenly; ignore verticalSpace
	#spreadSpace    spread elements evenly with spacing at ends; ignore verticalSpace
	#fit            like #spread, but resize elements for tight packing; ignore verticalSpace
	#fitSpace       like #fit, with spacing; ignore verticalSpace
	#topFit         like #top, but resize the last element to fit
	#topSpaceFit    like #topSpace, but resize the last element to fit
	#bottomFit      like #bottom, but resize the first element to fit
	#bottomSpaceFit like #bottomSpace, but extend the first element to fit
      the default (if never changed) is #centered
    "

    (vLayout ~~ aSymbol) ifTrue:[
	vLayout := aSymbol.
	self layoutChanged
    ]

    "Modified: 17.8.1997 / 15:19:58 / cg"
! !

!VerticalPanelView methodsFor:'layout'!

setChildPositions
    "(re)compute position of every child"

    |ypos space sumOfHeights numChilds l hEach hInside hL vL
     maxWidth maxHeight resizeToMaxV resizeToMaxH m2 subViews restHeight y2 bw|

    subViews := self subViewsToConsider.
    subViews size == 0 ifTrue:[^ self].

    bw := self borderWidth.

"/    self extentChangedFlag ifTrue:[
"/        ext := self computeExtent.
"/        width := ext x.
"/        height := ext y.
"/    ].

    space := verticalSpace.
    numChilds := subViews size.

    m2 := margin * 2.
    hInside := height - m2 + (bw*2) - subViews last borderWidth.

    hL := hLayout.
    vL := vLayout.

    resizeToMaxV := false.
    (vL endsWith:'Max') ifTrue:[
        resizeToMaxV := true.
        hEach := maxHeight := subViews inject:0 into:[:maxSoFar :child | maxSoFar max:child heightIncludingBorder].
        vL := (vL copyButLast:3) asSymbol.
    ].

    numChilds == 1 ifTrue:[
        (vL == #topFit or:[vL == #bottomFit]) ifTrue:[
            vL := #fit
        ].
        (vL == #topSpaceFit or:[vL == #bottomSpaceFit]) ifTrue:[
            vL := #fitSpace
        ].
    ].

    vL == #fitSpace ifTrue:[
        "
         adjust childs extents and set origins.
         Be careful to avoid accumulation of rounding errors
        "
        hEach := (hInside - (numChilds + 1 * space)) / numChilds.
        ypos := space + margin - bw.
    ] ifFalse:[
        vL == #fit ifTrue:[
            "
             adjust childs extents and set origins.
             Be careful to avoid accumulation of rounding errors
            "
            hEach := (hInside - (numChilds - 1 * space)) / numChilds.
            ypos := margin - bw.
        ] ifFalse:[
            l := vL.

            "
             compute net height needed
            "
            resizeToMaxV ifTrue:[
                sumOfHeights := subViews inject:0 into:[:sumSoFar :child | sumSoFar + maxHeight + (child borderWidth*2)].
            ] ifFalse:[
                sumOfHeights := subViews inject:0 into:[:sumSoFar :child | sumSoFar + child heightIncludingBorder].

                "/ adjust - do not include height of last(first) element if doing a fit
                (vL == #topFit or:[vL == #topSpaceFit]) ifTrue:[
                    sumOfHeights := sumOfHeights - subViews last heightIncludingBorder.
                ] ifFalse:[
                    (vL == #bottomFit or:[vL == #bottomSpaceFit]) ifTrue:[
                        sumOfHeights := sumOfHeights - subViews first heightIncludingBorder.
                    ]
                ].
            ].

            restHeight := hInside - sumOfHeights "- (numChilds-1*space)".
            ((l == #center) and:[numChilds == 1]) ifTrue:[l := #spread].
            (l == #spread and:[numChilds == 1]) ifTrue:[l := #spreadSpace].

            "
             compute position of topmost subview and space between them;
             if they do hardly fit, leave no space between them 
            "
            ((sumOfHeights > (height - m2))
            and:[l ~~ #fixTopSpace and:[l ~~ #fixTop]]) ifTrue:[
                "
                 if we have not enough space for all the elements, 
                 fill them tight, and show what can be shown (at least)
                "
                ypos := margin.
                space := 0
            ] ifFalse:[
                l == #fixTopSpace ifTrue:[
                    l := #topSpace
                ] ifFalse:[
                    l == #fixTop ifTrue:[
                        l := #top 
                    ]
                ].
                ((l == #bottom) or:[l == #bottomSpace
                or:[l == #bottomFit or:[l == #bottomSpaceFit]]]) ifTrue:[
                    ypos := restHeight - (space * (numChilds - 1)).
"/
"/                    bw == 0 ifTrue:[
"/                        ypos := ypos + space 
"/                    ].
"/           
                    (l == #bottomSpace
                    or:[l == #bottomSpaceFit]) ifTrue:[
                        ypos >= space ifTrue:[
                            ypos := ypos - space
                        ]
                    ].
                    ypos := ypos - margin.

                    ypos < 0 ifTrue:[
                        space := space min:(restHeight // (numChilds + 1)).
                        ypos := restHeight - (space * numChilds).
                    ].
                    y2 := ypos.
                ] ifFalse: [
                    (l == #spread) ifTrue:[
                        space := (restHeight - m2) // (numChilds - 1).
                        ypos := margin.
                        (space == 0) ifTrue:[
                            ypos := restHeight // 2
                        ]
                    ] ifFalse: [
                      (l == #spreadSpace) ifTrue:[
                        space := (restHeight - m2) // (numChilds + 1).
                        ypos := space + margin.
                        (space == 0) ifTrue:[
                            ypos := restHeight // 2
                        ]
                      ] ifFalse: [
                        ((l == #top) or:[l == #topSpace
                        or:[l == #topFit or:[l == #topSpaceFit]]]) ifTrue:[
                            (l == #top or:[l == #topFit]) ifTrue:[
                                space := space min:((restHeight - m2) // numChilds).
                            ] ifFalse:[
                                space := space min:((restHeight - m2) // (numChilds + 1)).
                            ].
                            (vL == #fixTop or:[vL == #fixTopSpace]) ifTrue:[
                                space := space max:verticalSpace.
                            ] ifFalse:[
                                space := space max:0.
                            ].
                            (l == #topSpace or:[l == #topSpaceFit]) ifTrue:[
                                ypos := space + margin.
                            ] ifFalse:[
                                "/
                                "/ if the very first view has a 0-level AND
                                "/ my level is non-zero, begin with margin
                                "/
                                true "(margin ~~ 0 and:[subViews first level == 0])" ifTrue:[
                                    ypos := margin
                                ] ifFalse:[
                                    ypos := 0
                                ]
                            ]
                        ] ifFalse:[
                            "center"
                            ypos := (restHeight - ((numChilds - 1) * space)) // 2.
                            ypos < 0 ifTrue:[
                                space := restHeight // (numChilds + 1).
                                ypos := (restHeight - ((numChilds - 1) * space)) // 2.
                            ]
                        ]
                      ]
                    ]
                ]
            ].
        ].
    ].

    resizeToMaxH := false.
    (hL endsWith:'Max') ifTrue:[
        resizeToMaxH := true.
        maxWidth := subViews inject:0 into:[:maxSoFar :child | maxSoFar max:child widthIncludingBorder].
        hL := (hL copyButLast:3) asSymbol.
    ].

    "
     now set positions
    "
    subViews keysAndValuesDo:[:index :child |
        |xpos advance bwChild wChild newWChild x2|

        wChild := child widthIncludingBorder.
        bwChild := child borderWidth.

        elementsChangeSize ifTrue:[
            "to avoid a recursion when we change the elements size"
            child removeDependent:self.
        ].
        resizeToMaxH ifTrue:[
            child width:(wChild := maxWidth - (bwChild  * 2)).
        ].

        hL == #left ifTrue:[
            xpos := 0 - bw + margin.
        ] ifFalse:[
            hL == #leftSpace ifTrue:[
                xpos := horizontalSpace + margin
            ] ifFalse:[
                hL == #right ifTrue:[
                    xpos := width - wChild - margin
                ] ifFalse:[
                    hL == #rightSpace ifTrue:[
                        xpos := width - horizontalSpace - wChild - margin.
                    ] ifFalse:[
                        hL == #fitSpace ifTrue:[
                            xpos := horizontalSpace + margin.
                            newWChild := width - m2 - (horizontalSpace + bwChild * 2)
                        ] ifFalse:[
                            hL == #fit ifTrue:[
                                newWChild := width "- (bwChild * 2)".
                                bw == 0 ifTrue:[
                                    newWChild :=  newWChild - (bwChild * 2)
                                ].
                                true "child level == 0" ifTrue:[
                                    xpos := margin - bw.
                                    newWChild := newWChild - m2
                                ] ifFalse:[
                                    xpos := 0 - bw. 
                                ].
                            ] ifFalse:[
                                "centered"
                                 xpos := margin + ((width - m2 - wChild) // 2).
                            ]
                        ]
                    ]
                ]
            ]
        ].
        newWChild notNil ifTrue:[
            child width:newWChild
        ].

"/        (xpos < 0) ifTrue:[ xpos := 0 ].

        x2 := xpos + child width - 1.

        rowHeight notNil ifTrue:[
            child origin:(xpos@ypos).
            advance := rowHeight
        ] ifFalse:[
            (vL == #fit 
            or:[vL == #fitSpace
            or:[resizeToMaxV]]) ifTrue:[
                child origin:(xpos @ (ypos rounded))
                      corner:(x2 @ (ypos + hEach - bwChild - 1) rounded).
                advance := hEach
            ] ifFalse:[
                child origin:(xpos@ypos).
                advance := child heightIncludingBorder
            ].
        ].

        index == numChilds ifTrue:[
            |y|

            (vL == #topFit or:[vL == #topSpaceFit]) ifTrue:[
                y := height - margin - 1.
                vL == #topSpaceFit ifTrue:[
                    y := y - space
                ].
                child corner:x2 @ y
            ].
        ].
        index == 1 ifTrue:[
            (vL == #bottomFit or:[vL == #bottomSpaceFit]) ifTrue:[
                ypos := margin + 0 + (child borderWidth * 2) - bw.
                vL == #bottomSpaceFit ifTrue:[
                    ypos := ypos + space
                ].
                advance := y2 ? 0.
                child origin:((child origin x) @ ypos)
                      corner:((child corner x) @ (ypos+advance))
            ].
        ].

        ypos := ypos + advance + space.
        elementsChangeSize ifTrue:[
            "reinstall dependency that we removed above"
            child addDependent:self.
        ].
    ]

    "Modified: / 04-09-1995 / 18:43:29 / claus"
    "Modified: / 10-10-2007 / 13:47:56 / cg"
! !

!VerticalPanelView methodsFor:'queries'!

preferredExtent
    "return a good extent, one that makes subviews fit"

    |sumOfHeights maxWidth maxHeight m2 subViews bw|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    "/ If I have a cached preferredExtent value..
    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].

    subViews := self subViewsToConsider.
    (subViews size == 0) ifTrue:[
        ^ super preferredExtent.
        "/ ^ horizontalSpace @ verticalSpace].
    ].

    bw := self borderWidth.

    "compute net height needed"

    sumOfHeights := 0.
    maxWidth := 0.
    maxHeight := 0.

    subViews do:[:child |
        |childsPreference|

        child realized ifTrue:[
            childsPreference := child extent max:child preferredExtent.
        ] ifFalse:[
            childsPreference := child preferredExtent.
        ].
        sumOfHeights := sumOfHeights + childsPreference y.
        maxHeight := maxHeight max:childsPreference y.
        maxWidth := maxWidth max:childsPreference x.

"/        sumOfHeights := sumOfHeights + child heightIncludingBorder.
"/        maxWidth := maxWidth max:(child widthIncludingBorder).
"/        maxHeight := maxHeight max:(child heightIncludingBorder).
    ].

    bw ~~ 0 ifTrue:[
        sumOfHeights := sumOfHeights + (verticalSpace * 2).
        maxWidth := maxWidth + (horizontalSpace * 2).
    ].

    (vLayout == #fit or:[vLayout == #fitSpace]) ifTrue:[
        sumOfHeights := maxHeight * subViews size.
        bw ~~ 0 ifTrue:[
            sumOfHeights := sumOfHeights + (verticalSpace * 2).
        ].
        vLayout == #fitSpace ifTrue:[
            "/ care for spacing ...
            sumOfHeights := sumOfHeights + (verticalSpace * (subViews size + 1)).
        ].
    ] ifFalse:[
        sumOfHeights := sumOfHeights + ((subViews size - 1) * verticalSpace).
        ((vLayout == #topSpace) or:[vLayout == #bottomSpace]) ifTrue:[
            sumOfHeights := sumOfHeights + verticalSpace
        ] ifFalse:[
            ((vLayout == #center) or:[vLayout == #spread]) ifTrue:[
                sumOfHeights := sumOfHeights + (verticalSpace * 2)
            ]
        ].
    ].

    ((hLayout == #leftSpace) or:[hLayout == #rightSpace]) ifTrue:[
        maxWidth := maxWidth + horizontalSpace
    ] ifFalse:[
        ((hLayout == #fitSpace) or:[hLayout == #center]) ifTrue:[
            maxWidth := maxWidth + (horizontalSpace * 2)
        ]        
    ].
    m2 := margin * 2.
    ^ (maxWidth + m2) @ (sumOfHeights + m2)

    "Modified: / 17.1.1998 / 00:18:16 / cg"
! !

!VerticalPanelView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

