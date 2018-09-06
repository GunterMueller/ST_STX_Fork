"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

ExternalStructure subclass:#Path
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!Path class methodsFor:'accessing'!

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

    ^12
! !

!Path class methodsFor:'primitives'!

primDestroy: path 

	<cdecl: const void "cairo_path_destroy" ( Cairo::Path ) >
	self primitiveFailed

    "Modified: / 10-09-2008 / 18:19:55 / Jan Vrany <vranyj1@fel.cvut.cz>"
! !

!Path methodsFor:'accessing'!

data
    "Returns (pointer-to ;; Line: 186
;; Namespace: Cairo
;; Class: PathData
)"

    ^self pointerAt:1 + 4
!

data: value

    self pointerAt:1 + 4 put:value
!

numData
    "Returns int32"

    ^self longAt:1 + 8
!

numData: value

    self longAt:1 + 8 put:value
!

status
    "Returns ;; Line: 398
;; Namespace: Cairo
;; Class: Status
(enum _cairo_status
	(value (CAIRO_STATUS_SUCCESS) 0)
	(value (CAIRO_STATUS_NO_MEMORY) 1)
	(value (CAIRO_STATUS_INVALID_RESTORE) 2)
	(value (CAIRO_STATUS_INVALID_POP_GROUP) 3)
	(value (CAIRO_STATUS_NO_CURRENT_POINT) 4)
	(value (CAIRO_STATUS_INVALID_MATRIX) 5)
	(value (CAIRO_STATUS_INVALID_STATUS) 6)
	(value (CAIRO_STATUS_NULL_POINTER) 7)
	(value (CAIRO_STATUS_INVALID_STRING) 8)
	(value (CAIRO_STATUS_INVALID_PATH_DATA) 9)
	(value (CAIRO_STATUS_READ_ERROR) 10)
	(value (CAIRO_STATUS_WRITE_ERROR) 11)
	(value (CAIRO_STATUS_SURFACE_FINISHED) 12)
	(value (CAIRO_STATUS_SURFACE_TYPE_MISMATCH) 13)
	(value (CAIRO_STATUS_PATTERN_TYPE_MISMATCH) 14)
	(value (CAIRO_STATUS_INVALID_CONTENT) 15)
	(value (CAIRO_STATUS_INVALID_FORMAT) 16)
	(value (CAIRO_STATUS_INVALID_VISUAL) 17)
	(value (CAIRO_STATUS_FILE_NOT_FOUND) 18)
	(value (CAIRO_STATUS_INVALID_DASH) 19)
	(value (CAIRO_STATUS_INVALID_DSC_COMMENT) 20)
	(value (CAIRO_STATUS_INVALID_INDEX) 21)
	(value (CAIRO_STATUS_CLIP_NOT_REPRESENTABLE) 22)
	(value (CAIRO_STATUS_TEMP_FILE_ERROR) 23)
	(value (CAIRO_STATUS_INVALID_STRIDE) 24)
	(value (CAIRO_STATUS_FONT_TYPE_MISMATCH) 25)
	(value (CAIRO_STATUS_USER_FONT_IMMUTABLE) 26)
	(value (CAIRO_STATUS_USER_FONT_ERROR) 27)
	(value (CAIRO_STATUS_NEGATIVE_COUNT) 28)
	(value (CAIRO_STATUS_INVALID_CLUSTERS) 29)
	(value (CAIRO_STATUS_INVALID_SLANT) 30)
	(value (CAIRO_STATUS_INVALID_WEIGHT) 31)
	(value (CAIRO_STATUS_INVALID_SIZE) 32)
	(value (CAIRO_STATUS_USER_FONT_NOT_IMPLEMENTED) 33)
	(value (CAIRO_STATUS_DEVICE_TYPE_MISMATCH) 34)
	(value (CAIRO_STATUS_DEVICE_ERROR) 35)
	(value (CAIRO_STATUS_INVALID_MESH_CONSTRUCTION) 36)
	(value (CAIRO_STATUS_DEVICE_FINISHED) 37)
	(value (CAIRO_STATUS_JBIG2_GLOBAL_MISSING) 38)
	(value (CAIRO_STATUS_LAST_STATUS) 39) )"

    ^self doubleWordAt:1 + 0
!

status: value

    self doubleWordAt:1 + 0 put:value
! !

!Path class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

