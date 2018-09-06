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
"{ Package: 'stx:libview2' }"

"{ NameSpace: Smalltalk }"

View subclass:#ActiveHelpView
	instanceVariableNames:'myView shapeStyle controllingHelpListener'
	classVariableNames:''
	poolDictionaries:''
	category:'Interface-Help'
!

!ActiveHelpView class methodsFor:'documentation'!

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
    a bubbleHelp view.

    Instances of myself show up either as a comics-like talking
    view, or as a simple square popup. This is configured via the
    styleSheet; the default is simple-square. 
    To get the fancy comics style, add a resource 'activeHelpStyle' with 
    a symbol-value of #cartoon.
    However, be aware that some servers have performance problems with
    these view-shapes (or do not support shapes at all).
    Therefore, the default style is a rectangular popupView.

    [author:]
        Claus Gittinger

    [See also:]
        ActiveHelp
"
! !

!ActiveHelpView class methodsFor:'instance creation'!

for:someText
    "create a bubble-view for some text"

    ^ self for:someText onDevice:Screen current.

    "
     |v|

     v := (ActiveHelpView for:'hello world\this is an ActiveHelpView' withCRs) shapeStyle:nil.
     v realize.
     Delay waitForSeconds:2.
     v destroy
    "

    "
     |v|

     v := (ActiveHelpView for:'hello world\this is an ActiveHelpView' withCRs) shapeStyle:#cartoon.
     v realize.
     Delay waitForSeconds:2.
     v destroy
    "

    "Modified: 28.6.1997 / 14:24:23 / cg"
!

for:someText onDevice:aDevice
    "create a bubble-view for some text"

    |helpView textView textShown|

    helpView := self onDevice:aDevice.
    someText isString ifFalse:[
        textView := Label onDevice:aDevice.
        textView logo:someText. 
        ^ (helpView withView:textView)
    ].
    
    ((someText startsWith:'<HTML>') or:[ someText startsWith:'<html>' ]) ifTrue:[
        textView := HTMLView onDevice:aDevice.
        textView level:0.
        textView extent:(600@400).
        textView contents:someText.
        textView preferredExtent:(textView extentOfContents + 20 min:(Display extent * 2 // 3)).
        textView extent:(textView extentOfContents + 20 min:(Display extent * 2 // 3)).
        textView contents:someText.
        ^ helpView withView:textView 
    ].
    
    textShown := someText.
    (textShown isString) ifTrue:[
        textShown := textShown withoutTrailingSeparators.
    ].    
    textView := Label onDevice:aDevice.
    textView font:(helpView deviceFont). 
    ^ (helpView withView:textView) contents:textShown

    "
     |v|

     v := (ActiveHelpView for:'hello world\this is an ActiveHelpView' withCRs) shapeStyle:nil.
     v realize.
     Delay waitForSeconds:2.
     v destroy
    "

    "
     |v|

     v := (ActiveHelpView for:'hello world\this is an ActiveHelpView' withCRs) shapeStyle:#cartoon.
     v realize.
     Delay waitForSeconds:2.
     v destroy
    "

    "Modified: 28.6.1997 / 14:24:23 / cg"
!

with:aView
    "create a talking-view wrapping some other view"

    ^ self new withView:aView

    "
     (ActiveHelpView with:(TextView new)) realize
     (ActiveHelpView with:(TextView new)) open
     (ActiveHelpView with:(Button label:'ok')) open
    "

    "Modified: 27.4.1996 / 15:14:18 / cg"
! !

!ActiveHelpView methodsFor:'accessing'!

contents:someText
    "set the text"

    (myView isKindOf:Label) ifTrue:[
        myView label:someText asString.
        myView extent:(myView preferredExtent).
    ] ifFalse:[
        myView contents:someText.
    ].
    self resizeToFit

    "Modified: 27.4.1996 / 15:14:56 / cg"
!

controllingHelpListener:something
    controllingHelpListener := something.
!

shapeStyle:aStyleSymbol
    "set the shapeStyle.
     Currently, only nil and #cartoon are supported"

    shapeStyle := aStyleSymbol.
    Screen current supportsArbitraryShapedViews ifFalse:[
        shapeStyle := nil
    ].
    self resizeToFit.
    self computeShape.

    "Created: 29.5.1996 / 15:39:41 / cg"
    "Modified: 28.6.1997 / 14:15:22 / cg"
!

withView:aView
    "set the component view"

    |fg|

    (aView isKindOf:Label) ifTrue:[
        aView viewBackground:viewBackground.
        aView backgroundColor:viewBackground.
        (fg := styleSheet colorAt:#'activeHelp.foregroundColor' default:nil) notNil ifTrue:[
            aView foregroundColor:fg.    
        ].
    ] ifFalse:[
        (aView isKindOf:HTMLView) ifTrue:[
            aView scrolledView 
                viewBackground:viewBackground;
                backgroundColor:viewBackground.
            aView style viewBGColor:viewBackground.
            "/ Transcript showCR:aView scrolledView preferredExtent.
        ].
    ].
    self addSubView:aView.
    myView := aView.
    myView borderWidth:0

    "Modified: 27.4.1996 / 15:16:46 / cg"
! !

!ActiveHelpView methodsFor:'event handling'!

keyPress:key x:x y:y
    controllingHelpListener hideHelp
! !

!ActiveHelpView methodsFor:'initialization'!

initStyle
    "setup viewStyle specifics"

    <resource: #style (#'activeHelp.backgroundColor'
                       #'activeHelp.borderWidth'
                       #'activeHelp.borderColor'
                       #'activeHelp.font'
                       #'activeHelp.style')>

    |bg defaultFont|

    super initStyle.

    (shapeStyle := UserPreferences current toolTipShapeStyle) isNil ifTrue:[
        shapeStyle := styleSheet at:#'activeHelp.style' default:nil.
    ].

    defaultFont := self class defaultFont.
    defaultFont isNil ifTrue:[
        defaultFont := styleSheet fontAt:#'activeHelp.font' default:nil.
    ].
    defaultFont notNil ifTrue:[
        self font:defaultFont
    ].

    bg := styleSheet colorAt:#'activeHelp.backgroundColor' default:nil.
    bg notNil ifTrue:[
        viewBackground := bg
    ] ifFalse:[
        shapeStyle == #cartoon ifTrue:[
            viewBackground := self whiteColor.
        ]
    ].
    self borderWidth:(styleSheet at:#'activeHelp.borderWidth' default:1).
    self borderColor:(styleSheet at:#'activeHelp.borderColor' default:self blackColor).

    "Modified: / 26.10.1997 / 17:02:09 / cg"
!

realize
    self create.
    self computeShape.
    self enableMotionEvents.
    self enableButtonMotionEvents.
    super realize
! !

!ActiveHelpView methodsFor:'private'!

computeShape
    "compute the shape, based upon the size of my component view"

    |extent oldOrigin shapeForm borderForm y1 bw h w mirrorH mirrorV
     p1 p2 p3 pB1 pB2 pB3 offs hEll h2 w2 w8 w78 mousePosition graphicsDevice|

    (shapeStyle == #cartoon) ifFalse:[
        ^ self.
    ].
    graphicsDevice := device.
    graphicsDevice supportsArbitraryShapedViews ifTrue:[
        extent := self extent.
        oldOrigin := self origin.
        h := extent y.
        w := extent x.
        bw := 4.
        offs := 0.
        mousePosition := graphicsDevice pointerPosition.

        ((mousePosition > (graphicsDevice width * (2/3)))
        or:[ self corner x > graphicsDevice usableWidth ]) ifTrue:[
            mirrorH := true.
            self origin:((oldOrigin x - w) @ (self origin y)).
            offs := bw * 2.
        ] ifFalse:[
            mirrorH := false
        ].
        ((mousePosition > (graphicsDevice height * (2/3)))
        or:[ self corner y > graphicsDevice usableHeight ]) ifTrue:[
            mirrorV := true.
            self origin:(oldOrigin x @ (self origin y - h)).
        ] ifFalse:[
            mirrorV := false
        ].

        borderForm := Form width:w height:h.
        shapeForm := Form width:w height:h.
        borderForm fill:(Color noColor).
        shapeForm fill:(Color noColor).

        hEll := (h // 3 * 2).

        mirrorV ifTrue:[
            y1 := 0.
        ] ifFalse:[
            y1 := h // 4.
        ].

        borderForm fillArcX:0 y:y1 
                   width:w height:hEll
                   from:0 angle:360.

        myView origin:(width - myView width // 2) @ (y1 + ((hEll - myView height) // 2)).

        h2 := h // 2.
        w2 := w // 2.
        w8 := w // 8.
        w78 := w * 7 // 8.

        mirrorH ifTrue:[
            mirrorV ifTrue:[
                p1 := w @ h. 
                p2 := (w78 @ h2).
                p3 := (w2 @ h2).
                pB1 := (w-bw) @ (h-bw). 
                pB2 := ((w78 - bw) @ (h2 - bw)).
                pB3 := ((w2 + bw) @ (h2 - bw))
            ] ifFalse:[
                p1 := w @ 0. 
                p2 := (w78 @ h2).
                p3 := (w2 @ h2).
                pB1 := (w-bw) @ bw. 
                pB2 := ((w78 - bw) @ (h2 + bw)).
                pB3 := ((w2 + bw) @ (h2 + bw))
            ]
        ] ifFalse:[
            mirrorV ifTrue:[
                p1 := 0@h. 
                p2 := (w8 @ h2). 
                p3 := (w2 @ h2).
                pB1 := bw@(h-bw). 
                pB2 := ((w8 + bw) @ (h2 - bw)). 
                pB3 := ((w2 - bw) @ (h2 - bw)).
            ] ifFalse:[
                p1 := 0@0. 
                p2 := (w8 @ h2). 
                p3 := (w2 @ h2).
                pB1 := bw@bw. 
                pB2 := ((w8 + bw) @ (h2 + bw)). 
                pB3 := ((w2 - bw) @ (h2 + bw)).
            ]
        ].

        borderForm fillPolygon:(Array with:p1 with:p2 with:p3).
        shapeForm fillPolygon:(Array with:pB1 with:pB2 with:pB3).

        shapeForm lineWidth:bw.
        shapeForm paint:(Color noColor).
        shapeForm displayPolygon:(Array with:p3 with:p1 with:p2).

        shapeForm paint:(Color colorId:1).
        shapeForm fillArcX:bw y:y1 + bw 
                  width:(w - (bw * 2)) height:(h // 3 * 2 - (bw * 2))
                  from:0 angle:360.
    ].
    borderForm notNil ifTrue:[
        self borderShape:borderForm.
        self viewShape:shapeForm
    ].

    "Modified: / 5.6.1999 / 21:41:01 / cg"
    "Modified: / 27.10.1999 / 13:45:45 / stefan"
!

resizeToFit
    "resize myself to make the component view fit"

    |h w pref bw|

    pref := myView preferredExtent.
    shapeStyle == #cartoon ifTrue:[
        h := pref y. 
        w := pref x. 
        self extent:((w / 0.85) @ (h * 4)) rounded.
    ] ifFalse:[
        bw := self borderWidth.
        self extent:(pref + (bw * 2)).
        myView origin:(bw asPoint).
    ]

    "Modified: 28.6.1997 / 14:23:49 / cg"
! !

!ActiveHelpView methodsFor:'queries'!

isPopUpView
    "return true - I am a popUp type of view (no decoration, pop-to-top)"

    ^ true

    "Modified: 12.5.1996 / 21:58:12 / cg"
!

wantsFocusWithButtonPress
    ^ false
! !

!ActiveHelpView class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !

