"
 COPYRIGHT (c) 1992 by Claus Gittinger
	      All Rights Reserved

 This software is furnished under a license and may be used
 only in accordance with the terms of that license and with the
 inclusion of the above copyright notice.   This software may not
 be provided or otherwise made available to, or used by, any
 other person.  No title to or ownership of the software is
 hereby transferred.
"
"{ Package: 'stx:libview' }"

"{ NameSpace: Smalltalk }"

Object subclass:#Cursor
	instanceVariableNames:'shape sourceForm maskForm hotX hotY device cursorId'
	classVariableNames:'DefaultFgColor DefaultBgColor NormalCursor HandCursor ArrowCursor
		WaitCursor CrossHairCursor OriginCursor CornerCursor SquareCursor
		FourWayCursor UpDownArrowCursor LeftRightArrowCursor
		ThumbsUpCursor ThumbsDownCursor ReadCursor WriteCursor XeqCursor
		StopCursor EyeCursor BlankCursor MarkerCursor UpCursor DownCursor
		LeftCursor RightCursor XMarkerCursor CaretCursor
		UpRightHandCursor DocumentCursor FolderCursor CrossCursor
		QuestionMarkCursor LeftHandCursor BottomLeftCornerCursor
		TopRightCornerCursor DownLimitCursor UpLimitCursor
		LeftLimitCursor RightLimitCursor ClosedEyeCursor'
	poolDictionaries:''
	category:'Graphics-Support'
!

!Cursor class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 1992 by Claus Gittinger
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
    I represents cursors in a device independent manner.
    Normally, cursors are defined at view creation time,
    via 
        'aView cursor:aCursor'.

    [Instance variables:]

        shape           <Symbol>        a shape (i.e. #arrow, #hand, ...) or nil
        sourceForm      <Form>          if shape is nil, the source bits
        maskForm        <Form>          if shape is nil, the mask bits
        hotX            <SmallInteger>  if shape is nil, the hotSpot x of the cursor
        hotY            <SmallInteger>  if shape is nil, the hotSpot y of the cursor
        device          <aDevice>       the device, if associated to one
        cursorId        <anObject>      the device-specific id if device is nonNil

    [class variables:]

        Lobby           <Registry>      keeps track of known device cursors
                                        (don't use it: this will be moved to the device)

        DefaultFgColor  <Color>         default foreground color for cursors (usually black)
        DefaultBgColor  <Color>         default background color for cursors (usually white)

        NormalCursor    <Cursor>        cached instance of normal (arrow) cursor
         ...

    [see also:]
        DeviceWorkstation 
        DisplaySurface
        Font Color Image Form
        ( introduction to view programming :html: programming/viewintro.html#CURSOR )

    [author:]
        Claus Gittinger
"
!

examples
"
    get a standard cursors:
                                                                        [exBegin]
        Cursor wait.
        Cursor stop.
        Cursor normal.
                                                                        [exEnd]

    create a custom cursor:
                                                                        [exBegin]
        Cursor extent:16@16 
               fromArray:#[ 2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]
                offset:-8 @ -8   
                                                                        [exEnd]

    some common cursors ...
                                                                        [exBegin]
        |v b cursors nextCursorAction|

        cursors := OrderedCollection new.
        cursors add:#arrow.
        cursors add:#blank.
        cursors add:#bottomLeft.
        cursors add:#bottomRight.
        cursors add:#caret.
        cursors add:#corner.
        cursors add:#cross.
        cursors add:#crossHair.
        cursors add:#document.
        cursors add:#down.
        cursors add:#downLimitArrow.
        cursors add:#execute.
        cursors add:#eye.
        cursors add:#folder.
        cursors add:#fourWay.
        cursors add:#hand.
        cursors add:#left.
        cursors add:#leftHand.
        cursors add:#leftLimitArrow.
        cursors add:#leftRightArrow.
        cursors add:#marker.
        cursors add:#normal.
        cursors add:#origin.
        cursors add:#questionMark.
        cursors add:#read.
        cursors add:#right.
        cursors add:#rightLimitArrow.
        cursors add:#stop.
        cursors add:#text.
        cursors add:#thumbsDown.
        cursors add:#thumbsUp.
        cursors add:#topLeft.
        cursors add:#topRight.
        cursors add:#up.
        cursors add:#upDownArrow.
        cursors add:#upLeftArrow.
        cursors add:#upLimitArrow.
        cursors add:#upRightArrow.
        cursors add:#upRightHand.
        cursors add:#wait.
        cursors add:#write.
        cursors add:#xMarker.

        nextCursorAction := [
            |sel c|

            cursors isEmpty ifTrue:[
                v close.
            ] ifFalse:[
                sel := cursors removeFirst.
                c := Cursor perform:sel.
                b label:sel.
                b cursor:c.
            ]
        ].

        v := StandardSystemView extent:100@100.
        b := Button origin:0.0@0.0 corner:1.0@1.0 in:v.
        b label:'default'.
        b action:nextCursorAction.
        v openAndWait.

                                                                        [exEnd]

    define a cursor for a view:
                                                                        [exBegin]
        |v|

        v := StandardSystemView extent:100@100.
        v cursor:Cursor stop.
        v open.
                                                                        [exEnd]


      with above custom cursor:
                                                                        [exBegin]
        |v|

        v := StandardSystemView extent:100@100.
        v cursor:(
            Cursor extent:16@16 
               fromArray:#[ 2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]
                offset:-8 @ -8).   
        v open.
                                                                        [exEnd]


      a custom cursor with mask:
                                                                        [exBegin]
        |v|

        v := StandardSystemView extent:100@100.
        v cursor:(
            Cursor 
               extent:16@16 
               sourceArray:#[ 
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000]
               maskArray:#[ 
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r00000000 2r00000000
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r11111111 2r11111111
                            2r00000000 2r00000000
                            2r00000000 2r00000000]
                offset:-8 @ -8).   
        v open.
                                                                        [exEnd]


      a cursor from an image read from a file:
                                                                        [exBegin]
        |v img|

        v := StandardSystemView extent:100@100.
        img := Image fromFile:'bitmaps/xpmBitmaps/cursors/mouse.xpm'.
        v cursor:(Cursor fromImage:img).
        v open.
                                                                        [exEnd]


      with multiple views:
                                                                        [exBegin]
        |v1 v2 top|

        top := StandardSystemView new.
        top extent:300@300.
        v1 := View origin:0.0@0.0 corner:1.0@0.5 in:top.
        v1 viewBackground:(Color grey:75).
        v1 cursor:Cursor thumbsUp.
        v2 := View origin:0.0@0.5 corner:1.0@1.0 in:top.
        v2 viewBackground:(Color white).
        v2 cursor:Cursor wait.
        top open.
                                                                        [exEnd]


    show a cursor (in the active ST/X view) for a while:
                                                                        [exBegin]

        Cursor wait 
            showWhile:[
                Delay waitForSeconds:5
            ]
                                                                        [exEnd]


    show a cursor in all views belonging to a windowGroup:
    (have to wait until top is visible to access windowGroup)
                                                                        [exBegin]
        |v1 v2 top|

        top := StandardSystemView new.
        top extent:300@300.
        v1 := View origin:0.0@0.0 corner:1.0@0.5 in:top.
        v1 viewBackground:(Color grey:75).
        v1 cursor:(Cursor normal).

        v2 := View origin:0.0@0.5 corner:1.0@1.0 in:top.
        v2 viewBackground:(Color white).
        v2 cursor:(Cursor crossHair).
        top openAndWait.

        Delay waitForSeconds:3.

        top windowGroup
            withCursor:Cursor wait 
            do:[
                  Delay waitForSeconds:5
               ]
                                                                        [exEnd]


    show a cursor in a single view for a while:
                                                                        [exBegin]
        |v1 v2 top|

        top := StandardSystemView new.
        top extent:300@300.
        v1 := View origin:0.0@0.0 corner:1.0@0.5 in:top.
        v1 viewBackground:(Color grey:75).
        v1 cursor:(Cursor normal).

        v2 := View origin:0.0@0.5 corner:1.0@1.0 in:top.
        v2 viewBackground:(Color white).
        v2 cursor:(Cursor crossHair).

        top openAndWait.

        Delay waitForSeconds:3.

        v1 withCursor:Cursor wait 
           do:[
                  Delay waitForSeconds:5
              ]
                                                                        [exEnd]
"
! !

!Cursor class methodsFor:'initialization'!

flushDeviceCursorsFor:aDevice
    "unassign all cursors from their device"

    aDevice deviceCursors do:[:aCursor |
        aCursor setDevice:nil id:nil
    ].
    aDevice releaseDeviceCursors

    "
     self flushDeviceCursorsFor:Display
    "
!

initialize
    Color initialize.
    Form initialize.
    self initializeNewCursors

    "
     Cursor initialize
    "
!

initializeNewCursors
    "Create additional cursors as bitmap cursors,
     if not available as native cursors on the device.
     This is invoked via the startup script (display.rc)
     (This is rubbish - we should keep that info on a per-device basis ...)
            Cursor blank
            Cursor down
            Cursor execute
            Cursor left
            Cursor marker
            Cursor normal
            Cursor read
            Cursor right
            Cursor square
            Cursor up
            Cursor wait
            Cursor write
            Cursor thumbsUp
            Cursor thumbsDown
            Cursor xMarker
            Cursor caret
            Cursor stop
            Cursor eye
            Cursor eyeClosed"

    |bits mask isWindows|

    "/ HandCursor := nil.
    HandCursor notNil ifTrue:[^ self].

    Screen isNil ifTrue:[
        isWindows := OperatingSystem isMSWINDOWSlike.
    ] ifFalse:[
        isWindows := Screen isWindowsPlatform.
    ].

    HandCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000011
                        2r0000000000001111
                        2r0000000000111100
                        2r0000000001111000
                        2r0000000011110000
                        2r0000000111111000
                        2r0000001111111100
                        2r0000001111111000
                        2r0001111111111100
                        2r0011011111111100
                        2r0110000111111000
                        2r0110000111110000
                        2r0011001010000000
                        2r0001100010000000
                        2r0000110100000000
                        2r0000011000000000)
                    maskArray: #(
                        2r0000000000000011
                        2r0000000000001111
                        2r0000000000111100
                        2r0000000001111000
                        2r0000000011110000
                        2r0000000111111000
                        2r0000001111111100
                        2r0000001111111000
                        2r0001111111111100
                        2r0011011111111100
                        2r0110000111111000
                        2r0110000111110000
                        2r0011001010000000
                        2r0001100010000000
                        2r0000110100000000
                        2r0000011000000000)
                    offset: 0@ -15).
    HandCursor setShape:#upRightHand.

    FolderCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0011111000000000
                        2r0100000100000000
                        2r1111111111111110
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1000000000000001
                        2r1010101010101011
                        2r0111111111111111
                        2r0000000000000000)
                    maskArray: #(
                        2r0000000000000000
                        2r0011111000000000
                        2r0111111100000000
                        2r1111111111111110
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r0111111111111111
                        2r0000000000000000)
                    offset: 0@ -3).

    DocumentCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0011111111100000
                        2r0010000000110000
                        2r0010000000101000
                        2r0010000000111100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0010000000000100
                        2r0011111111111100
                        2r0000000000000000)
                    maskArray: #(
                        2r0000000000000000
                        2r0011111111100000
                        2r0011111111110000
                        2r0011111111111000
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0011111111111100
                        2r0000000000000000)
                    offset: -2@ -1).

"/    OriginCursor :=   
"/            (Cursor
"/                    extent: 16@16
"/                    sourceArray: #(
"/                        2r0000000000000000
"/                        2r0111111111111111
"/                        2r0111111111111111
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000)
"/                    maskArray: #(
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000)
"/                    offset: -1@ -1).
"/    OriginCursor setShape:#origin.

    OriginCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
                        2r1111111111111110
                        2r1000000000000010
                        2r1000000000000010
                        2r1001111111111110
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1111000000000000
                        2r0000000000000000)
                    maskArray: #(
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r0000000000000000)
                    offset: -1@ -1).
    OriginCursor setShape:#origin.

"/    TopRightCornerCursor :=   
"/            (self
"/                    extent: 16@16
"/                    sourceArray: #(
"/                        2r0000000000000000
"/                        2r0111111111111111
"/                        2r0111111111111111
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110)
"/                    maskArray: #(
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111)
"/                    offset: -14@ -1).
"/    TopRightCornerCursor setShape:#topRightCorner.

    TopRightCornerCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
                        2r0111111111111111
                        2r0100000000000001
                        2r0100000000000001
                        2r0111111111111001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001111
                        2r0000000000000000)
                    maskArray: #(
                        2r0111111111111111
                        2r0111111111111111
                        2r0111111111111111
                        2r0111111111111111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000000000)
                    offset: -14@ -1).
    TopRightCornerCursor setShape:#topRightCorner.

"/    CornerCursor := 
"/            (self 
"/                    extent: 16@16
"/                    sourceArray: #(
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r0000000000000110
"/                        2r1111111111111110
"/                        2r1111111111111110
"/                        2r0000000000000000)
"/                    maskArray: #(
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r0000000000001111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111)
"/                    offset: -14@ -14).
"/    CornerCursor setShape:#corner.

    CornerCursor := 
            (self 
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0000000000001111
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0000000000001001
                        2r0111111111111001
                        2r0100000000000001
                        2r0100000000000001
                        2r0111111111111111)
                    maskArray: #(
                        2r0000000000000000
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0000000000001111
                        2r0111111111111111
                        2r0111111111111111
                        2r0111111111111111
                        2r0111111111111111)
                    offset: -14@ -14).
    CornerCursor setShape:#corner.

"/    BottomLeftCornerCursor :=   
"/            (Cursor
"/                    extent: 16@16
"/                    sourceArray: #(
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0110000000000000
"/                        2r0111111111111111
"/                        2r0111111111111111
"/                        2r0000000000000000)
"/                    maskArray: #(
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111000000000000
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111
"/                        2r1111111111111111)
"/                    offset: -1@ -14).
"/    BottomLeftCornerCursor setShape:#bottomLeftCorner.

    BottomLeftCornerCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r1111000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001000000000000
                        2r1001111111111110
                        2r1000000000000010
                        2r1000000000000010
                        2r1111111111111110)
                    maskArray: #(
                        2r0000000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111000000000000
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110)
                    offset: -1@ -14).
    BottomLeftCornerCursor setShape:#bottomLeftCorner.

    ReadCursor := (Cursor
                    extent: 16@16
                    sourceArray: #(
                        2r0
                        2r0000110000000110
                        2r0001001000001001
                        2r0001001000001001
                        2r0010000000010000
                        2r0100000000100000
                        2r1111101111100000
                        2r1000010000100000
                        2r1000010000100000
                        2r1011010110100000
                        2r0111101111000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000)
                    maskArray: #(
                        2r0001111000001111
                        2r0001111000011111
                        2r0011111000011111
                        2r0011100000111100
                        2r0111000000111000
                        2r1111111111110000
                        2r1111111111110000
                        2r1111111111110000
                        2r1111111111110000
                        2r1111111111110000
                        2r1111111111100000
                        2r0111111111000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000)
                    offset: -5 @ -7).
    ReadCursor setShape:#read.

    WriteCursor := (Cursor
                      extent: 16@16
                      sourceArray: #(
                          2r0000000000000110
                          2r0000000000001111
                          2r0000000000010110
                          2r0000000000100100
                          2r0000000001001000
                          2r0000000010010000
                          2r0000000100100000
                          2r0000001001000011
                          2r0000010010000010
                          2r0000100100000110
                          2r0001001000001000
                          2r0010010000001000
                          2r0111100001001000
                          2r0101000010111000
                          2r0110000110000000
                          2r1111111100000000)
                      maskArray: #(
                          2r0000000000000111
                          2r0000000000001111
                          2r0000000000011110
                          2r0000000000111100
                          2r0000000001111000
                          2r0000000011110000
                          2r0000000111100001
                          2r0000001111000110
                          2r0000011110000110
                          2r0000111100001110
                          2r0001111000001100
                          2r0011110001001100
                          2r0111100011111000
                          2r0111000110111000
                          2r0111111110000000
                          2r1111111100000000)
                      offset: 0@ -15).
    WriteCursor setShape:#write.

    WaitCursor := 
              (self
                    extent: 16@16
                    sourceArray: #(
                        2r1111111111111111
                        2r1000000000000001
                        2r0100000000000010
                        2r0010000000000100
                        2r0001110000111000
                        2r0000111101110000
                        2r0000011011100000
                        2r0000001111000000
                        2r0000001111000000
                        2r0000010110100000
                        2r0000100010010000
                        2r0001000110001000
                        2r0010001101000100
                        2r0100111111110010
                        2r1011111111111101
                        2r1111111111111111)
                    maskArray: #(
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111
                        2r0111111111111110
                        2r0011111111111100
                        2r0001111111111000
                        2r0000111111110000
                        2r0000011111100000
                        2r0000011111100000
                        2r0000111111110000
                        2r0001111111111000
                        2r0011111111111100
                        2r0111111111111110
                        2r1111111111111111
                        2r1111111111111111
                        2r1111111111111111)
                    offset: -8@ -8).
    WaitCursor setShape:#wait.

    BlankCursor := 
            (self
                    extent: 16@16
                    fromArray: #(
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000)
    offset: 0@0).
    BlankCursor setShape:#blank.

    XeqCursor := 
            (self
                    extent: 16@16
                    sourceArray: #(
            2r1000000000010000
            2r1100000000010000
            2r1110000000111000
            2r1111000111111111
            2r1111100011000110
            2r1111110001000100
            2r1111111001111100
            2r1111000001101100
            2r1101100011000110
            2r1001100010000010
            2r0000110000000000
            2r0000110000000000
            2r0000011000000000
            2r0000011000000000
            2r0000001100000000
            2r0000001100000000)
                    maskArray: #(
            2r1100000000111000
            2r1110000000111000
            2r1111000111111111
            2r1111100111111111
            2r1111110011111111
            2r1111111001111110
            2r1111111101111100
            2r1111100001111110
            2r1101110011100111
            2r1001110011000010
            2r0000111000000000
            2r0000111000000000
            2r0000011100000000
            2r0000011100000000
            2r0000001110000000
            2r0000001110000000)
    offset: 0@0).
    XeqCursor setShape:#execute.

    SquareCursor := 
            (self
                    extent: 16@16
                    fromArray: #(
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000001111000000
            2r0000001111000000
            2r0000001111000000
            2r0000001111000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000)
    offset: -8@ -8).
    SquareCursor setShape:#square.

    NormalCursor :=   
            (self
                    extent: 16@16
                    sourceArray: #(
            2r1000000000000000
            2r1100000000000000
            2r1110000000000000
            2r1111000000000000
            2r1111100000000000
            2r1111110000000000
            2r1111111000000000
            2r1111100000000000
            2r1111100000000000
            2r1001100000000000
            2r0000110000000000
            2r0000110000000000
            2r0000011000000000
            2r0000011000000000
            2r0000001100000000
            2r0000001100000000)
                    maskArray: #(
            2r1100000000000000
            2r1110000000000000
            2r1111000000000000
            2r1111100000000000
            2r1111110000000000
            2r1111111000000000
            2r1111111100000000
            2r1111110000000000
            2r1111110000000000
            2r1001110000000000
            2r0000111000000000
            2r0000111000000000
            2r0000011100000000
            2r0000011100000000
            2r0000001110000000
            2r0000001110000000)
    offset: 0@0).
    NormalCursor setShape:#upLeftArrow.

    UpDownArrowCursor :=   
            (self
                 extent: 16@16
                 sourceArray: #(
            2r0000000110000000
            2r0000001111000000
            2r0000011111100000
            2r0000111111110000
            2r0000000110000000
            2r0000000110000000
            2r0000000000000000
            2r0111111111111110
            2r0111111111111110
            2r0000000000000000
            2r0000000110000000
            2r0000000110000000
            2r0000111111110000
            2r0000011111100000
            2r0000001111000000
            2r0000000110000000)
                 maskArray: #(
            2r0000001111000000
            2r0000011111100000
            2r0000111111110000
            2r0001111111111000
            2r0001111111111000
            2r0000001111000000
            2r1111111111111111
            2r1111111111111111
            2r1111111111111111
            2r1111111111111111
            2r0000001111000000
            2r0001111111111000
            2r0001111111111000
            2r0000111111110000
            2r0000011111100000
            2r0000001111000000

            )
                    offset: -7@ -7).
    UpDownArrowCursor setShape:#upDownArrow.

    LeftRightArrowCursor :=   
            (self
                 extent: 16@16
                 sourceArray: #(
            2r0000000000000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0001000110001000
            2r0011000110001100
            2r0111000110001110
            2r1111110110111111
            2r1111110110111111
            2r0111000110001110
            2r0011000110001100
            2r0001000110001000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000000000000)
                 maskArray: #(
            2r0000001111000000
            2r0000001111000000
            2r0000001111000000
            2r0001101111011000
            2r0011101111011100
            2r0111111111111110
            2r1111111111111111
            2r1111111111111111
            2r1111111111111111
            2r1111111111111111
            2r0111111111111110
            2r0011101111011100
            2r0011101111011100
            2r0000001111000000
            2r0000001111000000
            2r0000001111000000)
                    offset: -7@ -7).
    LeftRightArrowCursor setShape:#leftRightArrow.


    CrossHairCursor :=   
            (self
                 extent: 16@16
                 sourceArray: #(
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r1111111111111110
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0000000100000000
            2r0)
                 maskArray: #(
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r1111111111111110
            2r1111111111111110
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0000000110000000
            2r0)
                    offset: -7@ -7).
    CrossHairCursor setShape:#crossHair.

    CrossCursor :=   
            (self
                 extent: 16@16
                 sourceArray: #(
            2r0000000000000000
            2r0110000000001100
            2r0111000000011100
            2r0011100000111000
            2r0001110001110000
            2r0000111011100000
            2r0000011111000000
            2r0000001110000000
            2r0000011111000000
            2r0000111011100000
            2r0001110001110000
            2r0011100000111000
            2r0111000000011100
            2r0110000000001100
            2r0000000000000000
            2r0)
                 maskArray: #(
            2r1110000000001110
            2r1111000000011110
            2r1111100000111110
            2r0111110001111100
            2r0011111011111000
            2r0001111111110000
            2r0000111111100000
            2r0000011111000000
            2r0000111111100000
            2r0001111111110000
            2r0011111011111000
            2r0111110001111100
            2r1111100000111110
            2r1111000000011110
            2r1110000000001110
            2r0)
                    offset: -7@ -7).
    CrossCursor setShape:#cross.

    RightLimitCursor := 
            self
                    extent: 16@16
                    sourceArray: #(
                2r0000000000000110
                2r0000000000000110
                2r0000000000000110
                2r0000001000000110
                2r0000001110000110
                2r0000001111100110
                2r0111111111111110
                2r0111111111111110
                2r0111111111111110
                2r0000001111100110
                2r0000001110000110
                2r0000001000000110
                2r0000000000000110
                2r0000000000000110
                2r0000000000000110
                2r0000000000000110)
                    maskArray: #(
                2r0000000000001111
                2r0000000000001111
                2r0000000000001111
                2r0000011100001111
                2r0000011111001111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r0000011111001111
                2r0000011100001111
                2r0000011000001111
                2r0000000000001111
                2r0000000000001111
                2r0000000000001111)
                    offset: -14@ -7.
    RightLimitCursor setShape:#rightLimitArrow.

    LeftLimitCursor := 
            self
                    extent: 16@16
                    sourceArray: #(
                2r0110000000000000 
                2r0110000000000000 
                2r0110000000000000 
                2r0110000001000000 
                2r0110000111000000 
                2r0110011111000000 
                2r0111111111111110 
                2r0111111111111110 
                2r0111111111111110 
                2r0110011111000000 
                2r0110000111000000 
                2r0110000001000000 
                2r0110000000000000 
                2r0110000000000000 
                2r0110000000000000 
                2r0110000000000000 
               )
                    maskArray: #(
                2r1111000000000000 
                2r1111000000000000 
                2r1111000000000000 
                2r1111000011100000 
                2r1111001111100000 
                2r1111111111111111 
                2r0111111111111111 
                2r0111111111111111 
                2r0111111111111111 
                2r1111111111111111 
                2r1111001111100000 
                2r1111000011100000 
                2r1111000000000000 
                2r1111000000000000 
                2r1111000000000000 
                2r1111000000000000 
               )
                    offset: -1@ -7.
    LeftLimitCursor setShape:#leftLimitArrow.

    UpLimitCursor := 
            self
                    extent: 16@16
                    sourceArray: #(
                2r0000000000000000
                2r1111111111111110
                2r1111111111111110
                2r0000000100000000
                2r0000001110000000
                2r0000011111000000
                2r0000111111100000
                2r0001111111110000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000000000000000
                2r0000000000000000
               )
                    maskArray: #(
                2r1111111111111110
                2r1111111111111110
                2r1111111111111110
                2r1111111111111110
                2r0000011111000000
                2r0000111111100000
                2r0001111111110000
                2r0011111111111000
                2r0011111111111000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000000000000000
                )
                    offset: -7@ -1.
    UpLimitCursor setShape:#upLimitArrow.

    DownLimitCursor := 
            self
                    extent: 16@16
                    sourceArray: #(
                2r0000000000000000
                2r0000000000000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0001111111110000
                2r0000111111100000
                2r0000011111000000
                2r0000001110000000
                2r0000000100000000
                2r1111111111111110
                2r1111111111111110
                2r0000000000000000)
                    maskArray: #(
                2r0000000000000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0000011111000000
                2r0011111111111000
                2r0011111111111000
                2r0001111111110000
                2r0000111111100000
                2r0000011111000000
                2r1111111111111110
                2r1111111111111110
                2r1111111111111110
                2r1111111111111110)
                    offset: -7@ -15.
    DownLimitCursor setShape:#downLimitArrow.

    LeftRightArrowCursor := 
            self
                    extent: 16@16
                    sourceArray: #(
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000100000010000
                2r0001100000011000
                2r0011100000011100
                2r0111111111111110
                2r1111100000011111
                2r0111111111111110
                2r0011100000011100
                2r0001100000011000
                2r0000100000010000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000)
                    maskArray: #(
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000100000010000
                2r0001100000011000
                2r0011100000011100
                2r0111111111111110
                2r1111111111111111
                2r0111111111111110
                2r0011100000011100
                2r0001100000011000
                2r0000100000010000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000)
                    offset: -7@ -7.
    LeftRightArrowCursor setShape:#leftRightArrow.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #(
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111110111111111
                2r1111110001111111
                2r1111110000011111
                2r1000000000000111
                2r1000000000000001
                2r1000000000000111
                2r1111110000011111
                2r1111110001111111
                2r1111110111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111).
    ] ifFalse:[
        "/ want it black-with white boundary
        bits := #(
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000001000000000
                2r0000001110000000
                2r0000001111100000
                2r0111111111111000
                2r0111111111111110
                2r0111111111111000
                2r0000001111100000
                2r0000001110000000
                2r0000001000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000).
    ].

    MarkerCursor := 
            self
                    extent: 16@16
                    sourceArray:bits
                    maskArray: #(
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000011100000000
            2r0000011111000000
            2r1111111111110000
            2r1111111111111100
            2r1111111111111111
            2r1111111111111100
            2r1111111111110000
            2r0000011111000000
            2r0000011100000000
            2r0000011000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000)
                    offset: -14@ -7.
    MarkerCursor setShape:#marker.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #(
                2r1111111111111111
                2r1011111111111111
                2r1001111111111111
                2r1000111111111111
                2r1000011111111111
                2r1000001111111111
                2r1000000111111111
                2r1001111111111111
                2r1001111111111111
                2r1001111111111111
                2r1001111111111111
                2r1001111111111111
                2r1001111111111111
                2r1001111111111111
                2r1001111111111111
                2r1111111111111111).
    ] ifFalse:[
        "/ want it black-with white boundary
        bits := #(
                2r0000000000000000
                2r0100000000000000
                2r0110000000000000
                2r0111000000000000
                2r0111100000000000
                2r0111110000000000
                2r0111111000000000
                2r0110000000000000
                2r0110000000000000
                2r0110000000000000
                2r0110000000000000
                2r0110000000000000
                2r0110000000000000
                2r0110000000000000
                2r0110000000000000
                2r0000000000000000).
    ].

    UpCursor := 
            self
                    extent: 16@16
                    sourceArray:bits
                    maskArray: #(
            2r1100000000000000
            2r1110000000000000
            2r1111000000000000
            2r1111100000000000
            2r1111110000000000
            2r1111111000000000
            2r1111111100000000
            2r1111111100000000
            2r1111000000000000
            2r1111000000000000
            2r1111000000000000
            2r1111000000000000
            2r1111000000000000
            2r1111000000000000
            2r1111000000000000
            2r1111000000000000)
                    offset: -1@ -1.
    UpCursor setShape:#upArrow.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #(
                2r1111111111111111
                2r1111100111111111
                2r1111100111111111
                2r1111100111111111
                2r1111100111111111
                2r1111100111111111
                2r1111100111111111
                2r1111100111111111
                2r1111100111111111
                2r1000000111111111
                2r1100000111111111
                2r1110000111111111
                2r1111000111111111
                2r1111100111111111
                2r1111110111111111
                2r1111111111111111).
    ] ifFalse:[
        "/ want it black-with white boundary
        bits := #(
                2r0000000000000000
                2r0000011000000000
                2r0000011000000000
                2r0000011000000000
                2r0000011000000000
                2r0000011000000000
                2r0000011000000000
                2r0000011000000000
                2r0000011000000000
                2r0111111000000000
                2r0011111000000000
                2r0001111000000000
                2r0000111000000000
                2r0000011000000000
                2r0000001000000000
                2r0000000000000000).
    ].

    DownCursor :=
             self
                    extent: 16@16
                    sourceArray:bits
                    maskArray: #(
            2r0000111100000000
            2r0000111100000000
            2r0000111100000000
            2r0000111100000000
            2r0000111100000000
            2r0000111100000000
            2r0000111100000000
            2r0000111100000000
            2r1111111100000000
            2r1111111100000000
            2r0111111100000000
            2r0011111100000000
            2r0001111100000000
            2r0000111100000000
            2r0000011100000000
            2r0000001100000000)
                    offset: -7@ -15.
    DownCursor setShape:#downArrow.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #(
                2r1111111111111111
                2r1000000000000001
                2r1100000000000001
                2r1110000111111111
                2r1111000111111111
                2r1111100111111111
                2r1111110111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111).
    ] ifFalse:[
        "/ want it black-with white boundary
        bits := #(
                2r0000000000000000
                2r0111111111111110
                2r0011111111111110
                2r0001111000000000
                2r0000111000000000
                2r0000011000000000
                2r0000001000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000).
    ].

    LeftCursor := 
            self
                    extent: 16@16
                    sourceArray:bits
                    maskArray: #(
            2r1111111111111111
            2r1111111111111111
            2r0111111111111111
            2r0011111111111111
            2r0001111100000000
            2r0000111100000000
            2r0000011100000000
            2r0000001100000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000)
                    offset: -1 @ -1.
    LeftCursor setShape:#leftArrow.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #(
                2r1111111111111111
                2r1111111110111111
                2r1111111110011111
                2r1111111110001111
                2r1111111110000111
                2r1000000000000011
                2r1000000000000001
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111
                2r1111111111111111).
    ] ifFalse:[
        "/ want it black-with white boundary
        bits := #(
                2r0000000000000000
                2r0000000001000000
                2r0000000001100000
                2r0000000001110000
                2r0000000001111000
                2r0111111111111100
                2r0111111111111110
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000
                2r0000000000000000).
    ].

    RightCursor :=
             self
                    extent: 16@16
                    sourceArray: bits
                    maskArray: #(
            2r0000000011000000
            2r0000000011100000
            2r0000000011110000
            2r0000000011111000
            2r1111111111111100
            2r1111111111111110
            2r1111111111111111
            2r1111111111111111
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000
            2r0000000000000000)
                    offset: -15@ -6.
    RightCursor setShape:#rightArrow.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #(
                2r1111111111111111
                2r1111111011111111
                2r1111111011111111
                2r1111110001111111
                2r1111110001111111
                2r1111100000111111
                2r1111100000111111
                2r1111000000011111
                2r1111000000011111
                2r1110000000001111
                2r1111110001111111
                2r1111110001111111
                2r1111110001111111
                2r1111110001111111
                2r1111110001111111
                2r1111111111111111).
    ] ifFalse:[
        "/ want it black-with white boundary
        bits := #(
                2r0000000000000000
                2r0000000100000000
                2r0000000100000000
                2r0000001110000000
                2r0000001110000000
                2r0000011111000000
                2r0000011111000000
                2r0000111111100000
                2r0000111111100000
                2r0001111111110000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000001110000000
                2r0000000000000000).
    ].

    XMarkerCursor := 
            self
                    extent: 16@16
                    sourceArray: bits
                    maskArray: #(
            2r0000000100000000
            2r0000001110000000
            2r0000001110000000
            2r0000011111000000
            2r0000011111000000
            2r0000111111100000
            2r0000111111100000
            2r0001111111110000
            2r0001111111110000
            2r0011111111111000
            2r0011111111111000
            2r0000011111000000
            2r0000011111000000
            2r0000011111000000
            2r0000011111000000
            2r0000011111000000)
                    offset: -7@ -1.
    RightCursor setShape:#xMarker.

    FourWayCursor := 
            self
                    extent: 16@16
                    sourceArray: #(
            2r0000000100000000
            2r0000001110000000
            2r0000011111000000
            2r0000111111100000
            2r0001001110010000
            2r0011001110011000
            2r0111111111111100
            2r1111111111111110
            2r0111111111111100
            2r0011001110011000
            2r0001001110010000
            2r0000111111100000
            2r0000011111000000
            2r0000001110000000
            2r0000000100000000
            2r0000000000000000)
                    maskArray: #(
            2r0000001110000000
            2r0000011111000000
            2r0000111111100000
            2r0001111111110000
            2r0010111111101000
            2r0111111111111100
            2r1111111111111110
            2r1111111111111110
            2r1111111111111110
            2r0111111111111100
            2r0010111111101000
            2r0001111111110000
            2r0000111111100000
            2r0000011111000000
            2r0000001110000000
            2r0000000000000000)
                    offset: -7@ -7.
    FourWayCursor setShape:#fourWay.

    ThumbsUpCursor := (self
                      extent: 16@16
                      sourceArray: #(
                          2r0000000000100000
                          2r0000000001010000
                          2r0000000010010000
                          2r0000000011110000
                          2r0000000100010000
                          2r0000000100010000
                          2r0001111100011000
                          2r0010000100000110
                          2r0100000000000000
                          2r0111111000000000
                          2r0100000000000000
                          2r0111111000000000
                          2r0100000000000000
                          2r0011111000001110
                          2r0001000000010000
                          2r0001111111100000)
                      maskArray: #(
                          2r0000000000100000
                          2r0000000001110000
                          2r0000000011110000
                          2r0000000011110000
                          2r0000000111110000
                          2r0000000111110000
                          2r0001111111111000
                          2r0011111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0011111111111110
                          2r0001111111110000
                          2r0001111111100000)
                      offset: -8@ 0).
    ThumbsUpCursor setShape:#thumbsUp.

    CaretCursor := (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0000000110000000
                        2r0000000110000000
                        2r0000001111000000
                        2r0000011111100000
                        2r0000011001100000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000)
                    maskArray: #(
                        2r0000000110000000
                        2r0000001111000000
                        2r0000001111100000
                        2r0000011111100000
                        2r0000111111110000
                        2r0000111111110000
                        2r0000011001100000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000)
                    offset: -8@0).
    CaretCursor setShape:#caret.

    ThumbsDownCursor := (self
                      extent: 16@16
                      sourceArray: #(
                          2r0001111111100000
                          2r0001000000010000
                          2r0011111000001110
                          2r0100000000000000
                          2r0111111000000000
                          2r0100000000000000
                          2r0111111000000000
                          2r0100000000000000
                          2r0010000100000110
                          2r0001111100011000
                          2r0000000100010000
                          2r0000000100010000
                          2r0000000011110000
                          2r0000000010010000
                          2r0000000001010000
                          2r0000000000100000)

                      maskArray: #(
                          2r0001111111100000
                          2r0001111111110000
                          2r0011111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0111111111111110
                          2r0011111111111110
                          2r0001111111111000
                          2r0000000111110000
                          2r0000000111110000
                          2r0000000011110000
                          2r0000000011110000
                          2r0000000001110000
                          2r0000000000100000)
                      offset: -8@ -15 "-16").
    ThumbsDownCursor setShape:#thumbsDown.

    StopCursor := (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0000011111000000
                        2r0001111111110000
                        2r0011111111111000
                        2r0011111111111000
                        2r0111111111111100
                        2r0111111111111100
                        2r0100000000000100
                        2r0100000000000100
                        2r0111111111111100
                        2r0111111111111100
                        2r0011111111111000
                        2r0011111111111000
                        2r0001111111110000
                        2r0000011111000000
                        2r0000000000000000
                        )
                    maskArray: #(
                        2r0000011111000000
                        2r0001111111110000
                        2r0011111111111000
                        2r0111111111111100
                        2r0111111111111100
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r1111111111111110
                        2r0111111111111100
                        2r0111111111111100
                        2r0011111111111000
                        2r0001111111110000
                        2r0000011111000000
                       )
                    offset: -8 @ -8).
    StopCursor setShape:#stop.

    EyeCursor := (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000011111000000
                        2r0001111111110000
                        2r0011000000011000
                        2r0110001110001100
                        2r1100011111000110
                        2r1100011111000110
                        2r0110001110001100
                        2r0011000000011000
                        2r0001111111110000
                        2r0000011111000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        )
                    maskArray: #(
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000011111000000
                        2r0001111111110000
                        2r0011111111111000
                        2r0111111111111100
                        2r1111111111111110
                        2r1111111111111110
                        2r0111111111111100
                        2r0011111111111000
                        2r0001111111110000
                        2r0000011111000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                       )
                    offset: -8 @ -8).
    EyeCursor setShape:#eye.

    ClosedEyeCursor := (self
                    extent: 16@16
                    sourceArray: #(
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000011111000000
                        2r0001111111110000
                        2r0011111111111000
                        2r0111111111111100
                        2r1111111111111110
                        2r1111111111111110
                        2r0111111111111100
                        2r0011111111111000
                        2r0001111111110000
                        2r0000011111000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        )
                    maskArray: #(
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000011111000000
                        2r0001111111110000
                        2r0011111111111000
                        2r0111111111111100
                        2r1111111111111110
                        2r1111111111111110
                        2r0111111111111100
                        2r0011111111111000
                        2r0001111111110000
                        2r0000011111000000
                        2r0000000000000000
                        2r0000000000000000
                        2r0000000000000000
                       )
                    offset: -8 @ -8).
    ClosedEyeCursor setShape:#eyeClosed.

    isWindows ifTrue:[
        "/ want it white-with black boundary
        bits := #[7 128 24 96 32 16 39 136 24 72 0 72 0 72 0 144 1 32 2 64 2 64 2 64 1 128 2 64 2 64 1 128].
        mask := #[7 128 31 224 63 240 63 248 24 120 0 120 0 120 0 240 1 224 3 192 3 192 3 192 1 128 3 192 3 192 1 128].
    ] ifFalse:[
        bits := #( 
                  2r0000000000000000
                  2r0000000000000000
                  2r0000001111000000
                  2r0000111111110000
                  2r0000110000111000
                  2r0000000000011000
                  2r0000000000011000
                  2r0000000000011000
                  2r0000000000110000
                  2r0000000001100000
                  2r0000000110000000
                  2r0000000110000000
                  2r0000000000000000
                  2r0000000110000000
                  2r0000000110000000
                  2r0000000000000000).
        mask := #(  
                  2r0000000000000000
                  2r0000011111000000
                  2r0000111111100000
                  2r0001111111111000
                  2r0001111111111100
                  2r0001111000111100
                  2r0000000000111100
                  2r0000000000111100
                  2r0000000001111000
                  2r0000000011110000
                  2r0000001111000000
                  2r0000001111000000
                  2r0000001111000000
                  2r0000001111000000
                  2r0000001111000000
                  2r0000001111000000).
    ].

    QuestionMarkCursor := (self
                    extent: 16@16
                    sourceArray:bits 
                    maskArray:mask 
                    offset: -8 @ -8).
    QuestionMarkCursor setShape:#questionMark.

    "/ if possible, preallocate them on the default display

"/ cg: no, do not do this here;
"/ defaultFG / defaultBG is not yet initialized.

"/    device notNil ifTrue:[
"/        FourWayCursor notNil ifTrue:[FourWayCursor := FourWayCursor onDevice:device].
"/        LeftCursor notNil ifTrue:[LeftCursor := LeftCursor onDevice:device].
"/        RightCursor notNil ifTrue:[RightCursor := RightCursor onDevice:device].
"/        XMarkerCursor notNil ifTrue:[XMarkerCursor := XMarkerCursor onDevice:device].
"/
"/        OriginCursor notNil ifTrue:[OriginCursor := OriginCursor onDevice:device].
"/        CornerCursor notNil ifTrue:[CornerCursor := CornerCursor onDevice:device].
"/        TopRightCornerCursor notNil ifTrue:[TopRightCornerCursor := TopRightCornerCursor onDevice:device].
"/        BottomLeftCornerCursor notNil ifTrue:[BottomLeftCornerCursor := BottomLeftCornerCursor onDevice:device].
"/
"/        LeftLimitCursor notNil ifTrue:[LeftLimitCursor := LeftLimitCursor onDevice:device].
"/        RightLimitCursor notNil ifTrue:[RightLimitCursor := RightLimitCursor onDevice:device].
"/        DownLimitCursor notNil ifTrue:[DownLimitCursor := DownLimitCursor onDevice:device].
"/        UpLimitCursor notNil ifTrue:[UpLimitCursor := UpLimitCursor onDevice:device].
"/
"/        ReadCursor notNil ifTrue:[ReadCursor := ReadCursor onDevice:device].
"/        WriteCursor notNil ifTrue:[WriteCursor := WriteCursor onDevice:device].
"/        WaitCursor notNil ifTrue:[WaitCursor := WaitCursor onDevice:device].
"/        XeqCursor notNil ifTrue:[XeqCursor := XeqCursor onDevice:device].
"/
"/        SquareCursor notNil ifTrue:[SquareCursor := SquareCursor onDevice:device].
"/
"/        NormalCursor notNil ifTrue:[NormalCursor := NormalCursor onDevice:device].
"/
"/        CrossHairCursor notNil ifTrue:[CrossHairCursor := CrossHairCursor onDevice:device].
"/
"/        MarkerCursor notNil ifTrue:[MarkerCursor := MarkerCursor onDevice:device].
"/        UpCursor notNil ifTrue:[UpCursor := UpCursor onDevice:device].
"/        DownCursor notNil ifTrue:[DownCursor := DownCursor onDevice:device].
"/        LeftCursor notNil ifTrue:[LeftCursor := LeftCursor onDevice:device].
"/        RightCursor notNil ifTrue:[RightCursor := RightCursor onDevice:device].
"/        XMarkerCursor notNil ifTrue:[XMarkerCursor := XMarkerCursor onDevice:device].
"/        CaretCursor notNil ifTrue:[CaretCursor := CaretCursor onDevice:device].
"/
"/        ThumbsUpCursor notNil ifTrue:[ThumbsUpCursor := ThumbsUpCursor onDevice:device].
"/        ThumbsDownCursor notNil ifTrue:[ThumbsDownCursor := ThumbsDownCursor onDevice:device].
"/        StopCursor notNil ifTrue:[StopCursor := StopCursor onDevice:device].
"/        EyeCursor notNil ifTrue:[EyeCursor := EyeCursor onDevice:device].
"/        QuestionMarkCursor notNil ifTrue:[QuestionMarkCursor := QuestionMarkCursor onDevice:device].
"/    ].

    "
     HandCursor := nil.   
     self initializeNewCursors.
    "

    "Modified: / 13.12.1999 / 12:25:48 / cg"
! !

!Cursor class methodsFor:'instance creation'!

extent:extent fromArray:array offset:offset
    "ST-80 compatibility
     create a new bitmap cursor from bits in the array argument.
     Here, the offset argument defines the hotSpot, but is given
     as the negative of the hotSpot coordinate within the cursor (sigh - ST80 compatibility)."

    ^ self
	extent:extent sourceArray:array maskArray:array offset:offset

    "Modified: 22.10.1997 / 23:59:41 / cg"
!

extent:extent sourceArray:sourceArray maskArray:maskArray offset:offset
    "create a new bitmap cursor with mask from bits in sourceArray and
     maskArray.
     The offset argument defines the hotSpot, but is given as the negative
     of the hotSpots coordinate within the cursor (sigh - ST80 compatibility)"

    |sourceForm maskForm|

    sourceForm := Form extent:extent fromArray:sourceArray offset:offset.
    sourceArray ~~ maskArray ifTrue:[
	maskForm := Form extent:extent fromArray:maskArray offset:offset.
    ] ifFalse:[
	maskForm := sourceForm
    ].
    ^ self sourceForm:sourceForm maskForm:maskForm hotSpot:(offset negated)

    "Modified: 22.10.1997 / 23:58:36 / cg"
!

fileCursorNamed:cursorName
    <resource: #obsolete>
    "return a cursor read from the file's 'cursorName_bits.bit' and
     'cursorName_mask.bit' - return nil if either file does not exist.
     This method is going to be obsoleted in the future."

    |cursorBits maskBits|

    self obsoleteMethodWarning.

    cursorBits := Smalltalk imageFromFileNamed:(cursorName , '_bits.bit') forClass:self.
    cursorBits notNil ifTrue:[
        maskBits := Smalltalk imageFromFileNamed:(cursorName , '_mask.bit') forClass:self.
        maskBits notNil ifTrue:[
            ^ self sourceForm:cursorBits maskForm:maskBits
        ]
    ].
    ^ nil

    "Modified: 23.10.1997 / 00:02:07 / cg"
!

fromImage:anImage
    "return a new cursor.
     Source- and (optional) mask-Bits are taken from anImage;
     The cursors hotSpot is the center of the image."

    ^ self
	fromImage:anImage hotSpot:(anImage center)

    "
     |i c|

     i := Image fromFile:'bitmaps/xpmBitmaps/cursors/ul_br_arrow.xpm'.
     c := Cursor fromImage:i.
     WindowGroup activeGroup 
	 withCursor:c 
	 do:[(Delay forSeconds:5)wait]
    "

    "Modified: 22.10.1997 / 23:55:01 / cg"
!

fromImage:anImage hotSpot:aPoint
    "return a new cursor.
     Source- and (optional) mask-Bits are taken from anImage;
     The cursors hotSpot is given as an offset from the top-left."

    |mask sourceForm maskForm|

    sourceForm := anImage asMonochromeFormOn:Screen current.

    mask := anImage mask.
    mask isNil ifTrue:[
	maskForm := sourceForm 
    ] ifFalse:[
	maskForm := mask asMonochromeFormOn:Screen current.
    ].
    ^ self sourceForm:sourceForm
	     maskForm:maskForm
		 hotX:(aPoint x)
		 hotY:(aPoint y)

    "
     |i c|

     i := Image fromFile:'bitmaps/xpmBitmaps/cursors/ul_br_arrow.xpm'.
     c := Cursor fromImage:i hotSpot:(i center).
     WindowGroup activeGroup 
	 withCursor:c 
	 do:[(Delay forSeconds:5)wait]
    "

    "Modified: 22.10.1997 / 23:49:00 / cg"
    "Created: 22.10.1997 / 23:51:32 / cg"
!

imageArray:imageBits maskArray:maskBits
    "ST-80 compatible cursor creation - the extent is fixed to 16@16"

    ^ self 
	imageArray:imageBits 
	maskArray:maskBits 
	hotSpot:8@8

    "
     |cursor|

     cursor := Cursor
	imageArray: #(
		2r0000000000000000
		2r0000000100001110
		2r0000000100001110
		2r0000000100001110
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0111111111111110
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000000000000)
	maskArray: #(
		2r0000001110011111
		2r0000001110011111
		2r0000001110011111
		2r0000001110011111
		2r0000001110011111
		2r0000001110000000
		2r1111111111111111
		2r1111111111111111
		2r1111111111111111
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000).

    cursor showWhile:[
	(Delay forSeconds:10) wait
    ]
    "

    "Modified: 23.10.1997 / 00:06:09 / cg"
!

imageArray:imageBits maskArray:maskBits hotSpot:hot
    "ST-80 compatible cursor creation - the extent is fixed to 16@16"

    ^ self 
	extent:16@16 
	sourceArray:imageBits
	maskArray:maskBits
	offset:hot negated

    "
     |cursor|

     cursor := Cursor
	imageArray: #(
		2r0000000000000000
		2r0000000100001110
		2r0000000100001110
		2r0000000100001110
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0111111111111110
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000100000000
		2r0000000000000000)
	maskArray: #(
		2r0000001110011111
		2r0000001110011111
		2r0000001110011111
		2r0000001110011111
		2r0000001110011111
		2r0000001110000000
		2r1111111111111111
		2r1111111111111111
		2r1111111111111111
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000
		2r0000001110000000)
	hotSpot: 8@8.

    WindowGroup activeGroup 
	withCursor:cursor 
	do:[(Delay forSeconds:10)wait]
    "
!

imageArray:imageBits maskArray:maskBits hotSpot:hot name:aString
    "ST-80 compatible cursor creation - the extent is fixed to 16@16"

    "name is ignored ..."

    ^ self imageArray:imageBits maskArray:maskBits hotSpot:hot
!

shape:aShape 
    "return one of the standard cursors.
     Each display may offer different shapes - see for example XWorkstation
     for details (however a basic minimum set should be supported by all)"

    ^ self basicNew setShape:aShape.

"/    |newCursor|
"/
"/    "first look if not already known"
"/
"/    Lobby isNil ifTrue:[
"/        self initialize
"/    ].
"/    Lobby do:[:aCursor |
"/        (aCursor shape == aShape) ifTrue:[
"/            ^ aCursor
"/        ]
"/    ].
"/    newCursor := self basicNew setShape:aShape.
"/    Lobby register:newCursor.
"/    ^ newCursor
!

shape:aShape on:aDevice
    "return one of the standard cursors already associated to aDevice.
     This is the same as '(Cursor shape:aShape) on:aDevice' but somwehat faster."

    |oldCursor|

    aDevice isNil ifTrue:[
        ^ self basicNew setShape:aShape
    ].

    "first look if not already known"

    oldCursor := aDevice deviceCursors detect:[:aCursor | aCursor shape == aShape] ifNone:nil.
    oldCursor notNil ifTrue:[ ^ oldCursor ].

    ^ (self basicNew setShape:aShape) allocateOnDevice:aDevice
!

sourceForm:aForm
    "return a new cursor.
     Source- and mask-Bits are taken from aForm; hotSpot is center"

    ^ self sourceForm:aForm maskForm:aForm

    "Modified: 23.10.1997 / 00:08:37 / cg"
!

sourceForm:sourceForm maskForm:maskForm
    "return a new cursor. hotSpot is center"

    ^ self sourceForm:sourceForm
	     maskForm:maskForm
		 hotX:(sourceForm width // 2)
		 hotY:(sourceForm height // 2)
!

sourceForm:sourceForm maskForm:maskForm hotSpot:aPoint
    "return a new cursor"

    ^ self sourceForm:sourceForm
	     maskForm:maskForm
		 hotX:(aPoint x)
		 hotY:(aPoint y)
!

sourceForm:sourceForm maskForm:maskForm hotX:hotX hotY:hotY
    "return a new cursor"

    (sourceForm isNil or:[maskForm isNil]) ifTrue:[^ nil].

    ^ self basicNew 
        setSourceForm:sourceForm 
        maskForm:maskForm
        hotX:hotX
        hotY:hotY.
! !

!Cursor class methodsFor:'default access'!

defaultBgColor
    "return the default bg color used for cursors"

    ^ DefaultBgColor 

!

defaultFgColor
    "return the default fg color used for cursors"

    ^ DefaultFgColor 

!

defaultFgColor:fgColor defaultBgColor:bgColor
    "set the default colors used for new cursors"

    DefaultFgColor := fgColor.
    DefaultBgColor := bgColor.

    "
     Cursor defaultFgColor:(Color red) defaultBgColor:(Color white)
    "
! !

!Cursor class methodsFor:'standard cursors'!

arrow
    "return an arrow (up-left-arrow) cursor"

    ^ self upLeftArrow

    "
     Cursor arrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:28:28 / cg"
!

blank 
    "Answer the instance of me that is an invisible cursor."

    ^ BlankCursor

    "
     Cursor blank
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:27:39 / cg"
!

bottomLeft
    "return a bottom-left corner cursor"

    ^ BottomLeftCornerCursor

    "
     Cursor bottomLeft
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:27:12 / cg"
!

bottomRight
    "return a bottom-right corner cursor"

    ^ self corner

    "
     Cursor bottomRight
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:27:02 / cg"
!

caret 
    "return a caret cursor"

    ^ CaretCursor

    "
     Cursor caret
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:27:08 / cg"
!

corner 
    "return a corner (bottom-right) cursor"

    ^ CornerCursor

    "
     Cursor corner
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:53 / cg"
!

cross
    "return a cross cursor"

    ^ CrossCursor

    "
     Cursor cross
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: / 29.4.1999 / 21:28:42 / cg"
!

crossHair
    "return a crossHair cursor"

    ^ CrossHairCursor

    "
     Cursor crossHair
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:42 / cg"
!

document
    "return a document cursor (dragging a document)"

    ^ DocumentCursor

    "
     Cursor document
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: / 23.10.1997 / 00:27:08 / cg"
    "Created: / 19.5.1998 / 17:17:53 / cg"
!

down
    "Answer the instance of me that is the shape of a down-arrow."

    ^ DownCursor

    "
     Cursor down
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:34 / cg"
!

downLimitArrow
    "return a down-arrow-to-limit cursor"

    ^ DownLimitCursor

    "
     Cursor downLimitArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:29 / cg"
!

execute
    "return a execute cursor - (the default here is a wait-cursor)"

    ^ XeqCursor

    "
     Cursor execute
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:19 / cg"
!

eye 
    "return an eye cursor"

    ^ EyeCursor

    "
     Cursor eye
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:06 / cg"
!

eyeClosed 
    "return an eye cursor"

    ^ ClosedEyeCursor

    "
     Cursor eyeClosed
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:26:06 / cg"
!

folder
    "return a folder cursor (dragging a folder)"

    ^ FolderCursor

    "
     Cursor folder
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: / 23.10.1997 / 00:27:08 / cg"
    "Created: / 19.5.1998 / 17:18:17 / cg"
!

fourWay 
    "return a four-way arrow cursor"

    ^ FourWayCursor

    "
     Cursor fourWay
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:25:34 / cg"
!

hand
    "return a hand cursor"

    ^ HandCursor

    "
     Cursor hand
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:25:07 / cg"
!

left
    "Answer the instance of me that is the shape of an arrow facing to the left."

    ^ LeftCursor

    "
     Cursor left
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:24:51 / cg"
!

leftHand
    "return a left-hand cursor"

    ^ LeftHandCursor ? HandCursor

    "
     Cursor leftHand
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: / 3.5.1999 / 18:54:52 / cg"
!

leftLimitArrow
    "return a left-arrow-to-limit cursor"

    ^ LeftLimitCursor

    "
     Cursor leftLimitArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:24:14 / cg"
!

leftRightArrow
    "return a left-right-arrow cursor"

    ^ LeftRightArrowCursor

    "
     Cursor leftRightArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:23:59 / cg"
!

marker
    "Answer the instance of me that is the shape of a horizontal arrow."

    ^ MarkerCursor

    "
     Cursor marker
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:23:33 / cg"
!

normal
    "return the normal cursor; an arrow.
     for ST-80 compatibility"

    ^ NormalCursor


    "
     Cursor normal
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:23:12 / cg"
!

origin
    "return an origin cursor"

    ^ OriginCursor

    "
     Cursor origin
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:22:58 / cg"
!

questionMark
    "return a question-mark cursor"

    ^ QuestionMarkCursor

    "
     Cursor questionMark
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: / 30.4.1999 / 10:14:52 / cg"
!

read
    "return a reading-file cursor (the default here is a wait-cursor)"

    ^ ReadCursor

    "
     Cursor read
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:22:23 / cg"
!

right
    "Answer the instance of me that is the shape of an arrow facing to the right."

    ^ RightCursor

    "
     Cursor right
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:22:05 / cg"
!

rightLimitArrow
    "return a right-arrow-to-limit cursor"

    ^ RightLimitCursor


    "
     Cursor rightLimitArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:15:12 / cg"
    "Created: 23.10.1997 / 00:21:21 / cg"
!

stop
    "return a stop cursor (the default here is a wait-cursor)"

    ^ StopCursor

    "
     Cursor stop
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:20:52 / cg"
!

text
    "return a text-cursor"

    ^ NormalCursor    
"/    ^ TextCursor

    "
     Cursor text
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:20:37 / cg"
!

thumbsDown
    "return a hand cursor - ST-80 compatibility"

    ^ ThumbsDownCursor

    "
     Cursor thumbsDown
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:20:20 / cg"
!

thumbsUp
    "return a hand cursor - ST-80 compatibility"

    ^ ThumbsUpCursor

    "
     Cursor thumbsUp
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:20:04 / cg"
!

topLeft 
    "return a top-left corner cursor"

    ^ self origin

    "
     Cursor topLeft
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:19:50 / cg"
!

topRight 
    "return a top-right corner cursor"

    ^ TopRightCornerCursor

    "
     Cursor topRight
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:19:33 / cg"
!

up
    "Answer the instance of me that is the shape of an up-arrow."

    ^ UpCursor

    "
     Cursor up
	showWhile:[ Delay waitForSeconds:5 ]
    "

    "Modified: 23.10.1997 / 00:19:14 / cg"
!

upDownArrow
    "return an up-down-arrow cursor"

    ^ UpDownArrowCursor

    "
     Cursor upDownArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:18:53 / cg"
!

upLeftArrow
    "return an up-right-arrow cursor"

    ^ NormalCursor

    "
     Cursor upLeftArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:18:37 / cg"
!

upLimitArrow
    "return an up-arrow-to-limit cursor"

    ^ UpLimitCursor

    "
     Cursor upLimitArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:18:19 / cg"
!

upRightArrow
    "return an up-right-arrow cursor"

    ^ NormalCursor
"/    ^ UpRightArrowCursor

    "
     Cursor upRightArrow
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:18:03 / cg"
!

upRightHand
    "return an up-right-hand cursor"

    ^ UpRightHandCursor

    "
     Cursor upRightHand
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:17:46 / cg"
!

wait
    "return a wait cursor"

    ^ WaitCursor

    "
     Cursor wait
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:17:32 / cg"
!

write
    "return a writing-file cursor (the default here is a wait-cursor)"

    ^ WriteCursor

    "
     Cursor write
        showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:17:22 / cg"
!

xMarker
    "Answer the instance of me that is displayed when thumb-scrolling on the x-axis."

    ^ XMarkerCursor

    "
     Cursor xMarker
	showWhile:[ Delay waitForSeconds:3 ]
    "

    "Modified: 23.10.1997 / 00:16:44 / cg"
! !

!Cursor class methodsFor:'styles'!

disableThumbsCursors

    ThumbsUpCursor := NormalCursor.
    ThumbsDownCursor := NormalCursor.

    "
        self initializeNewCursors.
        self disableThumbsCursors.
    "
! !

!Cursor methodsFor:'ST-80 displaying'!

displayOn:aGC at:origin clippingBox:aRectangle rule:aRule mask:aMask
    "ST-80 compatibility;
     limited functionality: can only display bitmap cursors (yet)"

    sourceForm notNil ifTrue:[
	sourceForm displayOn:aGC at:origin clippingBox:aRectangle 
			rule:aRule mask:aMask
    ]
!

show
    "ST-80 mimicri: change cursors in active groups views to the receiver."

    |wg|

    (wg := WindowGroup activeGroup) notNil ifTrue:[
	wg showCursor:self
    ]

    "Modified: 13.1.1997 / 20:10:01 / cg"
!

showIn:aView 
    "ST-80 mimicri: install the receiver as aViews cursor"

    aView cursor:self
!

showIn:aView while:aBlock
    "ST-80 mimicri: change aView's cursors to the receiver, while evaluationg aBlock.
     Return the value as returned by aBlock."

    |savedCursor|

    savedCursor := aView cursor.
    aView cursor:self.
    ^ aBlock ensure:[aView cursor:savedCursor]
!

showWhile:aBlock
    "ST-80 mimicri: change all views cursors to the receiver.
     Return the value as returned by aBlock."

    |wg|

    (wg := WindowGroup activeGroup) notNil ifTrue:[
        ^ wg withCursor:self do:aBlock
    ].
    ^ aBlock value

    "Modified: / 28.9.1998 / 12:56:59 / cg"
! !

!Cursor methodsFor:'accessing'!

device
    "return the device I am associated with"

    ^ device
!

extent
    sourceForm notNil ifTrue:[^ sourceForm extent].
    ^ 16@16
!

foreground:fgColor background:bgColor
    "set the cursor colors"

    device colorCursor:cursorId foreground:fgColor background:bgColor
!

graphicsDevice
    "same as #device, for ST-80 compatibility naming.
     Return the device I am associated with."

    ^ device

    "Created: 28.5.1996 / 18:39:01 / cg"
!

hotX
    "return the hotspots x-coordinate of the receiver"

    ^ hotX
!

hotY
    "return the hotspots y-coordinate of the receiver"

    ^ hotY
!

id
    "return the cursors deviceId"

    ^ cursorId
!

maskForm
    "return the mask-form of the receiver"

    ^ maskForm
!

maskForm:aForm
    "set the mask-form of the receiver"

    maskForm := aForm
!

shape
    "return the shape"

    ^ shape
!

sourceForm
    "return the source-form of the receiver"

    ^ sourceForm
!

sourceForm:aForm
    "set the source-form of the receiver"

    sourceForm := aForm
! !

!Cursor methodsFor:'copying'!

postCopy
    sourceForm := sourceForm copy.
    maskForm := maskForm copy.
    device := cursorId := nil
!

postDeepCopy
    device := cursorId := nil
! !

!Cursor methodsFor:'creating a device cursor'!

on:aDevice
    "create a new Cursor representing the same cursor as
     myself on aDevice; if one already exists, return the one"

    "/ send out a warning: #on: is typically used to create views
    "/ operating on a model.
    "/ Please use #onDevice: to avoid confusion.

    <resource:#obsolete>

    self obsoleteMethodWarning:'use #onDevice:'.
    ^ self onDevice:aDevice

    "Modified: 5.6.1997 / 21:04:35 / cg"
!

onDevice:aDevice
    "create a new Cursor representing the same cursor as
     myself on aDevice; if one already exists, return the one"

    |newCursor|

    "if I am already assigned to that device ..."
    (device == aDevice) ifTrue:[^ self].

    aDevice isNil ifTrue:[
        ^ self
    ].

    "first look if not already there"
    aDevice deviceCursors do:[:aCursor |
        shape notNil ifTrue:[
            (aCursor shape == shape) ifTrue:[
                ^ aCursor
            ]
        ] ifFalse:[
            (aCursor sourceForm == sourceForm) ifTrue:[
                (aCursor maskForm == maskForm) ifTrue:[
                    (aCursor hotX == hotX) ifTrue:[
                        (aCursor hotY == hotY) ifTrue:[
                            ^ aCursor
                        ]
                    ]
                ]
            ]
        ]
    ].

    device isNil ifTrue:[
        newCursor := self
    ] ifFalse:[
        newCursor := self shallowCopy.
        newCursor setDevice:nil id:nil.
    ].
    ^ newCursor allocateOnDevice:aDevice

    "Modified: 5.7.1996 / 17:58:00 / cg"
    "Created: 28.3.1997 / 13:46:38 / cg"
! !

!Cursor methodsFor:'instance release'!

executor
    "redefined to return a lightweight copy 
     - all we need is the device handle"

    ^ self class basicNew setDevice:device id:cursorId

    "Modified: 20.4.1996 / 23:23:19 / cg"
!

finalize
    "some Cursor has been collected - tell it to the display"

    |id dev|

    (id := cursorId) notNil ifTrue:[
        (dev := device) notNil ifTrue:[
            cursorId := device := nil.
            dev destroyCursor:id.
        ]
    ]
!

releaseFromDevice
    "I am no longer available on the device"

    sourceForm notNil ifTrue:[sourceForm releaseFromDevice].
    maskForm notNil ifTrue:[maskForm releaseFromDevice].
    cursorId := device := nil.
! !

!Cursor methodsFor:'printing'!

printOn:aStream
    "append a printed representation to aStream"

    self className printOn:aStream.
    aStream nextPut:$(.
    shape printOn:aStream.
    aStream nextPut:$).
! !

!Cursor methodsFor:'private'!

allocateOnDevice:aDevice
    "allocate a device-cursor-resource for me on aDevice"

    |id sF mF w h deviceSf deviceMf|

    device notNil ifTrue:[
        self error:'cursor is already assigned to a device' mayProceed:true.
        device unregisterCursor:self.
        device := cursorId := nil.
    ].

    "ask that device for the cursor"
    shape notNil ifTrue:[
        id := aDevice createCursorShape:shape.
        id isNil ifTrue:[
            sourceForm isNil ifTrue:[
                "/ no fallBack form provided ...
                'Cursor [warning]: no cursor with shape:' errorPrint. 
                shape errorPrint. ' on device ' errorPrint. aDevice errorPrintCR.
                ^ self
            ]
        ].
    ].
    id isNil ifTrue:[
        aDevice needDeviceFormsForCursor ifTrue:[
            sourceForm notNil ifTrue:[
                sF := deviceSf := sourceForm asFormOn:aDevice.
            ].
            maskForm notNil ifTrue:[
                mF := deviceMf := maskForm asFormOn:aDevice.
            ] ifFalse:[
                mF := sF
            ].
        ] ifFalse:[
            sourceForm notNil ifTrue:[
                sF := sourceForm bits.
                deviceSf := sourceForm.
            ].
            maskForm notNil ifTrue:[
                mF := maskForm bits.
                deviceMf := maskForm.
            ] ifFalse:[
                mF := sF
            ].
        ].
        (sF isNil or:[mF isNil]) ifTrue:[
            'Cursor [warning]: cursor has no form' errorPrintCR.
            ^ self
        ].
        w := sourceForm width.
        h := sourceForm height.
        id := aDevice 
                createCursorSourceForm:sF
                maskForm:mF
                hotX:hotX hotY:hotY
                width:w height:h.

        id isNil ifTrue:[
            'Cursor [warning]: cannot create pixmap cursor' errorPrintCR.
            ^ self
        ].
    ].

    "goody for IRIXs red cursor"
    DefaultFgColor notNil ifTrue:[
        aDevice colorCursor:id foreground:DefaultFgColor
                               background:DefaultBgColor
    ].

    device := aDevice.
    cursorId := id.
    sourceForm := deviceSf.
    maskForm := deviceMf.

    "must register"
    device registerCursor:self.
    ^ self
!

device:aDevice
    "set the cursors device"

    device := aDevice
!

id:anId
    "set the cursors id"

    cursorId := anId
!

restored
    "set both device and id"

    device := nil.
    cursorId := nil
! !

!Cursor methodsFor:'private-accessing'!

setDevice:aDevice id:anId
    "set the device and deviceId of the receiver"

    device := aDevice.
    cursorId := anId
!

setHotX:hx hotY:hy
    "set the hotspot"

    hotX := hx.
    hotY := hy.
!

setShape:aShapeSymbol
    "set the shape"

    shape := aShapeSymbol.
!

setSourceForm:sForm maskForm:mForm hotX:hx hotY:hy
    "set the forms and hotspot"

    sourceForm := sForm.
    maskForm := mForm.
    hotX := hx.
    hotY := hy.
! !

!Cursor methodsFor:'queries'!

isAnimatedCursor
    ^ false

    "Created: 26.6.1997 / 11:12:48 / cg"
! !

!Cursor class methodsFor:'documentation'!

version
    ^ '$Header$'
!

version_CVS
    ^ '$Header$'
! !


Cursor initialize!
