"{ Encoding: utf8 }"

"
 COPYRIGHT (c) 1995 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libui' }"

"{ NameSpace: Smalltalk }"

ViewWithSubcomponentsSpec subclass:#FullSpec
	instanceVariableNames:'window'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Support-UI-Specs'
!

!FullSpec class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1995 by Claus Gittinger
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
    Not normally used by applications.

    Notice: 
        this class was implemented using protocol information
        from alpha testers, literature and by read public domain code
        - it may not be complete or compatible to
        the corresponding ST-80 class. 
        If you encounter any incompatibilities, please forward a note 
        describing the incompatibility verbal (i.e. no code) to the ST/X team.

    [author:]
        Claus Atzkern

    [see also:]
        UIBuilder
        UIPainter
"
! !

!FullSpec methodsFor:'accessing'!

usedBackgroundColor
    ^ window usedBackgroundColor
!

window
    ^ window
!

window:something
    "set window"

    window := something.
! !

!FullSpec methodsFor:'building'!

buildViewFor:aBuilder
    ^ self buildViewFor:aBuilder in:nil
!

buildViewFor:aBuilder in:aWindowOrNil
    |menu mPanel y vScroll hScroll top win view scrollableView
     vscroller width height autoHide windowIsMine|

    aWindowOrNil isNil ifTrue:[
        win := top := window buildViewFor:aBuilder.
        windowIsMine := true.
    ] ifFalse:[
        win := top := aWindowOrNil.
        windowIsMine := false.
    ].

    window class == WindowSpec ifTrue:[
        height := top height.
        width  := top width.

        aBuilder isSubBuilder ifFalse:[
            (menu := window pullDownMenuIn:aBuilder) notNil ifTrue:[
                mPanel := MenuPanel in:top.
                mPanel verticalLayout:false.
                mPanel menu:menu.
                mPanel name:'MainMenu'.
                aBuilder menuBar:mPanel.
                "/ cg: no menuPanels are not tabable
                "/ (should this come from a styleSheet ?)
                mPanel canTab:(View styleSheet at:'menu.mainMenu.tabable' default:false). "/ mPanel canTab:true.

                y := mPanel preferredHeight.
                windowIsMine ifTrue:[
                    top height:(height + y + 1).
                ].
                mPanel origin:0@0 corner:1.0@y.

                win := View origin:0@y corner:1.0@1.0 in:top.
                "/ now, we might have a problem here,
                "/ sicne all attributes of the main window
                "/ must also be set in the new subview...
                win viewBackground:(top viewBackground).
            
"/            View styleSheet name == #win95 ifTrue:[
"/                win origin:0.0@(y-1).
"/                View styleSheet is3D ifTrue:[
"/                    mPanel level:1.
"/                    mPanel rightInset:-1.
"/                    win level:1.
"/                    win bottomInset:-1.
"/                    win rightInset:-1.
"/                ].
"/            ].
"/            top height:(height + y)
            ]
        ].

        (win name isNil or:[win name = win class name]) ifTrue:[
            win name:'MainView'.
        ].

        hScroll := window hasHorizontalScrollBar.
        vScroll := window hasVerticalScrollBar.

        (hScroll or:[vScroll]) ifTrue:[
            scrollableView := ScrollableView 
                                for:ViewScroller
                                hasHorizontalScrollBar:hScroll
                                hasVerticalScrollBar:vScroll
                                miniScrollerH:window miniScrollerHorizontal 
                                miniScrollerV:window miniScrollerVertical 
                                origin:0.0 @ 0.0 
                                corner:1.0 @ 1.0 
                                in:win.

            (autoHide := window autoHideScrollBars) notNil ifTrue:[
                scrollableView autoHideScrollBars:autoHide
            ].

            windowIsMine ifTrue:[
                top height:(top height + 6).
                vScroll ifTrue:[
                    top width:(top width + scrollableView verticalScrollBar width + 6).
                ].
                hScroll ifTrue:[
                    top height:(top height + scrollableView horizontalScrollBar height).
                ].
            ].
            vscroller := scrollableView scrolledView.

            hScroll ifFalse:[
                vscroller resizeScrolledViewHorizontal:true.
            ].
            vScroll ifFalse:[
                vscroller resizeScrolledViewVertical:true.
            ].
            view := ApplicationSubView new.
            view application:(aBuilder application).

"/ workaround for bug in ViewScroller which computes the
"/ layout during setting the scrooled View (preferred extent = 100@100)

"/            vscroller scrolledView:view.

            component buildViewWithLayoutFor:aBuilder in:view.

"/ now we have a valid ... preferred extent
            vscroller scrolledView:view.
            view extent:(width@height).
            window postBuildView:top for:aBuilder.
            ^ top
        ]
    ].

    view := component buildViewWithLayoutFor:aBuilder in:win.

    top isTopView ifTrue:[
        window postBuildView:top for:aBuilder.
    ].

    ^ top

    "Modified: / 5.2.2000 / 19:40:55 / cg"
!

fromBuilder:aView components:aListOfComponents
    window    := WindowSpec fromView:aView callBack:nil.
    component := aListOfComponents.
!

setupView:aView for:aBuilder
    window setupView:aView topView for:aBuilder.
    component buildViewWithLayoutFor:aBuilder in:aView.
    ^ aView

    "Modified: / 26.10.1997 / 12:48:37 / cg"
! !

!FullSpec methodsFor:'converting'!

fromLiteralArrayEncoding:aSpecArray
    "read my attributes from aSpecArray"

    |isHandled|

    isHandled := MissingClassInLiteralArrayErrorSignal isHandled.

    MissingClassInLiteralArrayErrorSignal handle:[:ex |
        isHandled ifTrue:[ ex reject ].

        (Dialog confirm:(ex description,'\\Proceed ?' withCRs) noLabel:'Cancel') ifFalse:[
            AbortOperationRequest raiseRequest
        ].
        ex proceedWith:nil
    ] do:[
        super fromLiteralArrayEncoding:aSpecArray.
        window notNil ifTrue:[
            window := window decodeAsLiteralArray.
        ]
    ]

    "Modified: / 26-02-2007 / 18:29:00 / cg"
!

literalArrayEncoding
    "for compatibility: return an order to generate the window-stuff BEFORE the component stuff"

    window bounds:(Rectangle origin:0@0 extent:window bounds extent).
    ^ super literalArrayEncoding
!

literalArrayEncodingSlotOrder
    "for compatibility: return an order to generate the window-stuff BEFORE the component stuff"

    |order idx1 idx2|

    order := (1 to:self class instSize) "super literalArrayEncodingSlotOrder" asOrderedCollection.
    idx1 := order indexOf:(self class instVarIndexFor:'component').
    idx2 := order indexOf:(self class instVarIndexFor:'window').
    order at:idx1 put:idx2.
    order at:idx2 put:idx1.
    ^ order
! !

!FullSpec methodsFor:'enumerating'!

do:aBlock
    super do:aBlock.

    window notNil ifTrue:[
        aBlock value:window
    ].

    "Created: / 25-06-2018 / 14:31:54 / Claus Gittinger"
! !

!FullSpec methodsFor:'parsing a view'!

fromView:aView callBack:aBlock
    "extract attributes from aView"

    window := WindowSpec fromView:aView callBack:aBlock.
    super fromView:aView callBack:aBlock


! !

!FullSpec methodsFor:'visiting'!

acceptUISpecVisitor:aVisitor 
    "Double dispatch back to the visitor, passing my type encoded in
     the selector (visitor pattern)"

    ^ aVisitor visitFullSpec:self
! !

!FullSpec class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libui/FullSpec.st,v 1.52 2018-06-25 12:44:02 cg Exp $'
! !

