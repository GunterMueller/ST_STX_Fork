"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Surface subclass:#SurfaceXlib
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:'Cairo::SurfaceType Cairo::Format'
	category:'Cairo-Objects'
!

!SurfaceXlib methodsFor:'accessing'!

width: w height: h
    CPrimitives cairo_xlib_surface_set_size: self _: w _: h

    "Created: / 10-07-2008 / 19:36:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 16-02-2016 / 07:45:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SurfaceXlib methodsFor:'change & update'!

update: aspect with: param from: sender

    (sender == view) ifTrue:[
        aspect == #sizeOfView  ifTrue:[
            self width: sender width height: sender height.
            ^self.
        ]
    ].

    super update: aspect with: param from: sender

    "Created: / 10-07-2008 / 19:33:39 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 17-06-2012 / 15:05:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

