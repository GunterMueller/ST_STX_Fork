"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

SimpleView subclass:#ClockView
	instanceVariableNames:'updater'
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Examples'
!


!ClockView methodsFor:'accessing-dimensions'!

preferredExtent

    ^400 @ 400

    "Created: / 17-06-2012 / 22:37:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClockView methodsFor:'event handling'!

destroy

    updater notNil ifTrue:[updater terminate].
    super destroy.

    "Created: / 17-06-2012 / 22:41:25 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

mapped

    updater isNil ifTrue:[
        updater := [ [ Delay waitForSeconds: 1. self invalidate ] loop ] newProcess.
        updater resume.
    ].
    super mapped.

    "Created: / 17-06-2012 / 22:40:41 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2016 / 16:40:06 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

unmapped

    updater notNil ifTrue:[updater terminate].
    super unmapped.

    "Created: / 17-06-2012 / 22:42:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 12-02-2016 / 16:40:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClockView methodsFor:'redrawing'!

redraw
    self redrawWithCairoBuffered

    "Created: / 16-06-2012 / 23:25:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:17:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

redrawX: x y: y width: w height: h
    self redrawWithCairoBufferedX: x y: y width: w height: h

    "Created: / 17-06-2012 / 21:33:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:18:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClockView methodsFor:'redrawing - cairo'!

redrawWithCairo: cr

    |   time hours mins secs |

    "/ scale to unit square and translate (0, 0) to be (0.5, 0.5), i.e.
    "/ the center of the window
    cr save.
    cr scale: self extent.
    cr translate: (0.5 @ 0.5).
    cr lineWidth: 0.05.

    cr sourceR: 0.33 G: 0.61 B: 0.11.
    cr paint.

    cr arcX: 0 y: 0 radius: 0.42 from: 0 to: (2 * (Float pi)).
    cr sourceR: 1.0 G: 1.0 B: 1.0.
    cr fillAndPreserve.
    cr sourceR: 0.0 G: 0.0 B: 0.0.
    cr strokeAndPreserve.
    cr clip.

    "Now, clock ticks"

    0 to: 11 do:[:i|
        | inset |

        inset := 0.05.
        cr save.

        cr lineCap: Cairo::LineCap CAIRO_LINE_CAP_ROUND.
        (i \\ 3) ~~ 0 ifTrue:[
            inset := inset * 0.8.
            cr lineWidth: 0.03.
        ].

        cr moveToX: (0.42 - inset) * ( i * (Float pi / 6)) cos
                 y: (0.42 - inset) * ( i * (Float pi / 6)) sin.

        cr lineToX: (0.42 ) * ( i * (Float pi / 6)) cos
                 y: (0.42 ) * ( i * (Float pi / 6)) sin.

        cr stroke.

        cr restore.
    ].

    "/ Not, the current time"

    time := Time now.
    hours := (time hours > 12 ifTrue:[time hours - 12] ifFalse:[time hours])
                * (Float pi / 6).
    mins := time minutes * (Float pi / 30).
    secs := time seconds * (Float pi / 30).

    cr save.
    cr lineCap: Cairo::LineCap CAIRO_LINE_CAP_ROUND.

    "/ draw the seconds hand
    cr save.
    cr lineWidth: 0.016.
    cr source: ((Color red: 70 green: 70 blue: 70) alpha: 0.8).
    cr moveToX: 0.0 y: 0.0.
    cr lineToX: (secs sin * (0.42 * 0.9))
             y: (-1 *  (secs cos * (0.42 * 0.9))).
    cr stroke.
    cr restore.

    "/ draw th minutes
    cr source: ((Color red: 11 green: 33 blue: 61) alpha: 0.7).
    cr moveToX: 0.0 y: 0.0.
    cr lineToX: ((mins + (secs / 60)) sin * (0.42 * 0.8))
             y: (-1 * ((mins + (secs / 60)) cos * (0.42 * 0.8))).
    cr stroke.

    "/ draw the hours hand
    cr source: ((Color red: 33 green: 61 blue: 11) alpha: 0.6).
    cr moveToX: 0.0 y: 0.0.
    cr lineToX: ((hours + (mins / 12)) sin * (0.42 * 0.5))
             y: (-1 * ((hours + (mins / 12)) cos * (0.42 * 0.5))).
    cr stroke.


    cr restore.
    cr arcX: 0 y: 0 radius: 0.01 from: 0 to: (2 * (Float pi)).
    cr fill.





    cr restore.

    "Created: / 27-12-2014 / 00:00:44 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 17:01:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ClockView class methodsFor:'documentation'!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

