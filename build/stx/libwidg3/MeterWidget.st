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

View subclass:#MeterWidget
	instanceVariableNames:'meterHolder meterWert middlePoint pEndPoint startNumber endNumber
		radX radY startAngle endAngle meterName tmp cChassis cBackgr
		cPointer cNumber cScale cName'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

MeterWidget comment:'hallo erstmal...
'
!

!MeterWidget class methodsFor:'documentation'!

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
    hallo erstmal ...

    a simple fun-view,
    zeigt eine Meter-Uhr wie z.B. ein Tachometer oder so.
    The model is a simple valueHolder, holding a number.
    This widget can be used as what ever you want.
    You can change the label as miles/h or simple as 'speed'.
    You can change all Colors which are used by this view.

    [author:]
        Timo Merkert (tm@exept.de)

    [see also:]


    [instance variables:]
    all color variables,
      cChassis, cBackgr, cPointer, cNumber, cScale, cName

    meterHolder for the valueHolder
    meterWert   for the value who needw the widget to compute the pEndPoint
    middlePoint is the middlePoint of the widget
    pEndPoint   is the position of the pointer
    startNumber is the startnumber of the scale (always 0)
    endNumber   is the endnumber of the scale (always 100)
    radX        is the radian of the widget
    radY        same as radX
    startAngle  is the startangle of the scale (0 is horizontal right)
    endAngle    is the different between startangle and endangle (im Uhrzeigersinn)
    meterName   is the label name
    tmp         is the old pointerPosition for delete the pointer

"
!

examples
"
                                                                [exBegin]
        MeterWidget new open
                                                                [exEnd]
"
! !

!MeterWidget methodsFor:'accessing'!

endAngle
    "return the value of the instance variable 'endAngle' (automatically generated)"

    endAngle isNil ifTrue:[ endAngle := 270 ].
    ^ endAngle
!

endAngle:something
    "set the value of the instance variable 'endAngle' is -delta to startangle (always 270)"

    "/endAngle := something.
    endAngle := 270.

    "Modified (comment): / 07-06-2017 / 18:17:38 / mawalch"
!

endNumber
    "return the value of the instance variable 'endNumber' (automatically generated)"

    endNumber isNil ifTrue:[ endNumber := 100 ].
    ^ endNumber
!

endNumber:something
    "set the value of the instance variable 'endNumber' (always 100)"

    "/endNumber := something.
    endNumber := 100.

    "Modified (comment): / 07-06-2017 / 18:17:45 / mawalch"
!

meterHolder
    "return the value of the instance variable 'meterHolder' (automatically generated)"

    meterHolder isNil ifTrue:[
        meterHolder :=  ValueHolder new value:0.
    ].
    ^ meterHolder
!

meterHolder:something
    "set the value of the instance variable 'meterHolder' (automatically generated)"

    meterHolder notNil ifTrue:[
        meterHolder retractInterestsFor:self.
    ].

    meterHolder := something.
    meterHolder notNil ifTrue:[
        meterHolder onChangeSend:#newdrawPointer to:self.
    ]
!

meterName
    "return the value of the instance variable 'meterName' (automatically generated)"

    meterName isNil ifTrue:[ meterName := 'how much' ].
    ^ meterName
!

meterName:something
    "set the value of the instance variable 'meterName' (automatically generated)"
    meterName := something.

    shown ifTrue:[
        self clear.
        self redrawSpeed.
    ]
!

middlePoint
    "return the value of the instance variable 'middlePoint' (automatically generated)"

    ^ middlePoint
!

middlePoint:aPoint
    "set the value of the instance variable 'middlePoint' (automatically generated)"

    middlePoint x: (aPoint x).
    middlePoint y: (aPoint y)

!

pEndPoint
    "return the value of the instance variable 'pEndPoint' (automatically generated)"

    ^ pEndPoint
!

pEndPoint:aPoint
    "set the value of the instance variable 'pEndPoint' (automatically generated)"

    pEndPoint x: (aPoint x).
    pEndPoint y: (aPoint y)
!

pEndPointX:xP y:yP
    "set the value of the instance variable 'pEndPoint' (automatically generated)"

    pEndPoint x: (xP).
    pEndPoint y: (yP)

!

radX
    "return the value of the instance variable 'radX' (automatically generated)"

    ^ radX
!

radX:something
    "set the value of the instance variable 'radX' (automatically generated)"

    radX := something.
!

radY
    "return the value of the instance variable 'radY' (automatically generated)"

    ^ radY
!

radY:something
    "set the value of the instance variable 'radY' (automatically generated)"

    radY := something.
!

startAngle
    "return the value of the instance variable 'startAngle' (automatically generated)"

    startAngle isNil ifTrue:[ startAngle := 225 ].
    ^ startAngle
!

startAngle:something
    "set the value of the instance variable 'startAngle' (always 225)"

    "/startAngle := something.
    startAngle := 225.

    "Modified (comment): / 07-06-2017 / 18:17:50 / mawalch"
!

startNumber
    "return the value of the instance variable 'startNumber' (automatically generated)"

    startNumber isNil ifTrue:[ startNumber := 0 ].
    ^ startNumber
!

startNumber:something
    "set the value of the instance variable 'startNumber' (always 0)"

    "/startNumber := something.
    startNumber := 0.

    "Modified (comment): / 07-06-2017 / 18:17:55 / mawalch"
! !

!MeterWidget methodsFor:'accessing-color & font'!

colorBackgr
    "return the meterViewDisplay background color"

    ^cBackgr





!

colorBackgr:aColor
    "set the meterViewDisplay background color"

    aColor ~= cBackgr ifTrue:[
        cBackgr := aColor.

        shown ifTrue:[
            self invalidateRepairNow:true
        ]
    ].

    "Modified: / 20.7.1998 / 23:32:48 / cg"
!

colorChassis
    "return the meterViewDisplay outline color"

    ^cChassis





!

colorChassis:aColor
    "set the meterViewDisplay outline color"

    aColor ~= cChassis ifTrue:[
        cChassis := aColor.

        shown ifTrue:[
            self invalidateRepairNow:true
        ]
    ].

    "Modified: / 20.7.1998 / 23:32:48 / cg"

!

colorName
    "return the meterViewName color"

    ^cName





!

colorName:aColor
    "set the meterViewName color"

    aColor ~= cName ifTrue:[
        cName := aColor.

        shown ifTrue:[
            self invalidateRepairNow:true
        ]
    ].

    "Modified: / 20.7.1998 / 23:32:48 / cg"

!

colorNumber
    "return the meterViewNumbers color"

    ^cNumber





!

colorNumber:aColor
    "set the meterViewNumber color"

    aColor ~= cNumber ifTrue:[
        cNumber := aColor.

        shown ifTrue:[
            self invalidateRepairNow:true
        ]
    ].

    "Modified: / 20.7.1998 / 23:32:48 / cg"

!

colorPointer
    "return the meterViewPointer color"

    ^cPointer





!

colorPointer:aColor
    "set the meterViewPointer color"

    aColor ~= cPointer ifTrue:[
        cPointer := aColor.

        shown ifTrue:[
            self invalidateRepairNow:true
        ]
    ].

    "Modified: / 20.7.1998 / 23:32:48 / cg"

!

colorScale
    "return the meterViewScale color"

    ^cScale





!

colorScale:aColor
    "set the meterViewScale color"

    aColor ~= cScale ifTrue:[
        cScale := aColor.

        shown ifTrue:[
            self invalidateRepairNow:true
        ]
    ].

    "Modified: / 20.7.1998 / 23:32:48 / cg"

! !

!MeterWidget methodsFor:'aspects'!

meterWert
    "automatically generated by UIPainter ..."

    "*** the code below creates a default model when invoked."
    "*** (which may not be the one you wanted)"
    "*** Please change as required and accept in the browser."

    meterWert isNil ifTrue:[
        meterWert :=  ValueHolder new value:0.
    ].
    ^ meterWert.



!

meterWert:something
    "set the value of the instance variable 'meterWert' (automatically generated)"

    meterWert := something.
! !

!MeterWidget methodsFor:'drawing'!

drawChassis
    "zeichnet den Chassis-Umfang"
    "middlePoint ist Instanzvariable für den Mittelpunkt"
    self paint:cBackgr.
    self fillCircle:middlePoint radius:radX.
    self lineWidth:3.
    self paint:cChassis.
    self displayCircle:middlePoint radius:radX.

    "Modified (comment): / 04-05-2017 / 18:24:14 / mawalch"
!

drawPointer
    "zeichnet den Zeiger, endPoint ist der Wert für die Zeigerstellung"
    "middlePoint ist Instanzvariable für den Mittelpunkt"

    self lineWidth:2.
    self displayLineFrom:((middlePoint x) @ (middlePoint y)) 
                      to:((pEndPoint x) @ (pEndPoint y))

    "Modified (comment): / 04-05-2017 / 18:23:16 / mawalch"
!

drawScale
    "zeichnet die Scala-Einteilung"
    |x y step alpha count len high s oldFont newFont tx ty nx ny| 
    "x und y sind für die Berechnung der x,y-Koordinaten eines Kreispunktes"

    "transformiere den Punkt 0@0 zum Mittelpunkt"
    self transformation:(WindowingTransformation scale:1 
                        translation:((width // 2+1) @ (height // 2+0.5)) ).

    self lineWidth:1.
    self paint:cScale.

    count := 0.
    step := (endAngle /100) asFloat.
    0 to: endAngle by:step do:[:index|
        alpha := startAngle - index.
        x := radX * ((alpha degreesToRadians) cos).
        y := radY * (((alpha degreesToRadians) sin) negated).

        count \\ 5 = 0 ifTrue:[
           self displayLineFromX:(x*0.95)rounded y:(y*0.95)rounded 
                toX:(x*0.85)rounded y:(y*0.85)rounded.
           ]
           ifFalse:[
              self displayLineFromX:(x*0.95)rounded y:(y*0.95)rounded 
                   toX:(x*0.9)rounded y:(y*0.9)rounded.
        ].
        count \\ 10 = 0 ifTrue:[
            ((width min:height) > 80
            or:[count \\ 20 = 0]) ifTrue:[
                s := count printString.     "Zahl nach String umwandeln"

"---------- nur wenn sich die Größe verändert hat -----------------------"
"/                (extentChanged or:[originChanged]) ifTrue:[
                    oldFont := self font.       "neue Schriftgröße vorbereiten"
                    newFont := oldFont asSize:(radX//6).  "neue Schriftgröße"
                    self font:newFont.                  "zuordnen"
                    tx isNil ifTrue:[
                        tx := self fillTableX.
                        ty := self fillTableY.
                    ].

                    nx:= 0-((newFont widthOf:meterName on:device)//2).
                    ny:=(radY*0.8).
                    self paint:cName.
                    self displayString:meterName x:nx y:ny.
                    len := newFont widthOf:s on:device.
                    high := newFont heightOf:s on:device.
"/               ].
"---------- nur wenn sich die Größe verändert hat ende ------------------"

               self paint:cNumber.   "/ (x*1.1)-5
               self displayString:s x:(x+(len*(tx at:(count/10+1)))) 
                                    y:(y+(high*(ty at:(count/10+1)))).
               self paint:cScale.
            ].
        ].

        count := count+1.

    ]."0 to:endAngle"
    self transformation:nil.

    "Modified: / 19-08-1998 / 22:59:57 / cg"
    "Modified (comment): / 04-05-2017 / 18:24:56 / mawalch"
!

drawSpeed
    self drawChassis.
    self drawScale. 
    self newdrawPointer. 


!

newdrawPointer
    "meterWert hat sich verändert, Zeiger löschen und neu zeichnen"
    "um neu zu zeichnen wird die Methode draw Pointer mit Übergabewert für neuen 
     pEndPoint benutzt. pEndPoint ist der Wert für die Zeigerstellung"

    |winkelAnteil alpha rx ry xP yP meterWertShown cPointerShown|

    self shown ifFalse:[^ self].

    rx := radX *0.8.    "Zeigerabstand von Skalierung"
    ry := radY *0.8.

    meterHolder isNil ifTrue:[
            meterWert := 0.
        ]
        ifFalse:[     
            meterWert := meterHolder value ? 0.
       ].
"---Zeiger löschen----------------------------------------------------------------"
    "Zeiger nur löschen, wenn sich der meterHolder verändert hat (tmp~=meterWert)"
    "tmp -> Variable für ValueHoderVeränderung"
    ((tmp ~= meterWert) and:[((tmp) notNil)]) ifTrue:[
        "Zeiger loeschen"
        self paint:cBackgr.             "Hintergrundfarbe als Zeichenfarbe setzen"
        self drawPointer.               "Zeiger löschen"
    ].

    tmp := meterWert.

    cPointerShown := cPointer.
    ((meterWertShown := meterWert) > 100
    or:[meterWertShown < 0]) ifTrue:[
        cPointerShown := Color red.
        meterWertShown := (0 max:meterWertShown) min:100.
    ].

    "meterWert -> 0...100"
    "meterWert nach pEndPoint umrechnen und zuweisen"
    winkelAnteil := 270 * meterWertShown /100.       "prozentualer Winkelanteil von 270 Grad"
    alpha := 225 - winkelAnteil.                "Winkel-Position des Zeigers"
    xP := rx * ((alpha degreesToRadians) cos).  "x-Koordinate des Zeigerpunktes"
    yP := ry * (((alpha degreesToRadians) sin) negated) .  "y-Koordinate des Zeigerpunktes"

    pEndPoint := (middlePoint)+(xP@yP).

    "Zeiger neu zeichnen"
    self paint:cPointerShown.
    self drawPointer.                            "Zeiger mit neuem Wert zeichnen"

    self paint:cPointer.
    self fillCircle:middlePoint radius:3.

    "Modified: / 19-08-1998 / 22:57:14 / cg"
    "Modified (comment): / 04-05-2017 / 19:13:11 / mawalch"
!

redrawSpeed
    (middlePoint isMemberOf:Point) ifFalse:[ 
        pEndPoint := Point new.
    ].

    meterName isNil ifTrue:[
       meterName := 'how much'
    ].

    startAngle := 225.
    endAngle := 270.    "Delta Endwinkel"    

    self drawSpeed

    "Modified: / 19.8.1998 / 22:52:33 / cg"
! !

!MeterWidget methodsFor:'event handling'!

redrawX:x y:y width:w height:h

    self clear.
    self redrawSpeed.

"/    |savClip|
"/
"/    shown ifFalse:[
"/
"/        ^ self
"/    ].
"/
"/    self paint: bgColor.
"/    self fillRectangleX:x y:y width:w height:h.
"/
"/    savClip := clipRect.
"/    self clippingRectangle:(Rectangle left:x top:y width:w height:h).
"/
"/    self redrawSpeed.
"/
"/    self clippingRectangle:savClip.

!

sizeChanged:how
    super sizeChanged:how.
    self initializeVariables.
    self invalidate.

    "Modified: / 11.2.2000 / 00:40:31 / cg"
! !

!MeterWidget methodsFor:'hooks'!

postBuildWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the widgets have been built, but before the view is opened"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    |view|
    cChassis value: Color black.
    cBackgr  value: Color gray.
    cPointer value: Color black.
    cNumber  value: Color green.
    cScale   value: Color blue.
    cName    value: Color red.

"/    pEndPoint  value: (((self width) *0.2) @ ((self height)*0.7)).
"/    scaleBegin value: 220.              "Startwinkel"
"/    scaleEnd   value: -270.             "Delta Endwinkel"
"/    endNumber  value: 100.              "0...100"

    view := (aBuilder componentAt:#meterView).
    view := view scrolledView.

"/    super postBuildWith:aBuilder
! !

!MeterWidget methodsFor:'initialization'!

initialize
    super initialize.

    cChassis := Color red.
    cBackgr  := viewBackground.
    cPointer := Color black.
    cNumber  := Color black.
    cScale   := Color blue.
    cName    := Color green.
    meterName := 'speed'.

    self initializeVariables.
!

initializeVariables
    "Instanzvariablen initialisieren"
    radX := ( (self width /2 ) * 0.8 ) rounded.
    radY := ( (self height /2) * 0.8 ) rounded.

    "maximaler radius ermitteln"
    radX > radY ifTrue:[        
        radX := radY.
    ].
    radY := radX.

    middlePoint := ((width@height) / 2) rounded.
!

start:begin stop:end
    "Defaultwerte der Scala - Beginn - und Endnummer -> 0 ... 100"
    begin isNil ifTrue:[ startNumber := 0
                ]
                ifFalse:[ 
                          "/ startNumber := begin
                ].

    end isNil ifTrue:[ endNumber := 100
              ]
              ifFalse:[ "/ endNumber := end
              ].
! !

!MeterWidget methodsFor:'private'!

fillTableX                 
    |tableX|
    tableX := Array new:11.
    tableX at:1 put:-1.
    tableX at:2 put:-1.
    tableX at:3 put:-1.
    tableX at:4 put:-1.
    tableX at:5 put:-3/4.
    tableX at:6 put:-1/2.
    tableX at:7 put:-1/4.
    tableX at:8 put:0.
    tableX at:9 put:0.
    tableX at:10 put:0.
    tableX at:11 put:0.

    ^ tableX
!

fillTableY
    |tableY|
    tableY := Array new:11.
    tableY at:1 put:1.
    tableY at:2 put:3/4.
    tableY at:3 put:1/2.
    tableY at:4 put:1/4.
    tableY at:5 put:0.
    tableY at:6 put:0.
    tableY at:7 put:0.
    tableY at:8 put:1/4.
    tableY at:9 put:1/2.
    tableY at:10 put:3/4.
    tableY at:11 put:1.

    ^ tableY
! !

!MeterWidget methodsFor:'views'!

getMeterWidget
    |v|
    v := MeterWidget new.
    v start:0 stop:100.
    v paint: Color gray.
    ^v 
! !

!MeterWidget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/MeterWidget.st,v 1.25 2017-11-28 18:27:08 cg Exp $'
! !

