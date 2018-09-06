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

View subclass:#PieChartWidget
	instanceVariableNames:'middlePoint radX radY anzahl summe aod aoHilf foregroundColor
		backgroundColor pieChartName style newfont oldfont rF'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

PieChartWidget comment:'hallo erstmal...
'
!

!PieChartWidget class methodsFor:'documentation'!

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
    This is a demo widget programmed as a learning experience...

    hallo erstmal...

    a simple PieChart,
    (zeigt ein Tortendiagramm, wobei die Stücke jedoch nicht essbar sind.)

    The model is a collection of chart description items,
    each being a dictionary filled with entries for:
        #value  aNumber         the numeric value
        #color  aColor          the color

    see example on how to fill such a chartDescription model.

    [author:]
        Timo Merkert (tm@idefix)

    [see also:]
        BarChartWidget ChartDescription

    [instance variables:]
    middlePoint,        only for the point in the middle => therefore middlepoint
    radX                radian for x-coordinate
    radY                radian for y-coordinate
    anzahl              number of pie-pieces
    summe               result of all values
    aod                 Array of Dictionaries
    aoHilf              Array with help coordinates
    foregroundColor     text color for percent displaying
    backgroundColor     background color of pie chart
    label1              name of pie chart
"
!

examples
"
                                                                [exBegin]
        |p chart piece holder|

        chart := OrderedCollection new.
        piece := Dictionary new.
        piece at:#value put:50.
        piece at:#color put:Color red.
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:100.
        piece at:#color put:Color blue.
        chart add:piece.

        p := PieChartWidget new.
        p model:(holder := ValueHolder new).
        p extent:300@300.
        p pieChartName:'demo PieChart'.
        p open.
        holder value:chart.
        Delay waitForSeconds:2.

        1 to: 5 do:[:i |
            piece := Dictionary new.
            piece at:#value put:30.

            piece at:#color put:(i odd ifTrue:[Color green] 
                                       ifFalse:[Color magenta]).
            chart add:piece.

            holder value:nil.
            holder value:chart.
        ]
                                                                [exEnd]
"
! !

!PieChartWidget methodsFor:'accessing'!

anzahl
    "return the value of the instance variable 'anzahl' (automatically generated)"

    ^ anzahl
!

anzahl:something
    "set the value of the instance variable 'anzahl' (automatically generated)"

    anzahl := something.
!

aoHilf
    "return the value of the instance variable 'aoHilf' (automatically generated)"

    ^ aoHilf
!

aoHilf:something
    "set the value of the instance variable 'aoHilf' (automatically generated)"

    aoHilf := something.
!

aod
    "return the value of the instance variable 'aod' (automatically generated)"

    ^ aod
!

aod:something
    "set the value of the instance variable 'aod' (automatically generated)"

    aod := something.
!

label
    ^ self pieChartName
!

label:aString
    self pieChartName:aString
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

model:newModel
    super model:newModel.
    self update:nil with:nil from:model.
!

newfont
    "return the value of the instance variable 'newfont' (automatically generated)"

    ^ newfont
!

newfont:something
    "set the value of the instance variable 'newfont' (automatically generated)"

    newfont := something.
!

oldfont
    "return the value of the instance variable 'oldfont' (automatically generated)"

    ^ oldfont
!

oldfont:something
    "set the value of the instance variable 'oldfont' (automatically generated)"

    oldfont := something.
!

pieChartName
    "return the value of the instance variable 'pieChartName' (automatically generated)"

    ^ pieChartName
!

pieChartName:something
    "set the value of the instance variable 'pieChartName' (automatically generated)"

    pieChartName := something.
!

rF
    "return the value of the instance variable 'rF' (automatically generated)"

    ^ rF
!

rF:something
    "set the value of the instance variable 'rF' (automatically generated)"

    rF := something.
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

style
    "return the value of the instance variable 'style' (automatically generated)"

    ^ style
!

style:something
    "set the value of the instance variable 'style' (automatically generated)"

    style := something.
!

summe
    "return the value of the instance variable 'summe' (automatically generated)"

    ^ summe
!

summe:something
    "set the value of the instance variable 'summe' (automatically generated)"

    summe := something.
! !

!PieChartWidget methodsFor:'accessing-color & font'!

backgroundColor
    "return the value of the instance variable 'backgroundColor' (automatically generated)"

    ^ backgroundColor
!

backgroundColor:something
    "set the value of the instance variable 'backgroundColor' (automatically generated)"

    backgroundColor := something.
!

foregroundColor
    "return the value of the instance variable 'foregroundColor' (automatically generated)"

    ^ foregroundColor
!

foregroundColor:something
    "set the value of the instance variable 'foregroundColor' (automatically generated)"

    foregroundColor := something.
! !

!PieChartWidget methodsFor:'change & update'!

delayedUpdateModel
    aod := model value.
    self invalidate
!

update:something with:aParameter from:changedObject
    |sensor|

    changedObject == model ifTrue:[
        (sensor := self sensor) notNil ifTrue:[
            (sensor hasUserEvent:#delayedUpdateModel for:self) ifFalse:[
                sensor pushUserEvent:#delayedUpdateModel for:self
            ]
        ]
    ]
! !

!PieChartWidget methodsFor:'drawing'!

drawLogo
    |chart piece|
    "put demo values into model"

    model isNil ifTrue:[

        chart := OrderedCollection new.
        piece := Dictionary new.
        piece at:#value put:3.
        piece at:#color put:(Color green).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:5.
        piece at:#color put:(Color red).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:4.
        piece at:#color put:(Color blue).
        chart add:piece.
        self model:chart
    ].
!

drawLogo2
    |x y w h startAngle endAngle|
    "zeichnet den pie-Umfang"

    model isNil ifTrue:[
        x := 0 - radX.
        y := 0 - radY.
        w := h := (radX*2 ).
        endAngle := 120.
        startAngle := 90.
        self paint:Color blue.
        self fillArcX:x  y:y  width:w  height:h
                 from:startAngle  angle:endAngle.
        startAngle := startAngle + endAngle.
        self paint:Color red.
        self fillArcX:x  y:y  width:w  height:h
                 from:startAngle  angle:endAngle.
        startAngle := startAngle + endAngle.
        self paint:Color green.
        self fillArcX:x  y:y  width:w  height:h
                 from:startAngle  angle:endAngle.
    ].
    "Umriss nachzeichnen"
    self lineWidth:2.
    self paint:Color black.
    self displayCircle:0@0 radius:radX.
!

drawPercentDescription
    |x y str count angle stringHeight stringWidth font|
    "Prozentausgabe der Diagrammstücke"
    count := 1.
    self paint:backgroundColor.             "Zeichenfarbe für Schrift"
    font := gc font.

    [count <= anzahl] whileTrue:[
        str := ((aoHilf at:count) at:#prozent) rounded printString.
        str := str ,'%'.
        stringWidth := (font widthOf:str)//2.
        stringHeight := (font heightOf:str)//2.
        rF := stringWidth max:stringHeight.

        angle := ((aoHilf at:count) at:#pos).
        x := ((radX * 1.1 + rF) * ((angle degreesToRadians) cos)) asInteger.
        y := ((radY * 1.1 + rF) * ((angle degreesToRadians) sin) negated) asInteger.

        self displayString:str  x:(x-stringWidth)  y:(y+stringHeight).
"/        self displayCircle:(0@0) radius:radX*1.1+rF.
"/        self displayCircle:(0@0) radius:radY*1.1+rF.

        count := count +1
    ].

    "Modified (format): / 04-05-2017 / 18:21:00 / mawalch"
!

drawPieChart

    self getAnzahl.             "get number of pieces"
    anzahl > 0 ifTrue:[         "is there a number?"

        "transformiere den Punkt 0@0 zum Mittelpunkt"
        self transformation:(WindowingTransformation scale:1 
                translation:((middlePoint x) @ (middlePoint y)) ).
        "Mittelpunkt ist jetzt 0@0"


"/        aod isNil ifTrue:[
"/            self halt.              "draw Demo"
"/        ].


        self getSumme.                 "get sum of all values"
        self fillAod.                   "put values in helpDictionary"

        self drawPiePieces.             "draw pie pieces"
        self drawPercentDescription.    "draw percents"

        self transformation:nil.        "switch off Transformation"

        self writeLabel.
    ]
    ifFalse:[
        self drawLogo.                  "draw DemoPieChart"
    ].

    "Modified: / 04-05-2017 / 18:29:20 / mawalch"
!

drawPiePieces
    "draw a filled arc in a box, given startAngle and endAngle."
    |x y w h rad startAngle endAngle count clr rgb str stringHeight stringWidth orgLineWidth|

    x := 0 - radX.
    y := 0 - radY.
    w := h := (radX*2 ).
    rad := 2*radX.
    startAngle := 0.
    count := 1.

    [count <= anzahl]
    whileTrue:[
        startAngle := ((aoHilf at:count) at:#start).
        endAngle   := ((aoHilf at:count) at:#end).

        clr := ((aod at:count) at:#color).
        self paint:clr.

        self fillArcX:x  y:y  width:w  height:h
             from:startAngle  angle:endAngle.

"/        "Umriss nachzeichnen"
"/        orgLineWidth := (self lineWidth).
"/        self lineWidth:2.
"/        self paint:backgroundColor.
"/        self displayArcX:x  y:y  width:w  height:h
"/             from:startAngle  angle:endAngle.
"/        self lineWidth:orgLineWidth.

        count := count + 1.
    ].
!

redrawPieChart
    |stringHeight stringWidth maxSpacing maxRad w h|

    w := self width.
    h := self height.

    "/ compute spacing need for my used font.
    stringWidth := (gc font widthOf:'87%') rounded.
    stringHeight := stringWidth.
    maxSpacing := stringWidth max: stringHeight.

    radX := ((w / 2) - maxSpacing) rounded.
    radY := ((h - maxSpacing) / 2 - maxSpacing) rounded.

    maxRad := radX max: radY.
    radX := maxRad.
    radY := maxRad.

    middlePoint := ((w @ h) / 2) rounded.

    self drawPieChart
!

writeLabel
    |x stringWidth stringHeight|

    pieChartName isNil ifTrue:[pieChartName := 'chart'].
    x := middlePoint x.
    self paint:foregroundColor.
    stringWidth := (gc font widthOf:pieChartName)//2.
    stringHeight := gc font heightOf:pieChartName.
    self displayString:pieChartName x:(x-stringWidth) y:stringHeight.



! !

!PieChartWidget methodsFor:'event handling'!

redrawX:x y:y width:w height:h
    |savClip|

    savClip := self clippingBounds.
    self paint:viewBackground.
    self fillRectangleX:x y:y width:w height:h.
    self redrawPieChart.
    self clippingBounds:savClip.
!

sizeChanged:how
    super sizeChanged:how.
    self clear.
    self redrawPieChart
! !

!PieChartWidget methodsFor:'hooks'!

postBuildWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the widgets have been built, but before the view is opened"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    |view|

    view := (aBuilder componentAt:#PieChartView).
    view := view scrolledView.

"/    super postBuildWith:aBuilder
! !

!PieChartWidget methodsFor:'initialization'!

initialize
    super initialize.
    "initialisierung und sein Kind"

    middlePoint := Point new.
    middlePoint:= 0@0.
    anzahl     := 0.
    aod        :=0.
    summe      := 0.
    pieChartName := 'chart'.
    backgroundColor := Color black.
    foregroundColor := Color black.

     "
      self initialize
     "

    "Modified: / 11-09-2006 / 16:09:55 / User"
! !

!PieChartWidget methodsFor:'private'!

fillAod
    "fills the Dictionaries in Array with Values"
    "anzahl und summe sind bereits bekannt"
    |count pro start angle test pos|

    "Array mit Hilfwerten anlegen"
    aoHilf := Array new:(aod size).
    1 to:(aod size) do:[:elem| aoHilf at:elem put:Dictionary new ].

    start := 90.  
    count := 1.
    [count <= anzahl]
    whileTrue:[ 
       "prozentualer Anteil ermitteln"
        pro := ( 100 /summe * ((aod at:count) at:#value) ).
        "prozentanteil eintragen"
        (aoHilf at:count) at:#prozent put:pro.
        "Endwinkel ermitteln"
        angle := ( pro * 360 / 100 ).
        start := start - angle.
        start < 0 ifTrue:[
            start := 360 - (start abs).
        ].

        "Startwinkel eintragen"
        (aoHilf at:count) at:#start put:start.
        "Endwinkel eintragen"
        (aoHilf at:count) at:#end put:angle.

        "Textposition eintragen"
        pos := start+(angle/2).
        (aoHilf at:count) at:#pos put:pos.

        count := count +1.
    ].
!

getAnzahl
    "ermittelt die Anzahl der belegten Diagrammstücke"

    "/ cg (critic):
    "/ same as:
    "/  anzahl := aod findLast:[:a | (aod at:count) includesKey:#value]
    "/ but I guess, findFirst: was actually the intention???

    |count|

    anzahl := 0.

    count:=1.
    [(count <= (aod size))] whileTrue:[ 
        ((aod at:count) includesKey:#value) ifTrue:[ anzahl := count ].
        count := count +1 
    ].

    "Modified (comment): / 04-05-2017 / 19:09:25 / mawalch"
!

getSumme
    "initialisiert die Instanzvariable summe mit der Gesammtsumme"
    |count|
    summe := 0.
    count := 0.
    aod isNil ifTrue:[^ self].

    [count < anzahl]
    whileTrue:[ 
        count := count +1.
        summe := summe + ((aod at:count) at:#value).
    ].

    "Created: / 04-05-2017 / 18:35:30 / mawalch"
! !

!PieChartWidget methodsFor:'views'!

getPieChartWidget
    |v|
    v := PieChartWidget new.
    ^v 
! !

!PieChartWidget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/PieChartWidget.st,v 1.20 2017-11-28 18:27:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/PieChartWidget.st,v 1.20 2017-11-28 18:27:44 cg Exp $'
! !

