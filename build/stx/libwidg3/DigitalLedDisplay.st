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

View subclass:#DigitalLedDisplay
	instanceVariableNames:'lastValue numberOfDigits scale bitMaps radix ledColor
		ledColorChannel'
	classVariableNames:'Bitmaps'
	poolDictionaries:''
	category:'Views-Misc'
!

!DigitalLedDisplay class methodsFor:'documentation'!

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
    a simple fun-view, displaying a numeric value as a 7-Segment LED-line.
    The model is a simple ValueHolder, holding a number.
    This widget can be used as a component in calculator-like applications.

    [author:]
        Claus Gittinger

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
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := 12345 asValue).
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 1)
        ]
    ] fork
                                                                [exEnd]


  HEX display (integers only):
                                                                [exBegin]
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds radix:16.
    leds model:(valueHolder := 12345 asValue).
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
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := 12345.123 asValue).
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
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := 12345.888 asValue).
    leds numberScale:2.
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 0.01)
        ]
    ] fork
                                                                [exEnd]

  scientific numbers:
                                                                [exBegin]
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := -3.1415e15 asValue).
    leds numberOfDigits:12.
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 10000)
        ]
    ] fork
                                                                [exEnd]

   number too big:
                                                                [exBegin]
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := 9995 asValue).
    leds numberScale:2.
    leds numberOfDigits:4.
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 1)
        ]
    ] fork
                                                                [exEnd]

   changing the color (above 100):
                                                                [exBegin]
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := 95 asValue).
    leds numberScale:2.
    leds numberOfDigits:4.
    leds foregroundColor:Color green.
    top openAndWait.

    [
        [top realized] whileTrue:[
            Delay waitForSeconds:1.
            valueHolder value:(valueHolder value + 1).
            valueHolder value >= 100 ifTrue:[
                leds foregroundColor:Color red.
            ]
        ]
    ] fork
                                                                [exEnd]

  displaying strings:
                                                                [exBegin]
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := Time now printString asValue).
    top openAndWait.
                                                                [exEnd]

  displaying strings:
                                                                [exBegin]
    |top leds valueHolder|

    top := StandardSystemView extent:200@200.
    leds := DigitalLedDisplay origin:0.0@0.0 corner:1.0@30 in:top.
    leds model:(valueHolder := 12345 asValue).
    top openAndWait.

    [
        [:exit |
            #('AAAAA'
              'bbbbb'
              'CCCCC'
              'ddddd'
              'EEEEE'
              'FFFFF'
              'uuuuu'
              'PPPPP'
              'rrrrr'
              'ooooo'
            ) do:[:s |
                top realized ifFalse:[exit value:nil].
                valueHolder value:s.
                Delay waitForSeconds:1.
            ]
        ] loopWithExit.
    ] fork
                                                                [exEnd]

"
! !

!DigitalLedDisplay class methodsFor:'initialization'!

bitmaps
    Bitmaps isNil ifTrue:[
        Bitmaps := Dictionary new.
        Bitmaps 
            at:Character space put:(self initBitmap:#ledOff);
            at:$. put:(self initBitmap:#ledPeriod);
            at:$: put:(self initBitmap:#ledCol);
            at:$- put:(self initBitmap:#ledMinus).

        'AbCdEFrou0123456789' do:[:eachChar |
            Bitmaps at:eachChar put:(self initBitmap:('led' , eachChar) asSymbol)
        ].
    ].

    ^ Bitmaps
!

initBitmap:symbol
    ^ self perform:symbol.
! !

!DigitalLedDisplay class methodsFor:'image specs'!

led0
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led0 inspect
     ImageEditor openOnClass:self andSelector:#led0
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led0'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@H@@@HB@@HB@ HB@@HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB
@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@@@@@@@@@@HB@@@B@@@A@@D@@P@@@ @@@@@A@@D@@P@A@@@@@@H@@@D@@P@A@@@B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @B@ HB@ @B@ @@@ @B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led1
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led1 inspect
     ImageEditor openOnClass:self andSelector:#led1
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led1'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@H@@@@A@@@A@@D@@@HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB
@@@@@P@@@@@@@@HB@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@@HB@@@A@@@A@@D@@P@@@ @@@@@A@@D@@P@A@@@@@@D@@@D@@P@A@@@B@@@@@P@@@@@@@@@B
@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@ HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB@@@@@P@@@P@A@@@B@ @@@P@@@P@A@@D@
@@H@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led2
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led2 inspect
     ImageEditor openOnClass:self andSelector:#led2
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led2'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@P@B@ HB@ HB@@H@@@@A@@HB@ HB@@HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB
@@@@@P@@@@@@@@HB@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@@HB@@@A@@HB@ HB@ H@@ @@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @A@@@B@ @@@@@@@@@A
@@@@@ HB@@@@@@@A@@D@@@HB@ @@@@@@@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A@@@B@ @B@ HB@ @A@@@@@ @B@ HB@ HB
@@D@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led3
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led3 inspect
     ImageEditor openOnClass:self andSelector:#led3
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led3'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@P@B@ HB@ HB@@H@@@@A@@HB@ HB@@HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB
@@@@@P@@@@@@@@HB@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@@HB@@@A@@HB@ HB@ H@@ @@@@HB@ HB@ HB@ @@@@D@@ HB@ HB@ @B@@@@@P@@@@@@@@@B
@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@ HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB@@@@@P@B@ HB@ @B@ @@@P@B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led4
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led4 inspect
     ImageEditor openOnClass:self andSelector:#led4
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led4'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@ @@@P@A@@D@@@H@@@HB@@@A@@D@@@HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB
@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@@@@@@@@@@HB@@@B@@HB@ HB@ H@@ @@@@HB@ HB@ HB@ @@@@D@@ HB@ HB@ @B@@@@@P@@@@@@@@@B
@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@ HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB@@@@@P@@@P@A@@@B@ @@@P@@@P@A@@D@
@@H@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led5
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led5 inspect
     ImageEditor openOnClass:self andSelector:#led5
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led5'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@D@@@HB@@HB@ HB@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A
@@@B@ H@@@@@@@@A@@@@@ HB@@@@@@@A@@D@@@HB@@@@@@@@@@D@@@@B@@HB@ HB@ H@@P@@@@HB@ HB@ HB@ @@@@D@@ HB@ HB@ @B@@@@@P@@@@@@@@@B
@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@ HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB@@@@@P@B@ HB@ @B@ @@@P@B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led6
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led6 inspect
     ImageEditor openOnClass:self andSelector:#led6
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led6'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@D@@@HB@@HB@ HB@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A
@@@B@ H@@@@@@@@A@@@@@ HB@@@@@@@A@@D@@@HB@@@@@@@@@@D@@@@B@@HB@ HB@ H@@P@@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @B@ HB@ @B@ @@@ @B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led7
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led7 inspect
     ImageEditor openOnClass:self andSelector:#led7
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led7'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@P@B@ HB@ HB@@H@@@@A@@HB@ HB@@HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB
@@@@@P@@@@@@@@HB@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@@HB@@@A@@@A@@D@@P@@@ @@@@@A@@D@@P@A@@@@@@D@@@D@@P@A@@@B@@@@@P@@@@@@@@@B
@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@ HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB@@@@@P@@@P@A@@@B@ @@@P@@@P@A@@D@
@@H@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

led8
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led8 inspect
     ImageEditor openOnClass:self andSelector:#led8
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led8'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@PDA@PDA@PDA@@@@@P@A@PDA@PDA@@D@@@DA@@DA@PDA@@DA@@@A@PD@@@@@@@DA@P@@@PDA@@@@@@@A@PD@@@DA@P@@@@@@@PDA
@@@A@PD@@@@@@@DA@P@@@PDA@@@@@@@A@PD@@@DA@@@@@@@@@@DA@@@A@@DA@PDA@PD@@P@@@@DA@PDA@PDA@P@@@@D@@PDA@PDA@P@A@@@A@P@@@@@@@@@A
@P@@@PDA@@@@@@@A@PD@@@DA@P@@@@@@@PDA@@@A@PD@@@@@@@DA@P@@@PDA@@@@@@@A@PD@@@DA@P@@@@@@@PDA@@@A@P@A@PDA@P@A@P@@@P@A@PDA@PDA
@@D@@@@A@PDA@PDA@PD@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 255 0 0]; yourself]
!

led9
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self led9 inspect
     ImageEditor openOnClass:self andSelector:#led9
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class led9'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@H@@@HB@@HB@ HB@@HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB
@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@@@@@@@@@@HB@@@B@@HB@ HB@ H@@ @@@@HB@ HB@ HB@ @@@@D@@ HB@ HB@ @B@@@@@P@@@@@@@@@B
@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@ HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB@@@@@P@B@ HB@ @B@ @@@P@B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

ledA
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledA inspect
     ImageEditor openOnClass:self andSelector:#ledA
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledA'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@H@@@HB@@HB@ HB@@HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB
@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@@@@@@@@@@HB@@@B@@HB@ HB@ H@@ @@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @@@P@A@@@B@ @@@ @@@P@A@@D@
@@H@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledC
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledC inspect
     ImageEditor openOnClass:self andSelector:#ledC
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledC'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@D@@@HB@@HB@ HB@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A
@@@B@ H@@@@@@@@A@@@@@ HB@@@@@@@A@@D@@@HB@@@@@@@@@@D@@@@B@@@A@@D@@P@@@P@@@@@A@@D@@P@A@@@@@@H@@@D@@P@A@@@A@@@B@ @@@@@@@@@A
@@@@@ HB@@@@@@@A@@D@@@HB@ @@@@@@@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A@@@B@ @B@ HB@ @A@@@@@ @B@ HB@ HB
@@D@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledCol
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledCol inspect
     ImageEditor openOnClass:self andSelector:#ledCol
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledCol'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@B@@@@@P@@@@D@@P@B@ H@@P@A
@@@@@P@@@ HB@@@A@@@@@P@A@@@B@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@@A@@D@@P@@@P@@@@@A@@D@@P@A@@@@@@D@@@D@@P@A@@@A@@@@@P@@@@@@@@@A
@@@@@P@A@@@B@@@A@@D@@@@A@@@B@ H@@@D@@@@A@@D@@ HB@@D@@P@@@@D@@@@B@@@@@P@@@@D@@P@@@@@@@P@A@@@@@P@@@P@A@@@A@@@@@P@@@P@A@@D@
@@D@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

ledE
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledE inspect
     ImageEditor openOnClass:self andSelector:#ledE
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledE'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@D@@@HB@@HB@ HB@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A
@@@B@ H@@@@@@@@A@@@@@ HB@@@@@@@A@@D@@@HB@@@@@@@@@@D@@@@B@@HB@ HB@ H@@P@@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @A@@@B@ @@@@@@@@@A
@@@@@ HB@@@@@@@A@@D@@@HB@ @@@@@@@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A@@@B@ @B@ HB@ @A@@@@@ @B@ HB@ HB
@@D@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledF
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledF inspect
     ImageEditor openOnClass:self andSelector:#ledF
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledF'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@ HB@ HB@ HB@@@@@ @B@ HB@ HB@@D@@@HB@@HB@ HB@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A
@@@B@ H@@@@@@@@A@@@@@ HB@@@@@@@A@@D@@@HB@@@@@@@@@@D@@@@B@@HB@ HB@ H@@P@@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @A@@@B@ @@@@@@@@@A
@@@@@ HB@@@@@@@A@@D@@@HB@ @@@@@@@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A@@@B@ @@@P@A@@@A@@@@@ @@@P@A@@D@
@@D@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledMinus
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledMinus inspect
     ImageEditor openOnClass:self andSelector:#ledMinus
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledMinus'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A
@@@@@P@@@@@@@@@A@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@HB@ HB@ H@@P@@@@HB@ HB@ HB@ @@@@D@@ HB@ HB@ @A@@@@@P@@@@@@@@@A
@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A@@@@@P@@@P@A@@@A@@@@@P@@@P@A@@D@
@@D@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledOff
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledOff inspect
     ImageEditor openOnClass:self andSelector:#ledOff
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledOff'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A
@@@@@P@@@@@@@@@A@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@@A@@D@@P@@@P@@@@@A@@D@@P@A@@@@@@D@@@D@@P@A@@@A@@@@@P@@@@@@@@@A
@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A@@@@@P@@@P@A@@@A@@@@@P@@@P@A@@D@
@@D@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0]; yourself]
!

ledPeriod
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledPeriod inspect
     ImageEditor openOnClass:self andSelector:#ledPeriod
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledPeriod'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A
@@@@@P@@@@@@@@@A@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@@A@@D@@P@@@P@@@@@A@@D@@P@A@@@@@@D@@@D@@P@A@@@A@@@@@P@@@@@@@@@A
@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A@@@@@P@@@PHA@@@A@@@@@P@@@PHB@ D@
@@D@@@@@@P@A@ D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

ledb
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledb inspect
     ImageEditor openOnClass:self andSelector:#ledb
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledb'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@ @@@P@A@@D@@@D@@@HB@@@A@@D@@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A
@@@B@ H@@@@@@@@A@@@@@ HB@@@@@@@A@@D@@@HB@@@@@@@@@@D@@@@B@@HB@ HB@ H@@P@@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @B@ HB@ @B@ @@@ @B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 128 0 0 255 0 0]; yourself]
!

ledd
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledd inspect
     ImageEditor openOnClass:self andSelector:#ledd
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledd'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@H@@@@A@@@A@@D@@@HB@@@A@@D@@@@@@@HB@ @@@@D@@@@@@@@B@ H@@@D@@P@@@@@@@ HB
@@@@@P@@@@@@@@HB@ @@@P@A@@@@@@@B@ H@@@@A@@@@@@@@@@HB@@@@@@HB@ HB@ H@@ @@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @B@ HB@ @B@ @@@ @B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledo
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledo inspect
     ImageEditor openOnClass:self andSelector:#ledo
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledo'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A
@@@@@P@@@@@@@@@A@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@@@@HB@ HB@ H@@@@@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @B@ HB@ @B@ @@@ @B@ HB@ HB
@@H@@@@B@ HB@ HB@ H@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledr
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledr inspect
     ImageEditor openOnClass:self andSelector:#ledr
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledr'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A
@@@@@P@@@@@@@@@A@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@@@@HB@ HB@ H@@@@@@@HB@ HB@ HB@ @@@@H@@ HB@ HB@ @A@@@B@ @@@@@@@@@A
@@@@@ HB@@@@@@@A@@D@@@HB@ @@@@@@@@D@@@@B@ H@@@@@@@D@@P@@@ HB@@@@@@@@@P@@@@HB@ @@@@@@@P@A@@@B@ @@@P@A@@@A@@@@@ @@@P@A@@D@
@@D@@@@@@P@A@@D@@P@@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
!

ledu
    "This resource specification was automatically generated
     by the ImageEditor of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the ImageEditor may not be able to read the specification."

    "
     self ledu inspect
     ImageEditor openOnClass:self andSelector:#ledu
     Icon flushCachedIcons
    "

    <resource: #image>

    ^Icon
        constantNamed:'DigitalLedDisplay class ledu'
        ifAbsentPut:[(Depth8Image new) width: 13; height: 23; photometric:(#palette); bitsPerSample:(#(8)); samplesPerPixel:(1); bits:(ByteArray fromPackedString:'
@@@@@@@@@@@@@@@@@@@@@@D@@P@A@@D@@@@@@P@@@P@A@@D@@@D@@@@A@@@A@@D@@@D@@@@A@@D@@@@@@@D@@P@@@@D@@@@@@@@@@P@@@@D@@P@@@@@@@P@A
@@@@@P@@@@@@@@@A@@@@@P@A@@@@@@@A@@D@@@@A@@@@@@@@@@D@@@@A@@@A@@D@@P@@@P@@@@@A@@D@@P@A@@@@@@H@@@D@@P@A@@@B@@@B@ @@@@@@@@@B
@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ H@@@@@@@HB@ @@@ HB@@@@@@@B@ H@@@HB@ @@@@@@@ HB@@@B@ @@@ HB@@@B@ @@@ @@@ HB@ H@
@@H@@@@@@ HB@ HB@ @@@@@@@@@@@@@@@@@@@@@b') ; colorMapFromArray:#[0 0 0 129 0 0 255 0 0]; yourself]
! !

!DigitalLedDisplay class methodsFor:'queries - plugin'!

aspectSelectors
    ^ #( ledColorChannel )

    "Created: / 11.2.2000 / 00:29:04 / cg"
! !

!DigitalLedDisplay methodsFor:'accessing'!

numberOfDigits
    "return the number of digits to display"

    ^ numberOfDigits
!

numberOfDigits:n
    "specify the number of digits to display"

    numberOfDigits := n

    "Created: / 23.10.1997 / 21:10:10 / cg"
    "Modified: / 16.6.1998 / 10:31:40 / cg"
!

numberScale
    "return the number of post-decimal-point digits"

    ^ scale 
!

numberScale:n
    "define the number of post-decimal-point digits"

    scale := n

    "Modified: / 25.10.1997 / 17:12:59 / cg"
    "Created: / 5.12.1997 / 02:03:40 / cg"
!

radix
    "return the number radix; for now, only 10 (default)
     or 16 are supported"

    ^ radix

    "Created: / 13.11.1997 / 17:43:35 / cg"
    "Modified: / 16.6.1998 / 10:33:03 / cg"
!

radix:something
    "set the number radix; for now, only 10 (default)
     or 16 are supported"

    radix := something.

    "Created: / 13.11.1997 / 17:43:35 / cg"
    "Modified: / 16.6.1998 / 10:32:53 / cg"
! !

!DigitalLedDisplay methodsFor:'accessing channels'!

ledColorChannel
    ledColorChannel isNil ifTrue:[
        ledColorChannel := ValueHolder new.
        ledColorChannel addDependent:self.
    ].
    ^ ledColorChannel

    "Created: / 11.2.2000 / 00:25:37 / cg"
    "Modified: / 11.2.2000 / 00:26:09 / cg"
!

ledColorChannel:aValueHolder
    ledColorChannel notNil ifTrue:[
        ledColorChannel removeDependent:self.
    ].
    ledColorChannel := aValueHolder.
    ledColorChannel notNil ifTrue:[
        ledColorChannel addDependent:self.
    ].

    "Created: / 11.2.2000 / 00:26:47 / cg"
! !

!DigitalLedDisplay methodsFor:'accessing-color & font'!

foregroundColor:aColor
    "change the led's color"

    |cmap2 cmap3 newCMap|

    aColor = ledColor ifTrue:[^ self].
    ledColor := aColor.

    cmap2 := Array 
                with:Color black
                with:aColor.
    cmap3 := Array 
                with:Color black
                with:aColor darkened darkened
                with:aColor.

    bitMaps do:[:anImage |
        anImage colorMap size == 2 ifTrue:[
            newCMap := cmap2
        ] ifFalse:[
            newCMap := cmap3
        ].
        anImage colorMap:newCMap
    ].

    self invalidate.

    "Created: / 16.6.1998 / 10:39:20 / cg"
    "Modified: / 11.2.2000 / 01:47:27 / cg"
! !

!DigitalLedDisplay methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "redraw myself, when the model changes"

    changedObject == model ifTrue:[
        model value ~= lastValue ifTrue:[
            lastValue := model value.
            self invalidate.
        ].
        ^ self
    ].
    changedObject == ledColorChannel ifTrue:[
        self foregroundColor:(ledColorChannel value).
        self invalidate.
        ^ self
    ].
    ^ super update:something with:aParameter from:changedObject

    "Created: / 23.10.1997 / 19:15:14 / cg"
    "Modified: / 11.2.2000 / 01:47:15 / cg"
! !

!DigitalLedDisplay methodsFor:'drawing'!

redrawX:rx y:ry width:rw height:rh
    "update my view"

    |val s x y w h img|

    shown ifFalse:[^ self].

    self clear.
    val := model value ? 0.

    val isString ifTrue:[
        s := val
    ] ifFalse:[
        (radix == 16 and:[val isInteger]) ifTrue:[
            s := val asInteger printStringRadix:16.
            s := s asUppercase.
            s replaceAll:$B with:$b.
            s replaceAll:$D with:$d.
        ] ifFalse:[
            val isInteger ifTrue:[
                s := val printStringRadix:(radix ? 10).
            ] ifFalse:[
                scale isNil ifTrue:[
                    "/
                    "/ float format
                    "/
                    val isFixedPoint ifTrue:[
                        s := val printString.
                    ] ifFalse:[
                        val := val asFloat.
                        s := val printfPrintString:'%f'.
                    ].
                    s size > numberOfDigits ifTrue:[
                        val printString size <= numberOfDigits ifTrue:[
                            s := val printString
                        ]
                    ].
                    (s includes:$.) ifTrue:[
                        [s endsWith:$0] whileTrue:[
                            s := s copyButLast:1.
                        ].
                        (s endsWith:$.) ifTrue:[
                            s := s copyButLast:1.
                        ]
                    ]
                ] ifFalse:[
                    "/
                    "/ fixed format
                    "/
                    val := val asFixedPoint:scale.
                    s := val printString.
                ]
            ]
        ].
        s size > numberOfDigits ifTrue:[
            s := String new:numberOfDigits withAll:$-
        ].
    ].

    img := bitMaps at:$0 ifAbsent:nil.
    img isNil ifTrue:[
        "/
        "/ fallBack, if bitmaps are not present
        "/
        self displayString:s x:0 y:(gc font ascent).
        ^ self
    ].

    w := img width.
    h := img height.
    x := width - margin - w.
    y := height - margin - h.

    s reverseDo:[:char |
        img := bitMaps at:char ifAbsent:nil.
        img isNil ifTrue:[
"/            self halt
        ] ifFalse:[
            img displayOn:self at:(x @ (y//2)).
        ].
        x := x - w
    ].

    img := bitMaps at:(Character space) ifAbsent:nil.
    img notNil ifTrue:[
        s size + 1 to:numberOfDigits do:[:i |
            img displayOn:self at:(x @ (y//2)).
            x := x - w
        ]
    ].

    "Created: / 23.10.1997 / 19:13:07 / cg"
    "Modified: / 16.6.1998 / 10:45:24 / cg"
! !

!DigitalLedDisplay methodsFor:'events'!

sizeChanged:how
    super sizeChanged:how.
    self invalidate

    "Created: / 16.6.1998 / 10:30:38 / cg"
    "Modified: / 11.2.2000 / 01:47:45 / cg"
! !

!DigitalLedDisplay methodsFor:'initialization'!

fetchDeviceResources
    "fetch device colors, to avoid reallocation at redraw time"

    |deviceBitmaps|

    deviceBitmaps := Dictionary new.
    self class bitmaps keysAndValuesDo:[:key :bitmap |
        bitmap notNil ifTrue:[
            deviceBitmaps at:key put:(bitmap onDevice:device)
        ]
    ].
    bitMaps := deviceBitmaps

    "Modified: / 08-08-2010 / 14:41:28 / cg"
!

initialize
    super initialize.

    self viewBackground:Color black.
    ledColor := Color red.

    numberOfDigits isNil ifTrue:[numberOfDigits := 10].

    "Created: / 23.10.1997 / 18:53:46 / cg"
    "Modified: / 16.6.1998 / 10:36:11 / cg"
! !

!DigitalLedDisplay methodsFor:'queries'!

preferredExtent
    |w h bm m2|

    "/ If I have an explicit preferredExtent..
    explicitExtent notNil ifTrue:[
        ^ explicitExtent
    ].

    (bitMaps isNil or:[ (bm := bitMaps at:$0) isNil]) ifTrue:[
        w := gc font widthOf:'0'.
        h := gc font height.
    ] ifFalse:[
        w := bm width.
        h := bm height.
    ].
    m2 := margin + margin.
    m2 := 0.

    ^ (w * numberOfDigits + m2 ) @ (h + m2 )

    "Created: / 23.10.1997 / 19:09:32 / cg"
    "Modified: / 25.10.1997 / 17:03:20 / cg"
! !

!DigitalLedDisplay class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/DigitalLedDisplay.st,v 1.31 2017-11-28 18:26:05 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/DigitalLedDisplay.st,v 1.31 2017-11-28 18:26:05 cg Exp $'
! !

