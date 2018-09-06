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

AbstractChart subclass:#ChartKey
	instanceVariableNames:'xPos summe foregroundColor backgroundColor fontOK verticalY'
	classVariableNames:''
	poolDictionaries:''
	category:'Statistic-Charts'
!

!ChartKey class methodsFor:'documentation'!

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
    ChartDescription for a diagram, whose values are a model as like an array of dictionaries 
    so have a look at 'class - documentation - examples'
    This can be used beside a BarChartWidget or PieChartWidget as
    a legend (extracting its values from the same model).

    This was one if the author's very first smalltalk programs ever.
    So please excuse any odd code.

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
        piece at:#color put:(Color red on:Display).
        chart add:piece.

        piece := Dictionary new.
        piece at:#name put:'Hallabadkapp'.
        piece at:#color put:(Color blue on:Display).
        chart add:piece.

        p := ChartDescription new.
        p model:(holder := ValueHolder new).
        p open.
        holder value:chart.
        Delay waitForSeconds:2.
        1 to: 20 do:[:i |
            piece := Dictionary new.
            i odd ifTrue:[
                piece at:#name put:'Hallo erstmal...'.
                piece at:#color put:(Color green on:Display).
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

                                                                [exBegin]
        |p v chart piece holder|

        chart := OrderedCollection new.
        piece := Dictionary new.
        piece at:#name put:'Güllemütz'.
        piece at:#color put:(Color red on:Display).
        chart add:piece.

        piece := Dictionary new.
        piece at:#name put:'Hallabadkapp'.
        piece at:#color put:(Color blue on:Display).
        chart add:piece.

        p := ChartKey new.
        p model:chart asValue.

        v := View new.
        v extent:1000@1000.
        v open.
        Delay waitForSeconds:1.
        p redrawChartDescOn:v inArea:(400@400 extent:50@50).
                                                                [exEnd]
"
! !

!ChartKey class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!ChartKey class methodsFor:'startup'!

open
    ^self new open
! !

!ChartKey methodsFor:'accessing'!

anzahl
    ^ aod count:[:aDic |aDic includesKey:#name].  
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

getColorAt:aNumber 
    ^ (aod at:aNumber) at:#color
!

getNameAt:num 
    ^ ((aod at:num) at:#name)
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
!

xPosOn:aView 
    ^ ((aView origin x)) rounded
! !

!ChartKey methodsFor:'accessing-color & font'!

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

!ChartKey methodsFor:'class initialization'!

initialize
    anzahl  :=0.
    summe   :=0.
    aod     :=0.
! !

!ChartKey methodsFor:'drawing'!

drawChartDescOn:aView inArea:aArea
"/    fontOK == true ifFalse:[
"/        self getVerticalStepOn:aView inArea:aArea.
"/        self getNewFontSizeOn:aView inArea:aArea.
"/        fontOK := true.
"/    ].
    self drawDescriptionOn:aView inArea:aArea.           "write description of pieces"
!

drawDescriptionOn:aView inArea:anArea
    |x y yPos keyName maxFontHeight verticalSpace|

    maxFontHeight := self getMaxFontSizeOn:aView inArea:anArea.
    verticalSpace := maxFontHeight / self anzahl.

    yPos := anArea origin y + maxFontHeight + verticalSpace.                              


    aView font:(aView font size:(maxFontHeight)).
    x := anArea origin x + (maxFontHeight * 2).                           
    y := yPos.
    1 to:self anzahl do:[:num|                          

        aView paint:(self getColorAt:num).

        aView fillRectangleX:anArea origin x  y:(y - (maxFontHeight ))          "draw colorpoint"
                          width:maxFontHeight  height: (maxFontHeight).


        keyName := self getNameAt:num.
        aView displayString:keyName x:x  y:y.            "write name"

        y := y + maxFontHeight + verticalSpace.         "y-koordinate"

    ].

"/     aView paint:(Color white).
"/    aView displayRectangle:anArea
!

redrawChartDescOn:aView inArea:aRect
    self drawChartDescOn:aView inArea:aRect
! !

!ChartKey methodsFor:'private'!

getMaxFontSizeOn:aView inArea:anArea
"
   needs to be refactored. hard coded attributes will confuse the reader.
"
    | maxString minSize maxSize font|
    maxString := self getMaxStringLenOn:aView.   
    minSize := 1.
    maxSize := 25.
    font := aView font copy.

    maxSize to: minSize by:-1 do:[:aSize |
        | width height|    
        font := font size:aSize.
        width := font widthOf:maxString on:aView device.   
        height := font heightOf:maxString on:aView device.   
        (width < (anArea width - (height * 2)) and:[((self anzahl + 2)* height) < anArea height]) ifTrue:[    

            ^ aSize
        ].
    ].           

    ^ minSize.       

"/   ^ anArea height / (self anzahl + 2)

    "Modified: / 29-11-2011 / 11:59:16 / cg"
!

getMaxStringLenOn:aView
    |str strlen max longest|

    max := 0.
    1 to:aod size do:[:idx |
        str := self getNameAt:idx.           
        strlen := aView font widthOf:str on:aView device.   
        strlen > max ifTrue:[
            max := strlen.
            longest := str
        ].

    ].

    ^ longest                                            
! !

!ChartKey class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/ChartKey.st,v 1.9 2017-11-28 18:23:46 cg Exp $'
! !

