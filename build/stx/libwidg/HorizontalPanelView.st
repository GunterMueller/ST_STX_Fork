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

PanelView subclass:#HorizontalPanelView
	instanceVariableNames:'reverseOrderIfOKAtLeft'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Layout'
!

!HorizontalPanelView class methodsFor:'documentation'!

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
    a View which arranges its child-views in a horizontal row.
    All real work is done in PanelView - only the layout computation is
    redefined here.

    The layout is controlled the instance variables: 
	horizontalLayout and verticalLayout
    in addition to 
	horizontalSpace and verticalSpace.

    HorizontalSpace and verticalSpace control the spacing between elements;
    they default to some 1mm.

    The horizontal layout can be any of:

	#left           arrange elements at left
	#leftSpace      arrange elements at the left, start with spacing
	#fixLeft        same as #left, but do not reduce spacing in case of no fit
	#fixLeftSpace   same as #leftSpace, but do not reduce spacing in case of no fit
	#right          arrange elements at the right
	#rightSpace     arrange elements at the right, start with spacing
	#center         arrange elements in the center
	#spread         spread elements evenly
	#spreadSpace    spread elements evenly with spacing at the ends
	#fit            like #spread, but resize elements for tight packing
	#fitSpace       like #fit, with additional spacing at the far ends
	#leftFit        like #left, but extend the last (rightMost) element to the right
	#leftSpaceFit   like #leftSpace, but extend the last (rightMost) element to the right
	#rightFit       like #right, but extend the first (leftMost) element to the left
	#rightSpaceFit  like #rightSpace, but extend the first (leftMost) element to the left

	#leftMax        like corresponding non-Max layouts,
	#leftSpaceMax   but resize all components to width of widest components
	#rightMax
	#rightSpaceMax
	#centerMax
	#spreadMax
	#spreadSpaceMax

    the vertical layout can be:

	#top            place element at the top
	#topSpace       place element at the top, offset by verticalSpace
	#center         place it horizontally centered
	#bottom         place it at the bottom
	#bottomSpace    place it at the bottom, offset by verticalSpace
	#fit            resize elements vertically to fit this panel
	#fitSpace       like #fit, but with spacing

	#topMax         like #top, but resize all views vertically to max height
	#topSpaceMax    like #topSpace, but resize all views vertically to max height
	#bottomMax      like #bottom, but resize all views vertically to max height
	#bottomSpaceMax like #bottomSpace, but resize all views vertically to max height
	#centerMax      like #center, but resize all views vertically to max height

    The defaults is #center for both directions.
    The layout is changed by the messages #verticalLayout: and #horizontalLayout:.
    For backward compatibility (to times, where only hLayout existed), the simple
    #layout: does the same as #horizontalLayout:. 
    Do not use this old method; it will vanish and currently outputs a warning.

    The panel assumes, that the elements do not resize themselfes, after it
    became visible. This is not true for all widgets (buttons, labels or
    inputFields may like to change). 
    If you have changing elements, tell this to the panel
    with 'aPanel elementsChangeSize:true'. In that case, the panel will react
    to size changes of its elements, and reorganize things.

    By combining Horizontal- and VerticalPanels (i.e. place a hPanel into a
    vPanel), most layouts should be implementable.
    However, iff none of these layout/space combinations is exactly what you need 
    in your application, create a subclass, and redefine the setChildPositions 
    method there.

    TODO: for completeness, support #fixRight, #fixRightSpace,
	  #rightFit, #rightSpaceFit layouts

    CAVEAT: this class started with #left and no vertical alignments;
    as time went by, more layouts were added (by users requests)
    and now, many layout combinations are possible.
    Reflecting this, the setup should be changed to use different selectors 
    for space-on/off, max-resize and alignment
    (i.e. having more and more layout symbols makes things a bit confusing ...)

    [see also:]
	VerticalPanelView
	VariableVerticalPanel VariableHorizontalPanel
	Label

    [author:]
	Claus Gittinger

    [author:]
	Claus Gittinger
"
!

examples
"
    These examples show the effect of various horizontalLayout and
    verticalLayout settings. Try them all. Especially, notice the
    differences between the xxx and xxxSpace layouts and the effect of
    setting different values for the spacing.
    Try resizing the view and see how the elements get rearranged.

    Most of the examples below place 3 buttons onto a panel; 
    Of course, you can put any other view into a panel ... the last examples show this.
    (The fit layouts are especially useful to be used with SelectionInListViews;
     you can combine multiple labels & editFields with a selectionInListView, which
     is expanded to fill the remaining area of the view)

    example: default layout (center)
        centers components
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'default: center'.

        p := HorizontalPanelView in:v.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: same (default center layout) with different sized elements
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'default: center'.

        p := HorizontalPanelView in:v.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: horizontal default (center); vertical centerMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=centerMax'.
        p := HorizontalPanelView in:v.
        p verticalLayout:#centerMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: horizontal default (center); vertical topMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=topMax'.
        p := HorizontalPanelView in:v.
        p verticalLayout:#topMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: horizontal default (center); vertical topSpaceMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=topSpaceMax'.
        p := HorizontalPanelView in:v.
        p verticalLayout:#topSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: horizontal default (center); vertical bottomMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=bottomMax'.
        p := HorizontalPanelView in:v.
        p verticalLayout:#bottomMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: horizontal default (center); vertical bottomSpaceMax
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'vL=bottomSpaceMax'.
        p := HorizontalPanelView in:v.
        p verticalLayout:#bottomSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: left-layout (vertical is default -> center)
        fills left-to-right; no spacing before leftMost component
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=left; vL=default (center)'.

        p horizontalLayout:#left.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: left starting with spacing (vertical is default -> center)
        fills left-to-right; spacing before leftMost component
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=leftSpace; vL=center'.

        p horizontalLayout:#leftSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: leftFit-layout (vertical is default -> center)
        fills left-to-right; resizes the rightMost component to fit
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=leftFit; vL=center'.

        p horizontalLayout:#leftFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: leftSpaceFit-layout (vertical is default -> center)
        fills left-to-right; 
        starts with spacing & resizes the rightMost component to fit with spacing
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=leftSpaceFit; vL=center'.

        p horizontalLayout:#leftSpaceFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: right-layout (vertical is default -> center)
        right-to-left
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v viewBackground:Color yellow.
        p := HorizontalPanelView in:v.
        p viewBackground:Color red.
        v label:'hL=right; vL=center'.

        p horizontalLayout:#rightSpaceFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := View in:p. b1 viewBackground:(Color green).
        b2 := View in:p. b2 viewBackground:(Color gray). 
        b3 := View in:p. b3 viewBackground:(Color white). 
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: right with initial spacing (vertical is default -> center)
        right-to-left with spacing after last component
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=rightSpace; vL=center'.

        p horizontalLayout:#rightSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: rightFit-layout (vertical is default -> center)
        right-to-left; resize the leftMost component to fit
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=rightFit; vL=center'.

        p horizontalLayout:#rightFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: rightSpaceFit with initial spacing (vertical is default -> center)
        right-to-left; start with spacing & resize the leftMost to fit
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=rightSpaceFit; vL=center'.

        p horizontalLayout:#rightSpaceFit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit-layout (vertical is default -> center)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        p horizontalLayout:#fit.
        v label:'hL=fit; vL=center'.

        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: full fit i.e. no spacing (vertical is default -> center)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        p horizontalLayout:#fit.
        p horizontalSpace:0.
        v label:'hL=fit hS=0; vL=center'.

        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit with spacing (vertical is default -> center)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fitSpace; vL=center'.

        p horizontalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: spread-layout (vertical is default -> center)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        p horizontalLayout:#spread.
        v label:'hL=spread; vL=center'.

        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: spread with spacing (vertical is default -> center)
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=spreadSpace; vL=center'.

        p horizontalLayout:#spreadSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: spread with spacing; vertical fit
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=spreadSpace; vL=fit'.

        p horizontalLayout:#spreadSpace.
        p verticalLayout:#fit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: spread with spacing; vertical fit with spacing
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=spreadSpace; vL=fitSpace'.

        p horizontalLayout:#spreadSpace.
        p verticalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit - top
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fit; vL=top'.

        p horizontalLayout:#fit.
        p verticalLayout:#top.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit with initial spacing
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fitSpace; vL=top'.

        p horizontalLayout:#fitSpace.
        p verticalLayout:#top.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit with initial spacing in both directions
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fitSpace; vL=fitSpace'.

        p horizontalLayout:#fitSpace.
        p verticalLayout:#fitSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit without spacing in both directions
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fit hS=0; vL=fit'.

        p horizontalLayout:#fit.
        p verticalLayout:#fit.
        p horizontalSpace:0.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit with initial spacing; top with spacing
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fitSpace; vL=topSpace'.

        p horizontalLayout:#fitSpace.
        p verticalLayout:#topSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit - top without spacing
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fit; vL=top'.

        p horizontalLayout:#fit.
        p verticalLayout:#top.
        p horizontalSpace:0.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit - bottom with spacing and bottomSpace
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fitSpace; vL=bottomSpace'.

        p horizontalLayout:#fitSpace.
        p verticalLayout:#bottomSpace.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: fit no horizontal space - bottom with spacing and bottomSpace
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=fit; vL=bottomSpace'.

        p horizontalLayout:#fit.
        p verticalLayout:#bottomSpace.
        p horizontalSpace:0.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'button2' in:p.
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]

    example: leftMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=leftMax; vL=default'.

        p horizontalLayout:#leftMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: leftSpaceMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=leftSpaceMax; vL=default'.

        p horizontalLayout:#leftSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: rightMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=rightMax; vL=default'.

        p horizontalLayout:#rightMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: rightSpaceMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=rightSpaceMax; vL=default'.

        p horizontalLayout:#rightSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: centerMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=centerMax; vL=default'.

        p horizontalLayout:#centerMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: spreadMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=spreadMax; vL=default'.

        p horizontalLayout:#spreadMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: spreadSpaceMax - vertical default
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=spreadSpaceMax; vL=default'.

        p horizontalLayout:#spreadSpaceMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'button1' in:p.
        b2 := Button label:'b2' in:p.
        b3 := Button label:'but3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: maximize elements in both directions and center
                                                                        [exBegin]
        |v p b1 b2 b3|

        v := StandardSystemView new.
        v label:'hL=centerMax; vL=centerMax'.

        p := HorizontalPanelView in:v.
        p horizontalLayout:#centerMax.
        p verticalLayout:#centerMax.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        b1 := Button label:'but1' in:p. b1 font:(b1 font size:8).
        b2 := Button label:'b2' in:p.      b2 font:(b1 font size:24).
        b3 := Button label:'button3' in:p.
        v extent:300 @ 100.
        v open
                                                                        [exEnd]


    example: placing hPanels into a vPanel
                                                                        [exBegin]
        |v vP hP1 hP2 hP3 b1 b2 b3 b4 b5 b6 b7 b8 b9|

        v := StandardSystemView new.
        vP := VerticalPanelView in:v.
        vP origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).
        vP verticalLayout:#fit;
           verticalSpace:0;
           horizontalLayout:#fit.

        hP1 := HorizontalPanelView in:vP.
        hP1 horizontalLayout:#fitSpace;
            verticalLayout:#center.
        b1 := Button label:'button1' in:hP1.
        b2 := Button label:'button2' in:hP1.
        b3 := Button label:'button3' in:hP1.

        hP2 := HorizontalPanelView in:vP.
        hP2 horizontalLayout:#fitSpace;
            verticalLayout:#center.
        b4 := Button label:'button4' in:hP2.
        b5 := Button label:'button5' in:hP2.
        b6 := Button label:'button6' in:hP2.

        hP3 := HorizontalPanelView in:vP.
        hP3 horizontalLayout:#fitSpace;
            verticalLayout:#center.
        b7 := Button label:'button7' in:hP3.
        b8 := Button label:'button8' in:hP3.
        b9 := Button label:'button9' in:hP3.

        v extent:300 @ 300.
        v open
                                                                        [exEnd]

    example: a browser like table, the two left tables have a fix width,
             while the rightmost list extends to the far right.
                                                                        [exBegin]
        |v p l1 l2 l3|

        v := StandardSystemView new.
        p := HorizontalPanelView in:v.
        v label:'hL=leftFit hS=0; vL=fit'.

        p horizontalLayout:#leftFit.
        p horizontalSpace:0.
        p verticalLayout:#fit.
        p origin:(0.0 @ 0.0) corner:(1.0 @ 1.0).

        l1 := ScrollableView for:FileSelectionList in:p.
        l1 stayInDirectory:true.
        l1 ignoreParentDirectory:true.
        l1 directory:'/'.
        l1 action:[:selection | l2 directory:(l1 selectedPathname)].

        l2 := ScrollableView for:FileSelectionList in:p.
        l2 stayInDirectory:true.
        l2 directory:nil.
        l2 ignoreParentDirectory:true.
        l2 action:[:selection | l3 directory:(l2 selectedPathname)].

        l3 := ScrollableView for:FileSelectionList in:p.
        l3 directory:nil.
        l3 ignoreParentDirectory:false.
        v extent:400 @ 300.
        v open
                                                                        [exEnd]


    trouble example: self-resizing elements may cause trouble
                                                                        [exBegin]
        |v p l1 l2 l3|

        v := StandardSystemView new.
        p := HorizontalPanelView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:v.

        l1 := (Label label:'one' in:p) level:-1.
        l2 := (Label label:'two' in:p) level:-1.
        l3 := (Label label:'three' in:p) level:-1.

        v extent:400 @ 300.
        v open.

        (Delay forSeconds:5) wait.

        l1 label:'oneone'.
        l2 label:'twotwo'.
        l3 label:'threethree'.
                                                                        [exEnd]


    fixed trouble example: tell the panel that this situation may happen
                                                                        [exBegin]
        |v p l1 l2 l3|

        v := StandardSystemView new.
        p := HorizontalPanelView origin:(0.0 @ 0.0) corner:(1.0 @ 1.0) in:v.
        p elementsChangeSize:true.

        l1 := (Label label:'one' in:p) level:-1.
        l2 := (Label label:'two' in:p) level:-1.
        l3 := (Label label:'three' in:p) level:-1.

        v extent:400 @ 300.
        v open.

        (Delay forSeconds:5) wait.

        l1 label:'oneone'.
        l2 label:'twotwo'.
        l3 label:'threethree'.
                                                                        [exEnd]
"
! !

!HorizontalPanelView class methodsFor:'queries'!

possibleHorizontalLayouts
    ^ #(
                #okCancelBox

                #left
                #leftSpace
                #fixLeft
                #fixLeftSpace
                #right
                #rightSpace
                #center
                #spread
                #spreadSpace
                #fit
                #fitSpace
                #leftFit 
                #leftSpaceFit
                #rightFit 
                #rightSpaceFit

                #leftMax
                #leftSpaceMax
                #rightMax
                #rightSpaceMax
                #centerMax
                #spreadMax
                #spreadSpaceMax
        ) 
!

possibleVerticalLayouts
       ^ #(
                #top
                #topSpace
                #center
                #bottom
                #bottomSpace
                #fit
                #fitSpace
                #topMax
                #topSpaceMax
                #bottomMax
                #bottomSpaceMax
                #centerMax
        ) 
! !

!HorizontalPanelView methodsFor:'accessing'!

horizontalLayout
    "return the horizontal layout as symbol.
     the returned value is one of
	#left           arrange elements at the left
	#leftSpace      arrange elements at the left, start with spacing
	#fixLeft        same as #left, but do not reduce spacing in case of no fit
	#fixLeftSpace   same as #leftSpace, but do not reduce spacing in case of no fit
	#right          arrange elements at the right
	#rightSpace     arrange elements at the right, start with spacing
	#center         arrange elements in the center
	#spread         spread elements evenly
	#spreadSpace    spread elements evenly with spacing at the ends
	#fit            like #spread, but resize elements for tight packing
	#fitSpace       like #fit, with additional spacing at the far ends
	#leftFit        like #left, but resize the last element to fit
	#leftSpaceFit   like #leftSpace, but resize the last element to fit
	#rightFit       like #right, but resize the first element to fit
	#rightSpaceFit  like #rightSpace, but resize the first element to fit
      the default is #center
      See the class documentation for  the meanings.
    "

    ^ hLayout

    "Modified: 17.8.1997 / 15:21:26 / cg"
!

horizontalLayout:layoutSymbolArg
    "change the horizontal layout as symbol.
     The argument, aSymbol must be one of:
        #okCancelBox    window system specific. Will dynamically be one of:
                        #maxRightSpace or #fitSpace, depending on style sheet value.
                        
        #left           arrange elements at the left
        #leftSpace      arrange elements at the left, start with spacing
        #fixLeft        same as #left, but do not reduce spacing in case of no fit
        #fixLeftSpace   same as #leftSpace, but do not reduce spacing in case of no fit
        #right          arrange elements at the right
        #rightSpace     arrange elements at the right, start with spacing
        #center         arrange elements in the center
        #spread         spread elements evenly
        #spreadSpace    spread elements evenly with spacing at the ends
        #fit            like #spread, but resize elements for tight packing
        #fitSpace       like #fit, with additional spacing at the far ends
        #leftFit        like #left, but resize the last element to fit
        #leftSpaceFit   like #leftSpace, but resize the last element to fit
        #rightFit       like #right, but resize the first element to fit
        #rightSpaceFit  like #rightSpace, but resize the first element to fit

        #leftMax        like non-Max layouts, resizing components to
        #leftSpaceMax   the width of the widest component
        #rightMax
        #rightSpaceMax
        #centerMax
        #spreadMax
        #spreadSpaceMax
      the default (if never changed) is #center.
      See the class documentation for the meanings.
    "

    |layoutSymbol|

    layoutSymbol := layoutSymbolArg.
    layoutSymbol == #okCancelBox ifTrue:[
        layoutSymbol := styleSheet at:#'horizontalPanel.okCancelBox' default:#fitSpace.
    ].

    (hLayout ~~ layoutSymbol) ifTrue:[
        hLayout := layoutSymbol.
        self layoutChanged
    ]

    "Modified: 17.8.1997 / 15:21:16 / cg"
!

layout:something
    "OBSOLETE compatibility interface. Will vanish.
     leftover for historic reasons - do not use any more.
     In the meantime, try to figure out what is meant ... a kludge"

    <resource:#obsolete>

    something isLayout ifTrue:[^ super layout:something].

    self obsoleteMethodWarning:'use #horizontalLayout:'.
    ^ self horizontalLayout:something

    "Modified: 31.8.1995 / 23:07:33 / claus"
!

reverseOrderIfOKAtLeft
    "return the reverseOrderIfOKAtLeft flag.
     This can be set for OK-Cancel like panels, where the OK Button should
     be positioned on the left for some viewStyles."

    ^ reverseOrderIfOKAtLeft 
!

reverseOrderIfOKAtLeft:aBoolean
    "set/clear the reverseOrderIfOKAtLeft flag.
     This can be set for OK-Cancel like panels, where the OK Button should
     be positioned on the left for some viewStyles."

    reverseOrderIfOKAtLeft := aBoolean
!

verticalLayout
    "return the vertical layout as a symbol.
     the returned value is one of
	#top            place element at the top
	#topSpace       place element at the top, offset by verticalSpace
	#center         place it horizontally centered
	#bottom         place it at the bottom
	#bottomSpace    place it at the bottom, offset by verticalSpace
	#fit            resize elements vertically to fit this panel
	#fitSpace       like #fit, but with spacing

	#topMax         like #top, but resize all views vertically to max height
	#topSpaceMax    like #topSpace, but resize all views vertically to max height
	#bottomMax      like #bottom, but resize all views vertically to max height
	#bottomSpaceMax like #bottomSpace, but resize all views vertically to max height
	#centerMax      like #center, but resize all views vertically to max height
      the default is #center
      See the class documentation for  the meanings.
    "

    ^ vLayout
!

verticalLayout:aSymbol
    "change the vertical layout as a symbol.
     The argument, aSymbol must be one of:
	#top            place element at the top
	#topSpace       place element at the top, offset by verticalSpace
	#center         place it horizontally centered
	#bottom         place it at the bottom
	#bottomSpace    place it at the bottom, offset by verticalSpace
	#fit            resize elements vertically to fit this panel
	#fitSpace       like #fit, but with spacing

	#topMax         like #top, but resize all views vertically to max height
	#topSpaceMax    like #topSpace, but resize all views vertically to max height
	#bottomMax      like #bottom, but resize all views vertically to max height
	#bottomSpaceMax like #bottomSpace, but resize all views vertically to max height
	#centerMax      like #center, but resize all views vertically to max height
      the default (if never changed) is #center
      See the class documentation for  the meanings.
    "

    (vLayout ~~ aSymbol) ifTrue:[
	vLayout := aSymbol.
	self layoutChanged
    ]
! !

!HorizontalPanelView methodsFor:'focus handling'!

subviewsInFocusOrder

    subViews isEmptyOrNil ifTrue:[ ^ #() ].
    
    (reverseOrderIfOKAtLeft == true
    and:[Dialog defaultOKButtonAtLeft]) ifTrue:[
        ^ subViews reversed
    ].
    ^ subViews
! !

!HorizontalPanelView methodsFor:'layout'!

setChildPositions
    "(re)compute position of every child whenever children are added or
     my size has changed"

    |xpos space sumOfWidths numChilds l wEach wInside hL vL resizeToMaxV
     resizeToMaxH maxHeight maxWidth m2 subViews restWidth y2 bw|

    subViews := self subViewsToConsider.
    (numChilds := subViews size) == 0 ifTrue:[^ self].

    reverseOrderIfOKAtLeft == true ifTrue:[
        (Dialog defaultOKButtonAtLeft) ifTrue:[
            subViews := subViews reversed.
        ]
    ].

"/    self extentChangedFlag ifTrue:[
"/        ext := self computeExtent.
"/        width := ext x.
"/        height := ext y.
"/    ].

    space := horizontalSpace.

    bw := self borderWidth.
    m2 := margin * 2.
    wInside := width - m2 + (bw*2) - subViews last borderWidth.

    hL := hLayout.
    vL := vLayout.
"/ hL == #rightFit ifTrue:[self halt].
    resizeToMaxH := false.
    (hL endsWith:'Max') ifTrue:[
        resizeToMaxH := true.
        wEach := maxWidth := subViews
                                inject:0
                                into:[:maxSoFar :child |
                                        maxSoFar max:child preferredWidth "widthIncludingBorder"
                                ].
        hL := (hL copyButLast:3) asSymbol.
    ].

    numChilds == 1 ifTrue:[
        (hL == #leftFit or:[hL == #rightFit]) ifTrue:[
            hL := #fit
        ].
        (hL == #leftSpaceFit or:[hL == #rightSpaceFit]) ifTrue:[
            hL := #fitSpace
        ].
    ].

    hL == #fitSpace ifTrue:[
        "
         adjust childs extents and set origins.
         Be careful to avoid accumulation of rounding errors
        "
        wEach := (wInside - ((numChilds + 1) * space)) / numChilds.
        xpos := space + margin - bw.
    ] ifFalse:[
        hL == #fit ifTrue:[
            "
             adjust childs extents and set origins.
             Be careful to avoid accumulation of rounding errors
            "
            wEach := (wInside - ((numChilds - 1) * space)) / numChilds.
            xpos := margin - bw.
        ] ifFalse:[
            l := hL.

            "
             compute net width needed
            "
            resizeToMaxH ifTrue:[
                sumOfWidths := subViews inject:0 into:[:sumSoFar :child | sumSoFar + maxWidth + (child borderWidth*2)].
            ] ifFalse:[
                sumOfWidths := subViews inject:0 into:[:sumSoFar :child | sumSoFar + child widthIncludingBorder].

                "/ adjust - do not include width of last(first) element if doing a fit
                (hL == #leftFit or:[hL == #leftSpaceFit]) ifTrue:[
                    sumOfWidths := sumOfWidths - subViews last widthIncludingBorder.
                ] ifFalse:[
                    (hL == #rightFit or:[hL == #rightSpaceFit]) ifTrue:[
                        sumOfWidths := sumOfWidths - subViews first widthIncludingBorder.
                        hL == #rightSpaceFit ifTrue:[
                            sumOfWidths := sumOfWidths + (space * (numChilds+1)).
                        ] ifFalse:[
                            sumOfWidths := sumOfWidths + (space * (numChilds-1)).
                        ]
                    ]
                ].
            ].

            restWidth := wInside "width" - sumOfWidths "- (numChilds-1*space)".

            ((l == #center) and:[numChilds == 1]) ifTrue:[l := #spread].
            (l == #spread and:[numChilds == 1]) ifTrue:[l := #spreadSpace].

            "
             compute position of leftmost subview and space between them;
             if they do hardly fit, leave no space between them
            "
            ((sumOfWidths > (width - m2))
            and:[l ~~ #fixLeftSpace and:[l ~~ #fixLeft]]) ifTrue:[
                xpos := margin.
                space := 0
            ] ifFalse: [
                l == #fixLeftSpace ifTrue:[
                    l := #leftSpace
                ] ifFalse:[
                    l == #fixLeft ifTrue:[
                        l := #left
                    ]
                ].
                ((l == #right) or:[l == #rightSpace
                or:[l == #rightFit or:[l == #rightSpaceFit]]]) ifTrue:[
                    xpos := restWidth - (space * (numChilds - 1)).
"/
"/                    bw == 0 ifTrue:[
"/                        xpos := xpos + space
"/                    ].
"/
                    (l == #rightSpace
                    or:[l == #rightSpaceFit]) ifTrue:[
                        xpos >= space ifTrue:[
                            xpos := xpos - space
                        ]
                    ].
                    xpos := xpos - margin.

                    xpos < 0 ifTrue:[
                        space := space min:(restWidth // (numChilds + 1)).
                        xpos := restWidth - (space * numChilds).
                    ]
                ] ifFalse:[
                    (l == #spread) ifTrue:[
                        numChilds == 1 ifTrue:[
                            space := (restWidth - m2).
                        ] ifFalse:[
                            space := (restWidth - m2) // (numChilds - 1).
                        ].
                        xpos := margin.
                        (space == 0) ifTrue:[
                            xpos := restWidth // 2
                        ]
                    ] ifFalse:[
                      (l == #spreadSpace) ifTrue:[
                        space := (restWidth - m2) // (numChilds + 1).
                        xpos := space + margin.
                        (space == 0) ifTrue:[
                            xpos := restWidth // 2
                        ]
                      ] ifFalse:[
                        ((l == #left) or:[l == #leftSpace
                        or:[l == #leftFit or:[l == #leftSpaceFit]]]) ifTrue:[
                            (l == #left or:[l == #leftFit]) ifTrue:[
                                numChilds == 1 ifTrue: [
                                    space := space min:(restWidth - m2).
                                ]ifFalse:[
                                    space := space min:(restWidth - m2) // (numChilds - 1).
                                ].
                            ] ifFalse:[
                                space := space min:(restWidth - m2) // (numChilds "+ 1").
                            ].
                            (hL == #fixLeft or:[hL == #fixLeftSpace]) ifTrue:[
                                space := space max:horizontalSpace.
                            ] ifFalse:[
                                space := space max:0.
                            ].
                            (l == #leftSpace or:[l == #leftSpaceFit]) ifTrue:[
                                xpos := space + margin.
                            ] ifFalse:[
                                "/
                                "/ if the very first view has a 0-level AND
                                "/ my level is non-zero, begin with margin
                                "/
                                true "(margin ~~ 0 and:[subViews first level == 0])" ifTrue:[
                                    xpos := margin
                                ] ifFalse:[
                                    xpos := 0
                                ]
                            ]
                        ] ifFalse:[
                            "center"
                            xpos := (restWidth - ((numChilds - 1) * space)) // 2.
                            xpos < 0 ifTrue:[
                                space := restWidth // (numChilds + 1).
                                xpos := (restWidth - ((numChilds - 1) * space)) // 2.
                            ]
                        ]
                      ]
                    ]
                ]
            ].
        ].
    ].

    resizeToMaxV := false.
    (vL endsWith:'Max') ifTrue:[
        resizeToMaxV := true.
        maxHeight := subViews inject:0 into:[:maxSoFar :child | maxSoFar max:child heightIncludingBorder].
        vL := (vL copyButLast:3) asSymbol.
    ].

    "
     now set positions
    "

    subViews keysAndValuesDo:[:index :child |
        |ypos advance bwChild hChild newHChild|

        hChild := child heightIncludingBorder.
        bwChild := child borderWidth.

        elementsChangeSize ifTrue:[
            "to avoid a recursion when we change the element's size"
            child removeDependent:self.
        ].
        resizeToMaxV ifTrue:[
            child height:(hChild := maxHeight - (bwChild  * 2)).
        ].

        vL == #top ifTrue:[
            ypos := margin
        ] ifFalse:[
            vL == #topSpace ifTrue:[
                ypos :=  margin + verticalSpace
            ] ifFalse:[
                vL == #bottom ifTrue:[
                    ypos := height - margin - child heightIncludingBorder
                ] ifFalse:[
                    vL == #bottomSpace ifTrue:[
                        ypos := height - margin
                                - verticalSpace - child heightIncludingBorder.
                    ] ifFalse:[
                        vL == #fitSpace ifTrue:[
                            ypos := verticalSpace.
                            newHChild := height - ((verticalSpace + bwChild) * 2).
                            ypos := ypos + margin.
                            newHChild := newHChild - m2.
                        ] ifFalse:[
                            vL == #fit ifTrue:[
                                newHChild := height "- (bwChild * 2)".
                                "/
                                "/ if the view has a 0-level AND
                                "/ my level is non-zero, begin with margin
                                "/
                                true "(level ~~ 0 and:[child level == 0])" ifTrue:[
                                    ypos := margin.
                                    newHChild := newHChild - m2.
                                ] ifFalse:[
                                    ypos := 0.
                                ].
                            ] ifFalse:[
                                "centered"
                                ypos := margin + ((height - m2 - hChild) // 2).
                            ]
                        ]
                    ]
                ]
            ]
        ].
        newHChild notNil ifTrue:[
            child height:newHChild
        ].

        (ypos < 0) ifTrue:[ypos := 0].

        y2 := ypos + child height - 1.

        (hL == #fit
         or:[hL == #fitSpace
         or:[resizeToMaxH]]) ifTrue:[
"/cg: removed this (OLD) piece of code,
"/ which prevents resizing of label-like things if its sizeFixed is set to true 

"/            child sizeFixed ifTrue:[
"/                d := wEach - (child widthIncludingBorder) // 2.
"/                child origin:(xpos truncated + d @ ypos)
"/            ] ifFalse:[
                child origin:(xpos truncated @ ypos)
                      corner:(xpos + wEach - bwChild - 1) truncated @ y2.
"/            ].
            advance := wEach.
        ] ifFalse:[
            child origin:(xpos @ ypos).
            advance := child widthIncludingBorder
        ].

        index == numChilds ifTrue:[
            |x|

            (hL == #leftFit or:[hL == #leftSpaceFit]) ifTrue:[
                x := width - margin - 1 - (bwChild * 2) + bw.
                hL == #leftSpaceFit ifTrue:[
                    x := x - space
                ].
                child corner:(x @ y2)
            ].
        ].
        index == 1 ifTrue:[
            (hL == #rightFit or:[hL == #rightSpaceFit]) ifTrue:[
                xpos := margin + 0 + (bwChild * 2) - bw.
                hL == #rightSpaceFit ifTrue:[
                    xpos := xpos + space
                ].
                advance := restWidth.
                child origin:(xpos @ (child origin y))
                      corner:((xpos+advance) @ (child corner y))
            ].
        ].

        xpos := xpos + advance + space.
        elementsChangeSize ifTrue:[
            "reinstall dependency that we removed above"
            child addDependent:self.
        ].
    ].

    "Modified: / 04-09-1995 / 18:43:10 / claus"
    "Modified: / 23-11-2016 / 00:36:03 / cg"
! !

!HorizontalPanelView methodsFor:'queries'!

preferredExtent
    "return a good extent, one that makes subviews fit"

    |sumOfWidths maxHeight maxWidth m2 subViews|

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

    "compute net height needed"

    sumOfWidths := 0.
    maxHeight := 0.
    maxWidth := 0.

    subViews do:[:child |
        |childsPreference|

        "/ better to use component's preferredExtent ...

        child realized ifTrue:[
            childsPreference := child extent max:child preferredExtent.
        ] ifFalse:[
            childsPreference := child preferredExtent.
        ].
        sumOfWidths := sumOfWidths + childsPreference x.
        maxHeight := maxHeight max:childsPreference y.
        maxWidth := maxWidth max:childsPreference x.

        "/ ... instead of actual extent
"/        sumOfWidths := sumOfWidths + child widthIncludingBorder.
"/        maxHeight := maxHeight max:(child heightIncludingBorder).
"/        maxWidth := maxWidth max:(child widthIncludingBorder).
    ].
"/    self borderWidth ~~ 0 ifTrue:[
"/        sumOfWidths := sumOfWidths + (horizontalSpace * 2).
"/        maxHeight := maxHeight + (verticalSpace * 2).
"/    ].

    (hLayout == #fit 
    or:[hLayout == #fitSpace
    or:[hLayout endsWith:'Max']]) ifTrue:[
        sumOfWidths := maxWidth * subViews size.
        self borderWidth ~~ 0 ifTrue:[
            sumOfWidths := sumOfWidths + (horizontalSpace * 2).
        ].
        hLayout == #fitSpace ifTrue:[
            "/ care for spacing ...
            sumOfWidths := sumOfWidths + (horizontalSpace * (subViews size + 1)).
        ].
    ] ifFalse:[
        sumOfWidths := sumOfWidths + ((subViews size - 1) * horizontalSpace).
        ((hLayout == #leftSpace) or:[hLayout == #rightSpace]) ifTrue:[
            sumOfWidths := sumOfWidths + horizontalSpace
        ] ifFalse:[
            ((hLayout == #center) or:[hLayout == #spread]) ifTrue:[
                sumOfWidths := sumOfWidths + (horizontalSpace * 2)
            ]
        ].
    ].

    ((vLayout == #topSpace) 
    or:[vLayout == #bottomSpace]) ifTrue:[
        maxHeight := maxHeight + verticalSpace
    ] ifFalse:[
        ((vLayout == #fitSpace) 
        or:[vLayout == #center
        or:[vLayout == #centerSpace]]) ifTrue:[
            maxHeight := maxHeight + (verticalSpace * 2)
        ]        
    ].

    m2 := margin * 2.
    ^ (sumOfWidths + m2) @ (maxHeight + m2)

    "Modified: / 17.1.1998 / 00:18:38 / cg"
! !

!HorizontalPanelView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

