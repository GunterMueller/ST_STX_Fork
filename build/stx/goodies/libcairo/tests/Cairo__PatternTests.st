"{ Package: 'stx:goodies/libcairo/tests' }"

"{ NameSpace: Cairo }"

TestCase subclass:#PatternTests
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Tests'
!


!PatternTests methodsFor:'tests - gradient'!

test_linear_01
    | p s |

    p := Cairo::Pattern linearFromX: 0.0  y: 0.0 toX: 1.0 y: 1.0.
    p addColor: Color red stopAt: 0.0.
    p addColor: Color green stopAt: 1.0.

    self assert: p colorStopCount = 2.
    s := p colorStopAtIndex: 1.
    self assert: s key = 0.0.
    self assert: s value = Color red.

    s := p colorStopAtIndex: 2.
    self assert: s key = 1.0.
    self assert: s value = Color green.

    self should: [ p colorStopAtIndex: -1 ] raise: Object indexNotFoundSignal.
    self should: [ p colorStopAtIndex:  3 ] raise: Object indexNotFoundSignal.

    "Created: / 15-03-2016 / 20:59:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_linear_02
    | p points |

    p := Cairo::Pattern linearFromX: 0.0  y: 0.0 toX: 1.0 y: 1.0.
    points := p points.
    self assert: points first x = 0.0.
    self assert: points first y = 0.0.
    self assert: points second x = 1.0.
    self assert: points second y = 1.0.

    "Created: / 15-03-2016 / 21:40:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

test_radial_02
    | p circles |

    p := Cairo::Pattern radialFromX: 0.0  y: 0.0 radius: 2.0 toX: 1.0 y: 1.0 radius: 3.0.
    circles := p circles.
    self assert: circles first x = 0.0.
    self assert: circles first y = 0.0.
    self assert: circles second = 2.0.
    self assert: circles third x = 1.0.
    self assert: circles third y = 1.0.
    self assert: circles fourth = 3.0.

    "Created: / 15-03-2016 / 22:21:54 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PatternTests methodsFor:'tests - solid'!

test_solid_01
    | p |

    p := Cairo::Pattern R: 1 G: 0 B: 0.
    self assert: p isSolid.
    self assert: p color = Color red.
    p release.

    p := Cairo::Pattern R: 0.5 G: 0.5 B: 0.5 A: 0.5.
    self assert: p isSolid.
    self assert: p color = ((Color scaledRed: 32768 scaledGreen: 32768 scaledBlue: 32768) alpha: 0.5).
    p release.

    p := Cairo::Pattern color: Color red.
    self assert: p isSolid.
    self assert: p color = Color red.
    p release.

    "Created: / 04-03-2016 / 09:49:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2016 / 22:12:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PatternTests methodsFor:'tests - surface'!

test_surface_01
    | image imageCr pattern |

    image := Surface newImageWithFormat: Format CAIRO_FORMAT_ARGB32 width: 2 height: 2.
    imageCr := image cairo.
    imageCr sourceR: 0 G: 1 B: 0.
    imageCr paint.
    image flush.
    self assert: (image data unsignedLongAt: 1) = 16rFF00FF00.

    pattern := Pattern surface: image.
    image := pattern surface.
    self assert:  (image data unsignedLongAt: 1) = 16rFF00FF00.

    "Created: / 05-03-2016 / 22:29:57 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!PatternTests class methodsFor:'documentation'!

version_HG

    ^ '$Changeset: <not expanded> $'
! !

