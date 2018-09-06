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

AbstractChart subclass:#BarChart
	instanceVariableNames:'maxWidth minWidth maxHeight minHeight xAbstand yMaxScale summe
		maxWert schrumpf foregroundColor backgroundColor barChartName
		style newfont oldfont'
	classVariableNames:''
	poolDictionaries:''
	category:'Statistic-Charts'
!

!BarChart class methodsFor:'documentation'!

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

    a simple BarChart, 

    The model is a collection of chart description items,
    each being a dictionary filled with entries for:
        #value  aNumber         the numeric value
        #color  aColor          the color

    see example on how to fill such a chartDescription model.
    This was one if the author's very first smalltalk programs ever.
    So please excuse any odd code.

    [author:]
        Timo Merkert (tm@idefix)

    [see also:]
        PieChartWidget ChartDescription

    [instance variables:]
        minWidth        left Viewport limit 
        maxWidth        right Viewport limit
        maxHeight       top Viewport limit
        minHeight       bottom Viewport limit
        xAbstand        difference between vertical lines
        yMaxScale       limit of horizontal value
        anzahl          number of values
        summe           summe of all values
        maxWert         biggest value
        schrumpf        factor of ...
        aod             Aray of Dictionaries
        foregroundColor color for label
        backgroundColor color for background lines
        label1          name of bar chart
        style           fontstyle
        newfont 
        oldfont
"
!

examples
"
                                                                [exBegin]
        |p chart bars holder|

        chart := OrderedCollection new.
        bars := Dictionary new.
        bars at:#value put:50.
        bars at:#color put:(Color red).
        chart add:bars.

        bars := Dictionary new.
        bars at:#value put:100.
        bars at:#color put:(Color blue).
        chart add:bars.

        p := BarChartWidget new.
        p model:(holder := ValueHolder new).
        p extent:400@250.
        p label:'demo BarChart'.
        p open.
        holder value:chart.
        Delay waitForSeconds:2.

        1 to: 5 do:[:i |
            bars := Dictionary new.
            bars at:#value put:30.

            bars at:#color put:(i odd ifTrue:[Color green] ifFalse:[Color magenta]).
            chart add:bars.

            holder value:nil.
            holder value:chart.
        ]
                                                                [exEnd]

                                                                [exBegin]
        |p chart bars holder v|

        chart := OrderedCollection new.
        bars := Dictionary new.
        bars at:#value put:50.
        bars at:#color put:(Color red).
        chart add:bars.

        bars := Dictionary new.
        bars at:#value put:100.
        bars at:#color put:(Color blue).
        chart add:bars.

        p := BarChart new.
        p model:(holder := chart asValue).
        p label:'demo BarChart'.

        v := View new.
        v extent:400@250.
        v open.
        Delay waitForSeconds:1.
        p redrawBarChartOn:v.

                                                                [exEnd]

"
! !

!BarChart class methodsFor:'instance creation'!

new
    ^ self basicNew initialize.
! !

!BarChart class methodsFor:'startup'!

open
    ^ self new open
! !

!BarChart methodsFor:'accessing'!

anzahl
    "return the value of the instance variable 'anzahl' (automatically generated)"

    ^ anzahl
!

anzahl:something
    "set the value of the instance variable 'anzahl' (automatically generated)"

    anzahl := something.
!

aod
    "return the value of the instance variable 'aod' (automatically generated)"

    ^ aod
!

aod:something
    "set the value of the instance variable 'aod' (automatically generated)"

    aod := something.
!

barChartName
    "return the value of the instance variable 'barChartName' (automatically generated)"

    ^ barChartName
!

barChartName:something
    "set the value of the instance variable 'barChartName' (automatically generated)"

    barChartName := something.
!

label
    ^ self barChartName


!

label:aString
    self barChartName:aString


!

maxHeight
    "return the value of the instance variable 'maxHeight' (automatically generated)"

    ^ maxHeight
!

maxHeight:something
    "set the value of the instance variable 'maxHeight' (automatically generated)"

    maxHeight := something.
!

maxWert
    "return the value of the instance variable 'maxWert' (automatically generated)"

    ^ maxWert
!

maxWert:something
    "set the value of the instance variable 'maxWert' (automatically generated)"

    maxWert := something.
!

maxWidth
    "return the value of the instance variable 'maxWidth' (automatically generated)"

    ^ maxWidth
!

maxWidth:something
    "set the value of the instance variable 'maxWidth' (automatically generated)"

    maxWidth := something.
!

minHeight
    "return the value of the instance variable 'minHeight' (automatically generated)"

    ^ minHeight
!

minHeight:something
    "set the value of the instance variable 'minHeight' (automatically generated)"

    minHeight := something.
!

minWidth
    "return the value of the instance variable 'minWidth' (automatically generated)"

    ^ minWidth
!

minWidth:something
    "set the value of the instance variable 'minWidth' (automatically generated)"

    minWidth := something.
!

model:newModel
    "set the value of the instance variable 'model' (automatically generated)"

    model:=newModel.
    aod := newModel value.
    self update:nil with:nil from:model
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

schrumpf
    "return the value of the instance variable 'schrumpf' (automatically generated)"

    ^ schrumpf
!

schrumpf:something
    "set the value of the instance variable 'schrumpf' (automatically generated)"

    schrumpf := something.
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
!

xAbstand
    "return the value of the instance variable 'xAbstand' (automatically generated)"

    ^ xAbstand
!

xAbstand:something
    "set the value of the instance variable 'xAbstand' (automatically generated)"

    xAbstand := something.
!

yMaxScale
    "return the value of the instance variable 'yMaxScale' (automatically generated)"

    ^ yMaxScale
!

yMaxScale:something
    "set the value of the instance variable 'yMaxScale' (automatically generated)"

    yMaxScale := something.
! !

!BarChart methodsFor:'accessing-color & font'!

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

!BarChart methodsFor:'drawing'!

drawBarBarsOn:aView
    "draw some filled rectangle as like bars in a barChart."
    |x y w h hmax distance expand num count clr orgLineWidth str stringWidth stringHeight|
    x := minWidth.
    y := minHeight asFloat.           "always static"
    expand := xAbstand *0.8.            "barWidth"
    distance := xAbstand *0.1.          "distance from ScaleLine to bar"
    w := expand.                        "barWidth"
    count := 1.
    hmax := (minHeight - maxHeight).
    [count <= anzahl]
    whileTrue:[
        clr := ((aod at:count) at:#color).
        aView paint:clr.
        x := (minWidth + ((count-1) * xAbstand) + distance) asFloat.
        w := expand asFloat.
        num := ((aod at:count) at:#value).
        h := (minHeight - (num * hmax / yMaxScale)) asFloat.
        aView fillRectangleX:x y:h
                      width:w height:(minHeight - h - 1).

        "write valueDescription"
        str := ((aod at:count) at:#label ifAbsent:'') printString.
        stringWidth := ((aView font widthOf:str on:aView device)//2)asFloat.
        stringHeight := (aView font heightOf:str on:aView device) asFloat.
        aView paint:backgroundColor.
        aView displayString:str  x:(x + (w/2) - stringWidth)  y:(aView height - 2).

        count := count + 1.
    ].


    "bottom line redraw, because it looks like sh..."
    orgLineWidth := (aView lineWidth).
    aView lineWidth:2.
    aView paint:Color white.
    aView displayLineFromX:minWidth y:y toX:maxWidth y:y.
    aView lineWidth:orgLineWidth.

    "Modified (comment): / 07-06-2017 / 18:12:08 / mawalch"
!

drawBarChartOn:aView
    self getAnzahl.                     "get number of bars"
    anzahl > 1 ifTrue:[                 "if number greater 1?"
        self getSumme.                 "get summe of values"
        self getMaxWert.                "get biggest value"
        self drawBarScaleOn:aView.              "draw background"
        self drawBarBarsOn:aView.               "draw Diagrammbalken"
        self writeLabelOn:aView.                "write label of bar chart"
    ]
    ifFalse:[
        model isNil ifTrue:[
            self drawLogoOn:aView.              "draw DemoBarChart"
        ].
    ].

    "Modified: / 04-05-2017 / 18:29:38 / mawalch"
!

drawBarScale2On:aView
    |x y anzahlLines yAbstand num check scaleNumber i str stringWidth stringHeight count|
    "xAbstand is a instanzVariable"

    "Sonderfälle"

    schrumpf := 1.
    anzahlLines := 10.

    maxWert <= 1 ifTrue:[
            num := 1.
        ]
        ifFalse:[
            maxWert <= 10 ifTrue:[
                    num := 10.
              ]
              ifFalse:[

"---round the maxWert---------------------------------------------------------------------------"
    "maxWert > 10 nämlich"
    num := maxWert.
    [num > 100]
    whileTrue:[
        num := num / 10.
        Transcript showCR:num printString.
        schrumpf := schrumpf * 10
    ].


    (num \\10) < 2 ifTrue:[
            num := num //10 *10 + 2.
"/            anzahlLines := 6.
        ]"\\2"
        ifFalse:[
            num \\10 < 4 ifTrue:[
                    num := num //10 *10 + 4.
"/                    anzahlLines := 7.
                ]
            ifFalse:[
                num \\10 < 6 ifTrue:[
                        num := num //10 *10 + 6.
"/                        anzahlLines := 8.
                    ]
                ifFalse:[
                    num \\10 < 8 ifTrue:[
                            num := num //10 *10+ 8.
"/                            anzahlLines := 9.
                        ]
                    ifFalse:[
                         num := num / 10.
                        schrumpf := schrumpf * 10.
                        num := (num + 1)floor.
"/                        anzahlLines := 10.
                    ]."\\10"
                ]."\\8"
            ]."\\6"
        ]."\\4"
      ]."maxWert > 10 nämlich"
    ]."maxWert > 1"
"-----------------------------------------------------------------------------------------------"

    num := num * schrumpf.

"---set new outline initialisation--------------------------------------------------------------"
    str := num printString.
    stringWidth := (aView font widthOf:str on:aView device)*1.2.
    minWidth  := stringWidth asFloat.   "left"

    stringHeight := ((aView font heightOf:str on:aView device) *2) asFloat.
    maxHeight := stringHeight.          "top"

    minHeight := (aView height - (stringHeight *0.5)).

"---format the scaleNumber----------------------------------------------------------------------"
    scaleNumber := (num / anzahlLines).
    scaleNumber isFraction ifTrue:[
            scaleNumber := scaleNumber asFloat asFixedPoint:1.
        ].

    "draw rectangle as outline"
    aView paint:backgroundColor.
    aView displayRectangleOrigin:(minWidth @ maxHeight)
                         corner:(maxWidth @ minHeight).

"---draw vertical Lines-------------------------------------------------------------------------"
    xAbstand := (maxWidth - minWidth /(anzahl)) asFloat.
    x := minWidth + xAbstand.
   [(x - 1)< (maxWidth - xAbstand)]                  "draw vertical Lines"
    whileTrue:[
        aView displayLineFromX:x y:minHeight toX:x y:maxHeight.
        x := x + xAbstand.
    ].

"---draw horizontal Lines-----------------------------------------------------------------------"
    count := 0.

    yAbstand := (minHeight - maxHeight /anzahlLines) asFloat.
    y := minHeight.                             "top"
    i := 0.
    maxHeight := maxHeight - 0.01.
    [y >= maxHeight]                      "horiontal Lines bottom up"
    whileTrue:[

        i := count * scaleNumber.
        count := count + 1.
        str := i printString.
        stringWidth := aView font widthOf:str on:aView device.
        stringHeight := ((aView font heightOf:str on:aView device)//2) asFloat.
        i ~= 0 ifTrue:[
            aView displayString:str  x:(minWidth-stringWidth)  y:(y + stringHeight).
            y > (maxHeight + 0.02) ifTrue:[
                aView displayLineFromX:minWidth y:y toX:maxWidth y:y.
            ].

        ]
        ifFalse:[
            aView displayString:str  x:(minWidth-stringWidth)  y:(y + (stringHeight*0.4)).
        ].

        y := (y - yAbstand) asFloat.
    ].

    yMaxScale := i.

    "Modified (comment): / 06-06-2017 / 16:40:06 / mawalch"
!

drawBarScaleOn:aView
    |x y anzahlLines yAbstand num scaleNumber i str stringWidth stringHeight count|
    "xAbstand is a instanzVariable"

    "Sonderfälle"

    schrumpf := 1.
    anzahlLines := 10.

    maxWert <= 1 ifTrue:[
            num := 1.
        ]
        ifFalse:[
            maxWert <= 10 ifTrue:[
                    num := 10.
              ]
              ifFalse:[

"---round the maxWert---------------------------------------------------------------------------"
    "maxWert > 10 nämlich"
    num := maxWert.
    [num > 100]
    whileTrue:[
        num := num / 10.
        schrumpf := schrumpf * 10
    ].


    (num \\10) < 2 ifTrue:[
            num := num //10 *10 + 2.
        ]"\\2"
        ifFalse:[
            num \\10 < 4 ifTrue:[
                    num := num //10 *10 + 4.
                ]
            ifFalse:[
                num \\10 < 6 ifTrue:[
                        num := num //10 *10 + 6.
                    ]
                ifFalse:[
                    num \\10 < 8 ifTrue:[
                            num := num //10 *10+ 8.
                        ]
                    ifFalse:[
                         num := num / 10.
                        schrumpf := schrumpf * 10.
                        num := (num + 1)floor.
                    ]."\\10"
                ]."\\8"
            ]."\\6"
        ]."\\4"
      ]."maxWert > 10 nämlich"
    ]."maxWert > 1"
"-----------------------------------------------------------------------------------------------"

    num := num * schrumpf * 1.

"---set new outline initialisation--------------------------------------------------------------"
    str := num printString.
    stringWidth := (aView font widthOf:str on:aView device)*1.2.
    minWidth  := stringWidth asFloat +10.    "left"

    stringHeight := ((aView font heightOf:str on:aView device) *2) asFloat.
    maxHeight := stringHeight.          "top"

    minHeight := (aView height - (stringHeight *0.5)).

"---format the scaleNumber----------------------------------------------------------------------"
    scaleNumber := (num / anzahlLines).
    scaleNumber isFraction ifTrue:[
            scaleNumber := scaleNumber asFloat asFixedPoint:1.
        ].

    "draw rectangle as outline"
    aView paint:Color white.
"/    aView displayRectangleOrigin:(minWidth @ maxHeight)
"/                         corner:(maxWidth @ minHeight).

    aView displayLineFromX:minWidth y:maxHeight toX:minWidth y:minHeight.
    aView displayLineFromX:minWidth y:minHeight toX:maxWidth y:minHeight.

"---draw vertical Lines-------------------------------------------------------------------------"
      xAbstand := (maxWidth - minWidth /(anzahl)) asFloat.
"/    x := minWidth + xAbstand.
"/   [(x - 1)< (maxWidth - xAbstand)]                  "draw vertical Lines"
"/    whileTrue:[
"/        aView displayLineFromX:x y:minHeight toX:x y:maxHeight.
"/        x := x + xAbstand.
"/    ].
"/
"---draw horizontal Lines-----------------------------------------------------------------------"
    count := 0.

    yAbstand := (minHeight - maxHeight /anzahlLines) asFloat.
    y := minHeight.                             "top"
    i := 0.
    [count <= anzahlLines]
    whileTrue:[

        i := count * scaleNumber.
        str := i printString.
        stringWidth := aView font widthOf:str on:aView device.
        stringHeight := ((aView font heightOf:str on:aView device)//2) asFloat.
        count ~= 0 ifTrue:[
            aView displayString:str  x:(minWidth-(stringWidth ))  y:(y + stringHeight).
            count < anzahlLines ifTrue:[
"/                aView displayLineFromX:minWidth y:y toX:maxWidth y:y.
            ].

        ]
        ifFalse:[
            aView displayString:str  x:(minWidth-stringWidth)  y:(y + (stringHeight*0.4)).
        ].

        count := count + 1.
        y := (y - yAbstand) asFloat.
    ].

    yMaxScale := i.

    "Modified (comment): / 06-06-2017 / 16:40:59 / mawalch"
!

drawLogoOn:aView
    | chart bars|
    "put demo values into model"

    model isNil ifTrue:[

        chart := OrderedCollection new.
        bars := Dictionary new.
        bars at:#value put:5.5.
        bars at:#color put:(Color green).
        chart add:bars.

        bars := Dictionary new.
        bars at:#value put:9.3.
        bars at:#color put:(Color red).
        chart add:bars.

        bars := Dictionary new.
        bars at:#value put:7.
        bars at:#color put:(Color blue).
        chart add:bars.
        self model:chart
    ].
!

redrawBarChartOn:aView
    "Instanzvariablen initialisieren"

"/    minWidth  := ((self width) * 0.1) asFloat.  "left; have a look at drawBarScale"
    maxWidth  := ((aView width) * 0.98) asFloat.  "right"
    maxHeight := ((aView height)* 0.1) asFloat.  "top"
    minHeight := ((aView height)* 0.98) asFloat.  "bottom"

    self drawBarChartOn:aView
!

writeLabelOn:aView
    |x y str stringWidth stringHeight|

    barChartName isNil ifTrue:[barChartName := 'chart'].
    str := barChartName.
    x := (aView width) //2.
    aView paint:Color white.
    stringWidth := (aView font widthOf:str on:aView device)//2.
    stringHeight := ((aView font heightOf:str on:aView device) *0.5)rounded.
    y := maxHeight - stringHeight.
    aView displayString:str  x:(x - stringWidth) y:y.
! !

!BarChart methodsFor:'initialization'!

initialize
    anzahl     :=0.
    summe      :=0.
    aod        :=0.
    barChartName := 'label'.
! !

!BarChart methodsFor:'private'!

getAnzahl
    "ermittelt die Anzahl der belegten Diagrammstücke"

    "/ cg (critic):
    "/ same as:
    "/  anzahl := aod findLast:[:a | (aod at:count) includesKey:#value]
    "/ but maybe, findFirst: was actually the intention???
    "/ or even: 
    "/  count:[:a | (aod at:count) includesKey:#value]
    "/ may be a useful alternative. Who knows...

    |count|

    anzahl := 0.

    count := 1.
    [(count <= (aod size))] whileTrue:[ 
        ((aod at:count) includesKey:#value) ifTrue:[ anzahl := count ].
        count := count + 1 
    ].

    "Modified (comment): / 04-05-2017 / 18:26:31 / mawalch"
!

getMaxWert
    "initialisiert die Instanzvariable maxWert mit dem größten Wert"


"/ this is a typical beginner's code:
"/ 
"/    |count|
"/    maxWert := 0.
"/    count := 1.
"/    aod isNil ifTrue:[^ self].
"/    [count <= anzahl]
"/    whileTrue:[ 
"/        ((aod at:count) at:#value) > maxWert ifTrue:[
"/            maxWert := ((aod at:count) at:#value)
"/        ].
"/        count := count +1.
"/    ].

"/ and this is how it could be done:
    aod notNil ifTrue:[
        maxWert := aod maxApplying:[:each | each at:#value].
    ].

"/ or, if you prefer inject:
"/    maxWert := aod inject:(aod first at:#value) into:[:maxSoFar :each | maxSoFar max:(each at:#value)]

    "Modified (comment): / 04-05-2017 / 18:26:37 / mawalch"
!

getSumme
    "initialisiert die Instanzvariable summe mit der Gesammtsumme"

"/ this is a typical beginner's code:
"/ 
"/    |count|
"/
"/    aod isNil ifTrue:[^ self].
"/    summe := 0.
"/    count := 0.
"/
"/    [count < anzahl]
"/    whileTrue:[ 
"/        count := count +1.
"/        summe := summe + ((aod at:count) at:#value).
"/    ].

"/ and this is how it could be done:
    aod notNil ifTrue:[
        summe := (aod collect:[:each | each at:#value]) sum.
    ].

"/ or, if you prefer inject:
"/    maxWert := aod inject:0 into:[:sumSoFar :each | sumSoFar + (each at:#value)]

    "Created: / 04-05-2017 / 18:27:27 / mawalch"
! !

!BarChart class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChart.st,v 1.11 2017-11-28 18:23:45 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChart.st,v 1.11 2017-11-28 18:23:45 cg Exp $'
! !

