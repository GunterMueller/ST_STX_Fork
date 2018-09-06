"{ Package: 'stx:goodies/libcairo' }"

"{ NameSpace: Cairo }"

CStructure variableByteSubclass:#Glyph
	instanceVariableNames:''
	classVariableNames:''
	poolDictionaries:''
	category:'Cairo-Objects'
!


!Glyph class methodsFor:'initialization'!

initialize
    "Invoked at system start or when the class is dynamically loaded."

    fields := #(
    )


    "/ please change as required (and remove this comment)

    "Modified: / 18-02-2016 / 09:07:09 / Jan Vrany <jan.vrany@fit.cvut.cz>"
! !

!Glyph class methodsFor:'accessing'!

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

    ^20
! !

!Glyph methodsFor:'accessing'!

index
    "Returns a Cface::CLongNode"

    ^self longLongAt:1 + 0
!

index: value

    self longLongAt:1 + 0 put:value
!

x
    "Returns double"

    ^self doubleAt:1 + 4
!

x: value

    self doubleAt:1 + 4 put:value
!

y
    "Returns double"

    ^self doubleAt:1 + 12
!

y: value

    self doubleAt:1 + 12 put:value
! !

!Glyph class methodsFor:'documentation'!

version
    ^'$Id$'
!

version_HG
    ^ '$Changeset: <not expanded> $'
! !


Glyph initialize!
