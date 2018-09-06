"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CObject subclass:#ScaledFont
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!ScaledFont class methodsFor:'instance creation'!

fromFontDescription: aFontDescription
    | screen vDPI |

    screen := Screen current.
    screen isX11Platform ifTrue:[ 
        "/ XWorkstation does not properly calculate the DPI on multihead
        "/ configurations, see:
        "/    https://swing.fit.cvut.cz/projects/stx-jv/ticket/74
        "/ For now, use 96 which seems to be hardcoded in various places, see:
        "/    http://unix.stackexchange.com/questions/75344/how-does-x-server-calculate-dpi
        vDPI := 96.
    ] ifFalse:[ 
        vDPI := screen verticalPixelPerInch.
    ].
    ^ self fromFontFace: (FontFace fromFontDescription: aFontDescription) scale: (vDPI / 72) * aFontDescription size.

    "
    Cairo::ScaledFont fromFontDescription: CodeView defaultFont               
    "

    "Created: / 17-02-2016 / 20:21:42 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-02-2016 / 06:39:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromFontFace: face matrix: fontMatrix transformation: transformationMatrix options: options
    ^ CPrimitives cairo_scaled_font_create: face _: fontMatrix _: transformationMatrix _: options

    "Created: / 17-02-2016 / 20:30:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

fromFontFace: face scale: scale
    | options font |
    options := FontOptions new.
    font := self fromFontFace: face matrix: (Matrix scale: scale) transformation: Matrix identity options: options.
    options release.
    ^ font.              
    "
    Cairo::ScaledFont fromFontDescription: CodeView defaultFont               
    "

    "Created: / 18-02-2016 / 08:15:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 18-02-2016 / 10:17:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ScaledFont class methodsFor:'accessing'!

sizeof
    "Returns size of undelaying structure in bytes"

    ^0
! !

!ScaledFont methodsFor:'accessing'!

fontMatrix
    | matrix |

    matrix := Matrix new.
    CPrimitives cairo_scaled_font_get_font_matrix: self _: matrix.
    ^ matrix

    "Created: / 18-02-2016 / 10:05:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

referenceCount
    "Return value of reference counter"

    ^ CPrimitives cairo_scaled_font_get_reference_count: self.

    "Modified: / 17-02-2016 / 20:16:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-02-2016 / 10:48:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    "Checks whether an error has previously occurred for this object.
     See Cairo::Status pool for possible values."

    ^ CPrimitives cairo_scaled_font_status: self

    "Modified: / 23-02-2016 / 10:48:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ScaledFont methodsFor:'cairo api'!

extents
    | extents |
    extents := FontExtents new.
    Cairo::CPrimitives cairo_scaled_font_extents: self _: extents.  
    ^ extents

    "Created: / 16-02-2016 / 14:56:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

textExtents: aString
    | extents |
    extents := TextExtents new.
    Cairo::CPrimitives cairo_scaled_font_text_extents: self _: aString utf8Encoded _: extents.  
    ^ extents

    "Created: / 16-02-2016 / 14:56:59 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ScaledFont methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

     CPrimitives cairo_scaled_font_destroy: self.
     self setAddress: nil.

    "Created: / 28-12-2014 / 22:10:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 17-02-2016 / 06:39:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.
     
     This method must be called whenever Cairo documentation says so,
     check comment on return value for methods returning a Cairo object"

    CPrimitives cairo_scaled_font_reference: self

    "Modified: / 05-03-2016 / 10:33:08 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!ScaledFont class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

