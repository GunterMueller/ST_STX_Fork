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

View subclass:#BarChartWidget
	instanceVariableNames:'maxWidth minWidth maxHeight minHeight xAbstand yMaxScale anzahl
		summe maxWert schrumpf aod foregroundColor backgroundColor
		barChartName style newfont oldfont'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!BarChartWidget class methodsFor:'documentation'!

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

    a simple BarChart, 

    The model is a collection of chart description items,
    each being a dictionary filled with entries for:
        #value  aNumber         the numeric value
        #color  aColor          the color

    see example on how to fill such a chartDescription model.

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
        bars at:#color put:Color red.
        chart add:bars.

        bars := Dictionary new.
        bars at:#value put:100.
        bars at:#color put:Color blue.
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

            bars at:#color put:(i odd ifTrue:[Color green] 
                                       ifFalse:[Color magenta]).
            chart add:bars.

            holder value:nil.
            holder value:chart.
        ]
                                                                [exEnd]
"
! !

!BarChartWidget methodsFor:'accessing'!

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

    super model:newModel.
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

!BarChartWidget methodsFor:'accessing-color & font'!

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

!BarChartWidget methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == model ifTrue:[
        aod := model value.
        self invalidate
    ]
! !

!BarChartWidget methodsFor:'drawing'!

drawBarBars
    "draw some filled rectangle as like bars in a barChart."
    |x y w h hmax distance expand num idx clr orgLineWidth str stringWidth stringHeight font|

    x := minWidth.
    y := minHeight asFloat.           "always static"
    expand := xAbstand *0.8.            "barWidth"
    distance := xAbstand *0.1.          "distance from ScaleLine to bar"
    w := expand.                        "barWidth"
    hmax := minHeight - maxHeight.  
    font := gc font.

    idx := 1.
    aod do:[:entry |
        entry isNumber ifTrue:[
            clr := self standardColors at:((idx - 1) \\ self standardColors size)+1.
            num := entry.
        ] ifFalse:[
            clr := entry at:#color.
            num := entry at:#value.
        ].
        self paint:clr.
        x := (minWidth + ((idx-1) * xAbstand) + distance) asFloat.
        w := expand asFloat.
        h := (minHeight - (num * hmax / yMaxScale)) asFloat.
        self fillRectangleX:x y:h width:w height:(minHeight - h - 1).

        "write valueDescription"
        str := num printString.
        stringWidth := ((font widthOf:str on: device)//2)asFloat.
        stringHeight := (font heightOf:str on: device) asFloat.
        self paint:backgroundColor.
        self displayString:str  x:(x + (w/2) - stringWidth)  y:(self height - 2).

        idx := idx + 1.
    ].

    "bottom line redraw, because it looks ugly"
    orgLineWidth := (self lineWidth).
    self lineWidth:2.
    self paint:backgroundColor.
    self displayLineFromX:minWidth y:y toX:maxWidth y:y.
    self lineWidth:orgLineWidth.
!

drawBarChart
    self getAnzahl.                     "get number of bars"

    anzahl > 1 ifTrue:[                 "if number greater 1?"
        self getSumme.                 "get summe of values"
        self getMaxWert.                "get biggest value"
        self drawBarScale.              "draw background"
        self drawBarBars.               "draw Diagrammbalken"
        self writeLabel.                "write label of bar chart"
    ]
    ifFalse:[
        model isNil ifTrue:[
            self drawLogo.              "draw DemoBarChart"
        ].
    ].

    "Modified: / 04-05-2017 / 18:29:35 / mawalch"
!

drawBarScale
    |x y anzahlLines yAbstand num scaleNumber i str stringWidth stringHeight count font|
    "xAbstand is a instanzVariable"

    "Sonderfaelle"

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

    num := num * schrumpf * 1.0.

"---set new outline initialisation--------------------------------------------------------------"
    str := num printString.
    font := gc deviceFont.
    stringWidth := (font widthOf:str) * 1.2.
    minWidth  := stringWidth asFloat + 10.    "left"

    stringHeight := ((font heightOf:str) * 2) asFloat.
    maxHeight := stringHeight.          "top"

    minHeight := (self height - (stringHeight *0.5)).

"---format the scaleNumber----------------------------------------------------------------------"            
    scaleNumber := (num / anzahlLines).
    scaleNumber isFraction ifTrue:[
            scaleNumber := scaleNumber asFloat asFixedPoint:1.
        ].

    "draw rectangle as outline"
    self paint:backgroundColor.
    self displayRectangleOrigin:(minWidth @ maxHeight) 
                         corner:(maxWidth @ minHeight).

"---draw vertical Lines-------------------------------------------------------------------------"
    xAbstand := ((maxWidth - minWidth) / anzahl) asFloat.
    x := minWidth + xAbstand.
   [(x - 1)< (maxWidth - xAbstand)]                  "draw vertical Lines"
    whileTrue:[
        self displayLineFromX:x y:minHeight toX:x y:maxHeight.
        x := x + xAbstand.        
    ].                    

"---draw horizontal Lines-----------------------------------------------------------------------"
    count := 0.

    yAbstand := ((minHeight - maxHeight) / anzahlLines) asFloat.
    y := minHeight.                             "top"
    i := 0.
    [count <= anzahlLines] whileTrue:[
        i := count * scaleNumber.
        str := i printString.
        stringWidth := font widthOf:str.
        stringHeight := ((font heightOf:str) //2 ) asFloat.
        count ~= 0 ifTrue:[
            self displayString:str  x:(minWidth-stringWidth)  y:(y + stringHeight).
            count < anzahlLines ifTrue:[
                self displayLineFromX:minWidth y:y toX:maxWidth y:y.
            ].

        ]
        ifFalse:[
            self displayString:str  x:(minWidth-stringWidth)  y:(y + (stringHeight*0.4)).
        ].

        count := count + 1.
        y := (y - yAbstand) asFloat. 
    ].                             

    yMaxScale := i.
!

drawBarScale2
    |x y anzahlLines yAbstand num scaleNumber i str stringWidth stringHeight count font|
    "xAbstand is a instanzVariable"

    "Sonderfaelle"

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
    font := gc deviceFont.
    stringWidth := (font widthOf:str) * 1.2.
    minWidth  := stringWidth asFloat.   "left"

    stringHeight := ((font heightOf:str) * 2) asFloat.
    maxHeight := stringHeight.          "top"

    minHeight := (self height - (stringHeight * 0.5)).

"---format the scaleNumber----------------------------------------------------------------------"            
    scaleNumber := (num / anzahlLines).
    scaleNumber isFraction ifTrue:[
            scaleNumber := scaleNumber asFloat asFixedPoint:1.
        ].

    "draw rectangle as outline"
    self paint:backgroundColor.
    self displayRectangleOrigin:(minWidth @ maxHeight) 
                         corner:(maxWidth @ minHeight).

"---draw vertical Lines-------------------------------------------------------------------------"
    xAbstand := ((maxWidth - minWidth) / anzahl) asFloat.
    x := minWidth + xAbstand.
   [(x - 1)< (maxWidth - xAbstand)]                  "draw vertical Lines"
    whileTrue:[
        self displayLineFromX:x y:minHeight toX:x y:maxHeight.
        x := x + xAbstand.        
    ].                    

"---draw horizontal Lines-----------------------------------------------------------------------"
    count := 0.

    yAbstand := ((minHeight - maxHeight) / anzahlLines) asFloat.
    y := minHeight.                             "top"
    i := 0.
    maxHeight := maxHeight - 0.01.
    [y >= maxHeight]                      "horiontal Lines bottom up"                
    whileTrue:[

        i := count * scaleNumber.
        count := count + 1.
        str := i printString.
        stringWidth := font widthOf:str.
        stringHeight := ((font heightOf:str)//2) asFloat.
        i ~= 0 ifTrue:[
            self displayString:str  x:(minWidth-stringWidth)  y:(y + stringHeight).
            y > (maxHeight + 0.02) ifTrue:[
                self displayLineFromX:minWidth y:y toX:maxWidth y:y.
            ].

        ]
        ifFalse:[
            self displayString:str  x:(minWidth-stringWidth)  y:(y + (stringHeight*0.4)).
        ].

        y := (y - yAbstand) asFloat. 
    ].                             

    yMaxScale := i.
!

drawLogo
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

redrawBarChart
    "Instanzvariablen initialisieren"

"/    minWidth  := ((self width) * 0.1) asFloat.  "left; have a look at drawBarScale"
    maxWidth  := ((self width) * 0.98) asFloat.  "right"
    maxHeight := ((self height)* 0.1) asFloat.  "top"
    minHeight := ((self height)* 0.98) asFloat.  "bottom"

    self drawBarChart
!

writeLabel
    |x y str stringWidth stringHeight font|

    barChartName isNil ifTrue:[barChartName := 'chart'].
    str := barChartName.
    x := (self width) //2.
    self paint:foregroundColor.
    font := gc deviceFont.
    stringWidth := (font widthOf:str) // 2.
    stringHeight := ((font heightOf:str) * 0.5)rounded.
    y := maxHeight - stringHeight.
    self displayString:str  x:(x - stringWidth) y:y.
! !

!BarChartWidget methodsFor:'event handling'!

redrawX:x y:y width:w height:h

    self clear.
    self redrawBarChart.

!

sizeChanged:how
    super sizeChanged:how.
    self clear.
    self redrawBarChart.
! !

!BarChartWidget methodsFor:'hooks'!

postBuildWith:aBuilder
    "automatically generated by UIPainter ..."

    "*** the code here does nothing. It is invoked when"
    "*** the widgets have been built, but before the view is opened"
    "*** Please change as required and accept in the browser."

    "specific code to be added below ..."
    "or after the super send"

    |view|

    view := (aBuilder componentAt:#BarChartView).
    view := view scrolledView.

"/    super postBuildWith:aBuilder
! !

!BarChartWidget methodsFor:'initialization'!

initialize
    super initialize.
    "initialisierung und sein Kind"

    anzahl := 0.
    summe  := 0.
    barChartName := 'chart'.
    backgroundColor := Color black.
    foregroundColor := Color black.
    aod        :=0.

    "Modified: / 11-09-2006 / 16:13:31 / User"
! !

!BarChartWidget methodsFor:'private'!

getAnzahl
    "ermittelt die Anzahl der belegten Diagrammstücke"

"/ bad, c-like programming
"/    |count|
"/
"/    count := 1.
"/    anzahl := 0.
"/
"/    [(count <= (aod size))] whileTrue:[ 
"/        ((aod at:count) includesKey:#value)
"/            ifTrue:[ anzahl := count ].
"/        count := count + 1 
"/    ].

    anzahl := aod size.

    "Modified (comment): / 04-05-2017 / 19:08:26 / mawalch"
!

getMaxWert
    "initialisiert die Instanzvariable maxWert mit dem größten Wert"

"/ bad, c-like programming
"/    |count|
"/    maxWert := 0.
"/    count := 1.
"/    aod isNil ifTrue:[^ self].
"/
"/    [count <= anzahl]
"/    whileTrue:[ 
"/        ((aod at:count) at:#value) > maxWert ifTrue:[
"/            maxWert := ((aod at:count) at:#value)
"/        ].
"/        count := count +1.
"/    ].

    self valuesDo:[:v |
        maxWert := (maxWert ? v) max:v
    ].

    "Modified (comment): / 04-05-2017 / 19:09:57 / mawalch"
!

getSumme
    "initialisiert die Instanzvariable summe mit der Gesamtsumme"

"/ bad, c-like programming
"/    summe := 0.
"/    aod isNil ifTrue:[^ self].
"/
"/    count := 0.
"/    [count < anzahl]
"/    whileTrue:[ 
"/        count := count +1.
"/        summe := summe + ((aod at:count) at:#value).
"/    ].

    summe := 0.
    self valuesDo:[:v | summe := summe + v].

    "Created: / 04-05-2017 / 18:35:08 / mawalch"
!

standardColors
    ^ Array 
        with:Color red
        with:Color green
        with:Color blue
!

valuesDo:aBlock
    (aod ? #()) do:[:el |
        el isNumber ifTrue:[
            aBlock value:el.
        ] ifFalse:[
            aBlock value:(el at:#value).
        ]
    ].
! !

!BarChartWidget methodsFor:'views'!

getBarChartWidget
    ^ self class new.
! !

!BarChartWidget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChartWidget.st,v 1.15 2017-11-28 18:27:50 cg Exp $'
! !

