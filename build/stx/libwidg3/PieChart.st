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

AbstractChart subclass:#PieChart
	instanceVariableNames:'middlePoint radX radY summe foregroundColor backgroundColor
		pieChartName style newfont oldfont rF'
	classVariableNames:''
	poolDictionaries:''
	category:'Statistic-Charts'
!

!PieChart class methodsFor:'documentation'!

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
"   hallo erstmal...

    a simple PieChart, 
    (zeigt ein Tortendiagramm, wobei die Stücke jedoch nicht essbar sind.)

    The model is a collection of chart description items,
    each being a dictionary filled with entries for:
        #value  aNumber         the numeric value
        #color  aColor          the color

    see example on how to fill such a chartDescription model.

    This was one of the author's very first Smalltalk programs ever.
    So please excuse any odd code.

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
        piece at:#color put:(Color red onDevice:Display).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:100.
        piece at:#color put:(Color blue onDevice:Display).
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

            piece at:#color put:(i odd ifTrue:[Color green onDevice:Display] 
                                       ifFalse:[Color magenta onDevice:Display]).
            chart add:piece.

            holder value:nil.
            holder value:chart.
        ]
                                                                [exEnd]

                                                                [exBegin]
        |p chart piece holder v|

        chart := OrderedCollection new.
        piece := Dictionary new.
        piece at:#value put:50.
        piece at:#color put:(Color red onDevice:Display).
        chart add:piece.

        piece := Dictionary new.
        piece at:#value put:100.
        piece at:#color put:(Color blue onDevice:Display).
        chart add:piece.

        p := PieChart new.
        p model:(holder := chart asValue).
        p pieChartName:'demo PieChart'.

        p.
        v := View new.
        v extent:300@300.
        v open.
        Delay waitForSeconds:1.
        p redrawPieChartOn:v.
                                                                [exEnd]

"
! !

!PieChart class methodsFor:'instance creation'!

new
  ^ self basicNew initialize
! !

!PieChart class methodsFor:'startup'!

open
    ^self new open
! !

!PieChart methodsFor:'accessing'!

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
    model := newModel.
    aod := model value.

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

!PieChart methodsFor:'accessing-color & font'!

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

!PieChart methodsFor:'drawing'!

drawKeyOn:aForm inArea:aRect
    |p chart piece|

    chart := OrderedCollection new.

    aod do:[:aDic |
        piece := Dictionary new.
        piece at:#name put: (aDic at:#label).
        piece at:#color put:(aDic at:#color).
        chart add:piece.
    ].


    p := ChartKey new.
    p model:chart asValue.

    p redrawChartDescOn:aForm inArea:aRect.
!

drawLogo2On:aView
    |x y w h startAngle endAngle|
    "zeichnet den pie-Umfang"

    model isNil ifTrue:[
        x := 0 - radX.
        y := 0 - radY.
        w := h := (radX*2 ).
        endAngle := 120.
        startAngle := 90.
        aView paint:Color blue.
        aView fillArcX:x  y:y  width:w  height:h
                 from:startAngle  angle:endAngle.
        startAngle := startAngle + endAngle.
        aView paint:Color red.
        aView fillArcX:x  y:y  width:w  height:h
                 from:startAngle  angle:endAngle.
        startAngle := startAngle + endAngle.
        aView paint:Color green.
        aView fillArcX:x  y:y  width:w  height:h
                 from:startAngle  angle:endAngle.
    ].
    "Umriss nachzeichnen"
    aView lineWidth:2.
    aView paint:Color black.
    aView displayCircle:0@0 radius:radX.
!

drawPercentDescriptionOn:aView
    |x y str count angle stringHeight stringWidth clr|
    "Prozentausgabe der Diagrammstücke"
    count := 1.
    aView paint:backgroundColor.             "Zeichenfarbe für Schrift"

    [count <= anzahl]
    whileTrue:[      
        str := ((aoHilf at:count) at:#prozent) rounded printString.
        str := str ,'%'.
        stringWidth := (aView font widthOf:str on:aView device)//2.
        stringHeight := (aView font heightOf:str on:aView device)//2.
        rF := stringWidth max:stringHeight.

        angle := ((aoHilf at:count) at:#pos).
        x := ((radX * 1.1 + rF) * ((angle degreesToRadians) cos)) asInteger.
        y := ((radY * 1.1 + rF) * ((angle degreesToRadians) sin) negated) asInteger.

        clr := (Color colorId:4).
        aView paint:clr.

        aView displayString:str  x:(x-stringWidth)  y:(y+stringHeight).
"/        aView displayCircle:(0@0) radius:radX*1.1+rF.
"/        aView displayCircle:(0@0) radius:radY*1.1+rF.

        count := count +1
    ].

    "Modified (format): / 04-05-2017 / 18:19:03 / mawalch"
!

drawPieChartOn:aView

    self getAnzahl.             "get number of pieces"
    anzahl > 0 ifTrue:[         "is there a number?"

        "transformiere den Punkt 0@0 zum Mittelpunkt"
        aView transformation:(WindowingTransformation scale:1
                translation:((middlePoint x) @ (middlePoint y )) ).
        "Mittelpunkt ist jetzt 0@0"


        self getSumme.                 "get sum of all values"
        self fillAod.                   "put values in helpDictionary"

        self drawPiePiecesOn:aView.             "draw pie pieces"
        self drawPercentDescriptionOn:aView.    "draw percents"

        aView transformation:nil.        "switch off Transformation"

        self writeLabelOn:aView.
    ]
    ifFalse:[
        self drawLogo2On:aView.                  "draw DemoPieChart"
    ].

    "Modified: / 17-05-2017 / 19:03:27 / mawalch"
!

drawPiePiecesOn:aView
    "draw a filled arc in a box, given startAngle and endAngle."
    |x y w h rad startAngle endAngle count clr|

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
        aView paint:clr.

        aView fillArcX:x  y:y  width:w  height:h
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

redrawPieChartOn:aView
    |diagramOrigin diagramCorner keyOrigin keyCorner extent|
    diagramOrigin := aView origin x @  (aView origin y + 40).
    diagramCorner := aView extent.


    self redrawPieChartOn:aView inArea:(diagramOrigin corner: diagramCorner).

    keyOrigin := 2 @ (aView extent y - 40).  
    keyCorner :=  diagramCorner x @ aView height.
    extent := (100@75).

    self drawKeyOn:aView inArea:((4 @ (diagramCorner y - extent y) ) extent:extent).
!

redrawPieChartOn:aView inArea:anArea
    "Instanzvariablen initialisieren"

    |str stringHeight strlen|

    str := '87%'.
    strlen := (aView font widthOf:str on:aView device)rounded.
    stringHeight := strlen.

    radX := (anArea width /2 - strlen) rounded.
    radY := (anArea height - stringHeight /2 - stringHeight) rounded.

    "maximaler radius ermitteln"
    radX > radY ifTrue:[        
        radX := radY.
    ].

    radY := radX.

    middlePoint x:((anArea width ) /2) rounded.
    middlePoint y:((anArea height) /2) rounded.

    self drawPieChartOn:aView
!

writeLabelOn:aView
    |x y str stringWidth stringHeight clr|
    pieChartName isNil ifTrue:[pieChartName := 'chart'].
    str := pieChartName.
    x := (middlePoint x).
    aView paint:foregroundColor.
    stringWidth := (aView font widthOf:str on:aView device)//2.
    stringHeight := (aView font heightOf:str on:aView device).
    y := stringHeight.
    clr := (Color colorId:4).
    aView paint:clr.
    aView displayString:str  x:(x-stringWidth) y:y.
! !

!PieChart methodsFor:'initialization'!

initialize
    super initialize.

    middlePoint:= 0@0.
    anzahl     := 0.
    summe      := 0.
    aod        := 0.
    pieChartName := 'chart'.
    backgroundColor := Color black.
    foregroundColor := Color black.
! !

!PieChart methodsFor:'private'!

fillAod
    "fills the Dictionaries in Array with Values"
    "anzahl und summe sind bereits bekannt"
    |count pro start angle pos|

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
        count == anzahl ifFalse:[       "hack"
            (aoHilf at:count) at:#end put:(angle + 1).
        ] ifTrue:[  
            (aoHilf at:count) at:#end put:(angle).
        ].

        "Textposition eintragen"
        pos := start+(angle/2).
        (aoHilf at:count) at:#pos put:pos.

        (aoHilf at:count) at:#label put:((aod at:count) at:#label).

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

    "Modified (comment): / 04-05-2017 / 19:07:59 / mawalch"
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

    "Created: / 04-05-2017 / 18:29:54 / mawalch"
! !

!PieChart class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/PieChart.st,v 1.11 2017-11-28 18:23:44 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/PieChart.st,v 1.11 2017-11-28 18:23:44 cg Exp $'
! !

