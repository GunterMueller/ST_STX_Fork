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

View subclass:#ChartDescription
	instanceVariableNames:'xPos anzahl summe aod aoHilf foregroundColor backgroundColor
		fontOK verticalY'
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

!ChartDescription class methodsFor:'documentation'!

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

    ChartDescription for a diagram, whose values are a model as like an array of dictionaries 
    so have a look at 'class - documentation - examples'
    This can be used beside a BarChartWidget or PieChartWidget as
    a legend (extracting its values from the same model).

    [author:]
        Timo Merkert (tm@idefix)

    [see also:]
        BarChartWidget PieChartWidget

    [instance variables:]
    xPos                x-Koordinate für Color-Punkt
    anzahl              number of pie-pieces
    summe               result of all values
    aod                 Array of Dictionaries
    aoHilf              Array für Hilfsvariablen der Winkelberechnungen
    foregroundColor     Textfarbe
    backgroundColor     Hintergrundfarbe
    label1              Name der Legende
"
!

examples
"
                                                                [exBegin]
        |p chart piece holder|

        chart := OrderedCollection new.
        piece := Dictionary new.
        piece at:#name put:'Güllemütz'.
        piece at:#color put:Color red.
        chart add:piece.

        piece := Dictionary new.
        piece at:#name put:'Hallabadkapp'.
        piece at:#color put:Color blue.
        chart add:piece.

        p := ChartDescription new.
        p model:(holder := ValueHolder new).
        p open.

      'here is the model'.
        holder value:chart.
        Delay waitForSeconds:2.
        1 to: 20 do:[:i |
            piece := Dictionary new.
            i odd ifTrue:[
                piece at:#name put:'Hallo erstmal...'.
                piece at:#color put:Color green.
            ]
            ifFalse:[
                piece at:#name put:'...und Tschüss'.
                piece at:#color put:Color magenta.
            ].
            chart add:piece.

            holder value:nil.
            holder value:chart.
        ].
                                                                [exEnd]
"
! !

!ChartDescription methodsFor:'accessing'!

anzahl
    "return the value of the instance variable 'anzahl' (automatically generated)"

    ^ anzahl
!

anzahl:something
    "set the value of the instance variable 'anzahl' (automatically generated)"

    anzahl := something 
!

aod
    "return the value of the instance variable 'aod' (automatically generated)"

    ^ aod
!

aod:something
    "set the value of the instance variable 'aod' (automatically generated)"


    (aod at:anzahl) at:#value put:something.
"/    aod := something.
!

model:newModel
    super model:newModel.
    self update:nil with:nil from:model.


!

summe
    "return the value of the instance variable 'summe' (automatically generated)"

    ^ summe
!

summe:something
    "set the value of the instance variable 'summe' (automatically generated)"

    summe := something.
!

verticalY
    "return the value of the instance variable 'verticalY' (automatically generated)"

    ^ verticalY
!

verticalY:something
    "set the value of the instance variable 'verticalY' (automatically generated)"

    verticalY := something.
!

xPos
    "return the value of the instance variable 'xPos' (automatically generated)"

    ^ xPos
!

xPos:something
    "set the value of the instance variable 'xPos' (automatically generated)"

    xPos := something.
! !

!ChartDescription methodsFor:'accessing-color & font'!

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

!ChartDescription methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    changedObject == model ifTrue:[
        aod := model value.
        self invalidate
    ]


! !

!ChartDescription methodsFor:'drawing'!

drawChartDesc
    model isNil ifTrue:[
        self drawDemo.              "draw Demo"
    ] ifFalse:[
        self getAnzahl.                     "get number of pieces"
        anzahl > 0 ifTrue:[                 "if someone"
            fontOK == true ifFalse:[
                self getVerticalStep.
                self getNewFontSize.
                fontOK := true.
            ].
            self drawDescription.           "write description of pieces"
        ]
    ].


!

drawDemo
    |chart descr|
    "put demo values into model"

    model isNil ifTrue:[

        chart := OrderedCollection new.

        descr := Dictionary new.
        descr at:#value put:1.
        descr at:#name put:'green'.
        descr at:#color put:(Color green).
        chart add:descr.

        descr := Dictionary new.
        descr at:#value put:1.
        descr at:#name put:'red'.
        descr at:#color put:(Color red).
        chart add:descr.

        descr := Dictionary new.
        descr at:#value put:1.
        descr at:#name put:'blue'.
        descr at:#color put:(Color blue).
        chart add:descr.
        self model:chart
    ].
!

drawDemo2
    |x y pos cPos oldFont newFont|

    pos := ((height)/(7)*2) rounded.            "Zeilen Anordung"
    oldFont := self font.                       "neue Schriftgröße vorbereiten"
    newFont  := (oldFont  size:pos).            "neue Schriftgröße"
    self font:newFont.                          "zuordnen"


    y := pos.                   "y-Koordinate"
    self paint:Color green.
    cPos := (pos * 0.8) rounded.
    self fillRectangleX:xPos  y:y-cPos 
                  width:cPos height:cPos.
    x := 2*xPos + cPos.
    self paint:Color black.
    self displayString:'green' x:x  y:y.      "Bezeichner ausgeben"

    y := 2*pos.
    self paint:Color red.
    cPos := (pos * 0.8) rounded.
    self fillRectangleX:xPos  y:y-cPos 
                  width:cPos height:cPos.
    x := 2*xPos + cPos.
    self paint:Color black.
    self displayString:'red' x:x  y:y.      "Bezeichner ausgeben"

    y := 3*pos.
    self paint:Color blue.
    cPos := (pos * 0.8) rounded.
    self fillRectangleX:xPos  y:y-cPos 
                  width:cPos height:cPos.
    x := 2*xPos + cPos.
    self paint:Color black.
    self displayString:'blue' x:x  y:y.      "Bezeichner ausgeben"

    "Modified (comment): / 04-05-2017 / 18:22:00 / mawalch"
!

drawDescription
    |x y yPos str strheight clr|
    anzahl > 0 ifTrue:[                                 

        yPos := verticalY.                              "y-koordinate"
        x := 2 * xPos + yPos.                           "x-koordinate of stringposition"

        1 to:anzahl do:[:num|                           "for all Pieces"
            y := (2 * verticalY * num) rounded.         "y-koordinate"


"/            aod isNil ifTrue:[
"/                self halt.              "draw Demo"
"/            ].


            clr := ((aod at:num) at:#color).            "get color"
            self paint:clr.

            self fillRectangleX:xPos  y:y-yPos          "draw colorpoint"
                              width:yPos height:yPos.

            y := y - (yPos / 2).
            strheight := (gc font heightOf:str on:device) / 2.
            y := (y + strheight) rounded.               "set new stringposition"
            self paint:foregroundColor.                 "set new textcolor"
            str := ((aod at:num) at:#name).             "get name"
            self displayString:str x:x  y:y.            "write name"

        ]."do"
    ]."ifTrue"
!

redrawChartDesc
    self drawChartDesc
! !

!ChartDescription methodsFor:'event handling'!

redrawX:x y:y width:w height:h

    self clear.
    self redrawChartDesc.

!

sizeChanged:how
    super sizeChanged:how.

    "Instanzvariablen initialisieren"
    xPos := ((self width) *0.05) rounded.    "x-koordinate for colorpoint"
    fontOK := false.

    self clear.
    self invalidate.
! !

!ChartDescription methodsFor:'hooks'!

postBuildWith:aBuilder
    ^ (aBuilder componentAt:#ChartDescription) scrolledView.
! !

!ChartDescription methodsFor:'initialization'!

initialize
    super initialize.
    "initialisierung und sein Kind"

    anzahl := 0.
    summe  := 0.
    aod     :=0.

    "Modified: / 11-09-2006 / 16:13:49 / User"
! !

!ChartDescription methodsFor:'private'!

fillAod
"/    "fills the Dictionaries in Array with Values"
"/    "anzahl und summe sind bereits bekannt"
"/    |count pro start angle test pos|
"/    start := 90.  
"/    count := 1.
"/    [count <= anzahl]
"/    whileTrue:[ 
"/
"/       "prozentualer Anteil ermitteln"
"/        pro := ( 100 /summe * ((aod at:count) at:#value) ).
"/        "prozentanteil eintragen"
"/        (aod at:count) at:#prozent put:pro.
"/        "Endwinkel ermitteln"
"/        angle := ( pro * 360 / 100 ).
"/        start := start - angle.
"/        start < 0 ifTrue:[
"/            start := 360 - (start abs).
"/        ].
"/
"/        "Startwinkel eintragen"
"/        (aod at:count) at:#start put:start.
"/        "Endwinkel eintragen"
"/        (aod at:count) at:#end put:angle.
"/
"/        "Textposition eintragen"
"/        pos := start+(angle/2).
"/        (aod at:count) at:#pos put:pos.
"/
"/
"/        count := count +1.
"/    ].
"/
!

getAnzahl
    "ermittelt die Anzahl der belegten Diagrammstücke"
    |count|
    count:=1.
    [(count <= (aod size))]
    whileTrue:[
        ((aod at:count) includesKey:#name)
        ifTrue:[ anzahl := count ].
        count := count +1
    ].

    "Modified (format): / 04-05-2017 / 19:08:39 / mawalch"
!

getMaxStringLen
    "ermittelt die position in aod, die den längsten String enthält"

    |str len strlen akt count font|
    count:=1.
    akt := 1.
    len := 0.
    font := gc font.

    [count <= aod size] whileTrue:[                     "solange noch Strings da sind"
        str := (aod at:count) at:#name.                 "String ermitteln"
        strlen := font widthOf:str.                     "Stringlänge ermitteln"
        strlen > len ifTrue:[                           "wenn String größer als len"
            len := strlen.                              "len die neue Stringlänge zuteilen"
            akt := count.                               "position merken"
        ].
        count := count +1                               "weiterzählen"
    ].
    ^ akt                                               "Stringposition zurückgeben"

    "Modified (comment): / 04-05-2017 / 19:09:19 / mawalch"
!

getNewFontSize
    |fontSize str maxStrlen|

    maxStrlen := ((self width) - (2 * xPos + verticalY)). "maximale Stringlänge"

    str := (aod at:self getMaxStringLen) at:#name.
    fontSize := (maxStrlen / (str size) * 1.6) rounded.

    self font:(gc font asSize:(fontSize min:verticalY)).

    "Modified (comment): / 04-05-2017 / 19:11:51 / mawalch"
!

getNewFontSize2
    |oldFont newFont strpos str strlen x maxlen minlen pos cPos delta minSize maxSize newSize|

    oldFont := self font.                               "neue Schriftgröße vorbereiten"

    minSize := 6.
    maxSize := oldFont size.
    (oldFont size < 12) ifTrue:[
        maxSize := 18.
    ].
    delta := maxSize - minSize.
    newSize := maxSize.

   "neue Schriftgröße ermitteln"
    pos := ((height)/(anzahl *2 +1)*2) rounded.         "Zeilen Anordung"
    cPos := (pos * 0.8) rounded.
    x := 2*xPos + cPos.                                 "x-Koordinate der Textausgabe"
    maxlen := ((self width)-x).                         "maximale Stringlänge"
    minlen := (maxlen *3 /4)rounded.


    strpos := self getMaxStringLen.                     "aod-Position mit längstem String ermitteln"
    str := (aod at:strpos)at:#name.                     "string zuordnen"
    strlen := oldFont widthOf:str.                      "stringlänge ermitteln"

"/    "Message ausgeben"
"/    self paint:Color black.
"/    self displayString:'compute the stringsize' 
"/                     x:0  y:(self height)//2.
"/    self flush.

    "solange Stringlänge nicht im gültigen Bereich liegt"
    [strlen between:minlen and:maxlen] whileFalse:[
        "solange String zu lange"
        [strlen > maxlen] whileTrue:[
            "Stringgröße -= deltasize/2"                
            delta := (delta / 2) rounded.
            newSize := newSize - delta.
            newFont := oldFont asSize:newSize.
            gc font:newFont.
            newFont := gc font.
            strlen := newFont widthOf:str.
        ].

        "solange String zu kurz"
        [strlen < minlen] whileTrue:[
            "Stringgröße += deltasize/2"                
            delta := (delta /2) rounded.
            newSize := newSize + delta.
            newFont := oldFont asSize:newSize.
            self font:newFont.
            newFont := gc font.
            strlen := newFont widthOf:str.
        ].
    ]."solange Stringlänge nicht im gültigen Bereich liegt"

    "Modified (comment): / 04-05-2017 / 19:12:42 / mawalch"
!

getSumme
    "initialisiert die Instanzvariable summe mit der Gesammtsumme"
    |count|
    summe := 0.
    count := 0.
    [count < anzahl]
    whileTrue:[ 
        count := count +1.
        summe := summe + ((aod at:count) at:#value).
    ].

    "Created: / 04-05-2017 / 18:35:45 / mawalch"
!

getVerticalStep
    |y|
    y := ( ( (height)/(anzahl *2 +1) )  ) rounded.     "y-koordinate"

    verticalY := y




                                      "/*2
! !

!ChartDescription methodsFor:'views'!

getChartDescription
    ^ self class new.
! !

!ChartDescription class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/ChartDescription.st,v 1.17 2017-11-28 18:25:52 cg Exp $'
! !

