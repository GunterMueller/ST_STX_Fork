"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

Surface subclass:#SurfaceImage
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!

!SurfaceImage methodsFor:'accessing'!

data
    "Get a pointer to the data (as ExternalBytes) of the image surface, for 
     direct inspection or modification.

     A call to Cairo::Surdace>>#flush is required before accessing the pixel 
     data to ensure that all pending drawing operations are finished. A call 
     to Cairo::Surface>>#markDirty is required after the data is modified."

    | data size |

    size := self stride * self height.
    data := CPrimitives cairo_image_surface_get_data: self.
    data := ExternalBytes basicNew setAddress: data address size: size.
    ^ data

    "Created: / 27-02-2016 / 16:49:46 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 27-02-2016 / 18:30:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

format
    "Get the format of the surface. See Cairo::Format"

    ^ CPrimitives cairo_image_surface_get_format: self.

    "Created: / 28-02-2016 / 08:00:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

height
    "Get the height of the image surface in pixels."

    ^ CPrimitives cairo_image_surface_get_height: self

    "Created: / 27-02-2016 / 16:51:55 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

stride
    "Get the stride of the image surface in bytes."

    ^ CPrimitives cairo_image_surface_get_stride: self

    "Created: / 27-02-2016 / 16:51:02 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

width
    "Get the width of the image surface in pixels."

    ^ CPrimitives cairo_image_surface_get_width: self

    "Created: / 27-02-2016 / 16:51:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!SurfaceImage methodsFor:'inspecting'!

inspector2TabImageCairo
    <inspector2Tab>

    | v |

    v := PluggableView new.
    v redrawAction:[
        | cr |

        cr := v cairo.
        [
            cr sourceSurface: self x: 1 y: 1.
            cr paint.
        ] ensure:[ 
            cr release.
        ].
    ].
    ^self newInspector2Tab
        label: 'Contents';
        priority: 49;
        view: (HVScrollableView forView: v);
        yourself

    "Created: / 31-12-2014 / 12:01:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

