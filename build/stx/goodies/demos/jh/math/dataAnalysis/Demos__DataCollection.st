"{ Package: 'stx:goodies/demos/jh/math/dataAnalysis' }"

"{ NameSpace: Demos }"

Object subclass:#DataCollection
	instanceVariableNames:'data min max sum size sumOfSquares'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-DataAnalysis'
!


!DataCollection class methodsFor:'creation'!

data:aCollection
    ^self new data:aCollection
! !

!DataCollection methodsFor:'accessing'!

confidenceInterval: percentage
	"return the confidence interval for the population mean
	based on the samples of the receiver.
	assumptions:
		samples are approximately normal distributed
		samples are iid (independent identically distibuted)
		self size >= 2
		0 < percentage < 1
	the result should be interpreted as follows:
		when calculating the interval many times,
		the population mean will be contained by the interval
		in percentage number of cases
	see Law and Kelton section 9.4.1.
	"
	| mean delta |
	mean := self mean.
	delta := (DhbStudentDistribution degreeOfFreedom: (self size - 1)) value: (1 - percentage / 2).
	delta := delta * (self variance / self size) sqrt.
	^Array with: mean - delta with: mean + delta
!

data:aCollection
    data := aCollection.
    min := aCollection min.
    max := aCollection max.
    size := aCollection size.
    sum := aCollection sum.
    sumOfSquares := aCollection inject:0 into:[:x :y | x + (y squared)]
!

legenda
	| stream |
	stream := WriteStream on: String new.
	self legendaOn: stream.
	^stream contents
!

legendaOn: aStream
    self legendaOn: aStream indent: 0
!

legendaOn: aStream indent: aSetOfabs
	| interval relativePrecision confidencePercentage |
	confidencePercentage := 0.95.
	interval := self confidenceInterval: confidencePercentage.
	relativePrecision := self relativePrecisionWithConfidence: confidencePercentage.
	aStream
		tab: aSetOfabs; nextPutAll: 'size: '; print: self size;
		crtab: aSetOfabs; nextPutAll: 'mean: '; print: self mean asFloat;
		crtab: aSetOfabs; nextPutAll: 'variance: '; print: self variance asFloat;
		crtab: aSetOfabs; nextPutAll: 'min: '; print: self min asFloat;
		crtab: aSetOfabs; nextPutAll: 'max: '; print: self max asFloat;
		crtab: aSetOfabs; nextPutAll: 'conf interval of mean '; print: confidencePercentage*100; nextPutAll: '%: ';
		 nextPutAll: '<', interval first printString, ' - ', interval last printString, '>';
		crtab: aSetOfabs; nextPutAll: 'rel precision: '; print: relativePrecision asFloat.
!

max
^max
!

mean
^sum  / size
!

min
^min
!

range
^max - min
!

relativePrecisionWithConfidence: confidencePercentage
       | interval |
	interval := self confidenceInterval: confidencePercentage.
	^(interval last - interval first) / self mean abs.
!

size
^size
!

standardDeviation
	^self variance sqrt
!

sum
^sum
!

update:aView
    |fs height width numberOfBars max min step histogram bw labels fw size labelWidth bl startPoint|

    fs := aView font size.
    fw := aView font width.
    height := aView height.
    width := aView width.
    numberOfBars := ((height / (2 * fs + 4)) floor) min:data size.
    numberOfBars <= 2 ifTrue:[
	'to small' displayOn:aView at:(4 @ (fs + 4)).
	^ self
    ].
    bw := ((height) / numberOfBars floor) max: (fs + 2).
    max := data max.
    min := data min.
    size := data size.
    step := ((max - min) / (numberOfBars - 1)).
    labels := Array new:numberOfBars.
    1 to:numberOfBars do:[:entry |
	labels at:entry
	    put:(min + ((entry - 1) * step)) printString , '..'
		    , (min + (entry * step)) printString
    ].
    histogram := Array new:numberOfBars withAll:0.
    data do:[:e |
	|entry|

	entry := 1 + (((e - min) / step) floor).
	e < (min + ((entry) * step)) ifFalse:[
	    entry := entry + 1
	].
	(histogram at:entry put:((histogram at:entry) + 1))
    ].
    labelWidth := (labels collect:[:l | l size * fw]) max.
    bl := (width - labelWidth - 20 - (6 * fw)) / (histogram max / size).
    startPoint := labelWidth + 10 + (6 * fw).
    1 to:numberOfBars do:[:entry |
	|y|

	y := ((0.5 * fs) + ((entry - 0.5) * bw )).
	(labels at:entry) displayOn:aView at:(2 @ y).
	(((10000 * (histogram at:entry) / size) floor / 100.0) printString , '%')
	    displayOn:aView
	    at:((4 + labelWidth) @ y).
	(histogram at:entry) = 0 ifFalse:[
	    y := 1 + ((entry - 1) * bw).
	    (Rectangle origin:(startPoint @ (y + 1))
		corner:(startPoint + (bl * ((histogram at:entry) / size)) floor)
			@ (y + bw - 1))
		    displayFilledOn:aView
	]
    ]
!

variance
	size <= 1 ifTrue: [^self error: 'no variance'].
	^(sumOfSquares - (sum squared / size)) / (size - 1)
! !

!DataCollection methodsFor:'testing'!

histogramViewWithIntervals2: intervalCollection
      | histogram window max x list labels style lw |
	histogram := self histogramWithIntervals: intervalCollection.
	max := histogram max.
	labels := OrderedCollection new.
	list := String new writeStream.
	list nextPutAll: '< '; print: intervalCollection first.
	labels add: list contents. list reset.
	1 to: intervalCollection size - 1 do:
		[ :i |
		list print: (intervalCollection at: i); nextPutAll: ' .. '; print: (intervalCollection at: i+1).
		labels add: list contents. list reset].
	list nextPutAll: '> '; print: intervalCollection last.
	labels add: list contents. list reset.
	labels := TextList onList: labels.
	style := TextAttributes default.
	labels textStyle: style.
	lw := labels preferredBounds width + 4.
	window := ScheduledWindow model: self label: 'Histogram' minimumSize: (lw+40)@(labels height).
	window component: (GraphicsView new display:
		[ :gc |
		labels displayOn: gc.
		1 to: histogram size do:
			[ :i |
			x := (histogram at: i) * (gc medium width - lw) / max.
			gc displayRectangle: (lw@((i-1)*style lineGrid) extent: x@(style lineGrid -2))]
		]).
	window open.
!

histogramViewWithIntervals:intervalCollection
    "(DataCollection data:((DhbNormalDistribution new: 10 sigma: 3) next: 100)) histogramViewWithIntervals: (0 to: 20 by: 1)"

    |histogram max list labels v top|

    histogram := self histogramWithIntervals:intervalCollection.
    max := histogram max.
    labels := OrderedCollection new.
    list := String new writeStream.
    list
	nextPutAll:'< ';
	print:intervalCollection first.
    labels add:list contents.
    list reset.
    1 to:intervalCollection size - 1 do:[:i |
	list
	    print:(intervalCollection at:i);
	    nextPutAll:' .. ';
	    print:(intervalCollection at:i + 1).
	labels add:list contents.
	list reset
    ].
    list
	nextPutAll:'> ';
	print:intervalCollection last.
    labels add:list contents.
    list reset.
    v := CodingExamples_GUI::HistogrammView new.
    v labels:labels.
    v values:histogram.
    top := StandardSystemView label:'Histogram view'.
    " v colors:(Array with:Color red with:Color green with:Color blue).     "
    top extent:400 @ 400.
    top
	addSubView:v
	in:(0.0 @ 0.0 corner:1.0 @ 1.0)
	borderWidth:0.
    top open
!

histogramWithIntervals:anIntervalCollection
    |histogram found i|

    histogram := Array new:anIntervalCollection size + 1 withAll:0.
    data do:[:d |
	found := false.
	d <= anIntervalCollection first ifTrue:[
	    histogram at:1 put:(histogram first) + 1.
	    found := true
	].
	d > anIntervalCollection last ifTrue:[
	    histogram at:histogram size put:(histogram last) + 1.
	    found := true
	].
	i := 1.
	[found] whileFalse:[
	    (d > (anIntervalCollection at:i) and:[d <= (anIntervalCollection at:i + 1)]) ifTrue:[
		histogram at:i + 1 put:(histogram at:i + 1) + 1.
		found := true
	    ].
	    i := i + 1
	]
    ].
    ^ histogram
! !

!DataCollection class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/dataAnalysis/Demos__DataCollection.st,v 1.2 2008-10-26 13:45:19 cg Exp $'
! !
