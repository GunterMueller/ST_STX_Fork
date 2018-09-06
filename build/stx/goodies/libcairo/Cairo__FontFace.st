"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CObject subclass:#FontFace
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!FontFace class methodsFor:'instance creation'!

fromFontDescription: aFontDescription
    Screen current platformName == #X11 ifTrue:[ 
        | pattern |

        pattern := FcPattern fromFontDescription: aFontDescription.
        ^ CPrimitives cairo_ft_font_face_create_for_pattern: pattern.
    ].
    Screen current platformName = 'WIN32' ifTrue:[
        | hfont |

        hfont := aFontDescription fontId.
        hfont isNil ifTrue:[ 
            hfont := Screen current
                                getFontWithFamily:aFontDescription family 
                                face:aFontDescription face 
                                style:aFontDescription style 
                                size:(aFontDescription sizeUnit == #px ifTrue:[aFontDescription pixelSize] ifFalse:[aFontDescription size])  
                                sizeUnit:aFontDescription sizeUnit  
                                encoding:aFontDescription encoding ? '*'.      
            hfont isNil ifTrue:[ 
                self error: 'Faled to get HFONT'.
                ^ nil.
            ].
        ].
        ^ CPrimitives cairo_win32_font_face_create_for_hfont: hfont.
    ].   
    self error: 'Noy yet implemented'.

    "
    Cairo::FontFace fromFontDescription: CodeView defaultFont
    "

    "Created: / 17-02-2016 / 20:01:48 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified: / 19-02-2016 / 21:01:50 / jv"
! !

!FontFace class methodsFor:'accessing'!

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

sizeof
    "Returns size of undelaying structure in bytes"

    ^0
! !

!FontFace methodsFor:'accessing'!

referenceCount
    "Return value of reference counter"

    ^ CPrimitives cairo_font_face_get_reference_count: self

    "Modified: / 17-02-2016 / 19:54:07 / Jan Vrany <jan.vrany@fit.cvut.cz>"
    "Modified (comment): / 23-02-2016 / 10:49:38 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

status
    "Checks whether an error has previously occurred for this object.
     See Cairo::Status pool for possible values."

    ^ CPrimitives cairo_font_face_status: self

    "Modified: / 23-02-2016 / 10:50:05 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

type
    "This function returns the type of the backend used to create a font face. 
     See FontType for available types."

    ^ CPrimitives cairo_font_face_get_type: self

    "Created: / 17-02-2016 / 19:54:58 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontFace methodsFor:'private'!

destroy
    "Tell Cairo library to destroy the corresponding C object.
     Remember that object is physically destroyed only if internal
     refcounter goes to zero. However, after calling destroy,
     this instance should be treated as invalid."

    ^ CPrimitives cairo_font_face_destroy: self

    "Modified: / 17-02-2016 / 19:54:30 / Jan Vrany <jan.vrany@fit.cvut.cz>"
!

reference
    "Increases the reference count on the receiver by one. This prevents the
     receiver from being destroyed until a matching call to #destroy is made.
     
     This method must be called whenever Cairo documentation says so,
     check comment on return value for methods returning a Cairo object"

    CPrimitives cairo_font_face_reference: self.

    "Modified: / 05-03-2016 / 10:32:04 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!FontFace class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !

