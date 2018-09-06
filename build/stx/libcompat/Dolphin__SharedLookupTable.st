"{ Package: 'stx:libcompat' }"

"{ NameSpace: Dolphin }"

Object subclass:#SharedLookupTable
	instanceVariableNames:'mutex table'
	classVariableNames:''
	poolDictionaries:''
	category:'Compatibility-Dolphin'
!


!SharedLookupTable class methodsFor:'instance creation'!

new
    ^ self basicNew initialize
! !

!SharedLookupTable methodsFor:'accessing'!

at:key
    |val|

    mutex critical:[
        val := table at:key
    ].
    ^ val

    "Created: / 23-09-2011 / 22:28:29 / cg"
!

at:key ifAbsent:aBlock 
    |val|

    mutex critical:[
        val := table at:key ifAbsent:aBlock
    ].
    ^ val

    "Created: / 23-09-2011 / 22:28:44 / cg"
!

at:key put:value
    mutex critical:[
        table at:key put:value.
    ].
    ^ value

    "Created: / 23-09-2011 / 22:27:39 / cg"
!

keysAndValuesDo:aBlock
    mutex critical:[
        table keysAndValuesDo:aBlock
    ].

    "Created: / 23-09-2011 / 22:46:01 / cg"
!

removeKey:key ifAbsent:aBlock 
    |val|

    mutex critical:[
        val := table removeKey:key ifAbsent:aBlock
    ].
    ^ val

    "Created: / 23-09-2011 / 22:46:39 / cg"
!

values
    |val|

    mutex critical:[
        val := table values
    ].
    ^ val

    "Created: / 04-10-2011 / 17:16:17 / cg"
! !

!SharedLookupTable methodsFor:'setup'!

initialize
    mutex := Semaphore forMutualExclusion.
    table := LookupTable new.
    super initialize

    "Modified: / 23-09-2011 / 22:28:12 / cg"
! !

!SharedLookupTable class methodsFor:'documentation'!

version
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SharedLookupTable.st,v 1.3 2011-10-04 16:47:42 cg Exp $'
!

version_CVS
    ^ '$Header: /cvs/stx/stx/libcompat/Dolphin__SharedLookupTable.st,v 1.3 2011-10-04 16:47:42 cg Exp $'
! !
