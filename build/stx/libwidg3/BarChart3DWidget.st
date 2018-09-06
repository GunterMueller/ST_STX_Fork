"
 COPYRIGHT (c) 2002 by eXept Software AG
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

ObjectView subclass:#BarChart3DWidget
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Views-Misc'
!

DisplayObject subclass:#Bar
	instanceVariableNames:'origin corner color percentageHeight depthVector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BarChart3DWidget
!

DisplayObject subclass:#Label
	instanceVariableNames:'origin corner label font depthVector'
	classVariableNames:''
	poolDictionaries:''
	privateIn:BarChart3DWidget
!

!BarChart3DWidget class methodsFor:'documentation'!

copyright
"
 COPYRIGHT (c) 2002 by eXept Software AG
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
    Display a matrix of values as bars in 3D.
    The values have to be between 0.0 and 1.0.
    The Matrix is given as collection of rows.
    Additionally a labeling of rows and columns
    is possible.

    [author:]
        Martin Walser (martin@vercingetorix)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

examples
"
    From sample data:
                                                                [exBegin]
    self open.
                                                                [exEnd]
"
! !

!BarChart3DWidget class methodsFor:'queries'!

isVisualStartable
    "
    Be startable from Browser!!
    "

    ^ true.
! !

!BarChart3DWidget class methodsFor:'samples'!

sampleLabelsColumns
    "Return a collection with labels for the columns of a bar matrix.
     Attention - Corresponding in size to matrix sample.
    "
    ^ #('Müller' 'Hofmann' 'Hermann' 'Fritz' 'Allmendinger' 'Gebhart' 'Schmidt' 'Elwert' 'Mayer' 'Ebert' 'Schröder' 'Peters' 'Albert').
!

sampleLabelsRows
    "Return a collection with labels for the rows of a bar matrix.
     Attention - Corresponding in size to matrix sample.
    "
    ^ #(1995 1996 1997 1998 1999 2000 2001 2002).
!

sampleMatrix
    "Return a sample matrix useable 
     as a model for bar-chart-view.
    "
    |randomizer rowSize columnSize random sample|
    randomizer := Random new.

    rowSize    := self sampleLabelsRows size.
    columnSize := self sampleLabelsColumns size.

    sample :=  (1 to:rowSize) collect:[        
        :rowIndex|
        (1 to:columnSize) collect:[
            :columnIndex|
            random := randomizer nextBetween:1 
                                         and:10.

            1 / random.
        ].
    ].

    "/ Force one to be at maximum, for test reason.
    (sample at:1) at:1 put:1.

    ^ sample
! !

!BarChart3DWidget class methodsFor:'startup'!

open
    "
    Open up with an example.
    "

    |instance|
    instance := self new.

    instance extent: 1000@500.
    instance model:             self sampleMatrix.
    instance labelsForColumns:  self sampleLabelsColumns.
    instance labelsForRows:     self sampleLabelsRows.

    instance open.
! !

!BarChart3DWidget methodsFor:'accessing'!

barExtent
    "Return the extent for one bar.
     It is the two dimensional extent.
    "
    ^ Bar defaultExtent .
!

columnGap
    "Return the gap between two columns of bars.
    "
    ^ 5.
!

depthVector
    "Return the depthsVector for all bars and column labels.
    "
    ^ Bar defaultDepthsVector
!

labelsForColumns:aCollectionOfLabels
    "Set labels for the columns.
     The size of of the collection
     has to be the number of columns.
    "
    self buildColumnLabelsFor:aCollectionOfLabels.
!

labelsForRows:aCollectionOfLabels
    "Set labels for the rows.
     The size of the collection
     has to be the number of rows.
    "
    self buildRowLabelsFor:aCollectionOfLabels.
!

matrix
    "Return the matrix we are displaying.
    "
    ^ model value.
!

offset
    "
    "
    ^ 30@30.
!

rowGapFactor
    "Return a factor to build gap inbetween the rows.
     The gap is build from the depths vector.
    "
    ^ 1.5.
! !

!BarChart3DWidget methodsFor:'accessing-mvc'!

model:aModel
    "A new model gets set to the view.
     Update the view with this model.
    "
    super model:aModel.

    self buildBars.
! !

!BarChart3DWidget methodsFor:'change & update'!

update:something with:aParameter from:changedObject
    "Update on model changes.
    "
    changedObject == model ifTrue:[
        ^ self buildBars.
    ].

    super update:something 
            with:aParameter 
            from:changedObject
! !

!BarChart3DWidget methodsFor:'private building'!

buildBars
    "Build bars for the values in the matrix.
     A matrix is a collection of collections 
     with percentage values(0.0 - 1.0) in it.
    "
    |matrix bar|
    matrix := self matrix.
    matrix ifNil:[^ self].

    self removeAll.

    matrix withIndexDo:[
        :row :rowIndex|
        row withIndexDo:[
            :value :columnIndex|
            bar := Bar
                      for:value
                       on:self
                       at:(rowIndex@columnIndex).

            self add:bar.
        ].
    ].
!

buildColumnLabelsFor:aCollectionOfLabels
    "Build display objects for a collection of labels 
     and add them to the content of this view.
    "
    |displayLabel|
    aCollectionOfLabels doWithIndex:[
        :label :index|
        displayLabel := Label 
                            turnedFor:label printString
                                   on:self
                                   at:index.

        self add:displayLabel.
    ].
!

buildRowLabelsFor:aCollectionOfLabels
    "Build labels from a collection of strings 
     and add them to the content of this view.
    "
    |displayLabel|

    aCollectionOfLabels doWithIndex:[
        :label :index|
        displayLabel  := Label 
                             for:label printString
                              on:self
                              at:index 
.
        self add:displayLabel.
    ].
! !

!BarChart3DWidget methodsFor:'queries'!

heightOfContents
    "Need to have reasonable scrollers.
     Calculates the needed size from merging all bars.
     If there is no content my size is zero.
    "
    |list|
    list := contents collect:[:bar|bar computeMaxBoundingBox].
    list isEmpty ifTrue:[^ 0].

    ^ (Rectangle merging:list) height + self offset y.
!

widthOfContents
    "Need to have reasonable scrollers.
     Calculates the needed size from merging all bars.
     If there is no content my size is zero.
    "
    |list|
    list := contents collect:[:bar|bar computeMaxBoundingBox].
    list isEmpty ifTrue:[^ 0].

    ^ (Rectangle merging:list) width + self offset x.
! !

!BarChart3DWidget::Bar class methodsFor:'defaults'!

defaultColorsAt:aNumber
    "Return a color for a number.
     Use three different colors and alternate them for bigger numbers.
     Caller gets always a useable bar-color.
    "
    |colors|
    colors := Array with:Color blue
                    with:Color red
                    with:Color green.

    ^ colors at:1 + ((aNumber - 1) \\ colors size).


!

defaultDepthsVector
    "Return a vector for the depths.
     Holding direction and length of the depths of a bar.
    "
    ^ 10@20.
!

defaultExtent
    "Return the default extent of a display bar.
    "
    ^ 50@100.
! !

!BarChart3DWidget::Bar class methodsFor:'documentation'!

documentation
"
    One 3-dimensional-bar of a bar-chart-view.

    [author:]
        Martin Walser (martin@vercingetorix)

    [instance variables:]
        color                Color
        origin               Like with rectangle the most top left point 
                             of the maximum bar, not of the real bar.
        corner               Like with rectangle the most bottom right point.
        percentageHeight     The 'value' of the bar, a value inbetwen 0,0 and 1.0
        depthVector          Depth of the bar as vector.

    [class variables:]

    [see also:]

"
! !

!BarChart3DWidget::Bar class methodsFor:'instance creation'!

for:aValue on:aBarChartView at:aPosition
    "Build a display bar on a view.
    "
    |instance|
    instance := self new.

    instance for:aValue 
              on:aBarChartView 
              at:aPosition.

    ^ instance.
! !

!BarChart3DWidget::Bar methodsFor:'accessing'!

corner
    "Return the corner.
    "
    ^ corner.
!

origin
    "Return the origin of this bar.
     It is the origin of the maximum bar.
    "
    ^ origin.
! !

!BarChart3DWidget::Bar methodsFor:'drawing required'!

drawIn:aDrawable offset:anOffset 
    "Display yourself in a drawable.
     Draws three sides of three dimensional bar.
    "
    |oldPaint topLeft corner depths extent height width color topFront topBack bottomBack backLeft frontRight|
    oldPaint   := aDrawable paint.
    depths     := aDrawable depthVector.
    topLeft    := self origin + anOffset + (0@depths y).
    corner     := self corner + anOffset.
    color      := self color.
    extent     := corner - topLeft.
    height     := self percentageHeight * extent y.
    width      := extent x  - depths x.
    topFront   := topLeft y + extent y - height.
    topBack    := topFront  - depths y.
    bottomBack := corner y  - depths y.
    backLeft   := topLeft x + depths x.
    frontRight := corner x  - depths x.

    "/ The top side: 
    aDrawable paint:color lightened.  "/ light
    aDrawable fillPolygon:(
                            Array with:topLeft x  @ topFront
                                  with:backLeft   @ topBack
                                  with:corner x   @ topBack
                                  with:frontRight @ topFront
                          ).    


    "/ The right side:
    aDrawable paint:color darkened.   "/ shadow
    aDrawable fillPolygon:(
                            Array with:frontRight @ corner y
                                  with:frontRight @ topFront
                                  with:corner x   @ topBack
                                  with:corner x   @ bottomBack
                          ).

    "/ the front side:               
    aDrawable paint:color.            "/ normal
    aDrawable fillRectangleX:topLeft x
                           y:topFront
                       width:width
                      height:height.

    aDrawable paint:oldPaint

    "/ This code can be enabled to show the different boundings
    "/ Attention just for testing not redrawable secure.

    "/ aDrawable paint:Color black.
    "/ aDrawable displayRectangle:self computeMaxBoundingBox.

    "/ aDrawable paint:Color red.
    "/ aDrawable displayRectangle:self computeBoundingBox.
! !

!BarChart3DWidget::Bar methodsFor:'initialization'!

computeBoundingBox
    "Return the bounding box of the drawn real display bar.
     You can see this box if you enable some line in the draw method.
    "
    |offset origin corner extent height topFront topBack|

    offset   := depthVector y.
    origin   := self origin + (0@offset).
    corner   := self corner.
    extent   := corner - origin.
    height   := self percentageHeight * extent y.
    topFront := origin y + extent y - height.
    topBack  := topFront - offset.
    origin   := origin x @ topBack.

    frame := Rectangle
          origin:origin asInteger
          corner:corner asInteger.

    ^ frame
!

computeMaxBoundingBox
    "Return the bounding box of the total potential display bar.
     You can see this box if you enable some line in the draw method.
    "
    ^ Rectangle
          origin:self origin asInteger 
          corner:self corner asInteger.
! !

!BarChart3DWidget::Bar methodsFor:'private accessing'!

color
    "Return the color.
     If no color set, use first of defaults.
    "
    color ifNil:[
        color := self class defaultColorsAt:1.
    ].

    ^ color.
!

percentageHeight
    "Return the percentage height of the bar.
     Default is to be 100% = 1.0
    "
    ^ percentageHeight ? 1
! !

!BarChart3DWidget::Bar methodsFor:'private instance creation'!

for:aValue on:aBarChartView at:aPosition 
    "Build a display bar.
     Private - use only for instance creation.
    "
    |matrix amount extent singleDepth totalDepth offset columnGap|
    percentageHeight := aValue.
    matrix           := aBarChartView matrix.
    amount           := matrix size.
    extent           := aBarChartView barExtent.
    depthVector      := aBarChartView depthVector.
    singleDepth      := depthVector * (1 @ -1) * aBarChartView rowGapFactor.
    totalDepth       := singleDepth * (amount - 1).
    color            := (self class defaultColorsAt:aPosition x).
    offset           := aBarChartView offset - (0 @ totalDepth y).

    "/ Commented is another look, to use you have to change labels too!!   
    columnGap        := aBarChartView columnGap  "+ totalDepth x".

    origin           := offset + (singleDepth * (amount - aPosition x))+ (((extent x + columnGap) * (aPosition y - 1)) @ 0).
    corner           := origin + extent.

    self computeBoundingBox
! !

!BarChart3DWidget::Label class methodsFor:'defaults'!

defaultFont
    "Return a font to draw with."

    ^ Label defaultFont asSize:14.
! !

!BarChart3DWidget::Label class methodsFor:'documentation'!

documentation
"
    One Label for a column or a row.

    [author:]
        Martin Walser (martin@vercingetorix)

    [instance variables:]
        origin               Like with rectangle, the most top left point.
        corner               Like with rectangle, the most bottom right point.
        label                String to print as label.
        font                 Font used for the label.
        depthVector          Depth for turned labels, used only for column-labels.

    [class variables:]

    [see also:]

"
! !

!BarChart3DWidget::Label class methodsFor:'instance creation'!

computeExtentForTurned:aLabel font:aFont depth:aVector
    "Compute the extent for a turned label.
    "
    |textHeight textWidth height width vector theta|
    textHeight := aFont heightOf:aLabel.
    textWidth  := aFont widthOf:aLabel.

    vector := aVector normalized * textWidth.   
    theta  := vector theta.

    width  := vector x + (theta sin * textHeight).
    height := vector y + (theta cos * textHeight).

    ^ (width @ height) asInteger.
!

for:aLabel on:aView at:anIndex
    "Create and return a new display label.
     Use default font.
    "
    ^ self for:aLabel 
            on:aView
            at:anIndex
          font:self defaultFont.
!

for:aLabel on:aBarChartView at:anIndex font:aFont
    "Create and return a horizontal display bar label.
     This one are used for the description of rows.
    "
    |instance|
    instance := self new.
    instance for:aLabel 
              on:aBarChartView 
              at:anIndex 
            font:aFont.

    ^ instance.
!

turnedFor:aLabel on:aBarChartView at:anIndex 
    "Create and return a new display label. The label is turned.
     The turn angle is defined by depth vector of the bar chart view.
     Use default font.
    "
    ^ self turnedFor:aLabel
                  on:aBarChartView
                  at:anIndex
                font:self defaultFont.
!

turnedFor:aLabel on:aBarChartView at:anIndex font:aFont
    "Create and return a turned display bar label.
     This ones are used for dispcription of columns.
    "
    |instance|
    instance := self new.

    instance turnedFor:aLabel
                    on:aBarChartView 
                    at:anIndex 
                  font:aFont.

    ^ instance.
! !

!BarChart3DWidget::Label methodsFor:'accessing'!

corner
    "Return the corner.
    "
    ^ corner.
!

origin
    "Return the origin of this bar.
    "
    ^ origin.
!

textHeight
   "Return the length of the label-text.
   "
   ^ font heightOf:label printString.
!

textLength
   "Return the length of the label-text.
   "
   ^ font widthOf:label printString.
!

textOrigin
   "Return the label-text origin.
    The origin is the start of the baseline.
   "
   |vector ascent normal|
   vector := self depthVector.
   ascent := font ascent.

   vector ifNil:[
       ^ origin + (0@ascent)
   ].
   normal := vector normalized * ascent.
   normal := (normal y @ normal x).

   ^ origin + (0@self textVector y) + normal.
!

textVector
    "Return a vector with length and 
     direction of the label text.
    "
    |vector|
    vector := self depthVector.
    vector ifNil:[^ nil].

    ^ vector normalized * self textLength.
! !

!BarChart3DWidget::Label methodsFor:'drawing required'!

drawIn:aDrawable offset:anOffset 
    "Display yourself on a drawable
    "
    |oldFont position|
    oldFont  := aDrawable font.
    aDrawable font:font.

    position := self textOrigin + anOffset.

    self depthVector isNil ifTrue:[
        aDrawable displayString:label
                             at:position.
    ] ifFalse:[
        aDrawable displayString:label
                              x:position x
                              y:position y
                          angle:(depthVector * (1 @ -1)) theta radiansToDegrees.
    ].

    aDrawable font:oldFont.

    "/ Display the bounding box for test.
    "/ aDrawable displayRectangle:self frame.
! !

!BarChart3DWidget::Label methodsFor:'initialization'!

computeBoundingBox
    "Return the bounding box of this label.
   "
   frame := Rectangle
       origin:self origin
       corner:self corner.
   ^ frame
!

computeMaxBoundingBox
   "Compute the maximal bounding box.
    Used to calculate content extent.
    For labels same like compute bounding box = frame.
   "
   ^ frame ? self computeBoundingBox.
! !

!BarChart3DWidget::Label methodsFor:'private accessing'!

depthVector
    "Return the depth vector.
    "
    ^ depthVector
! !

!BarChart3DWidget::Label methodsFor:'private instance creation'!

for:aLabel on:aBarChartView at:anIndex font:aFont 
    "Build a normal display bar label.
     Private - use only for instance creation.
    "
    |columnGap matrix singleDepth totalDepth numberOfRows numberOfColumns offset barExtent columnWidth textHeight|
    font            := aFont onDevice:aBarChartView device.
    label           := aLabel.
    columnGap       := aBarChartView columnGap.
    matrix          := aBarChartView matrix.
    numberOfRows    := matrix size.
    numberOfColumns := matrix first size.
    singleDepth     := aBarChartView depthVector * (1 @ -1) * aBarChartView rowGapFactor.
    totalDepth      := singleDepth * numberOfRows.
    barExtent       := aBarChartView barExtent.

    "/ Commented is another look, to use you have to change bars and column labels too!!    
    columnWidth     := barExtent x + columnGap "+ ((numberOfRows - 1) * singleDepth x)".

    textHeight      := self textHeight.
    offset          := aBarChartView offset + ((numberOfColumns * columnWidth) @ (barExtent y - textHeight)).
    origin          := offset + ((singleDepth x * (numberOfRows - anIndex)) @ (singleDepth y * (1 - anIndex))).
    corner          := origin + (self textLength @ textHeight).

    self computeBoundingBox
!

turnedFor:aLabel on:aBarChartView at:anIndex font:aFont 
    "Build a turned display bar label.
     Private - Use only for instance creation.
    "
    |columnGap barExtent matrix numberOfRows numberOfColumns singleDepth columnWidth barWidth hook extent|
    font            := aFont onDevice:aBarChartView device.
    label           := aLabel.
    columnGap       := aBarChartView columnGap.
    depthVector     := aBarChartView depthVector.
    barExtent       := aBarChartView barExtent.
    matrix          := aBarChartView matrix.
    numberOfRows    := matrix size.
    numberOfColumns := matrix first size.
    singleDepth     := depthVector * aBarChartView rowGapFactor.

    "/ Commented is another look, to use you have to change bars and rowlabels too!!    
    columnWidth     := barExtent x + columnGap"+ ((numberOfRows - 1) * singleDepth x)".

    extent          := self class computeExtentForTurned:aLabel
                                                    font:aFont
                                                   depth:depthVector.

    barWidth        := barExtent x - depthVector x.
    hook            := (((anIndex - 1) * columnWidth) + (barWidth / 2)) @ (barExtent y + ((numberOfRows - 1) * singleDepth y)).
    origin          := hook - ((depthVector normalized * self textLength) x @ 0).
    origin          := aBarChartView offset + origin.
    corner          := origin + extent.

    self computeBoundingBox
! !

!BarChart3DWidget class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChart3DWidget.st,v 1.10 2017-01-03 09:46:04 stefan Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libwidg3/BarChart3DWidget.st,v 1.10 2017-01-03 09:46:04 stefan Exp $'
! !

