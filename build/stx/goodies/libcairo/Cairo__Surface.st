"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CObject subclass:#Surface
	instanceVariableNames:'view'
	classVariableNames:''
	poolDictionaries:'Cairo::SurfaceType Cairo::Format'
	category:'Cairo-Objects'
!


!Surface class methodsFor:'instance creation'!

forView: aView
    ^ self onView: aView

    "Created: / 10-07-2008 / 10:15:04 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 14-02-2016 / 00:01:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newImageWithFormat:format width:width height:height 
    ^ CPrimitives 
        cairo_image_surface_create:format
        _:width
        _:height

    "Created: / 24-12-2014 / 23:43:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 22:03:52 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newImageWithFormat:format width:width height:height similarTo: surface
    OperatingSystem isMSWINDOWSlike ifTrue:[ 
        ^ CPrimitives cairo_image_surface_create: format _:width _:height
    ] ifFalse:[
        ^ CPrimitives cairo_surface_create_similar_image: surface _:format _:width _:height
    ]

    "Created: / 27-02-2016 / 16:00:26 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 01-03-2016 / 23:37:37 / jv"
!

newPDFWithFile:aStringOrFilename width:w height:h 
    ^ CPrimitives 
        cairo_pdf_surface_create:aStringOrFilename asFilename asString
        _:w asDouble
        _:h asDouble

    "Created: / 10-07-2008 / 09:35:34 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:05:49 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newPNGWithFile:aStringOrFilename
    aStringOrFilename asFilename exists ifFalse:[ 
        self error: 'No such file'.
    ].
    ^ CPrimitives cairo_image_surface_create_from_png:aStringOrFilename asFilename asString

    "Created: / 28-02-2016 / 07:52:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

newWin32WithDC: hdc
    ^ CPrimitives cairo_win32_surface_create:hdc

    "Created: / 19-02-2016 / 12:07:29 / jv"
!

newXlibWithDisplay:dpy drawable:drawable visual:visual width:width height:height 
    ^ CPrimitives 
        cairo_xlib_surface_create:dpy
        _:drawable
        _:visual
        _:width
        _:height

    "Created: / 10-07-2008 / 11:06:22 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 22:06:28 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

onView: aView
    aView device platformName == #X11 ifTrue:[
        | surface |
        surface := self newXlibWithDisplay:aView device displayId
                                  drawable:aView drawableId address
                                    visual:aView device queryDefaultVisual
                                     width:aView width
                                    height:aView height.  
        surface setView: aView.
        ^ surface.
    ].
    (aView device platformName = 'WIN32') ifTrue:[
        aView gcId isNil ifTrue:[ 
            aView initGC
        ].
        ^ self newWin32WithHDC: (aView device hdcForGC: aView gcId)
    ].
    self error: 'Unsupported plarform'

    "Created: / 13-02-2016 / 23:47:50 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-02-2016 / 12:11:20 / jv"
! !

!Surface class methodsFor:'accessing'!

dllPath

    OperatingSystem isMSWINDOWSlike ifTrue:[
        ^ #( 'C:\Windows' 'C:\Windows\System32' "Wild guess, should not harm" )
    ].

    OperatingSystem isUNIXlike ifTrue:[
        OperatingSystem getSystemType == #linux ifTrue:[
            | path |

            path := #( '/lib' '/usr/lib' '/usr/local/lib' ).
            (OperatingSystem getSystemInfo at:#machine) = 'x86_64' ifTrue:[
                "If the machine is 64bit, prepend standard path for 32bit libs.
                 Leave standard paths at the end, as the system might be completely 
                 32bit but running on 64bit-capable CPU.

                CAVEAT: This is bit dangerous, as on 64bit OS, if ia32 libs are
                not installed byt 64bit sqlite libs are, then 64bit libs are found
                and when a function is called, segfault will occur!!

                Q: Is there a way how to figure out if the OS itself is 32bit,
                regardles on CPU?"
                path := #( '/lib32' '/usr/lib32' '/usr/local/lib32' ) , path.
            ].
            ^path

        ].
    ].

    self error:'Unsupported operating system'

    "
        SqliteLibrary dllPath
    "

    "Created: / 31-08-2011 / 18:02:17 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

libraryName

    OperatingSystem isUNIXlike ifTrue:[^'libcairo.so.2'].

    OperatingSystem isMSWINDOWSlike ifTrue:[^'cairo.dll'].

    self error:'Library name for host OS is not known'
!

sizeof
    "Returns size of undelaying structure in bytes"

    ^0
! !

!Surface methodsFor:'accessing'!

cairo
    ^ GraphicsContext onSurface: self

    "Created: / 05-03-2016 / 22:25:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

referenceCount
    "Return value or reference counter"

    ^ CPrimitives cairo_surface_get_reference_count: self

    "Created: / 28-12-2014 / 22:09:45 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    "Checks whether an error has previously occurred for this object.
     See Cairo::Status pool for possible values."

    ^ CPrimitives cairo_surface_status: self

    "Modified: / 23-02-2016 / 11:28:21 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    ^CPrimitives cairo_surface_get_type: self

    "Created: / 10-07-2008 / 10:34:36 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 28-12-2014 / 21:46:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

view
    "Return's associated view (if any) or nil"
    ^ view

    "Modified (comment): / 29-03-2016 / 22:53:48 / jv"
! !

!Surface methodsFor:'cairo api'!

finish

    ^CPrimitives cairo_surface_finish: self

    "Created: / 17-06-2012 / 08:49:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 21:48:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

flush
    "Do any pending drawing for the surface and also restore any temporary 
     modifications cairo has made to the surface's state. This function must 
     be called before switching from drawing on the surface with cairo to 
     drawing on it directly with native APIs, or accessing its memory outside 
     of Cairo. If the surface doesn't support direct access, then this function
     does nothing."

    CPrimitives cairo_surface_flush: self

    "Created: / 10-07-2008 / 10:32:50 / Jan Vrany <vranyj1@fel.cvut.cz>"
    "Modified: / 18-02-2016 / 20:15:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markDirty
    "Tells cairo that drawing has been done to surface using means other than cairo, 
      and that cairo should reread any cached areas. Note that you must call 
      Cairo::Surface>>#flush before doing such drawing."

    CPrimitives cairo_surface_mark_dirty: self.
    self statusCheck.

    "Created: / 24-02-2016 / 17:12:23 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

markDirtyX: x y: y width: w height: h
    "Like $markDirty, but drawing has been done only to the specified rectangle, 
     so that cairo can retain cached contents for other parts of the surface.

     Any cached clip set on the surface will be reset by this function, to 
     make sure that future cairo calls have the clip set that they expect."

    CPrimitives cairo_surface_mark_dirty_rectangle: self _: x _:y _:w _:h.
    self statusCheck.

    "Created: / 24-02-2016 / 17:14:11 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Surface methodsFor:'initialization'!

initialize
    super initialize.
    self class == Cairo::Surface ifTrue:[ 
        | type |

        type := self type.
        type == CAIRO_SURFACE_TYPE_IMAGE ifTrue:[ 
            self changeClassTo: SurfaceImage.
            ^ self.
        ].
        type == CAIRO_SURFACE_TYPE_XLIB ifTrue:[ 
            self changeClassTo: SurfaceXlib.
            ^ self.
        ].
        type == CAIRO_SURFACE_TYPE_WIN32 ifTrue:[ 
            self changeClassTo: SurfaceWin32.
            ^ self.
        ].
        type == CAIRO_SURFACE_TYPE_PDF ifTrue:[ 
            self changeClassTo: SurfacePDF.
            ^ self.
        ].
    ].

    "Created: / 04-03-2016 / 00:45:31 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 05-03-2016 / 22:21:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Surface methodsFor:'initialization & release'!

setView: aView
    view notNil ifTrue:[
        self error: 'Trying to set view twice'
    ].
    view := aView.

    "Created: / 17-06-2012 / 15:04:20 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 25-02-2016 / 11:03:19 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 29-03-2016 / 22:41:12 / jv"
! !

!Surface methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

    CPrimitives cairo_surface_destroy: self.
    self setAddress: nil.

    "Created: / 28-12-2014 / 22:10:47 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 13-02-2016 / 16:10:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.
     
     This method must be called whenever Cairo documentation says so,
     check comment on return value for methods returning a Cairo object"

    CPrimitives cairo_surface_reference: self

    "Modified: / 05-03-2016 / 10:33:36 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Surface methodsFor:'queries'!

isViewSurface
    "Return true, if this sufrace if for a kind of a View"

    ^self isXLibSurface or:[ self isWin32Surface ]

    "Created: / 17-06-2012 / 15:02:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isWin32Surface

    ^self type == CAIRO_SURFACE_TYPE_WIN32

    "Created: / 17-06-2012 / 15:01:18 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 21:46:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

isXLibSurface

    ^self type == CAIRO_SURFACE_TYPE_XLIB

    "Created: / 17-06-2012 / 14:58:40 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 28-12-2014 / 21:46:27 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Surface class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

