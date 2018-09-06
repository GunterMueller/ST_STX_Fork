"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CObject variableByteSubclass:#FontOptions
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!FontOptions class methodsFor:'instance creation'!

new
    ^ CPrimitives cairo_font_options_create

    "Created: / 17-02-2016 / 20:30:10 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontOptions class methodsFor:'accessing'!

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

!FontOptions class methodsFor:'primitives'!

primCopy: original 

	<cdecl: const Cairo::FontOptions "cairo_font_options_copy" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primDestroy: options 

	<cdecl: const void "cairo_font_options_destroy" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primEqual: options other: other 

	<cdecl: const int32 "cairo_font_options_equal" ( Cairo::FontOptions Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primFontOptionsCreate

	<cdecl: const Cairo::FontOptions "cairo_font_options_create" ( ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primFtFontOptionsSubstitute: options pattern: pattern 

	<cdecl: const void "cairo_ft_font_options_substitute" ( Cairo::FontOptions pointer ) >
	self primitiveFailed

    "Created: / 10-07-2008 / 23:05:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primGetAntialias: options 

	<cdecl: const int32 "cairo_font_options_get_antialias" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primGetHintMetrics: options 

	<cdecl: const int32 "cairo_font_options_get_hint_metrics" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:54 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primGetHintStyle: options 

	<cdecl: const int32 "cairo_font_options_get_hint_style" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primGetSubpixelOrder: options 

	<cdecl: const int32 "cairo_font_options_get_subpixel_order" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primHash: options 

	<cdecl: const int32 "cairo_font_options_hash" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primMerge: options other: other 

	<cdecl: const void "cairo_font_options_merge" ( Cairo::FontOptions Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primSetAntialias: options antialias: antialias 

	<cdecl: const void "cairo_font_options_set_antialias" ( Cairo::FontOptions int32 ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primSetHintMetrics: options hintMetrics: hint_metrics 

	<cdecl: const void "cairo_font_options_set_hint_metrics" ( Cairo::FontOptions int32 ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primSetHintStyle: options hintStyle: hint_style 

	<cdecl: const void "cairo_font_options_set_hint_style" ( Cairo::FontOptions int32 ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primSetSubpixelOrder: options subpixelOrder: subpixel_order 

	<cdecl: const void "cairo_font_options_set_subpixel_order" ( Cairo::FontOptions int32 ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
!

primStatus: options 

	<cdecl: const int32 "cairo_font_options_status" ( Cairo::FontOptions ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!FontOptions methodsFor:'accessing'!

referenceCount
    "Return value of reference counter"

    ^ -1 "/ Not refcounted 

    "Modified: / 23-02-2016 / 10:49:16 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    "Checks whether an error has previously occurred for this object.
     See Cairo::Status pool for possible values."

    ^ CPrimitives cairo_font_options_status: self

    "Modified: / 23-02-2016 / 10:49:32 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontOptions methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

    CPrimitives cairo_font_options_destroy: self.

    "Modified: / 17-02-2016 / 20:29:13 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.
     
     This method must be called whenever Cairo documentation says so,
     check comment on return value for methods returning a Cairo object"

    "/ Nothing, FontOptions are not refcounted

    "Modified: / 05-03-2016 / 10:32:34 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontOptions class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

