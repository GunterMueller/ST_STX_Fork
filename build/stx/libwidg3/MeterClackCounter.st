"
 COPYRIGHT (c) 1998 by eXept Software AG
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

View subclass:#MeterClackCounter
	instanceVariableNames:'numberOfDigits scale bitMap bmSingleWidth space magnify
		prevString'
	classVariableNames:'DigitsBitmap DigitWidth'
	poolDictionaries:''
	category:'Views-Misc'
!

!MeterClackCounter class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1998 by eXept Software AG
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
    a simple fun-view, displaying a numeric value as a milesCounter in Cars.
    The model is a simple vlaueHolder, holding a number.
    This widget can be used as a component what ever you like to count something.

    The valueHolder always will be converted as an Array.
    The values: I only like numbers like as 0123456789 and .<- point.

    [author:]
        Timo Merkert tm@exept.de

    [see also:]
        DigitalClockView
        Label
        ValueHolder
"
!

examples
"
  displaying integers:
                                                                [exBegin]
    |top num valueHolder|

    top := StandardSystemView extent:150@33.
    num := MeterClackCounter origin:0.0@0.0 corner:1.0@1.0 in:top.
    num numberOfDigits: 6.
    num model:(valueHolder := 12345 asValue).
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 1)
        ]
    ] fork
                                                                [exEnd]


  displaying floats:
                                                                [exBegin]
    |top num valueHolder|

    top := StandardSystemView extent:200@33.
    num := MeterClackCounter origin:0.0@0.0 corner:1.0@1.0 in:top.
    num numberOfDigits:9.
    num model:(valueHolder := 12345.123 asValue).
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 1)
        ]
    ] fork
                                                                [exEnd]

  displaying fixedPoint numbers:
                                                                [exBegin]
    |top num valueHolder|

    top := StandardSystemView extent:200@33.
    num := MeterClackCounter origin:0.0@0.0 corner:1.0@30 in:top.
    num numberOfDigits:8.
    num model:(valueHolder := (12345.8 asFixedPoint:2) asValue).
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + (0.1 asFixedPoint:2))
        ]
    ] fork
                                                                [exEnd]

  displaying aSpeedy milesCounter:
  but don`t drink and drive as fast
                                                                [exBegin]
    |top num valueHolder|

    top := StandardSystemView extent:500@300.
    num := MeterClackCounter origin:0.0@0.0 corner:1.0@1.0 in:top.
    num numberOfDigits: 10.
    num space:5.
    num model:(valueHolder := 0123456789 asValue).
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForMilliseconds:10.
            valueHolder value:(valueHolder value + 1)
        ]
    ] fork
                                                                [exEnd]

"
! !

!MeterClackCounter class methodsFor:'images'!

digitWidth
    "return the width of each individual digit in the digitsBitmap."

    DigitWidth isNil ifTrue:[
        self initializeDigitsBitmap
    ].
    ^ DigitWidth

    "
     self digitWidth
    "
!

digitsBitmap
    "return the image providing the digit-images."

    DigitsBitmap isNil ifTrue:[
        self initializeDigitsBitmap
    ].
    ^ DigitsBitmap

    "
     self digitsBitmap
    "
!

initializeDigitsBitmap
    "read the image providing the digit-images and set the class variable DigitsBitmap.
     Also set digitWidth, the width of each individual digit.
     Somewhat of a kludge, as things are hardcoded here"

    DigitsBitmap := ToolbarIconLibrary meterBitmaps.

"/      DigitWidth := (bitMap width / 11)rounded.
    DigitWidth := 20.

    "
     self initializeDigitsBitmap
    "
! !

!MeterClackCounter methodsFor:'accessing'!

magnify
    "return the value of the instance variable 'magnify' (automatically generated)"

    ^ magnify 
!

magnify:aPoint
    "set the value of the instance variable 'magnify' (automatically generated)"

    magnify := aPoint copy

!

numberOfDigits:n
    "specify the number of digits to display"

    numberOfDigits := n

    "Created: / 23.10.1997 / 21:10:10 / cg"
    "Modified: / 16.6.1998 / 10:31:40 / cg"
!

numberScale:n
    "define the number of post-decimal-point digits"

    scale := n

    "Modified: / 25.10.1997 / 17:12:59 / cg"
    "Created: / 5.12.1997 / 02:03:40 / cg"
!

space:something
    "set the value of the instance variable 'space' (automatically generated)"
    "space will be the different between numbers"

    space := something.
! !

!MeterClackCounter methodsFor:'accessing-color & font'!

backgroundColor:aColor
    viewBackground := aColor.
    self invalidate.

    "Modified: / 11.2.2000 / 01:52:51 / cg"
! !

!MeterClackCounter methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "redraw myself, when the model changes"

    changedObject == model ifTrue:[
        self invalidate.
        ^ self
    ].
    ^ super update:something with:aParameter from:changedObject

    "Created: / 23.10.1997 / 19:15:14 / cg"
    "Modified: / 16.6.1998 / 10:13:08 / cg"
! !

!MeterClackCounter methodsFor:'drawing'!

clearDigitsPos:pos n:anzahl
    "clear number of n digits at position pos in View"

    |x y w h nPos|

    "pos starts at 1"
    nPos := pos - 1.
    h := bitMap height.
    y := space.
    x := space + (pos * (bmSingleWidth + space)).
    w := anzahl * (bmSingleWidth + space).

    self paint:viewBackground.
    self fillRectangleX:x  y:y width:w height:h.
!

drawCounter
    "draw my view"
    |str val xdest|

    shown ifFalse:[^ self].

    val := model value.
    val isNil ifTrue:[
        "/ Transcript showCR:'model is nil or out of range'.
        str := String new:numberOfDigits withAll:(Character space).
    ] ifFalse:[
        str := val printString.
        str size > numberOfDigits ifTrue:[
            "/ Transcript showCR:'model size is out of range'.
            str := String new:numberOfDigits withAll:$-.
        ] ifFalse:[
            str := self getFullString:str.
        ].
    ].

    prevString = str ifTrue:[
        "/ no change
        ^ self
    ].

"/    xdest := space.
"/    str keysAndValuesDo:[:idx :char|
"/        "/ only draw changed digits.
"/        (prevString size < idx
"/        or:[(prevString at:idx) ~~ char]) ifTrue:[
"/            self drawDigit:12 atPos:xdest.
"/        ].
"/        xdest := xdest + bmSingleWidth + space
"/    ].
"/    Delay waitForSeconds:0.1.

    xdest := space.
    str keysAndValuesDo:[:idx :char|
        |x|

        "/ only draw changed digits.
        (prevString size < idx
        or:[(prevString at:idx) ~~ char]) ifTrue:[
            (char between:$0 and:$9) ifTrue:[
                x := char digitValue.
            ] ifFalse:[
                char = $. ifTrue:[      " . "
                    x := 10.
                ] ifFalse:[
                    char = $- ifTrue:[  " - "
                        x := 11.
                    ] ifFalse:[
                        x := 12
                    ]
                ]
            ].
            self drawDigit:x atPos:xdest.
        ].
        xdest := xdest + bmSingleWidth +space
    ].

    prevString := str.

    "Modified (comment): / 07-06-2017 / 18:15:04 / mawalch"
!

drawDigit:aDigitIndex atPos:pos 
    "aDigitIndex is DigitNumber from 0 to 9 or 10=>'.', 11=>'-' or 12=>space"
    "pos is position from 1 to numberOfDigits"
    
    |bmPos|

    bitMap isNil ifTrue:[
        ^ self
    ].
    bmPos := aDigitIndex * bmSingleWidth.
    (aDigitIndex between:0 and:12) ifFalse:[
        Transcript
            show:'MeterClackCounter [warning]: drawDigit -> aDigit ';
            show:aDigitIndex printString;
            showCR:' is not in bitmap'.
    ] ifTrue:[
        (pos between:0 and:((20 + space) * numberOfDigits)) ifFalse:[
            Transcript
                show:'MeterClackCounter [warning]: drawDigit -> ';
                show:pos printString;
                showCR:'is out of Range'
        ] ifTrue:[
            "draw aDigit"
            self 
                copyFrom:bitMap
                x:bmPos
                y:0
                toX:pos
                y:space
                width:bmSingleWidth
                height:(bitMap height).
            
"/                    Transcript show:'Size is ';show:bmSingleWidth;show:' @ ';showCR:(bitMap height);
"/                        show:bmPos;show:' @ ';show:0;show:' -> ';show:bmSingleWidth;show:' @ ';showCR:(bitMap height);
"/                        show:pos;show:' @ ';show:space;show:' -> ';show:bmSingleWidth;show:' @ ';showCR:(bitMap height);showCR:' '.
        ].
    ].
!

redraw
    "update my view"

    shown ifTrue:[
        self clear.
        prevString := nil.
        self drawCounter.
    ]
!

redrawCounter
    "update my view"

    self clear.
    prevString := nil.
    self drawCounter.
! !

!MeterClackCounter methodsFor:'events'!

sizeChanged:how
"/    super sizeChanged:how.

    magnify notNil ifTrue:[
        self initBitmap.
    ].
    prevString := nil.
    self invalidate

    "Created: / 16.6.1998 / 10:30:38 / cg"
    "Modified: / 11.2.2000 / 01:54:18 / cg"
! !

!MeterClackCounter methodsFor:'initialization'!

initBitmap
    bitMap := self class digitsBitmap.
    bmSingleWidth := self class digitWidth.

    magnify notNil ifTrue:[
        bmSingleWidth := (bitMap width / bmSingleWidth) * magnify x.
        bitMap := bitMap magnifiedTo:(magnify x)@(magnify y).
    ].
!

initialize
    super initialize.

    self maxExtent:preferredExtent.
    self minExtent:preferredExtent.

    viewBackground := (Color green)darkened.

    numberOfDigits isNil ifTrue:[numberOfDigits := 4].
    space := 3.

    self initBitmap.
! !

!MeterClackCounter methodsFor:'private'!

getFullString:str
    "returns the string with leading zeros"

    ^ str leftPaddedTo:numberOfDigits with:$0
!

getNilArray:str
    |size|
    size := numberOfDigits.
    ^ Array new:size withAll:0
!

getNilString:str
    |size|
    size := numberOfDigits.
    ^ String new:size withAll:$0
! !

!MeterClackCounter methodsFor:'queries'!

preferredExtent
    |w h bm|

    preferredExtent notNil ifTrue:[
        ^ preferredExtent
    ].
    (bm := bitMap) isNil ifTrue:[
        w := gc font widthOf:'0'.
        h := gc font height.
    ] ifFalse:[
        w := bitMap width + space.
        h := bitMap height + (2* space).
    ].

    ^ (w * numberOfDigits + space) @ h

    "Created: / 23.10.1997 / 19:09:32 / cg"
    "Modified: / 25.10.1997 / 17:03:20 / cg"
! !

!MeterClackCounter methodsFor:'views'!

getMeterClackCounter
    |c|
    c := MeterClackCounter new.
    ^c 
! !

!MeterClackCounter class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/MeterClackCounter.st,v 1.15 2017-11-28 18:27:00 cg Exp $'
! !

