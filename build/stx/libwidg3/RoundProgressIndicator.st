"{ Encoding: utf8 }"

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
"{ Package: 'stx:libwidg3' }"

"{ NameSpace: Smalltalk }"

ProgressIndicator subclass:#RoundProgressIndicator
	instanceVariableNames:'bWidth'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!RoundProgressIndicator class methodsFor:'documentation'!

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
    RoundProgressIndicator provides the same functionality as
    its superClass, ProgressIndicator; however, the percentage
    display is in a round fashion.

    [author:]
        Claus Gittinger
"
!

examples
"
    getting progress from a model:
                                                                        [exBegin]
      |model top p h|

      model := 0 asValue.

      top := StandardSystemView new.
      top extent:100@100.
      top label:'Progress'.
      p := RoundProgressIndicator in:top.
      p model:model.
      p level:-1.

      p origin:(0.1@0.1) corner:(0.9@0.9).
      top open.

      [
          1 to:100 do:[:val |
              (Delay forSeconds:0.05) wait.
              model value:val 
          ]
      ] fork
                                                                        [exEnd]
"
! !

!RoundProgressIndicator methodsFor:'accessing'!

borderWidth
    "get the border width"

    ^bWidth


!

borderWidth:aWidth 
    "set the border width"

    aWidth ~~ bWidth ifTrue:[
        bWidth := aWidth abs min: width//2.

        shown ifTrue:[
            self invalidate
        ]
    ]

    "Modified: / 6.6.1998 / 19:57:21 / cg"
! !

!RoundProgressIndicator methodsFor:'drawing'!

redraw
    "redraw the percentage arc and optional percentage string"

    |circleMargin arcWidth arcHeight angle|

    circleMargin:= margin + bWidth .

    arcWidth  := width  - (2*circleMargin) - 1.
    arcHeight := height - (2*circleMargin) - 1.

    angle := (360 * percentage / 100) rounded.
    self clear.

    self paint:bgColor. 
    self fillArcX: circleMargin y: circleMargin width: arcWidth height: arcHeight from:90         angle:360-angle.
    self paint:fgColor.
    self fillArcX: circleMargin y: circleMargin width: arcWidth height: arcHeight from:450-angle angle:angle.

    bWidth ~~ 1 ifTrue: [self lineWidth: bWidth].
    self paint:self blackColor.
    bWidth ~~ 0 
    ifTrue: 
    [       
        circleMargin := circleMargin - (bWidth//2).
        arcWidth  := width  - (2*circleMargin) - 1.
        arcHeight := height - (2*circleMargin) - 1.
        self displayArcX: circleMargin y: circleMargin width: arcWidth height: arcHeight from: 0 angle: 360
    ].    

    showPercentage ifTrue:[
        |s x y font|
        s := percentage printString , ' %'.

        font := gc font.
        x := (width - (font widthOf:s)) // 2. 
        y := (height + (font height//2)) // 2.
        self paint:self whiteColor.
        self displayString:s x:x+1 y:y+1.
        self paint:self blackColor.
        self displayString:s x:x y:y.
    ].
    self lineWidth: 1.

    "Modified: / 18.4.1998 / 14:35:16 / cg"
! !

!RoundProgressIndicator methodsFor:'initialization'!

initialize

    super initialize.

    bWidth := 0
! !

!RoundProgressIndicator class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/RoundProgressIndicator.st,v 1.7 2016-07-20 09:35:59 stefan Exp $'
! !

