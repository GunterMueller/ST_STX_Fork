"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SimpleView subclass:#TextExampleView
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!


!TextExampleView methodsFor:'accessing-dimensions'!

preferredExtent

    ^400 @ 400

    "Created: / 17-06-2012 / 22:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextExampleView methodsFor:'redrawing'!

redraw

    self font: (Font family: 'Helvetica' face: 'medium' style: 'italic' size: 32).
    self displayString: 'Hello world!!' x: 10 y: 40.

    self redrawWithCairo

    "Created: / 16-06-2012 / 23:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-12-2014 / 00:37:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawWithCairo: cr

    self clippingBounds: nil. 


    self font: (Font family: 'Helvetica' face: 'medium' style: 'italic' size: 32).
    self displayString: 'Hello world!!' x: 10 y: 40.

    cr fontFaceFamily: 'Helvetice' slant: Cairo::FontSlant CAIRO_FONT_SLANT_ITALIC weight: Cairo::FontWeight CAIRO_FONT_WEIGHT_NORMAL. 
    cr fontSize: 42.

    cr moveToX: 10 y: 82.
    cr showText: 'Hello World!!'

    "Created: / 27-12-2014 / 00:36:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:13:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawX: x y: y width: w height: h
    self redraw

    "Created: / 17-06-2012 / 21:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-12-2014 / 00:37:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextExampleView class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

