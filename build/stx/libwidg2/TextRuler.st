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

Ruler subclass:#TextRuler
	instanceVariableNames:'leftMargin rightMargin spec moving settingTab'
	classVariableNames:'LeftAlignForm RightAlignForm AlignForm CenterForm LeftMarginForm
		RightMarginForm LeftTabForm RightTabForm CenterTabForm
		DecimalTabForm'
	poolDictionaries:''
	category:'Views-Interactors'
!

!TextRuler class methodsFor:'documentation'!

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
    This is a special ruler built for text processing
    applications. Currently, it is not used in the system.
    It will allow setting of margins, tabs and text-layout.

    The implementation is not yet finished - take it as example
    goody ...

    TextRuler new open
"
! !

!TextRuler class methodsFor:'defaults'!

alignForm
    "return the form displayed in the align-button"

    AlignForm isNil ifTrue:[
	AlignForm := Image fromFile:'bitmaps/align.xbm' resolution:100
    ].
    ^ AlignForm
!

centerForm
    "return the form displayed in the center-button"

    CenterForm isNil ifTrue:[
	CenterForm := Image fromFile:'bitmaps/center.xbm' resolution:100
    ].
    ^ CenterForm
!

centerTabForm
    "return the form displayed in the centerTab-button"

    CenterTabForm isNil ifTrue:[
	CenterTabForm := Image fromFile:'bitmaps/centerTab.xbm' resolution:100
    ].
    ^ CenterTabForm
!

decimalTabForm
    "return the form displayed in the decimalTab-button"

    DecimalTabForm isNil ifTrue:[
	DecimalTabForm := Image fromFile:'bitmaps/decimalTab.xbm' resolution:100
    ].
    ^ DecimalTabForm
!

leftAlignForm
    "return the form displayed in the leftAlign-button"

    LeftAlignForm isNil ifTrue:[
	LeftAlignForm := Image fromFile:'bitmaps/leftAlign.xbm' resolution:100
    ].
    ^ LeftAlignForm
!

leftMarginForm
    "return the form displayed for the left margin marker"

    LeftMarginForm isNil ifTrue:[
	LeftMarginForm := Image fromFile:'bitmaps/leftMargin.xbm' resolution:100
    ].
    ^ LeftMarginForm
!

leftTabForm
    "return the form displayed in the leftTab-button"

    LeftTabForm isNil ifTrue:[
	LeftTabForm := Image fromFile:'bitmaps/leftTab.xbm' resolution:100
    ].
    ^ LeftTabForm
!

rightAlignForm
    "return the form displayed in the rightAlign-button"

    RightAlignForm isNil ifTrue:[
	RightAlignForm :=  Image fromFile:'bitmaps/rightAlign.xbm' resolution:100
    ].
    ^ RightAlignForm
!

rightMarginForm
    "return the form displayed for the right margin marker"

    RightMarginForm isNil ifTrue:[
	RightMarginForm := Image fromFile:'bitmaps/rightMarg.xbm' resolution:100
    ].
    ^ RightMarginForm
!

rightTabForm
    "return the form displayed in the rightTab-button"

    RightTabForm isNil ifTrue:[
	RightTabForm := Image fromFile:'bitmaps/rightTab.xbm' resolution:100
    ].
    ^ RightTabForm
! !

!TextRuler methodsFor:'accessing'!

paragraphSpecification:aSpec
    spec := aSpec
! !

!TextRuler methodsFor:'initializing'!

initialize
    |leftAlignToggle alignToggle centerToggle rightAlignToggle
     leftTabButton centerTabButton rightTabButton decimalTabButton
     lineSpacingField panel1 panel3 scaleHeight h group|

    super initialize.

    scaleHeight := (font height) * 2.
    self height:(scaleHeight * 3).

    h := self class leftAlignForm height.
    panel1 := HorizontalPanelView
			origin:(0.0 @ 0.0)
			extent:[(width // 3 * 2) @ (h*2)]
			    in:self.
    panel1 borderWidth:0.
    panel1 layout:#leftSpace.

    panel3 := HorizontalPanelView
			origin:[(width // 3 * 2) @ margin]
			extent:[((width // 3)-margin) @ (h*2) "(height - scaleHeight)"]
			    in:self.
    panel3 borderWidth:0.
    panel3 layout:#right.

    leftAlignToggle := RadioButton form:(self class leftAlignForm)
				 action:[self leftAlign]
				     in:panel1.
    alignToggle := RadioButton form:(self class alignForm)
			     action:[self align]
				 in:panel1.
    centerToggle := RadioButton form:(self class centerForm)
			      action:[self center]
				  in:panel1.
    rightAlignToggle := RadioButton form:(self class rightAlignForm)
				  action:[self rightAlign]
				      in:panel1.
    group := RadioButtonGroup new.
    group add:leftAlignToggle.
    group add:alignToggle.
    group add:centerToggle.
    group add:rightAlignToggle.

    "separator"
    (View in:panel1) extent:(50 @ 2); borderWidth:0; level:0.

    leftTabButton := Button form:(self class leftTabForm)
			  action:[self leftTab]
			      in:panel1.
    centerTabButton := Button form:(self class centerTabForm)
			    action:[self centerTab]
				in:panel1.
    rightTabButton := Button form:(self class rightTabForm)
			   action:[self rightTab]
			       in:panel1.
    decimalTabButton := Button form:(self class decimalTabForm)
			     action:[self decimalTab]
				 in:panel1.

"/    lineSpacingField := EditField in:panel3.


    leftMargin := 0.0.
    rightMargin := 8.5

    "TextRuler new open"
! !

!TextRuler methodsFor:'redrawing'!

clearMargin:which
    "clear margin"

    |this other otherX otherX2 x x2 top form symOther viewOrigin|

    self paint:viewBackground.

    top := height - (font height) - (font ascent).

    (which == #left) ifTrue:[
	this := leftMargin.
	other := rightMargin. symOther := #right.
	form := self class leftMarginForm
    ].
    (which == #right) ifTrue:[
	this := rightMargin.
	other := leftMargin. symOther := #left.
	form := self class rightMarginForm
    ].

    x := (self inchToPixel:this) rounded - (form width // 2).
    viewOrigin := self viewOrigin.
    self displayForm:form
		   x:x + viewOrigin x
		   y:(top - form height - viewOrigin y).

    "
     if it covers any other, redraw them
    "
    x2 := x + form width.
    otherX := (self inchToPixel:other) rounded - (form width // 2).
    otherX2 := otherX + form width.

    otherX  > x2 ifFalse:[
	otherX2 < x ifFalse:[
	    self drawMargin:symOther
	]
    ].
!

drawMargin:which
    "clear margin"

    |x top form viewOrigin|

    self paint:fgColor.

    top := height - (font height) - (font ascent).

    (which == #left) ifTrue:[
	x := (self inchToPixel:leftMargin) rounded.
	form := self class leftMarginForm
    ].
    (which == #right) ifTrue:[
	x := (self inchToPixel:rightMargin) rounded.
	form := self class rightMarginForm
    ].

    viewOrigin := self viewOrigin.
    self displayForm:form
		   x:(x - (form width // 2) - viewOrigin x)
		   y:(top - form height - viewOrigin y).

!

redraw
    "redraw margin & tab marks"

    |x top form tab type tabStops tabAlign viewOrigin orgX orgY|

    self clear.

    super redraw.

    viewOrigin := self viewOrigin.
    orgX := viewOrigin x.
    orgY := viewOrigin y.

    self paint:fgColor.

    top := height - (font height) - (font ascent).

    x := (self inchToPixel:leftMargin) rounded.
    form := self class leftMarginForm.
    self displayForm:form
		   x:(x - (form width // 2) - orgX)
		   y:(top - form height - orgY).

    x := (self inchToPixel:rightMargin) rounded.
    form := self class rightMarginForm.
    self displayForm:form
		   x:(x - (form width // 2) - orgX)
		   y:(top - form height - orgY).

    spec notNil ifTrue:[
	tabStops := spec positions.
	tabAlign := spec align.
	tabStops notNil ifTrue:[
	    1 to:tabStops size do:[:tabNr |
		tab := tabStops at:tabNr.
		type := tabAlign at:tabNr.
		x := (spec positionOfTab:tabNr on:self) rounded.
		(type == #left) ifTrue:[
		    form := self class leftTabForm
		] ifFalse:[
		    (type == #right) ifTrue:[
			form := self class rightTabForm
		    ] ifFalse:[
			(type == #center) ifTrue:[
			    form := self class centerTabForm
			] ifFalse:[
			    (type == #decimal) ifTrue:[
				form := self class decimalTabForm
			    ]
			]
		    ]
		].
		self displayForm:form
			       x:(x - (form width // 2) - orgX)
			       y:(top - form height - orgY)
	    ]
	]
    ]
! !

!TextRuler methodsFor:'user interaction'!

align
    ^ self
!

buttonMotion:state x:x y:y
    "position a tab or start moving a ruler"

    |mpos|

    moving notNil ifTrue:[
	self clearMargin:moving.
	mpos := self pixelToInch:x + self viewOrigin x.
	(mpos < 0) ifTrue:[
	    mpos := 0
	].
	(mpos > paperWidth) ifTrue:[
	    mpos := paperWidth
	].
	(moving == #left) ifTrue:[
	    leftMargin := mpos
	].
	(moving == #right) ifTrue:[
	    rightMargin := mpos
	].
	self drawMargin:moving
    ]
!

buttonPress:button x:pX y:y
    "position a tab or start moving a ruler"

    |mpos x|

    ((button == #select) or:[button == 1]) ifFalse:[
	^ super buttonPress:button x:pX y:y
    ].

    x := pX + self viewOrigin x.
    settingTab notNil ifTrue:[
	self setTabX:x.
	settingTab := nil.
	^ self
    ].

    mpos := self inchToPixel:leftMargin.
    (((mpos - 4) <= x) and:[x <= (mpos + 4)]) ifTrue:[
	"start moving left margin"
	moving := #left.
	^ self
    ].
    mpos := self inchToPixel:rightMargin.
    (((mpos - 4) <= x) and:[x <= (mpos + 4)]) ifTrue:[
	"start moving right margin"
	moving := #right.
	^ self
    ].

    ^ self
!

buttonRelease:button x:x y:y
    "position a tab or start moving a ruler"

    moving := nil
!

center
    ^ self
!

centerTab
    settingTab := #center.
!

decimalTab
    settingTab := #decimal.

!

leftAlign
    ^ self
!

leftTab
    settingTab := #left.

!

rightAlign
    ^ self
!

rightTab
    settingTab := #right.

! !

!TextRuler class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg2/TextRuler.st,v 1.15 2006-11-13 16:11:31 cg Exp $'
! !

