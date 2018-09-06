"{ Package: 'stx:goodies/libcairo/tests' }"

"{ NameSpace: Cairo }"

TestCase subclass:#GraphicsContextTests
	instanceVariableNames:'view cr'
	classVariableNames:''
	poolDictionaries:'Cairo::FontSlant Cairo::FontWeight'
	category:'Cairo-Tests'
!


!GraphicsContextTests methodsFor:'running'!

setUp
    | top |
    self assert: Display notNil.

    top := StandardSystemView new.
    view := View new.
    view origin:0.0 @ 0.0 corner:1.0 @ 1.0.
    top addSubView:view.
    top extent: 200 @ 200.
    top openAndWait.
    view viewBackground: Color white.
    view clear.
    cr := view cairo.

    "Created: / 18-02-2016 / 08:36:43 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 26-03-2016 / 23:37:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

tearDown
    view notNil ifTrue:[ 
        cr release.
        view := view topView destroy.
    ].

    "Created: / 18-02-2016 / 08:37:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContextTests methodsFor:'tests - source'!

test_source_01
    | c |

    cr sourceR: 1 G: 0 B: 0.
    c := cr source color.
    self assert: c = Color red.
    "/ Now try to get rid of the pattern,
    "/ this tests that we tell cairo
    "/ that the pattern is referenced from
    "/ outside...
    Smalltalk garbageCollect

    "Created: / 05-03-2016 / 12:32:56 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_source_02
    | c |

    cr source: (Pattern color: Color red).
    c := cr source color.
    self assert: c = Color red.

    "Created: / 05-03-2016 / 22:17:53 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContextTests methodsFor:'tests - text'!

test_01
    | extents1 fontMatrix1 extents2 fontMatrix2 |        

    cr font: 'Helvetica' slant: CAIRO_FONT_SLANT_ITALIC weight: CAIRO_FONT_WEIGHT_NORMAL.
    cr fontSize: 10.0.
    extents1 := cr textExtents: 'Hello world'.
    fontMatrix1 := cr fontMatrix.

    cr fontSize: 5.0.
    cr font: (ScaledFont fromFontDescription: (FontDescription family: 'Helvetica' face: 'thin' style: 'italic' size: 10)).
    extents2 := cr textExtents: 'Hello world'.
    fontMatrix2 := cr fontMatrix.

    self assert: extents1 = extents2.

    "Created: / 18-02-2016 / 08:37:12 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-07-2018 / 20:08:33 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContextTests methodsFor:'tests - transformation & clipping'!

test_clip_01
    self assert: (view colorAtX: 5 y: 5) = Color white.

    cr source: Color red.
    cr rectangleX: 0 y:0 width: 20 height: 20.
    cr fill.
    self assert: (view colorAtX: 10 y: 10) = Color red.

    cr rectangleX: 5 y:5 width: 10 height: 10.
    cr clip.
    cr source: Color blue.
    cr rectangleX: 0 y:0 width: 20 height: 20.
    cr fill.
    self assert: (view colorAtX: 3 y: 3) = Color red.
    self assert: (view colorAtX: 10 y: 10) = Color blue.
    self assert: (view colorAtX: 18 y: 18) = Color red.
    self assert: cr clipBounds = (5@5 corner: 15@15).

    cr clipReset.
    cr source: Color yellow.
    cr rectangleX: 0 y:0 width: 40 height: 40.
    cr fill.
    self assert: (view colorAtX: 10 y: 10) = Color yellow.
    self assert: (view colorAtX: 30 y: 30) = Color yellow.
    self assert: cr clipBounds = (0@0 extent: view extent).

    "Created: / 26-03-2016 / 23:34:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_clip_02
    self assert: (view colorAtX: 5 y: 5) = Color white.

    cr translate: 100.
    cr source: Color red.
    cr rectangleX: 0 y:0 width: 20 height: 20.
    cr fill.
    self assert: (view colorAtX: 10 y: 10) = Color white.
    self assert: (view colorAtX: 100 y: 100) = Color red.

    cr rectangleX: 5 y:5 width: 10 height: 10.
    cr clip.
    cr source: Color blue.
    cr rectangleX: 0 y:0 width: 20 height: 20.
    cr fill.
    self assert: (view colorAtX: 3 y: 3) = Color white.
    self assert: (view colorAtX: 103 y: 103) = Color red.
    self assert: (view colorAtX: 10 y: 10) = Color white.
    self assert: (view colorAtX: 110 y: 110) = Color blue.
    self assert: (view colorAtX: 18 y: 18) = Color white.
    self assert: (view colorAtX: 118 y: 118) = Color red.
    self assert: cr clipBounds = (5@5 corner: 15@15).

    cr clipReset.
    cr source: Color yellow.
    cr rectangleX: 0 y:0 width: 40 height: 40.
    cr fill.
    self assert: (view colorAtX: 10 y: 10) = Color white.
    self assert: (view colorAtX: 110 y: 110) = Color yellow.
    self assert: (view colorAtX: 130 y: 130) = Color yellow.
    self assert: cr clipBounds = (-100@-100 extent: view extent).

    "Created: / 26-03-2016 / 23:44:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!GraphicsContextTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

