"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CStructure variableByteSubclass:#TextExtents
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!TextExtents class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    fields := #(
        xBearing
        yBearing
        width
        height
        xAdvance
        yAdvance
    )

    "Modified: / 18-02-2016 / 09:06:39 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!TextExtents class methodsFor:'accessing'!

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

    ^48
! !

!TextExtents methodsFor:'accessing'!

height
    "Returns double"

    ^self doubleAt:1 + 24
!

height: value

    self doubleAt:1 + 24 put:value
!

width
    "Returns double"

    ^self doubleAt:1 + 16
!

width: value

    self doubleAt:1 + 16 put:value
!

xAdvance
    "Returns double"

    ^self doubleAt:1 + 32
!

xAdvance: value

    self doubleAt:1 + 32 put:value
!

xBearing
    "Returns double"

    ^self doubleAt:1 + 0
!

xBearing: value

    self doubleAt:1 + 0 put:value
!

yAdvance
    "Returns double"

    ^self doubleAt:1 + 40
!

yAdvance: value

    self doubleAt:1 + 40 put:value
!

yBearing
    "Returns double"

    ^self doubleAt:1 + 8
!

yBearing: value

    self doubleAt:1 + 8 put:value
! !

!TextExtents class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !


TextExtents initialize!
