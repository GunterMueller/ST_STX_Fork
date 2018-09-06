"{ Package: 'stx:goodies/demos/jh/math/dataAnalysis' }"

"{ NameSpace: Demos }"

ApplicationModel subclass:#HistogramApplication
	instanceVariableNames:'histogramView legenda'
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-DataAnalysis'
!

!HistogramApplication class methodsFor:'documentation'!

documentation
"
    Application to display a historgram

    [author:]
	Jan Hussaarts (Jan@DESKTOPJAN)

    [instance variables:]

    [class variables:]

    [see also:]

"
!

example1
    HistogramApplication openOn:((Distributions::NormalDistribution mean: 100 deviation: 20) next: 3000)
!

example2
    HistogramApplication openOn:(1 to:100)
! !

!HistogramApplication class methodsFor:'instance creation'!

openOn: aCollection
   self new openOn:aCollection
! !

!HistogramApplication class methodsFor:'interface specs'!

windowSpec
    "This resource specification was automatically generated
     by the UIPainter of ST/X."

    "Do not manually edit this!! If it is corrupted,
     the UIPainter may not be able to read the specification."

    "
     UIPainter new openOnClass:HistogramApplication andSelector:#windowSpec
     HistogramApplication new openInterface:#windowSpec
     HistogramApplication open
    "

    <resource: #canvas>

    ^
     #(#FullSpec
	#name: #windowSpec
	#window:
       #(#WindowSpec
	  #label: 'Histogram'
	  #name: 'Histogram'
	  #min: #(#Point 0 0)
	  #max: #(#Point 1024 749)
	  #bounds: #(#Rectangle 13 23 308 527)
	)
	#component:
       #(#SpecCollection
	  #collection: #(
	   #(#NonScrollableArbitraryComponentSpec
	      #name: 'NonScrollableArbitraryComponent1'
	      #layout: #(#LayoutFrame 9 0 9 0 -9 1 -153 1)
	      #borderWidth: 1
	      #component: #histogramView
	    )
	   #(#TextEditorSpec
	      #name: 'TextEditor1'
	      #layout: #(#LayoutFrame 9 0 -146 1 -9 1 -9 1)
	      #model: #legenda
	      #style: #(#FontDescription #ARIAL #medium #roman 10)
	      #hasHorizontalScrollBar: true
	      #hasVerticalScrollBar: true
	      #foregroundColor: #(#Color 0.0 0.0 0.0)
	      #backgroundColor: #(#Color 100.0 100.0 100.0)
	      #isReadOnly: true
	    )
	   )

	)
      )
! !

!HistogramApplication methodsFor:'accessing'!

histogramView
    "return the value of the instance variable 'histogramView' (automatically generated)"

    ^ histogramView
!

histogramView:something
    "set the value of the instance variable 'histogramView' (automatically generated)"

    histogramView := something.
!

legenda
^legenda
! !

!HistogramApplication methodsFor:'initialize / release'!

openOn:aCollection
| data |
data := (DataCollection data:aCollection).
    histogramView := HistogramView on:data.
histogramView backgroundColor: Color white.
legenda := data legenda.
    super open
! !

!HistogramApplication class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/dataAnalysis/Demos__HistogramApplication.st,v 1.3 2008-10-26 13:45:19 cg Exp $'
! !
