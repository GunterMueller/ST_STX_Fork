"{ Package: 'stx:goodies/demos/jh/math/dataAnalysis' }"

"{ NameSpace: Demos }"

View subclass:#HistogramView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'demos-JH-DataAnalysis'
!


!HistogramView methodsFor:'drawing'!

sizeChanged:how
    super sizeChanged:how.
    self clear.
    self redraw.
! !

!HistogramView class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/goodies/demos/jh/math/dataAnalysis/Demos__HistogramView.st,v 1.2 2008-10-26 13:45:19 cg Exp $'
! !
